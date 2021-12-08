# Scary Bunny

*What could be inside this creepy rabbit?*

*[Download image](https://tinyurl.com/4csyne6s)*

*SHA1: 7ab2d9b1986ae12b780d0a2124a3adce6ed4c4e1*

---
使用`steghide info`查看图片隐写信息
```shell
╭─ ~/CTF/DEADFACE
╰─$ steghide info bunny.jpg
"bunny.jpg":
  format: jpeg
  capacity: 2.7 KB
Try to get information about embedded data ? (y/n) y
Enter passphrase:
  embedded file "steganopayload730241.txt":
    size: 13.0 Byte
    encrypted: rijndael-128, cbc
    compressed: yes
```
使用`steghide extract`提取隐写的文件`steganopayload730241.txt`
```shell
╭─ ~/CTF/DEADFACE
╰─$ steghide extract -sf bunny.jpg
Enter passphrase:
the file "steganopayload730241.txt" does already exist. overwrite ? (y/n) y
wrote extracted data to "steganopayload730241.txt".

╭─ ~/CTF/DEADFACE
╰─$ cat steganopayload730241.txt
flag{Carr0t}
```

**flag:**`flag{Carr0t}`