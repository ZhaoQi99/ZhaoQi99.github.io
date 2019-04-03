---
title: Git
date: 2019-03-19 00:02:43
comments: false
categories:
tags:
---
{% note warning %}
**2019.03.25冯哥，我困了**
{% endnote %}
{% note warning %}
**2019.03.29完成准备工作部分**
{% endnote %}
# 准备工作
## Git安装(Winodws)
1. 从[官网](https://git-scm.com/downloads)下载安装程序,安装时，请勾选Add to PATH选项，安装完之后有一个Git bash的东西
{% note warning %}
Git Bash，这是git for windows自带的一组程序，提供了Linux风格的shell，在该环境下，您可以直接用上面提到的命令来安装Node.js。打开它的方法很简单，在任意位置单击右键，选择“Git Bash Here”即可。
{% endnote %}
2. 安装完成后进行相关配置
`git config --global user.name "Your Name"`
`git config --global user.email "email@example.com"`
{% note warning %}
git config命令的--global参数，用了这个参数，表示你这台机器上所有的Git仓库都会使用这个配置，当然也可以对某个仓库指定不同的用户名和Email地址。
{% endnote %}

## Github 账号注册
1. 正常注册即可，然后点击邮箱中链接接受加入组织邀请
2. (Option)帮你搞一个正式一点的邮箱
3. (Option)修改一下Github的profile,在QQ邮箱中绑定outlook邮箱
3. ssh配置(参见相关文档2)

# 相关文档
1. [Git团队协作工作流](https://blog.csdn.net/qq_32452623/article/details/78905181)
2. [github设置添加SSH](https://www.cnblogs.com/chuyanfenfei/p/8035067.html)

# 常用命令
1.