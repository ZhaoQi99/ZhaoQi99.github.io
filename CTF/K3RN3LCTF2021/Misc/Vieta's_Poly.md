# Vieta's Poly

Here's a pwntools tutorial challenge to get you warmed up!

nc ctf.k3rn3l4rmy.com 2236

https://ctf.k3rn3l4rmy.com/kernelctf-distribution-challs/Vietas-Poly/template.py

---

题目给了一个多项式,要求我们计算:

* 根的和
* 根的倒数的和
* 根的平方的和

解析出多项式系数,借助`numpy.poly1d`构造多项式,即可计算出根,进一步计算得到所需结果(需要保留两位小数)

代码:

```python
from math import ceil
from pwn import *
import numpy as np

context.log_level = 'debug'
conn = remote('ctf.k3rn3l4rmy.com', 2236)

def get_input():
    input = conn.recvline().strip().decode()
    return input

def parse(polynomial):
    '''
    TODO: Parse polynomial
    For example, parse("x^3 + 2x^2 - x + 1") should return [1,2,-1,1]
    '''
    pattern = re.compile(r"([-]?\d+?)x\^\d+")
    ls = pattern.findall(polynomial.replace(" ",''))
    ls.insert(0, 1)
    return list(map(int, ls))

for _ in range(4):
    get_input()
for i in range(100):
    type = get_input()
    coeffs = parse(get_input())
    ans = -1
    Q = np.poly1d(coeffs, r=False)
    xs = np.roots(Q)
    if 'sum of the roots' in type:
        ans = xs.sum()
    elif 'sum of the reciprocals of the roots' in type:
        ans = (1/xs).sum()
    elif 'sum of the squares of the roots' in type:
        ans = np.power(xs,2).sum()
    ans = ceil(round(ans.real,2))
    conn.sendline(str(ans))
    get_input()
conn.interactive()

```

**flag:**`flag{Viet4s_f0r_th3_win}`