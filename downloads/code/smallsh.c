#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <fcntl.h>
#include <sys/wait.h>
#include <signal.h>
#include <unistd.h>

#define MAX_INPUT_LENGTH 2048
#define MAX_ARG_NUMBER 512
#define SPLIT_CHAR " \t\r\n"

int allowBg = 1;

char *readLine()
{
    size_t maxLength = MAX_INPUT_LENGTH;
    char *line = (char *)malloc(sizeof(char) * maxLength);
    fgets(line, maxLength, stdin);
    int i = 0;
    for (i = 0; i < maxLength; i++)
    {
        if (line[i] == '\n')
        {
            line[i] = '\0';
        }
    }
    return line;
}
char **parse(char *line, int *num, int *back)
{
    size_t maxNumber = MAX_ARG_NUMBER;
    int i = 0;
    char **arr = (char **)malloc(sizeof(char *) * maxNumber);
    char *token;
    token = strtok(line, SPLIT_CHAR);
    while (token != NULL)
    {
        arr[i] = token;
        // replace $$
        int j = 0;
        for (j = 0; j < strlen(arr[i])-1; j++)
        {
            if (arr[i][j] == '$' && arr[i][j + 1] == '$')
            {
                arr[i][j] = '\0';
                arr[i][j+1] = '\0';
                char t[10];
                char newArg[50];
                memset(t, '\0', 10);
                memset(newArg, '\0', 50);
                strncpy(newArg, arr[i], j);
                sprintf(t, "%d", getpid());
                strcat(newArg, t);
                // sprintf(arr[i], newArg);
                arr[i] = newArg;
            }
        }
        i++;
        token = strtok(NULL, SPLIT_CHAR);
    }
    if (i >= 2 && strcmp(arr[i - 1], "&") == 0)
    {
        arr[i - 1] = NULL;
            i--;
        if(allowBg == 1){
            *back = 1;
        }
    }
    *num = i;
    arr[i] = NULL;
    return arr;
}
void printStatus(int status)
{
    if (status == 0 || status == 1)
        printf("exit value %d\n", status);
    else
        printf("terminated by signal %d\n", status);
}
void catchSIGTSTP(int sig)
{
    if (allowBg == 1)
    {
        char *message = "Entering foreground-only mode(& is now ignored)\n";
        write(STDOUT_FILENO, message, 49);
        fflush(stdout);
        allowBg = 0;
    }
    else
    {
        char *message = "Exiting foreground-only mode\n";
        write(STDOUT_FILENO, message, 30);
        fflush(stdout);
        allowBg = 1;
    }
}
void catchSIGINT(int signo)
{
    char message[] = "terminated by signal ";
    char t[10];
    memset(t, '\0', 10);
    sprintf(t, "%d", signo);
    strcat(message, t);
    strcat(message, "\n");
    printf("%s", message);
    fflush(stdout);
    fflush(stdin);
}

