title: Windows下编译Miracl密码库
author: Zhao Qi
abbrlink: 2543483413
tags:
  - Miracl
  - 密码学
categories: []
date: 2020-04-20 16:32:00
---
# 介绍
Miracl是一个密码学C语言函数库,网上针对Windows环境下使用的教程都是使用MSVC编译的,步骤比较繁琐,还需安装Visual Studio。看了一下官网文档,是支持使用gcc进行编译的,遂尝试了一下。

# 所需环境
* [CodeBlocks](http://www.codeblocks.org/downloads)
* [Git Bash](https://gitforwindows.org/)
<!--more-->
# 编译
1. 从Github上下载项目最新源码。([下载地址](https://github.com/miracl/MIRACL/archive/master.zip))
2. 打开Git Bash,创建一个文件夹`miracl`，并将压缩文件拷贝至此。
`mkdir miracl`
3. 打开Git Bash，输入如下命令，将所有文件解压到一个目录中。
`unzip -j -aa -L master.zip`
4. 编辑`gcdoit.bat`，注释掉最后几行并保存。
{% asset_img pasted-1.png %}
5. 执行`gcdoit.bat`,生成的`miracl.a`即为编译好的库。

# 测试
1. 打开CodeBlocks，新建Console application项目。
{% asset_img pasted-2.png %}
2. 将`mirdef.h`、`miracl.h`、`miracl.a`拷贝至项目根目录。
3. 对着CB左侧工作空间中的项目名右键，点击添加文件,将上述三个文件添加至项目中。
{% asset_img pasted-3.png %}
4. 对着CB左侧工作空间中的项目名右键,点击生成选项,修改链接器设置.
{% asset_img pasted-4.png %}
{% note warning %}
环境设置选择: 仅使用项目选项
{% endnote %}
5. 在`main.c`中输入如下代码，进行测试。
```cpp
#include "miracl.h"
int  main() {
    big x,y,z;
    miracl *mip = mirsys(1000, 16);
    x= mirvar(0);
    y= mirvar(0);
    z= mirvar(0);
    bigbits(100,x);
    bigbits(100,y);
    bigbits(100,z);
    add(x,y, z);
    cotnum(z,stdout);
    return 0;
}
```
4. 点击CB中的生成并运行按钮，如图所示。
{% asset_img pasted-5.png 运行结果图%}

5. gcc编译命令为:
```cpp
gcc filename.c miracl.a -o filename
./filename.exe
```


# 参考资料
- [树莓派下编译并使用miracl密码库](https://www.cnblogs.com/little-kwy/p/12285955.html)
- [win10+gcc+miracl](https://blog.csdn.net/joker_clown/article/details/83662846)
