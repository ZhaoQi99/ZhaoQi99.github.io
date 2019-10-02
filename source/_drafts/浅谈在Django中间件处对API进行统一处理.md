title: 浅谈在Django中间件处对API进行统一处理
author: Zhao Qi
abbrlink: 2620614917
tags:
  - Python
  - Django
  - API
categories:
  - Django
date: 2019-09-29 16:31:00
---
# 前言
公司实习时遇到一个问题:项目中所使用不是Restful API,所以每个视图函数中便充斥着如下的代码:
```python
result={
	"msg":'xx",
	"status":200,
	"result":data
}
return HttpResponse(json.loads(result))
```
为了解决该问题，自定义了一个Django中间件对API格式和异常进行统一处理，以此达到如下效果:
* 在view中只需返回data即可
* 在view中catch住可能出现的异常，`raise`自定义的异常
* 以此
* 对于`view`中出现的其他异常，`Response`会返回`Unknown exception`
* 异常的`message`实现i18n

# Django中对异常的处理

# 代码实现
## 文件
* middleware.py
* exceptions.py
* message.py

## 修改settings文件
`settings`

# 参考文献
* [Django文档](https://docs.djangoproject.com/zh-hans/2.1/topics/http/middleware/)
* [Github项目(django-exceptionbox)](https://github.com/shaowenchen/django-exceptionbox)
* [错误码设计以及 Django 的异常统一处理](https://www.chenshaowen.com/blog/error-code-design-and-unified-processing-in-django.html#32-ExceptionBox)