int newProcess(char **arr, int num, int back)
{
    pid_t pid = fork();
    int status, fd;
    int input_flag = -1;
    int output_flag = -1;
    int i = 0;
    for (i = 0; i < num; i++)
    {
        if (strcmp(arr[i], "<") == 0)
            input_flag = i;
        else if (strcmp(arr[i], ">") == 0)
            output_flag = i;
    }
    if (pid == 0)
    {
        struct sigaction sigint = {0};
        sigint.sa_handler = catchSIGINT;
        sigemptyset(&sigint.sa_mask);
        sigint.sa_flags = 0;
        sigaction(SIGINT, &sigint, NULL);

        // input redirect
        if (input_flag > -1)
        {
            fd = open(arr[input_flag + 1], O_RDONLY, 0644);
            if (fd == -1)
            {
                printf("cannot open %s for input\n", arr[input_flag + 1]);
                exit(1);
            }
            else
            {
                if (dup2(fd, 0) == -1)
                {
                    printf(": Could not redirect stdin for input file %s\n", arr[input_flag + 1]);
                    exit(1);
                }
                arr[input_flag] = NULL;
                close(fd);
            }
        }
        //output redirect
        if (output_flag > -1)
        {
            fd = open(arr[output_flag + 1], O_WRONLY | O_CREAT | O_TRUNC, 0644);
            if (fd == -1)
            {
                printf("cannot not open %s for output\n", arr[output_flag + 1]);
                exit(1);
            }
            else
            {
                if (dup2(fd, 1) == -1)
                {
                    printf("Could not redirect stdout for output file %s\n", arr[output_flag + 1]);
                    exit(1);
                }
                arr[output_flag] = NULL;
                close(fd);
            }
        }
        if (back == 1 && input_flag < 0)
        {
            fd = open("/dev/null", O_RDONLY, 0644);
            if (fd == -1)
            {
                printf("Could not open \"/dev/null\"\n");
                exit(1);
            }
            else
            {
                if (dup2(fd, 0) == -1)
                {
                    printf("Could not redirect stdin to \"/dev/null\"\n");
                    exit(1);
                }
                close(fd);
            }
        }
        // printf("%c\n", arr[0][0]);
        if (execvp(arr[0], arr) == -1 && arr[0][0] >= 'a' && arr[0][0] <= 'z')
        {
            printf("%s: no such file or directory\n", arr[0]);
            fflush(stdout);
            exit(1);
        }
    }
    else if (pid < 0)
    {
        printf("Smallsh !\n");
        return 1;
    }
    else
    { // parent
        if (back == 1)
        {
            printf("Background pid is %d.\n", pid);
            fflush(stdout);
        }
        else
        {
            waitpid(pid, &status, WUNTRACED);
            if (WIFEXITED(status))
                return (WEXITSTATUS(status));
            else if (WIFSIGNALED(status))
                return (WTERMSIG(status));
        }
    }
    return status;
}
int executeCommand(char **arr, int status, int num, int back)
{
    if (arr[0] == NULL || strcmp("#", arr[0]) == 0)
        return status;
    else if (strcmp(arr[0], "exit") == 0)
        exit(0);
    else if (strcmp(arr[0], "status") == 0)
        printStatus(status);
    else if (strcmp(arr[0], "cd") == 0)
    {
        char *directory;
        if (arr[1] == NULL)
            directory = getenv("HOME");
        else
            directory = arr[1];
        if (chdir(directory) == -1)
        {
            printf("cd: No such file or directory\n");
            fflush(stdout);
        }
        return status;
    }
    else
    {
        int t = newProcess(arr, num, back);
        // printf("------------%d---\n",t);
        // fflush(stdout);
        return t;
    }
}


int main()
{
    char *input;
    char **arr;
    int status = 0;

    struct sigaction sigint = {0};
    sigint.sa_handler = SIG_IGN;
    sigemptyset(&sigint.sa_mask);
    sigint.sa_flags = 0;
    sigaction(SIGINT, &sigint, NULL);

    struct sigaction sigtstp = {0};
    sigtstp.sa_handler = catchSIGTSTP;
    sigfillset(&sigtstp.sa_mask);
    sigtstp.sa_flags = 0;
    sigaction(SIGTSTP, &sigtstp, NULL);
    while (1)
    {
        int num = 0;
        int back = 0;
        printf(": ");
        fflush(stdout);
        input = readLine();
        arr = parse(input, &num, &back);
        status = executeCommand(arr, status, num, back);

        //background
        pid_t childPid = waitpid(-1, &status, WNOHANG);
        if (childPid > 0)
        {
            printf("background pid %d is done: ", childPid);
            if (WIFEXITED(status))
                printf("exit value %d\n", WEXITSTATUS(status));
            else
                printf("terminated by signal %d\n", status);
            fflush(stdout);
        }
        fflush(stdin);
        free(input);
        free(arr);
    }
    return 0;
}