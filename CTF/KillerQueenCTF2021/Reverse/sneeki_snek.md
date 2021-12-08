# sneeki snek

*ssssssssssssssssssssssssssssssssssssss*

---

根据字节码还原文件:

```python
f = ''
a = 'rwhxi}eomr\\^`Y'
z = 'f]XdThbQd^TYL&\x13g'
a = a + z
for i,b in enumerate(a):
    c = ord(b)
    c = c - 7
    c = c+i
    f += chr(c)

print(f)
```

**flag:**`kqctf{dont_be_mean_to_snek_:(}`