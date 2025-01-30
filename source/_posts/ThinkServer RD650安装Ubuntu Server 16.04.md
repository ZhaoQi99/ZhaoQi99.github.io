---
title: ThinkServer RD650安装Ubuntu Server 16.04
categories: Linux
tags:
  - Ubuntu
  - Linux
date: '2018-07-24 22:50:22'
abbrlink: 560540611
---
## 准备工作
1. 在Ubuntu官网上下载Ubuntu Server 16.04的ISO镜像([下载链接](http://releases.ubuntu.com/16.04/))；
2. 使用刻录软件(如:软碟通)将iso镜像文件写入U盘中，制成启动盘；
3. 将ISO镜像文件拷贝至U盘的根目录，为了方便后续操作，这里可将镜像文件重命名为`Ubuntu.iso`；
<!--more-->

## 设置引导
1. 按电源键开机，启动服务器(服务器启动可能会比较缓慢)；
![1](images/Ubuntu_Server_16.04/IMG20180724134039.jpg)
2. 出现此界面时，按"F10"进入TDM(ThinkServer Deployment Manager)；
![](/images/Ubuntu_Server_16.04/IMG20180724134100.jpg)
3. 进入TDM后，选择"BIOS Setup(BIOS 设置)"；
![](/images/Ubuntu_Server_16.04/IMG20180724134421.jpg)
4. 选择"Boot Manager(引导管理)",将"Boot Mode(引导模式)"改为"UEFI Only(仅UEFI模式)"；
![](/images/Ubuntu_Server_16.04/IMG20180724134519.jpg)
5. 点击"Save & Reset(保存 & 重启)",在弹出的对话框中选择"Yes(是)"重启电脑。如果出现如下对话框，选择"No(否)"；
![](/images/Ubuntu_Server_16.04/IMG20180724134545.jpg)

## 开始安装
1. 将U盘插入服务器后的USB插槽中，重启服务器，进入下图所示界面。选择"Install Ubuntu Server(安装Ubuntu服务器版)"；
注:若无法进入下图所示界面，请进入BIOS修改U盘为第一启动项。
![](/images/Ubuntu_Server_16.04/IMG20180723165615.jpg)
2. 选择安装过程和系统的默认语言为"English(英语)"；
![](/images/Ubuntu_Server_16.04/IMG20180723165649.jpg)
3. "Select your location(选择你的区域)"，这里选择"Other(其他)"；
![](/images/Ubuntu_Server_16.04/IMG20180724153430.jpg)
4. "Continent or region(大陆或地区)"选择"Asia(亚洲)"；
![](/images/Ubuntu_Server_16.04/IMG20180724153439.jpg)
5. "Country(国家)"选择"China(中国)"；
![](/images/Ubuntu_Server_16.04/IMG20180724153448.jpg)
6. 是否通过一系列的按键检测键盘布局，选择"NO(否)"；
![](/images/Ubuntu_Server_16.04/IMG20180723165712.jpg)
7. 字符集编码选择"United States -en_US.UTF-8"；
![](/images/Ubuntu_Server_16.04/IMG20180724153454.jpg)
8. "Country or Region for the keyboard(键盘布局所属国家或地区)",选择"English(US)"；
![](/images/Ubuntu_Server_16.04/IMG20180723165717.jpg)
9. "Keyboard layout(键盘布局)"，选择"English(US)"；
![](/images/Ubuntu_Server_16.04/IMG20180723165725.jpg)
10. 稍等片刻，将会显示出现错误,原因为:安装程序未检测到CD-ROM。是否重试，选择"No(否)"；
![](/images/Ubuntu_Server_16.04/IMG20180723165744.jpg)
11. 进入如下界面，选择"Execute a shell(运行shell)"；
![](/images/Ubuntu_Server_16.04/IMG20180723165801.jpg)
12. 在shell中依次输入如下命令:
```
ls /dev/sd*
umount /dev/sdb4/
mkdir udev
mount /dev/sdb4 /udev
mount /udev/ubuntu.iso /cdrom
exit
```
一般会出现两个`/dev/sdb*`项，我们选择带数字的那一项去替换上面代码中的`/dev/sdb4`;
`ubuntu.iso`为U盘中Ubuntu Server的ISO镜像的文件名"。
![](/images/Ubuntu_Server_16.04/IMG20180723165911.jpg)
13. 进入如下界面后，选择"Detect and mount CD-ROM(探测并挂载光盘)"；
![](/images/Ubuntu_Server_16.04/IMG20180723165919.jpg)
14. 进入如下界面，选择"Network interface(网络接口)"，这里选择第一个网络接口，等待安装程序自动完成配置；
![](/images/Ubuntu_Server_16.04/IMG20180723165949.jpg)
15. 设置"Hostname(主机名)"；
![](/images/Ubuntu_Server_16.04/IMG20180723170037.jpg)
16. 设置"Full name for the new user(新用户的全名)"；
![](/images/Ubuntu_Server_16.04/IMG20180723170121.jpg)
17. 设置"Username for your account(你账号的用户名)"；
![](/images/Ubuntu_Server_16.04/IMG20180723170137.jpg)
18. 设置"password for the new user(新用户的密码)"；
![](/images/Ubuntu_Server_16.04/IMG20180723170145.jpg)
19. 如果所设置的密码较为简单，可能会弹出如下对话框，询问你是否使用一个"weak password(弱口令)"，选择"Yes(是)"；
![](/images/Ubuntu_Server_16.04/IMG20180723170157.jpg)
20. 出现如下界面，询问你是否"Encrypt your home directory(加密你的主目录)"；
![](/images/Ubuntu_Server_16.04/IMG20180723170208.jpg)
21. 然后可能会出现时区设置错误，选择 "Continue(继续)",进入如下界面，选择"Install the system(安装系统)",然后直接回车，选择"Partion disks(磁盘分区)"；
![](/images/Ubuntu_Server_16.04/IMG20180723170228.jpg)
![](/images/Ubuntu_Server_16.04/IMG20180723170234.jpg)
22. 出现下图界面，询问你是否"Umount partitions that are in use(卸载正在使用的分区)"，选择"Yes(是)"；
![](/images/Ubuntu_Server_16.04/IMG20180723170255.jpg)
23. 选择"Partitioning method(分区方法)"，这里我们选择"Guided - use entire disk and set up LVM(使用整个磁盘并配置LVM)"；
![](/images/Ubuntu_Server_16.04/IMG20180723170318.jpg)
24. "Select disk to partition(选择要分区的磁盘)"；
![](/images/Ubuntu_Server_16.04/IMG20180723170325.jpg)
25. 选择"Partitioning Scheme(分区方案) "，这里推荐选择"All files in one partition(所有文件放在同一分区)"；
![](/images/Ubuntu_Server_16.04/IMG20180723170331.jpg)
26. 出现如下界面，询问你是否"Write the changes to disks and configure LVM(将修改写入磁盘并配置LVM)"；
![](/images/Ubuntu_Server_16.04/IMG20180723170342.jpg)
27. 设置"Name of the volume group for the new system(新系统的卷组名)"；
![](/images/Ubuntu_Server_16.04/IMG20180723170359.jpg)
28. 设置"Amount of volume group to use for guided partitioning(用于分区引导的卷组数)"，默认大小即可，无需修改；
![](/images/Ubuntu_Server_16.04/IMG20180723170421.jpg)
29. 出现下图界面，询问你是否"Umount partitions that are in use(卸载正在使用的分区)"，选择"Yes(是)"；
![](/images/Ubuntu_Server_16.04/IMG20180723170434.jpg)
30. 出现如下界面，询问你是否"Force UEFI installation(强制UEFI安装)"，选择"Yes(是)"；
![](/images/Ubuntu_Server_16.04/IMG20180723170442.jpg)
31. 出现如下界面，询问是否"Write the changes to disks(将改动写入磁盘)"，选择"Yes(是)"；
![](/images/Ubuntu_Server_16.04/IMG20180723170452.jpg)
32. "Kernel to install(要安装的内核)",选择默认的"Linux-generic"即可；
![](/images/Ubuntu_Server_16.04/IMG20180723170544.jpg)
33. 回车后出现如下界面，这里要选择包含在initrd中的驱动程序，选择默认的"generic:include all available drivers(通用:包含所有可用的驱动程序)"即可；
![](/images/Ubuntu_Server_16.04/IMG20180723170555.jpg)
34. "HTTP proxy information(HTTP代理信息)"不写，直接回车即可；
![](/images/Ubuntu_Server_16.04/IMG20180723170657.jpg)
35. 询问你管理系统更新的方式，选择"No automatic updates(不自动更新)"；
![](/images/Ubuntu_Server_16.04/IMG20180723170737.jpg)
36. "Choose software to install(选择要安装的软件)"，建议勾选上"OpenSSh server"，然后回车;
选择方法为:通过键盘上下键移动光标至选要择项，在要选择的项上按空格即可；
![](/images/Ubuntu_Server_16.04/IMG20180724154325.jpg)
37. 回车后，显示安装完成，继续回车，重启系统，此时就可以拔掉U盘；
![](/images/Ubuntu_Server_16.04/IMG20180723170940.jpg)
38. 重启后，再次进入TDM，将"Boot Mode(引导模式)"改为"Legacy　Only(仅Legacy模式)"，否则有可能出现不能进入Linux系统的情况；