# Cloudsourcing

*Sourced in the cloud*

---

使用[RsaCtfTool](https://github.com/Ganapati/RsaCtfTool)破解公钥,将得到的私钥保存至`a.pem`

```shell
~$ python RsaCtfTool.py --publickey cloudsourcing/key.pub --private
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAzTf73VQrgsjh5aRpcE1waspEO5B48ZgjIfZyloCzR5cC2Rc1
e+YwvI/2hNPuageLgmjOqk6FLO3dxa2kemzH2EBG+n7RHlxIe4z6hobXCkXM4Sd4
O7NvHlkebe5ULoOvpJxs5f7LB4zNffl49MLVRmGJOWI33LVPi86VQg53U5nVCUTn
dmqWJsnjf06aeNJb0htFA1oy7eA9GaaNyBZC7recU+pj5CJmnlitxaSaLLTahi7m
lW92j4LDnDnIODhEtxqmWA3sMLoMGGwlve1+cXd4+r1ovhkBWmkBR5/lp/p2KQLs
pet5HzDZgAlvQzA0Cw2q6B2mt33hgVb7JfT8WQIDAQABAoIBADrihoWyoi2L4K3Z
KFwODGTIFx4UTW/dXK9hHO4sjcTMAwgxzan4miFxGaZxfWa1NYW89xgNIc+LjWgs
dBag4hMeFn/IJc8VYcL55+T0Cf4rmyc8ARb4XLkTj1Sx3zvdk2ejbufr3WwULd6o
19k7kqD4Wby6fxb4e5O9OjzTE9BLvr1NpHN1QRUupSUX3kv/mhtO3gQrRrkAT1L2
Ais+piqHmSrtX6YAnjood9oW2qy6oyBWvA11ipY9ZqfpI2G5Qc9WtViH/Erz2/3S
wFf0J9pgn+iAPbhcGwVh6U/cF+BcQZGse9GaY5Us4SJaQmM0ZdKiYbhKTRGBkudH
60sqeDUCgYEA0mwnrjcDpoc5Kv7qMB4AQCwP6LKnaG5q8Tc86JzYaPEnfUzl4trO
TruiSXmsok8RM/OLdAiIYiazz3GWgxFVNGtv+cEk4AKQnu2iRg5kP4wKBzqhYCnT
gMMMnt2UQfUrPOX7WDHaqQaOxkF06GJeHY7/RMswdOlXWx3w4oo2LJMCgYEA+atH
z0eS+0wzV4lubfpNl/6gi6KJxnpoPJtDt2vJBAa24fbS6ox9bx+Riki/CkpWiGDs
mb2ha1j5580kzDLfJjt1rncCd1iJy+S8zXmX0I1lkmhCnGKjsDDP4nqGmWoHyc9U
HxBYPWd2RtKNcBVDLImxr9IGe74GArU0Q2TmcuMCgYAvtwDEe4sjXvRysH1QTe1G
n/c3kBNwFeHAMwNnx/E20sBepGpYp78ykU+6k5G2+HDxM9/CfxDWGOqbNqmnrO2C
Rn6MxuRiu5Ipx78NXcQTuOCpRP1E/hcM0q3w9FPjJQIZ/BijpiJsQ6VqhXtKGsw2
ra9q3Rxu1l7NtZti825XawKBgHMG2LTE8xDYUKc56Ci/M1SduXXb0sIgzzltB0vQ
WvKB7Ww5/X6Wb4vs7W7aiTnCeg+nKBrE5UPB4JFNUHDL10eUCWnx5q75mbLYlavN
I4awPmWvp1DJmUSpmH1tmenAkgoGfWk6bI0Nx85lX0iOYz53yeeJSfdk2vwQZB3Q
tOOlAoGBAM83orP3tq+o57yvX/v36APtNW7ja7fMnSnmZRuWyJDqCJMNvGRlGObt
hfLludqNeJ4BSJ1nZNqbIvukk8J7DDukrGE5WxP+L1UmuIcTLgOeW7heMEUFbuVG
SpUX47+QBmx6Q8mHa97x/sGidZMlOEBG38bhvfdMgX0pW8zO+Oll
-----END RSA PRIVATE KEY-----
```

编写代码,用RSA解密

```python
from Crypto.PublicKey import RSA
from Crypto.Cipher import PKCS1_v1_5 as PKCS1_cipher
import base64
c = 'Oz5cG3uh6HGoPTsM9yERR2senJ+flkD9dikgzIDimT7xvguYEHGCMvYiD5F5dwbDIlvM7SqYxbzsx5L7+Kfg5OkvrJOMdc7tEsQK7L4n4QSN2mhxVP0AjxpHgufob+MfvL7/36grb6taeW8l5uLUveZ3aPK/XJt35znPScCxTLShFGj0xc/aCxRZYV+oNT6ygyPV4RSGh8v/yeY9bY1wIjYfQLqufKeogcsdBtBXTYQGCX+JQo9NVBLNkU7zQLT+AKit68HkTsORXhjNBFqvj4hQs3jB4rfUt54MKoDDuK0BFrfACKJIQe2LpmBtrVznlyfygIBfmFwrdkHRDi9bdA=='

with open('a.pem','r') as f:
    pri_key = RSA.importKey(f.read())
    cipher = PKCS1_cipher.new(pri_key)
    plain = cipher.decrypt(base64.b64decode(c), 0)
    print(plain)
```

**flag:**`kqctf{y0uv3_6r4du473d_fr0m_r54_m1ddl3_5ch00l_abe7e79e244a9686efc0}`