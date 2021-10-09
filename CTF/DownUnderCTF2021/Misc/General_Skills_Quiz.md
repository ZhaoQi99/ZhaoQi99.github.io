# General Skills Quiz

*QUIZ TIME! Just answer the questions. Pretty easy right?*

*Author: Crem*

*`nc pwn-2021.duc.tf 31905`*

---

本题要求使用`nc`命令连接远程服务器,并在30s内回答所有问题.

代码:

```python
from pwn import *
from urllib.parse import unquote
import base64

def rot13(message):
    PAIRS = dict(zip("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
                     "nopqrstuvwxyzabcdefghijklmNOPQRSTUVWXYZABCDEFGHIJKLM"))
    return "".join(PAIRS.get(c, c) for c in message)

p = remote('pwn-2021.duc.tf', 31905)
p.send(b'\n')
p.recvuntil(b'ticking...', drop=True)
p.recvline()

while True:
    s = p.recvline().decode('utf-8').strip('\n')
    print(s)
    t = s.split()[-1]
    print(t)
    if '1+1=?' in s:
        p.send('2'.encode())
    elif 'Decode this hex string and provide me the original number (base 10)' in s:
        p.send(str(int(t, 16)).encode())
    elif 'Decode this hex string and provide me the original ASCII letter' in s:
        p.send(chr(int(t, 16)).encode())
    elif 'Decode this URL encoded string and provide me the original ASCII symbols' in s:
        p.send(unquote(t).encode())
    elif 'Decode this base64 string and provide me the plaintext' in s:
        p.send(base64.b64decode(t))
    elif 'Encode this plaintext string and provide me the Base64' in s:
        p.send(base64.b64encode(t.encode()))
    elif 'Decode this rot13 string and provide me the plaintext' in s:
        p.send(rot13(t).encode())
    elif 'Encode this plaintext string and provide me the ROT13' in s:
        p.send(rot13(t).encode())
    elif 'Decode this binary string and provide me the original number' in s:
        p.send(str(int(t, 2)).encode())
    elif 'Encode this number and provide me the binary equivalent' in s:
        p.send(bin(int(t)).encode())
    else:
        p.send('DUCTF\n'.encode())
        print(p.recvall().decode())
        break
    p.send('\n'.encode())
    p.recvline()
    p.recvline()
```

**flag:**`DUCTF{you_aced_the_quiz!_have_a_gold_star_champion}`

