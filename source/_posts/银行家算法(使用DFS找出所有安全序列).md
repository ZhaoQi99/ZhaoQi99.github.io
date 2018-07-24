---
title: 银行家算法(使用DFS找出所有安全序列)
categories: 操作系统
tags:
  - DFS
  - 操作系统
date: '2018-06-02　12:41:13'
abbrlink: 647653334
---
## 背景

### 银行家算法
银行家算法是一种最有代表性的避免死锁的算法。在避免死锁方法中允许进程动态地申请资源，但系统在进行资源分配之前，应先计算此次分配资源的安全性，若分配不会导致系统进入不安全状态，则分配，否则等待。为实现银行家算法，系统必须设置若干数据结构。

### 安全状态
* 系统能按某种进程推进顺序{P<sub>1</sub>，…，P<sub>n</sub>}为每个进程P<sub>i</sub>分配其所需资源，直至满足每个进程对资源的最大需求，使每个进程都可顺利地完成。
* 此时称{P<sub>1</sub>，…，P<sub>n</sub>}为安全序列。如果系统无法找到这样一个安全序列，则称系统处于不安全状态。
* 并非所有不安全状态都必然会转为死锁状态，但当系统进入不安全状态后，就有可能进入死锁状态。反之，只要系统处于安全状态，系统便不会进入死锁状态。
* 因此，避免死锁的实质在于，系统在进行资源分配时，应用系统不进入不安全状态。

## 数据结构
1. 可利用资源向量Available
是个含有m个元素的数组，其中的每一个元素代表一类可利用的资源数目。如果Available[j]=K，则表示系统中现有Rj类资源K个。
2. 最大需求矩阵Max
这是一个n×m的矩阵，它定义了系统中n个进程中的每一个进程对m类资源的最大需求。如果Max[i,j]=K，则表示进程i需要R<sub>j</sub>类资源的最大数目为K。
3. 分配矩阵Allocation
这也是一个n×m的矩阵，它定义了系统中每一类资源当前已分配给每一进程的资源数。如果Allocation[i,j]=K，则表示进程i当前已分得R<sub>j</sub>类资源的数目为K。
4. 需求矩阵Need。
这也是一个n×m的矩阵，用以表示每一个进程尚需的各类资源数。如果Need[i,j]=K，则表示进程i还需要R<sub>j</sub>类资源K个，方能完成其任务。
Need[i,j]=Max[i,j]-Allocation[i,j]

## 银行家算法
设Request<sub>i</sub>是进程P<sub>i</sub>的请求向量，如果Request<sub>i</sub>[j]=K,表示进程P<sub>i</sub>需要K个R<sub>j</sub>类型。当P<sub>i</sub>发出资源请求后，系统按下输步骤进行检查:
1. 如果Request<sub>i</sub>[j] <= Need[i][j],便转向步骤2；否则认为出错，因为它所需要的资源数已超过它所宣布的最大值
2. 如果Request<sub>i</sub>[j] <= Available[i][j]，便转向步骤3；否则表示尚无足够资源，P<sub>i</sub>需等待  
3. 系统试探着把资源分配给进程P<sub>i</sub>,并修改下面数据结构中的数值:
	* Available[j] -= Request<sub>i</sub>[j]
	* Allocation[i][j] += Request<sub>i</sub>[j]
	* Need[i][j] -= Request<sub>i</sub>[j]
4. 系统执行安全性算法，检查此次资源分配后系统是否处于安全状态.若安全，正式将资源分配给进程P<sub>i</sub>，以完成本次分配；否则，讲将本次的试探分配作废,恢复原来的资源分配状态，让进程P<sub>i</sub>等待

```C++
bool check_bank(int i, int Request[]) //按照银行家算法检查资源请求
{
    for(int j = 0; j < m; j++)
    {
        if(Request[j] > Need[i][j] || Request[j] > Available[j])
            return false;
    }
    update(i, Request);
    return true;
}
```
## 尝试分配资源/恢复原来的资源分配状态

