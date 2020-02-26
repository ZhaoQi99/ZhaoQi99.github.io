title: C语言实现一个迷你Shell
author: Zhao Qi
abbrlink: 1118750159
tags:
  - Shell
  - C语言
  - Linux
categories: []
date: 2020-02-25 20:23:00
---
# 简介
俄勒冈州立大学（Oregon State University) CS 344作业,使用C语言实现一个Shell.
<!--more-->

# 要求
- 内置 `cd`,`status`和`exit` 命令
- 支持输入和输出的重定向
- 支持后台运行(&)
- Ctrl-Z 与 Ctrl-C
- 调用系统其他命令
- 替换命令中的`$$`为Shell的`PID`

# 参考资料
## 作业pdf

{% pdf  ./1118750159/Program3.pdf %}

## 测试脚本
{% include_code lang:bash   p3testscript %}

# 源码
{% include_code lang:c smallsh.c %}