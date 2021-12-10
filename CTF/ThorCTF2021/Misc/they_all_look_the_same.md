# they all look the same

*They are slightly different*

https://drive.google.com/file/d/1XjkSCEjydggD7FHaWsBxKYTrivyesd1M/view?usp=sharing

---

解压下载的zip文件,发现里面一堆jpg文件,首先看看md5值
```shell
~$ md5 *
MD5 (images - Copy (1).jpg) = b69410fdc3f11fbac6bb3e32e40df1de
MD5 (images - Copy (10).jpg) = 1aa6e81b2335fdee91492125d4352503
MD5 (images - Copy (100).jpg) = 58d55ebd6b5b7717ec7188af4f4bef66
MD5 (images - Copy (101).jpg) = 58d55ebd6b5b7717ec7188af4f4bef66
MD5 (images - Copy (102).jpg) = 592434721909e841870ba0cfc0bce6aa
MD5 (images - Copy (103).jpg) = 58d55ebd6b5b7717ec7188af4f4bef66
MD5 (images - Copy (104).jpg) = 58d55ebd6b5b7717ec7188af4f4bef66
MD5 (images - Copy (105).jpg) = 58d55ebd6b5b7717ec7188af4f4bef66
```

然后用`exiftool`查看文件的元数据试试
```shell
~$ exiftool images\ -\ Copy\ \(1\).jpg
ExifTool Version Number         : 12.31
File Name                       : images - Copy (1).jpg
Directory                       : .
File Size                       : 16 KiB
File Modification Date/Time     : 2021:11:21 00:21:28+08:00
File Access Date/Time           : 2021:12:10 09:32:26+08:00
File Inode Change Date/Time     : 2021:12:10 09:32:26+08:00
File Permissions                : -rw-r--r--
File Type                       : JPEG
File Type Extension             : jpg
MIME Type                       : image/jpeg
JFIF Version                    : 1.01
Resolution Unit                 : inches
X Resolution                    : 96
Y Resolution                    : 96
Exif Byte Order                 : Big-endian (Motorola, MM)
Image Description               : S
XP Title                        : S
Padding                         : (Binary data 2060 bytes, use -b option to extract)
About                           : uuid:faf5bdd5-ba3d-11da-ad31-d33d75182f1b
Title                           : S
Description                     : S
Image Width                     : 376
Image Height                    : 134
Encoding Process                : Baseline DCT, Huffman coding
Bits Per Sample                 : 8
Color Components                : 3
Y Cb Cr Sub Sampling            : YCbCr4:2:0 (2 2)
Image Size                      : 376x134
Megapixels                      : 0.050
```

发现`Image Description`里有一个S,顺序打印一下所有文件的`Image Description`试试

```shell
~$ for i in `seq 1 153`;do exiftool images\ -\ Copy\ \(${i}\).jpg| grep "Image Description";done
Image Description               : S
Image Description               : B
Image Description               : C
Image Description               : T
Image Description               : F
Image Description               : {
Image Description               : H
Image Description               : 0
Image Description               : w
....

~$ cat tmp |  awk '{print $4}' | xargs echo
S B C T F { H 0 w _ c 0 u l d _ y 0 u _ d ! s t ! n g u ! s h S _ S S S ! S S S m S S S @ S S S g S S S 3 S S S s S S S _ S S S
```

结尾似乎有一些多余的S,去掉后即可得到flag

**flag:**`SBCTF{H0w_c0uld_y0u_d!st!ngu!sh_!m@g3s_}`