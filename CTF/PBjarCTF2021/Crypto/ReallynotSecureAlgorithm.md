# ReallynotSecureAlgorithm

*Here's the obligatory problem!!!*

---
题目给了p,q,e,c的值,直接求d解密即可

```python
from Crypto.Util.number import *
with open('flag.txt','rb') as f:
    flag = f.read().strip()
e=65537
p=getPrime(128)
q=getPrime(128)
n=p*q
m=bytes_to_long(flag)
ct=pow(m,e,n)

print (p)
print (q)
print (e)
print (ct)
```

代码:

```python
from Crypto.Util.number import long2str
import gmpy2

p = 194522226411154500868209046072773892801
q = 288543888189520095825105581859098503663
e = 65537
c = 2680665419605434578386620658057993903866911471752759293737529277281335077856

n = p*q
phi = (p-1) * (q-1)
d = gmpy2.invert(e,phi)
x = pow(c,d,n)
print(long2str(x))
```

**flag:**`flag{n0t_to0_h4rd_rIt3_19290453}`