### 尝试分配资源
```C++
void update(int i, int Request[]) //更新数据
{
    for(int j = 0; j < m; j++)
    {
        Available[j] -= Request[j];
        Allocation[i][j] += Request[j];
        Need[i][j] -= Request[j];
    }
}
```
### 恢复原来的资源分配状态
```C++
void recovery(int i, int Request[])//还原数据
{
    for(int j = 0; j < m; j++)
    {
        Available[j] += Request[j];
        Allocation[i][j] -= Request[j];
        Need[i][j] += Request[j];
    }
}
```

## 安全性算法
1. 设置两个工作向量:
① 工作向量WORK，它表示系统可提供给进程继续运行所需的各类资源数目，它含有m个元素，在执行安全算法开始时，WORK:=Available 
② Finish:它表示系统是否有足够的资源分配给进程，使之运行完成。初始Finish[i]: = false；当有足够资源分配给进程时，再令Finish[i]：=true。 
2. 从进程集合中找出一个满足下列条件的进程： 
① Finish[i] = false
② Need[i][j] <= work[j] 
若找到，执行3,否则，执行步骤4
3. 当进程p<sub>i</sub>获得资源后，可顺利执行，直至完成，并释放出分配给它的资源，故应执行:
* Finish[i] = true 
* WORK[j] += Allocation[i][j]
* go to step 2
4. 如果所有进程的Finish[i] = true，则表示系统处于安全性状态，否则，系统处于不安全状态。

```C++
int check_safe(int i, int Request[]) //检查系统安全性
{
    int Work[MaxNumber];
    bool Finished[MaxNumber];
    memset(Finished, false, sizeof(Finished));
    for(int i = 0; i < m; i++)
        Work[i] = Available[i];
    sta = UnSafe;
    Dfs(0, Work, Finished);
    if(sta==UnSafe)
        recovery(i, Request);//还原数据
    return sta;
}
```
复杂度分析:安全性检查算法，有两种for循环，最内层for循环每次继续向下一层搜索，故时间复杂度为O((n * m)^ n)

## 利用Dfs找出所有安全序列
```C++
void Dfs(int i, int Work[], bool Finished[])//深度优先搜索,找到所有的安全序列
{
    if(i == n)
    {
        for(int j = 0; j < n; j++)
        {
            if(Finished[j] == false)
            {
                return ;
            }
        }
        sta = Safe;
        SafeOrder.push_back(temp);
        //temp.clear();
        return;
    }
    for(int j = 0; j < n; j++)
    {
        if(Finished[j] == false)
        {
            bool t = true;
            for(int k = 0; k < m; k++)
            {
                if(Need[j][k] > Work[k])
                {
                    t = false;
                    break;
                }
            }
            if(t == true)
            {
                for(int k = 0; k < m; k++)
                    Work[k] += Allocation[j][k];
                Finished[j] = true;
                temp.push_back(j);
                Dfs(i + 1, Work, Finished);
                temp.pop_back();       //回溯,将第i个进程所做的改变恢复
                for(int k = 0; k < m; k++)
                {
                    Work[k] -= Allocation[j][k];
                }
                Finished[j] = false;
            }
        }
    }
    return ;
}
```

## 测试数据
{% note default  no-icon%}
3
A 3
B 3
C 2
5
7 5 3
3 2 2
9 0 2
2 2 2
4 3 3
0 1 0
2 0 0
3 0 2
2 1 1
0 0 2
2
1
1
0
2
{% endnote %}

