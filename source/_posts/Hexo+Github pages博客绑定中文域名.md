---
title: Hexo+Github pages博客绑定中文域名
categories: Hexo
tags:
  - Hexo
  - Github
abbrlink: 24787
date: 2018-02-12 18:48:43
---
## 摘要
近期又开始了hexo的折腾，在阿里云上买了一个属于自己的域名，因此想着把自己用hexo+Github搭建的博客通过域名访问，于是按照百度上的教程一步一步来绑定域名，结果出现了很多问题 。整个过程可谓一波三折，终于实现了通过域名来访问博客，下面简要介绍一下我绑定域名过程中遇到的问题以及解决方案。
<!--more-->
## 购买域名
这里以在[阿里云](https://www.aliyun.com/)上购买域名为例,大家也可以去其他平台购买域名。
登录阿里云，点击**产品**，选择**域名注册**。
注册域名前需查询域名是否已被注册，选择自己喜欢的域名，支付即可。
![](/images/20180213014855.jpg)
一般来说，.top与.xyz结尾的域名都比较便宜。为了节约成本，我买的.top结尾的域名，一年只需两块钱，很便宜。
## 域名解析
购买域名后，我们依次点击个人昵称->域名与网站(万网)->域名，进入管理控制台，在这里我们可以看到自己购买的域名,点击**解析**，进入解析设置。
![](/images/20180212235815.jpg)
点击添加解析，依次输入：**CNAME、@、Github博客地址**，点击**确定**，完成个人域名向个人博客的映射。
![](/images/20180212230359.jpg)
<div class="note warning"><p>注意：这里填入博客地址的时候无需填写https:// ，只需按照example.github.io格式填写就行了。
</p></div>

## 创建CNAME文件
在本地的根目录下的source文件夹中新建一个名为**CNAME**的文本文件，文件内容为**个人域名**（没有http:// ,也没有www.）,然后重命名删除该文件的后缀名:**.txt**。
使用`hexo d -g`命令部署博客，这时在浏览器中输入新注册的域名，已经可以正常的访问博客了。

### 英文域名
英文域名就直接写:`example.con`
### 中文域名
中文域名的话,则需先将中文域名转换为**Punycode标准编码的字符串**:[中文域名转换Punycode标准编码工具](http://www.dh.vg/tools/zm.php)
For example:
`例子.中文`经过转换为`xn--fsqu00a.xn--fiq228c`
将`xn--****.xn--***`填入**CNAME**文件即可。
<div class="note danger"><p>如果直接在CNAME文件中填写中文域名,则Github会通过邮件提醒你:
The CNAME xxx.com is not properly formatted. See https://help.github.com/articles/troubleshooting-custom-domains/#github-repository-setup-errors for more information.
</p></div>
## LeanCloud数据丢失
通过域名访问博客，发现文章的阅读次数不显示，于是各种折腾：检查元素、谷歌，最后发现是由于没有将新注册的域名加入到LeanCloud设置中的**Web 安全域名**,导致无法调用服务器资源。
解决方案：访问：[LeanCloud官网](https://leancloud.cn),进入**控制台**，在设置中点击**安全中心**，将新注册的域名加入到**Web安全域名**中，点击**保存**即可。
![](/images/20180213013700.jpg)

## busuanzi数据丢失
无论是通过域名还是github地址访问博客，博客底部的统计浏览量与浏览人次均不是以前的数据，而是从头开始计算....
busuanzi还不具备统初始值的功能，只能从头开始计算了。。。

## 拓展
### 中文域名
１、一类是域名后缀为英文字母的国际中文域名和别国中文域名，比如：中文.com，中文.net，中文.biz，中文.cc，中文.hk，中文.tm，中文.tv，中文.tw；
２、一类是域名后缀为中文的纯中文国内中文域名，比如：中文域名.中国，中文域名.公司，中文域名.网络；
中文域名在解析的时候，需要先转换为 xn--fiq228c.com或xn--fiq228c.cn形式的ASCII码，这种编码称为PunyCode。纯中文域名不被标准的解析服务器支持，要实现对这种纯中文域名的正确访问，ISP需要做相应的修改，以便能够正确解析中文域名。同时CNNIC也提供了专用服务器，用户只要将浏览器的DNS设置指向这台服务器，它同样可以完成对纯中文域名的正确解析。另外，考虑到现在有些ISP还没有做修改，而有些用户又不方便将DNS设置指向CNNIC提供的服务器，纯中文域名会被加上.cn后缀，即对每一个纯中文域名同时有两种形式：纯中文域名和纯中文域名.CN， 如："中文域名.网络"和"中文域名.网络.CN"。这样即使ISP还没有做相应的修改，用户也可以正确使用中文域名。
### PunyCode
英文域名在IIS或Apache中的虚拟主机设置，可以直接使用英文域名，如webmasterhome.cn。
中文域名在IIS或Apache中应如何设置主机头呢？如"中国站长之家.com"。
1、在进行设置之前要先把中文域名转化成为PunyCode编码，然后在主机头设置里面填上中文域名所对应的PunyCode编码(｀xn--fiqsC146Ah4ex80Cro7A.com｀)便可。
新的国际化域名的标准在网域名称编码上，为了保留向下兼容性及不影响现有的应用程序协议，因此将多国语言域名转成ASCII编码，而这种编码称为『punycode』。
因为经过Nameprep处理过的国际化域名是以 Unicode 序列的形式表示的。但现有的 DNS系统只支持用 ASCII字符表示的域名，所以要对Unicode序列进行 ACE(ASCII-compatible encoding)编码，把 Unicode序列表示的域名转换成 ASCII 字符串表示的ACE域名。
2、PunyCode是一种专为国际化域名而设计的高效ACE编码方式。它可以在Unicode序列和ASCII 字符串之间进行唯一的和可逆的转换。转换的过程中，Unicode 序列中的ASCII字符保持不变，国际化字符则用字母和数字来表示。它的实质是一种用数量有限的基本字符(字母和数字)来唯一地表示大字符集(Unicode)中的字符的通用算法。域名中的字符，包括 ASCII 码和 Unicode 码，都是作为整数进行处理。
PunyCode则是将一个经过Nameprep处理过的IDN，从一个8位的编码的形式转换为7位编码的形式。目前Internet DNS一向是7位ASCII编码的环境，经过这个PunyCode转码程序，便将IDN从一个8位的IDN转换为与现有DNS环境兼容的编码。
3、在DNS服务器方面，需要将IDN以PunyCode的编码形式来设定。因为PunyCode本身就是一种7位的编码，与ASCII编码完全兼容，所以可适用设定于目前所有可用的DNS版本,也就是说可以不需要为了设定PunyCode而重新安装BIND新版本。但是若是需要使用DNAME指令来设定资源记录(Resource Record)，则需先提升为BIND9的版本。

