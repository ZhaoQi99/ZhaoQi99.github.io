# Happy Flag

*We have many flags. But we need a good flag!*

https://drive.google.com/file/d/1194sBi8Ijb4C-cYDGP2qZvXgj9uxSe7R/view?usp=sharing

---

题目给了一个文件`world_flags.zeep`,`file`后发现是一个zip压缩文件,使用`unzip`解压.

解压后发现有

```shell
~$ file world_flags.zeep
world_flags.zeep: Zip archive data, at least v1.0 to extract
~$ unzip world_flags.zeep
Archive:  world_flags.zeep
   creating: world_flags/
  inflating: world_flags/1.txt       
  inflating: world_flags/10.txt      
  inflating: world_flags/100.txt     
  inflating: world_flags/1000.txt    
  inflating: world_flags/10000.txt   
  inflating: world_flags/10001.txt
  ....
```

直接`cat`所有文件,然后用`uniq`去重

```shell
~$ cat *.txt | uniq
SBGTF{false_flag_🥺} 
SBCTF{Cool_flag_!!!}
```

**flag:**`SBCTF{Cool_flag_!!!}`