## 实验截图
![合理且安全的资源请求](/images/Banker's Algorithm1.jpg)
<center>合理且安全的资源请求</center>
![不合理的资源请求](/images/Banker's Algorithm2.jpg)
<center>不合理的资源请求</center>
![会导致系统处于不安全状态的资源请求](/images/Banker's Algorithm3.jpg)
<center>会导致系统处于不安全状态的资源请求</center>

## 完整代码
```C++
/*
Problem:银行家算法
Author:QiZhao
Data:2018-05-31
Description:预防进程死锁的银行家算法
Copyright  2018 QiZhao. All rights reserved.
*/
#include<iostream>
#include<vector>//提供vector
#include<cstring>//提供memset函数
#include<cstdio>//提供fflush函数
#include<cstdlib>//提供exit函数

using namespace std;

enum status {Safe, UnSafe};//安全性检查的结果
const int MaxNumber = 100;//进程数量的最大值

int Available[MaxNumber];//每种资源的可用数量
int Max[MaxNumber][MaxNumber];//n*m的矩阵,表示每个进程所需的最大资源量
string name[MaxNumber];//n个进程的进程名
int Allocation[MaxNumber][MaxNumber];//n*m的矩阵,表示每个进程每种资源已经分配的量
int Need[MaxNumber][MaxNumber];//n*m的矩阵,表示每个进程还需的每种资源量
int Request[MaxNumber];//所请求的每种资源的资源量
vector<vector<int> > SafeOrder;//存储所有的安全序列
vector<int> temp;//存储一个临时安全序列
int n, m;//进程数，资源种类数

status sta = UnSafe;//安全性检查的结果

//函数声明
void input();
void init();
void show();
void update(int i, int Request[]);
void recovery(int i, int Request[]);
bool check_bank(int i, int Request[]);
int check_safe(int i, int Request[]);
void request();
void choose();
void Dfs(int i,int Wordk[],bool Finished[]);
void menu();

//函数实现
void input()//读入数据
{
    cout << "请输入系统资源的种类数:";
    cin >> m;
    cout << "请依次输入" << m << "种系统资源的名称与数量:" << endl;
    for(int i = 0; i < m; i++)
        cin >> name[i] >> Available[i];
    cout << "请输入进程的数量:";
    cin >> n;
    cout << "请输入各个进程的最大需求量<" << n << "*" << m << "矩阵>[MAX]" << endl;
    for(int i = 0; i < n; i++)
    {
        for(int j = 0; j < m; j++)
            cin >> Max[i][j];
    }
    cout << "请输入各进程已申请的资量<" << n << "*" << m << "矩阵>[Allocation]" << endl;
    for(int i = 0; i < n; i++)
    {
        for(int j = 0; j < m; j++)
            cin >> Allocation[i][j];
    }
}

void init()//计算Need
{
    for(int i = 0; i < n; i++)
    {
        for(int j = 0; j < m; j++)
        {
            Need[i][j] = Max[i][j] - Allocation[i][j];
        }
    }
}

void show()//显示资源使用情况
{
    cout << " Max\tAllocation\tNeed\tAvaliable" << endl;
    for(int j = 0; j < 4; j++)
    {
        if(j==3)
            cout<<" ";
        for(int i = 0; i < m; i++)
        {
            cout << name[i] << " ";
            if(j == 1)
                cout << "  ";
        }
        cout << "\t";
    }
    cout<<endl;
    for(int i = 0; i < n; i++)
    {
        for(int j = 0; j < m; j++)
        {
            cout << Max[i][j] << " ";
        }
        cout << "\t";
        for(int j = 0; j < m; j++)
        {
            cout << Allocation[i][j] << "   ";
        }
        cout << "\t";
        for(int j = 0; j < m; j++)
        {
            cout << Need[i][j] << " ";
        }
        cout << "\t ";
        for(int j = 0; j < m; j++)
        {
            cout << Available[j] << " ";
        }
        cout << endl;
    }
}

void update(int i, int Request[]) //更新数据
{
    for(int j = 0; j < m; j++)
    {
        Available[j] -= Request[j];
        Allocation[i][j] += Request[j];
        Need[i][j] -= Request[j];
    }
}

void recovery(int i, int Request[])//还原数据
{
    for(int j = 0; j < m; j++)
    {
        Available[j] += Request[j];
        Allocation[i][j] -= Request[j];
        Need[i][j] += Request[j];
    }
}

bool check_bank(int i, int Request[]) //按照银行家算法检查资源请求
{
    for(int j = 0; j < m; j++)
    {
        if(Request[j] > Need[i][j] || Request[j] > Available[j])
            return false;
    }
    update(i, Request);
    return true;
}

void Dfs(int i, int Work[], bool Finished[])//深度优先搜索,找到所有的安全序列
{
    if(i == n)
    {
        for(int j = 0; j < n; j++)
        {
            if(Finished[j] == false)
            {
                return ;
            }
        }
        sta = Safe;
        SafeOrder.push_back(temp);
        //temp.clear();
        return;
    }
    for(int j = 0; j < n; j++)
    {
        if(Finished[j] == false)
        {
            bool t = true;
            for(int k = 0; k < m; k++)
            {
                if(Need[j][k] > Work[k])
                {
                    t = false;
                    break;
                }
            }
            if(t == true)
            {
                for(int k = 0; k < m; k++)
                    Work[k] += Allocation[j][k];
                Finished[j] = true;
                temp.push_back(j);
                Dfs(i + 1, Work, Finished);
                temp.pop_back();       //回溯,将第i个进程所做的改变恢复
                for(int k = 0; k < m; k++)
                {
                    Work[k] -= Allocation[j][k];
                }
                Finished[j] = false;
            }
        }
    }
    return ;
}

int check_safe(int i, int Request[]) //检查系统安全性
{
    int Work[MaxNumber];
    bool Finished[MaxNumber];
    memset(Finished, false, sizeof(Finished));
    for(int i = 0; i < m; i++)
        Work[i] = Available[i];
    sta = UnSafe;
    Dfs(0, Work, Finished);
    if(sta==UnSafe)
        recovery(i, Request);//还原数据
    return sta;
}

void request()//某个进程申请资源
{
    int i;
    memset(Request, 0, sizeof(Request));
    cout << "请输入要请求分配资源的进程号<0~" << n << ">:";
    cin >> i;
    cout << "请输入进程" << i << "申请的资源数目" << endl;
    for(int j = 0; j < m; j++)
    {
        cout << name[j] << ":";
        cin >> Request[j];
    }
    SafeOrder.clear();
    if(check_bank(i, Request) == true)
    {
        if(check_safe(i, Request) == Safe)
        {
            cout << "系统是安全的!" << endl;
            cout << "安全序列有:"<<SafeOrder.size()<<"种"<<endl;
            for(int j = 0; j < SafeOrder.size(); j++)//输出所有的安全序列
            {
                for(int k = 0; k < SafeOrder[j].size(); k++)
                {
                    cout << "P" << SafeOrder[j][k];
                    if(k != SafeOrder[j].size() - 1)
                        cout << "->";
                }
                if(SafeOrder[j].size()!=0)
                cout << endl;
            }
            return;
        }
        else
        {
            cout << "系统不安全,恢复原来状态!" << endl;
            return;
        }
    }
    else
        cout << "资源请求不合理!" << endl;
    return;
}
void choose()//选择菜单
{
    char i = -1;
    while(true)
    {
        fflush(stdin);
        cout << "请选择你要进行的操作" << endl;
        cin >> i;
        switch(i)
        {
        case '0':
            exit(0);
            break;
        case '2':
            request();
            break;
        case '1':
            show();
            break;
        default:
            cout << "输入有误,请重新输入" << endl;
        }
        menu();
    }
}

void menu()//显示菜单
{
    cout << "****************银行家算法演示***************" << endl;
    cout << "\t\t1:显示各个矩阵的内容" << endl;
    cout << "\t\t2:进程请求系统分配资源" << endl;
    cout << "\t\t0:退出程序" << endl;
    cout << "*********************************************" << endl;
}

int main()
{
    //freopen("in.txt", "r", stdin);
    //freopen("out.txt", "w", stdout);
    input();
    init();
    menu();
    choose();
    return 0;
}
```

## 参考资料
[银行家算法实现——找出所有安全序列](https://blog.csdn.net/qq_27008079/article/details/53946253)
[百度百科_银行家算法](https://baike.baidu.com/item/%E9%93%B6%E8%A1%8C%E5%AE%B6%E7%AE%97%E6%B3%95/1679781?fr=aladdin)
[《计算机操作系统（第四版）》](https://baike.baidu.com/item/计算机操作系统（第四版）/19925494)，汤小丹，西安电子科技大学出版社，2014.5