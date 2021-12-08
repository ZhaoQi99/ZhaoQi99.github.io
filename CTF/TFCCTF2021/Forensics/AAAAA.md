# AAAAA 

*AAAAA. That's all*

---

首先用`exiftool`分析,提示文件前2000个字节都是A

```shell
~$ exiftool AAAAA
ExifTool Version Number         : 12.31
File Name                       : AAAAA
Directory                       : .
File Size                       : 157 KiB
File Modification Date/Time     : 2021:11:27 00:33:54+08:00
File Access Date/Time           : 2021:11:27 00:35:25+08:00
File Inode Change Date/Time     : 2021:11:27 00:34:19+08:00
File Permissions                : -rw-r--r--
Error                           : First 2000 bytes of file is ASCII 'A' characters
```

`hexdump -C AAAAA   `发现文件末尾的字节也有很多A,并且文件应该是一张PNG格式的图片

```shell
~$ hexdump -C AAAAA | head
00000000  41 41 41 41 41 41 41 41  41 41 41 41 41 41 41 41  |AAAAAAAAAAAAAAAA|
*
000007d0  89 50 4e 47 0d 0a 1a 0a  00 00 00 0d 49 48 44 52  |.PNG........IHDR|
000007e0  00 00 07 62 00 00 05 89  08 02 00 00 00 23 47 40  |...b.........#G@|
000007f0  3c 00 00 00 09 70 48 59  73 00 00 2e 23 00 00 2e  |<....pHYs...#...|
00000800  23 01 78 a5 3f 76 00 02  65 2b 49 44 41 54 78 9c  |#.x.?v..e+IDATx.|
00000810  ec bd 67 7b 1a cb da b4  dd 83 10 39 83 50 b6 bd  |..g{.......9.P..|
00000820  c2 de ff ff df dc ef 5e  6b d9 96 ad 48 ce 39 cc  |.......^k...H.9.|
00000830  fb a1 9e a9 e3 12 b2 bd  1c 24 10 50 e7 07 1d 08  |.........$.P....|
00000840  21 18 26 f4 74 57 57 d7  e5 f9 be ef 84 10 42 08  |!.&.tWW.......B.|

~$ hexdump -C AAAAA | tail  
00026cf0  00 00 88 26 13 03 00 00  00 00 44 93 89 01 00 00  |...&......D.....|
00026d00  00 00 a2 c9 c4 00 00 00  00 00 d1 64 62 00 00 00  |...........db...|
00026d10  00 80 68 32 31 00 00 00  00 40 34 99 18 00 00 00  |..h21....@4.....|
00026d20  00 20 9a 4c 0c 00 00 00  00 10 4d 26 06 00 00 00  |. .L......M&....|
00026d30  00 88 f6 7f 00 7a e5 96  20 a3 a9 bd a4 00 00 00  |.....z.. .......|
00026d40  00 49 45 4e 44 ae 42 60  82 41 41 41 41 41 41 41  |.IEND.B`.AAAAAAA|
00026d50  41 41 41 41 41 41 41 41  41 41 41 41 41 41 41 41  |AAAAAAAAAAAAAAAA|
*
00027510  41 41 41 41 41 41 41 41  41                       |AAAAAAAAA|
00027519
```

去除文件首位的`A`即可,代码:

```python
from pathlib import  Path
p = Path('AAAAA')
data = p.read_bytes()
data = data.strip(b'A')
Path('a.png').write_bytes(data)
```

![AAAAA.png](../../CTF/TFCCTF2021/Forensics/images/AAAAA.png)

**flag:**`TFCCTF{Gr4phic_d35ign_is_my_p455ion}`

