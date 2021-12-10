# Email Hunt

*I want to find the PGP Public Key of someone's ProtonMail account, but all I got is a useless document he shared with me (https://docs.google.com/spreadsheets/d/1iBRs347v5xXICdgHm4-sQBEFozbqhTABPIespxSBI20).*
*Can you help me find it?*

*Note: Please submit the flag like this example:*
```asciiarmor
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: ProtonMail

aBBBBBBBBBBBBBBBB
BBBBBBBBBBBBBBBBB
BBBBYz
-----END PGP PUBLIC KEY BLOCK-----
```

*Flag: SBCTF{aBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBYz}*

---

访问题目中给出的Google表格的链接.

然后访问[https://docs.google.com/spreadsheets/u/0/](https://docs.google.com/spreadsheets/u/0/)查看最近访问的表格文件,并用F12抓包

![image-20211208101433762](../../CTF/ThorCTF2021/Osint/images/image-20211208101433762.png)

找到Gmail邮箱`priv4te3mail0fmr.8@gmail.com`

题目要求我们找到ProtonMail账号的PGP公钥,猜测邮箱前缀可能一样,即`priv4te3mail0fmr.8@gmail.com`

参照[https://protonmail.com/support/knowledge-base/download-public-private-key/](https://protonmail.com/support/knowledge-base/download-public-private-key/),下载PGP公钥

```shell
~$ wget https://api.protonmail.ch/pks/lookup?op=get&search=priv4te3mail0fmr.8@protonmail.com
--2021-12-08 10:43:59--  https://api.protonmail.ch/pks/lookup?op=get&search=priv4te3mail0fmr.8@protonmail.com
正在解析主机 api.protonmail.ch (api.protonmail.ch)... 185.70.42.25
正在连接 api.protonmail.ch (api.protonmail.ch)|185.70.42.25|:443... 已连接。
已发出 HTTP 请求，正在等待回应... 200 OK
长度：709 [application/pgp-keys]
正在保存至: “lookup?op=get&search=priv4te3mail0fmr.8@protonmail.com”

lookup?op=get&search=priv4te3mail0fmr 100%[========================================================================>]     709  --.-KB/s  用时 0s

2021-12-08 10:44:00 (225 MB/s) - 已保存 “lookup?op=get&search=priv4te3mail0fmr.8@protonmail.com” [709/709])
~$ cat lookup?op=get&search=priv4te3mail0fmr.8@protonmail.com
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: ProtonMail

xjMEYZcIIhYJKwYBBAHaRw8BAQdAgXzkYJTBPtkxMSemLogafK1ryTzAsPoU
bjT8hQ6Wc4XNRXByaXY0dGUzbWFpbDBmbXIuOEBwcm90b25tYWlsLmNvbSA8
cHJpdjR0ZTNtYWlsMGZtci44QHByb3Rvbm1haWwuY29tPsKPBBAWCgAgBQJh
lwgiBgsJBwgDAgQVCAoCBBYCAQACGQECGwMCHgEAIQkQBcfjCjlf+3IWIQRS
LQS+kFOUoSEmSs4Fx+MKOV/7cgCtAP0dhlLk+UMY9FBnN/SiR+nIObn0q4f/
AS2k8kRvuA9cQgEA13kb1fTDmIGXp/rkTh9MSUt22m6rF5khiOr9yCYoTQrO
OARhlwgiEgorBgEEAZdVAQUBAQdARRDPDTZcD3gJkaXMzYOSGcLSY0M8PEMs
8w0eI9ydnxcDAQgHwngEGBYIAAkFAmGXCCICGwwAIQkQBcfjCjlf+3IWIQRS
LQS+kFOUoSEmSs4Fx+MKOV/7ckoLAQCjmVOWyFLflAz5dCinOZI0G8yOsduV
8PSw2hvTeyiZMwEAkl9U2tmg2i/XW5PckxqvNgxAZZkkEoQPWa6UpKICIw8=
=E+gi
-----END PGP PUBLIC KEY BLOCK-----
```

**flag:**`SBCTF{xjMEYZcIIhYJKwYBBAHaRw8BAQdAgXzkYJTBPtkxMSemLogafK1ryTzAsPoUbjT8hQ6Wc4XNRXByaXY0dGUzbWFpbDBmbXIuOEBwcm90b25tYWlsLmNvbSA8cHJpdjR0ZTNtYWlsMGZtci44QHByb3Rvbm1haWwuY29tPsKPBBAWCgAgBQJhlwgiBgsJBwgDAgQVCAoCBBYCAQACGQECGwMCHgEAIQkQBcfjCjlf+3IWIQRSLQS+kFOUoSEmSs4Fx+MKOV/7cgCtAP0dhlLk+UMY9FBnN/SiR+nIObn0q4f/AS2k8kRvuA9cQgEA13kb1fTDmIGXp/rkTh9MSUt22m6rF5khiOr9yCYoTQrOOARhlwgiEgorBgEEAZdVAQUBAQdARRDPDTZcD3gJkaXMzYOSGcLSY0M8PEMs8w0eI9ydnxcDAQgHwngEGBYIAAkFAmGXCCICGwwAIQkQBcfjCjlf+3IWIQRSLQS+kFOUoSEmSs4Fx+MKOV/7ckoLAQCjmVOWyFLflAz5dCinOZI0G8yOsduV8PSw2hvTeyiZMwEAkl9U2tmg2i/XW5PckxqvNgxAZZkkEoQPWa6UpKICIw8==E+gi}`

