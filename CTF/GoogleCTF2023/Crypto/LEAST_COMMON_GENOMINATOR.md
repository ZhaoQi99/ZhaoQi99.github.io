# LEAST COMMON GENOMINATOR?

*Someone used this program to send me an encrypted message but I can't read it! It uses something called an LCG, do you know what it is? I dumped the first six consecutive values generated from it but what do I do with it?!*

*[Attachment](https://storage.googleapis.com/gctf-2023-attachments-project/4e90c59c2c12ac422f0b83094cca2c3e5c4c7cce464dddc5cb2ad391155f11c96a183290a289dfe1c64cc9e3cd467706f07e621904588ca4def3a4f6906234b7.zip)*

---

```python
from secret import config
from Crypto.PublicKey import RSA
from Crypto.Util.number import bytes_to_long, isPrime

class LCG:
    lcg_m = config.m
    lcg_c = config.c
    lcg_n = config.n

    def __init__(self, lcg_s):
        self.state = lcg_s

    def next(self):
        self.state = (self.state * self.lcg_m + self.lcg_c) % self.lcg_n
        return self.state

if __name__ == '__main__':

    assert 4096 % config.it == 0
    assert config.it == 8
    assert 4096 % config.bits == 0
    assert config.bits == 512

    # Find prime value of specified bits a specified amount of times
    seed = 211286818345627549183608678726370412218029639873054513839005340650674982169404937862395980568550063504804783328450267566224937880641772833325018028629959635
    lcg = LCG(seed)
    primes_arr = []

    dump = True
    items = 0
    dump_file = open("dump.txt", "w")

    primes_n = 1
    while True:
        for i in range(config.it):
            while True:
                prime_candidate = lcg.next()
                if dump:
                    dump_file.write(str(prime_candidate) + '\n')
                    items += 1
                    if items == 6:
                        dump = False
                        dump_file.close()
                if not isPrime(prime_candidate):
                    continue
                elif prime_candidate.bit_length() != config.bits:
                    continue
                else:
                    primes_n *= prime_candidate
                    primes_arr.append(prime_candidate)
                    break

        # Check bit length
        if primes_n.bit_length() > 4096:
            print("bit length", primes_n.bit_length())
            primes_arr.clear()
            primes_n = 1
            continue
        else:
            break

    # Create public key 'n'
    n = 1
    for j in primes_arr:
        n *= j
    print("[+] Public Key: ", n)
    print("[+] size: ", n.bit_length(), "bits")

    # Calculate totient 'Phi(n)'
    phi = 1
    for k in primes_arr:
        phi *= (k - 1)

    # Calculate private key 'd'
    d = pow(config.e, -1, phi)

    # Generate Flag
    assert config.flag.startswith(b"CTF{")
    assert config.flag.endswith(b"}")
    enc_flag = bytes_to_long(config.flag)
    assert enc_flag < n

    # Encrypt Flag
    _enc = pow(enc_flag, config.e, n)

    with open ("flag.txt", "wb") as flag_file:
        flag_file.write(_enc.to_bytes(n.bit_length(), "little"))

    # Export RSA Key
    rsa = RSA.construct((n, config.e))
    with open ("public.pem", "w") as pub_file:
        pub_file.write(rsa.exportKey().decode())
```

分析可知:

* flag是使用RSA加密的,已知公🔑 文件,即n,e

* 使用LCG线性同余生成器生成素数

* 已知LCG的种子和前6个连续生成的数字

* config.it = 8

* config.bits = 256

LCG是伪随机数生成器和流密码的一种,递推公式是 𝑋𝑛+1=(𝑎𝑋𝑛+𝑐) 𝑚𝑜𝑑 𝑚

已知初值和随后LCG连续生成的6个值,未知增量、乘数和模数.

我们可以通过攻击得到这三个值,然后只需要模拟原算法通过LCG得到8个素数后,通过欧拉函数求逆元得到e,解密即可.

题解:

```python
import math
from functools import reduce

import gmpy2

from Crypto.PublicKey import RSA
from Crypto.Util.number import bytes_to_long, isPrime, long_to_bytes

dump_file = open("dump.txt")
output_values = [int(x) for x in dump_file.readlines()]  # 已知的 LCG 输出值

def crack_unknown_increment(states, modulus, multiplier):
    """
    已知：a,m,s0,s1
    求c
    """
    increment = (states[1] - states[0] * multiplier) % modulus
    return modulus, multiplier, increment

def crack_unknown_multiplier(states, modulus):
    """
    已知：m,s0,s1,s2
    求a
    """
    multiplier = (
        (states[2] - states[1]) * gmpy2.invert(states[1] - states[0], modulus) % modulus
    )  # 注意这里求逆元
    return crack_unknown_increment(states, modulus, multiplier)

def crack_unknown_modulus(states):
    """
    已知：s0-s6
    求a,c,m
    """
    diffs = [s1 - s0 for s0, s1 in zip(states, states[1:])]
    zeroes = [t2 * t0 - t1 * t1 for t0, t1, t2 in zip(diffs, diffs[1:], diffs[2:])]
    modulus = abs(reduce(math.gcd, zeroes))
    return crack_unknown_multiplier(states, modulus)

class LCG:
    def __init__(self, lcg_m, lcg_c, lcg_n, lcg_s):
        self.state = lcg_s
        self.lcg_m = lcg_m
        self.lcg_c = lcg_c
        self.lcg_n = lcg_n

    def next(self):
        self.state = (self.state * self.lcg_m + self.lcg_c) % self.lcg_n
        return self.state


m, a, c = crack_unknown_modulus(output_values)
seed = 211286818345627549183608678726370412218029639873054513839005340650674982169404937862395980568550063504804783328450267566224937880641772833325018028629959635
lcg = LCG(a, c, m, seed)
print(a, c, m)
primes_n = 1
primes_arr = []
for i in range(8):
    while True:
        prime_candidate = lcg.next()
        if not isPrime(prime_candidate):
            continue
        elif prime_candidate.bit_length() != 512:
            continue
        else:
            primes_n *= prime_candidate
            primes_arr.append(prime_candidate)
            break

print(list(primes_arr))

phi = 1
for k in primes_arr:
    phi *= k - 1

key = RSA.importKey(open("public.pem", "r").read())
n = key.n
e = key.e
d = gmpy2.invert(e, phi)

enc = open("flag.txt", "rb").read()

flag = pow(int.from_bytes(enc, "little"), d, n)
print(long_to_bytes(flag))
```

**flag**: `CTF{C0nGr@tz_RiV35t_5h4MiR_nD_Ad13MaN_W0ulD_b_h@pPy}`

参考:

* [攻击线性同余生成器(LCG) | 码农网](https://www.codercto.com/a/35743.html)
* [LCG(线性同余生成器)_lcg线性同余_WustHandy的博客-CSDN博客](https://blog.csdn.net/weixin_45883223/article/details/115299389)
