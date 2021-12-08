# The Count

*Apparently DEADFACE is recruiting programmers, but spookyboi is a little apprehensive about recruiting amateurs. He's placed a password hash in the form of a flag for those able to solve his challenge. Solve the challenge and submit the flag as `flag{SHA256_hash}`.*

*[Link to Thread](https://ghosttown.deadface.io/t/what-programming-needs-are-there/56/4)*

*code.deadface.io:50000*

---

使用nc命令连接服务器
```shell
╭─ ~/CTF/DEADFACE
╰─$ nc code.deadface.io 50000
DEADFACE gatekeeper: Let us see how good your programming skills are.
If a = 0, b = 1, c = 2, etc.. Tell me what the sum of this word is:

 You have 5 seconds to give me an answer.

Your word is: tightfisted
Too slow!! Word has been reset!

```

我们取每一位字符的ASCII码后减去97,求和即可

```python
from pwn import *

p = remote('code.deadface.io', 50000)

x = p.recvline_contains(b'Your word')
word = x.decode().rsplit(':')[-1].strip()
count = sum([ord(x)-97 for x in word])
p.send(str(count).encode())
print(p.recvline())
print(p.recvline())
print(p.recvline())


```



**flag:**`flag{d1c037808d23acd0dc0e3b897f344571ddce4b294e742b434888b3d9f69d9944}`
