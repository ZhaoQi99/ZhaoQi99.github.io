# Key Exchange

*Let's exchange the flag (securely):*
*nc crypto.chall.pwnoh.io 13374*

---

分析给出的代码,发现当输入的B等于g的时候,A的值即为`shared_secret`,从而可以得到AES密钥,解密后即可得到flag.

使用nc连接服务器:

```shell
╭─ ~/CTF/BuckeyeCTF2021
╰─$ nc crypto.chall.pwnoh.io 13374
I'm going to send you the flag.
However, I noticed that an FBI agent has been eavesdropping on my messages,
so I'm going to send it to you in a way that ONLY YOU can decrypt the flag.

p = 10880518517873967643757501014080864657695946662967756945469976115601889926901188881654458659008874387964581741306546485865737476973040012870453076020399351
g = 5
A = 6446823763385202977767001480185601116794559100492085785295943164615816598597259338015414246293095497644717507604784350316218874347470456507125850300019180
Give me your public key B: 5
ciphertext = a54eef574e0764239040ee22ffe762c907e7390372bf7de1f8ea7db0fa8218490890d545e5694332c8de1154fdff4cfb830a304df635217155b453bd12beb4e8
```


代码

```python
def decrypt():
    shared_secret = 6446823763385202977767001480185601116794559100492085785295943164615816598597259338015414246293095497644717507604784350316218874347470456507125850300019180
    key = hashlib.sha1(cun.long_to_bytes(shared_secret)).digest()[:16]
    cipher = AES.new(key, AES.MODE_ECB)
    message = 0xa54eef574e0764239040ee22ffe762c907e7390372bf7de1f8ea7db0fa8218490890d545e5694332c8de1154fdff4cfb830a304df635217155b453bd12beb4e8
    plaintext = cipher.decrypt(cun.long_to_bytes(message))
    print(plaintext)

decrypt()
```

**flag:**`buckeye{DH_1s_s0_h3ck1ng_c00l_l1k3_wh0_w0uldv3_th0ught_0f_th1s?}`

