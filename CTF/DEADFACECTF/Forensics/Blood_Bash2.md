# Blood Bash 2

*We've obtained access to a system maintained by bl0ody_mary. We believe bl0ody_mary stole a sensitive document and is storing it on her Linux machine. Search her system for any files relating to De Monne Financial.*

*Username: `bl0ody_mary` Password: `d34df4c3`*

*bloodbash.deadface.io:22*

---

在`Documents`目录`ls -a`后发现存在文件`.demonne_info.txt`,`cat`即可
```shell
bl0ody_mary@16ef1481fce1:~$ ls -a
.  ..  flag.txt  .demonne_info.txt
bl0ody_mary@16ef1481fce1:~$ cat .demonne_info.txt
flag{a856b162978fe563537c6890cb184c48fc2a018a}
```

**flag:**`flag{a856b162978fe563537c6890cb184c48fc2a018a}`

