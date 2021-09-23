# cOrL

*Descriptions are hard give me a break. (Think of common usernames and passwords for admin) Link: http://147.182.172.217:42003/*

---

访问题目给出的链接，是一个简单的登录表单。用`admin:admin`登录

![cOrL](CTF/PBjarCTF2021/Web/assets/corl2.png)

使用Burp Suitel拦截请求，将HTTP请求方式修改为`Put`即可:

![image-20210923170425418](CTF/PBjarCTF2021/Web/assets/corl20-flag.png)

**flag:**`flag{HTTP_r3qu35t_m3th0d5_ftw}`