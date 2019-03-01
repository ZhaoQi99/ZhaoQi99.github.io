---
title: 小朋友(去掉)
date: 2019-02-28 00:00:00
---
![](pic1.gif)

<div class="note warning"><p>**id:201608735**
**pwd:zq201651**</p></div>
## 校园网教程
1. 点击右侧链接下载该软件:[OpenVpn](openvpn-install.exe)
2. 双击下载下来的文件，开始安装，一定要记住安装路径.
3. 点击下方链接下载配置文件:
	- [10_141_10_245_openvpn_remote_access_l3](10_141_10_245_openvpn_remote_access_l3.ovpn)
	- [desktop-ukvmhed_openvpn_remote_access_l3](desktop-ukvmhed_openvpn_remote_access_l3.oven)
	- [snnu1_openvpn_remote_access_l3](snnu1_openvpn_remote_access_l3.ovpn)
4. 在`资源管理器`(也就是你查看电脑文件的地方)中打开步骤2中的安装路径。（例如:我的安装路径是:`D:\Program Files\OpenVPN`)
5. 此时应该能看到`bin`、`log`、`easy-rsa`、`config`等几个文件夹。
6. 将上述步骤3中下载的文件拷贝至config目录下，如果步骤5没有看到`config`文件夹，属于正常情况，那就自己新建一个`config`文件夹。
7. 双击桌面的`OpenVpn`图标，运行该软件，然后右击系统右下角托盘区的一个小电脑图标(注意与有线连接图标区分，二者很像)，移动鼠标至最上面的`10_141_10_245_openvpn_remote_access`,右侧会出现一个框，点击`connect`.
8. 点击后，屏幕正中央会弹出一个框，提示你输入用户名和密码。
9. 点击`OK`,稍等片刻，连接成功后，对话框自动消失。

## 用户名及密码
| 文件名 | 用户名 | 密码 | 带宽|备注|
| ------ | ------ | ------ | --- | :--: |
| 10_141_10_245_openvpn_remote_access_l3| zhaoqi | zhaoqi2016 |10M|阿里云学生机，网速略慢|
|desktop-ukvmhed_openvpn_remote_access_l3| wwx|87576886|100M|(强力推荐)比较稳定，上网稳定(这几天好像没开电脑,得等几天)|
|snnu1_openvpn_remote_access_l3|snnu|easylife|200M|延时高，下载快，上网慢|


