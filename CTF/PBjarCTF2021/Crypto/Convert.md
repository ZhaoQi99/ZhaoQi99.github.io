# Convert

*So this is supposed to be the challenge for absolute beginners. For this chall, you will get a hexadecimal number, and have to convert it to text. If you don't know how to do this, Google is your best friend!!!*

---

给了一个文件`file.txt`,里面是一个16进制的数:


```python
n = '666c61677b6469735f69735f615f666c346767675f68317d'
for i in range(0,len(n),2):
    print(chr(int(n[i:i+2],16)),end='')
```

**flag:**`flag{dis_is_a_fl4ggg_h1}`

