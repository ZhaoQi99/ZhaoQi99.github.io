# Blood Bash 3

*There's a flag on this system that we're having difficulty with. Unlike the previous flags, we can't seem to find a file with this flag in it. Perhaps the flag isn't stored in a traditional file?*

*Username: `bl0ody_mary` Password: `d34df4c3`*

*bloodbash.deadface.io:22*

---

在Unix/Linux系统中“一切皆文件”,socket也被认为是一种文件.

题意提示我们flag没有被存储在传统文件中,运行`netstat -ano`

```shell
bl0ody_mary@5349049d19cd:~$ netstat -ano
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       Timer
udp        0      0 127.0.0.1:43526         0.0.0.0:*                           off (0.00/0/0)
```

注意到有本地43526端口的监听(UDP),用`nc`连接一下

```shell
bl0ody_mary@16ef1481fce1:~$ nc -u 127.0.0.1 43526
flag{open_port(al)s}
```

**flag:**`flag{open_port(al)s}`

