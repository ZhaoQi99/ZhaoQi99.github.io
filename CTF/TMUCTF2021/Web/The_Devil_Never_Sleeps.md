# The Devil Never Sleeps

*If you put the devil to sleep, you will get the flag successfully. Unfortunately, the devil never sleeps. But what if you use some sleeping pills?*

*[http://194.5.207.57:8080](http://194.5.207.57:8080/)*

---

访问题目链接
```
To get sleeping pills, navigate to /sleepingpill. To get the flag, navigate to /flag.
```

访问`/sleepingpill`得到`JWT`和`Public Key`,保存至`pub.key`

```ASN.1
-----BEGIN PUBLIC KEY-----
MIGsMA0GCSqGSIb3DQEBAQUAA4GaADCBlgKBjgD/////////////////////////
/////////////////////////////////////////////////////////////3//
///////////+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAECAwEAAQ==
-----END PUBLIC KEY-----
```

访问`/flag`

```json
{
   "msg": "Missing Pill Header"
}
```

加上`Pill`试试,可以看到是一个标准的`JWT`格式

```json
{
    "msg": "Missing 'Bearer' type in 'Pill' header. Expected 'Pill: Bearer <JWT>'"
}
```

在[jwt.io](https://jwt.io/)上解析一下`JWT`

![jwt](assets/jwt-decoded.jpg)

使用[RsaCtfTool](https://github.com/Ganapati/RsaCtfTool)生成私钥,保存至`private.pem`

```shell
python RsaCtfTool.py --publickey ./key.pub --private
```

```ASN.1
-----BEGIN RSA PRIVATE KEY-----
MIICmwIBAAKBjgD/////////////////////////////////////////////////
/////////////////////////////////////3/////////////+AAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAECAwEAAQKBjSp/1YAqf9WAKn/VgCp/1YAqf9WAKn/VgCp/1YAqf9WA
Kn/VgCp/1YAqf9WAKn/VgCp/1YAqf9WAKn/VgCp/1YAqVVWqqlVVqqpVVaoAVf+q
AFX/qgBV/6oAVf+qAFX/qgBV/6oAVf+qAFX/qgBV/6oAVf+qAFX/qgBV/6oAVf+q
AFX/qgBV/6oAVf+qAQJMf///////////////////////////////////////////
/////////////////////////////////////////////////////////wJCAf//
////////////////////////////////////////////////////////////////
////////////////////AkxVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWq
qlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqpAkIB
gIB/f4CAf3+AgH9/gIB/f4CAf3+AgH9/gIB/f4CAf3+AgH9/gIB/f4CAf3+AgH9/
gIB/f4CAf3+AgH9/gIB/f38CTHve973ve973ve9773ve973ve973ve+973ve973v
e973vve973ve973ve9773ve973ve973ve+973ve973ve973vve973ve973ve970=
-----END RSA PRIVATE KEY-----
```

修改`payload`中的`sleep`为`true`和`exp`为`9999999999`,生成`JWT Token`并请求`/flag`

代码:

```Python
import jwt

with open('private.pem','r') as f:
    secret = f.read()
print(secret)

dic = {
    "fresh": False,
    "iat": 1631241476,
    "jti": "4b30d7a8-256f-405e-9640-4278728a8602",
    "type": "access",
    "sub": "devil",
    "nbf": 1631241476,
    "exp": 9999999999,
    "sleep": "true",
    "danger": "true"
}
headers = {
    "typ": "JWT",
    "alg": "RS256"
}
token = jwt.encode(dic, secret, headers=headers, algorithm='RS256')
print(token)
```

**flag:**`TMUCTF{0h_51nn3rm4n_Wh3r3_Y0u_60nn4_Run_70?}`
