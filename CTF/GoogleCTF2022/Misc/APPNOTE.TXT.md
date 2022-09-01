# APPNOTE.TXT

*Every single archive manager unpacks this to a different file...*

*[Attachment](https://storage.googleapis.com/gctf-2022-attachments-project/2551253642bde3066e55c9cc8e9b0b4aa77feadc00c81032da778e6f7c89907135dfc2611fd8617204720dbfadb31429ae11f6ecd202887f4ce99f2f53a3c5e8)*

---

解压下载得到的文件`dump.zip`,得到`hello.txt`: `There's more to it than meets the eye...`

猜测可能有隐藏文件,用`binwalk`分析:

* 文件名从`flag00.zip`到`flag18.zip`
* 每个文件名出现36次

```bash
~$ binwalk dump.zip

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             Zip archive data, v0.0 compressed size: 41, uncompressed size: 41, name: hello.txt
135           0x87            Zip archive data, v0.0 compressed size: 33, uncompressed size: 33, name: hi.txt
256           0x100           Zip archive data, v0.0 compressed size: 1, uncompressed size: 1, name: flag00
345           0x159           Zip archive data, v0.0 compressed size: 1, uncompressed size: 1, name: flag00
434           0x1B2           Zip archive data, v0.0 compressed size: 1, uncompressed size: 1, name: flag00
523           0x20B           Zip archive data, v0.0 compressed size: 1, uncompressed size: 1, name: flag00
612           0x264           Zip archive data, v0.0 compressed size: 1, uncompressed size: 1, name: flag00
...
60598         0xECB6          Zip archive data, v0.0 compressed size: 1, uncompressed size: 1, name: flag18
60687         0xED0F          Zip archive data, v0.0 compressed size: 1, uncompressed size: 1, name: flag18
60776         0xED68          Zip archive data, v0.0 compressed size: 1, uncompressed size: 1, name: flag18
60865         0xEDC1          Zip archive data, v0.0 compressed size: 1, uncompressed size: 1, name: flag18
60954         0xEE1A          Zip archive data, v0.0 compressed size: 1, uncompressed size: 1, name: flag18
61043         0xEE73          Zip archive data, v0.0 compressed size: 1, uncompressed size: 1, name: flag18
61572         0xF084          End of Zip archive, footer length: 22
```

使用`strings`和`hexdump`分析,发现:

* 包含文件`hi.txt`: `Find a needle in the haystack...`
* 猜测flag的长度为18,每组`flagXX`表示了flag中的一个字符
* dump出来任意一组`flagXX`,得到flag的字母表`abcdefghijklmnopqrstuvwxyz{CTF0137}_`
* 已知flag格式为`CTF{...}`

```bash
~$ strings dump.zip
V~uK)
hello.txtThere's more to it than meets the eye...
V~uK)
hello.txtPK
hi.txtFind a needle in the haystack...
hi.txtPK
flag00aPK
flag00PK
flag00bPK
flag00PK
flag00cPK
flag00PK
flag00dPK
flag00PK
flag00ePK
......
flag18PK
flag181PK
flag18PK
flag183PK
flag18PK
flag187PK
flag18PK
flag18}PK
flag18PK
flag18_PK
flag18PK
```

```bash
~$ hexdump -C dump.zip | head -n 30
00000000  50 4b 03 04 00 00 00 00  00 00 00 00 00 00 56 7e  |PK............V~|
00000010  75 4b 29 00 00 00 29 00  00 00 09 00 00 00 68 65  |uK)...).......he|
00000020  6c 6c 6f 2e 74 78 74 54  68 65 72 65 27 73 20 6d  |llo.txtThere's m|
00000030  6f 72 65 20 74 6f 20 69  74 20 74 68 61 6e 20 6d  |ore to it than m|
00000040  65 65 74 73 20 74 68 65  20 65 79 65 2e 2e 2e 0a  |eets the eye....|
00000050  50 4b 01 02 00 00 00 00  00 00 00 00 00 00 00 00  |PK..............|
00000060  56 7e 75 4b 29 00 00 00  29 00 00 00 09 00 00 00  |V~uK)...).......|
00000070  fd ef 00 00 00 00 00 00  00 00 00 00 00 00 68 65  |..............he|
00000080  6c 6c 6f 2e 74 78 74 50  4b 03 04 00 00 00 00 00  |llo.txtPK.......|
00000090  00 00 00 00 00 9a 15 62  e9 21 00 00 00 21 00 00  |.......b.!...!..|
000000a0  00 06 00 00 00 68 69 2e  74 78 74 46 69 6e 64 20  |.....hi.txtFind |
000000b0  61 20 6e 65 65 64 6c 65  20 69 6e 20 74 68 65 20  |a needle in the |
000000c0  68 61 79 73 74 61 63 6b  2e 2e 2e 0a 50 4b 01 02  |haystack....PK..|
000000d0  00 00 00 00 00 00 00 00  00 00 00 00 9a 15 62 e9  |..............b.|
000000e0  21 00 00 00 21 00 00 00  06 00 00 00 84 ef 00 00  |!...!...........|
000000f0  00 00 00 00 00 00 87 00  00 00 68 69 2e 74 78 74  |..........hi.txt|
00000100  50 4b 03 04 00 00 00 00  00 00 00 00 00 00 43 be  |PK............C.|
00000110  b7 e8 01 00 00 00 01 00  00 00 06 00 00 00 66 6c  |..............fl|
00000120  61 67 30 30 61 50 4b 01  02 00 00 00 00 00 00 00  |ag00aPK.........|
00000130  00 00 00 00 00 43 be b7  e8 01 00 00 00 01 00 00  |.....C..........|
00000140  00 06 00 00 00 2b ef 00  00 00 00 00 00 00 00 00  |.....+..........|
00000150  01 00 00 66 6c 61 67 30  30 50 4b 03 04 00 00 00  |...flag00PK.....|
00000160  00 00 00 00 00 00 00 f9  ef be 71 01 00 00 00 01  |..........q.....|
00000170  00 00 00 06 00 00 00 66  6c 61 67 30 30 62 50 4b  |.......flag00bPK|
00000180  01 02 00 00 00 00 00 00  00 00 00 00 00 00 f9 ef  |................|
00000190  be 71 01 00 00 00 01 00  00 00 06 00 00 00 d2 ee  |.q..............|
000001a0  00 00 00 00 00 00 00 00  59 01 00 00 66 6c 61 67  |........Y...flag|
000001b0  30 30 50 4b 03 04 00 00  00 00 00 00 00 00 00 00  |00PK............|
000001c0  6f df b9 06 01 00 00 00  01 00 00 00 06 00 00 00  |o...............|
000001d0  66 6c 61 67 30 30 63 50  4b 01 02 00 00 00 00 00  |flag00cPK.......|
```

参照ZIP文件格式,按照`504B0304`、`504B0102`、`504B0506`分隔`dump.zip`的[十六进制表示形式](../../CTF/GoogleCTF2022/Misc/hex.out),分析发现:
* `hello.txt`和`hi.txt`一共占用256字节
* `flagXX`的文件实体为37字节、目录源数据为52字节
* 每组`flagXX`共占用(37 + 53) * 36字节

![B04B0506](../../CTF/GoogleCTF2022/Misc/images/B04B0506.png)

发现结尾多了18个目录数据源结束标识,猜测可能以此还原文件,以`flag00`为例:

目录源数据的开始位置偏移为`0x880A0000`,用小端表示为`0x00000A88`(2696),减去`hello.txt`和`hi.txt`的256字节,减去第一个文件实体的37字节,然后除以(37+52)得到27,指向`flag00`这一组的第27个文件实体(从0开始),即字符C.基于flag的格式以C开头,大胆猜测这就是正确答案.

剩下的过程与之类似,可以使用脚本简化:

```python
data = """\
880A0000
65170000
42240000
BB2F0000
6C380000
274A0000
7F520000
3A640000
71690000
377C0000
587F0000
F1950000
3E9D0000
5EA80000
88BC0000
92C50000
2CD40000
20DB0000
3FEE0000
""".split()
print(len(data))

CHOICES = 'abcdefghijklmnopqrstuvwxyz{CTF0137}_'
ans = list()

def conv(s):
  	# 大端转小端
    a = [s[2 * i:2 * (i + 1)] for i in range(len(s) // 2)]
    a.reverse()
    return ''.join(a)

for i,item in enumerate(data):
    t = int(conv(item), 16) - 256 - 37
    tt = t // (37 + 52)
    ttt = tt - 36 * i
    ans.append(CHOICES[ttt])
    print(''.join(ans))
```

flag:`CTF{p0s7m0d3rn_z1p}`

参考

* [从做CTF题到手撕ZIP](https://xz.aliyun.com/t/3994)
* [ZIP格式分析](http://lordaeronesz.top/2021/08/29/ZIP%E6%A0%BC%E5%BC%8F%E5%88%86%E6%9E%90/)
* [.ZIP File Format Specification](https://pkware.cachefly.net/webdocs/casestudies/APPNOTE.TXT)

