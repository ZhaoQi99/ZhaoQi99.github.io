# Not_Baby

*Hmm.... What is this?*

---

```python
from Crypto.Util.number import *
with open('flag.txt', 'rb') as g:
    flag = g.read().strip()

with open('nums.txt', 'r') as f:
    s = f.read().strip().split()
    a = int(s[0])
    b = int(s[1])
    c = int(s[2])

e = 65537
n = a**3+b**3-34*c**3
m = bytes_to_long(flag)
ct = pow(m, e, n)

print("n: ", n)
print("e: ", e)
print("ct: ", ct)
```

在[factordb.com](http://factordb.com/)上分解n,得到

```python
n = 2^2 · 73 · 181 · 11411 · 235111 · 6546828737292350227122068012441477<34> · 61872434969046837223597248696590986360784288448775988338706090668799371<71>
```

继续尝试在[factordb.com](http://factordb.com/)上分解后两个数,发现二者均为素数

选择两个以上的素数相乘得到n时,公钥、私钥、加解密与一般 RSA 相同。

`φ(n)=(p1−1)(p2−1)(p3−1)...`

**exp**

```python
import gmpy2
from Crypto.Util.number import long2str
n = 57436275279999211772332390260389123467061581271245121044959385707165571981686310741298519009630482399016808156120999964
e = 65537
ct = 25287942932936198887822866306739577372124406139134641253461396979278534624726135258660588590323101498005293149770225633

ls = [2, 2, 73, 181, 11411, 235111, 6546828737292350227122068012441477, 61872434969046837223597248696590986360784288448775988338706090668799371]

phi = 1
for x in ls:
    phi *= (x-1)

d = gmpy2.invert(e, phi)
x = pow(ct, d, n)
print(long2str(x))
```

**flag:**`flag{f4ct0ring_s0000oo00000o00_h4rd}`