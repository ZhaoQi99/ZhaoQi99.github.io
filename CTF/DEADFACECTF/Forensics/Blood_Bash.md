# Blood Bash

*We've obtained access to a system maintained by bl0ody_mary. There are five flag files that we need you to read and submit. Submit the contents of flag1.txt.*

*Username: `bl0ody_mary` Password: `d34df4c3`*

*bloodbash.deadface.io:22*

---

使用`ssh`命令连接,`ls - R`后发现`Documents`目录下有一个`flag.txt`文件,直接`cat`即可.
```shell
╭─ ~/CTF/DEADFACECTF
╰─$ ssh bl0ody_mary@bloodbash.deadface.io
bl0ody_mary@bloodbash.deadface.io's password: 
bl0ody_mary@16ef1481fce1:~$ ls -R
.:
'De Monne Customer Portal.pdf'   Documents   Downloads   Music   Pictures   Videos

./Documents:
flag1.txt

./Downloads:

./Music:

./Pictures:

./Videos:
bl0ody_mary@16ef1481fce1:~$ cat Documents/flag1.txt
flag{cd134eb8fbd794d4065dcd7cfa7efa6f3ff111fe}
```

**flag:**`flag{cd134eb8fbd794d4065dcd7cfa7efa6f3ff111fe}`

