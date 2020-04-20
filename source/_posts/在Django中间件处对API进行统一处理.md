tags:
  - Python
  - API
  - Django
categories:
  - Django
title: 在Django中间件处对API进行统一处理
author: ''
abbrlink: 2620614917
date: 2019-10-04 17:56:00
---
# 前言
公司实习时遇到一个问题:项目中所使用不是Restful API,每个视图函数都要先生成字典，于是项目中便充斥着如下的代码:
```python
result={
	"msg":'xx",
	"status":200,
	"result":data
}
return HttpResponse(json.loads(result))
```
<!--more-->

维护起来比较麻烦，对前端也很不友好，为了解决该问题，自定义了一个Django中间件对API格式和异常进行统一处理，以此达到如下效果:
* 在view中只需返回`data`，`raise`自定义的异常
* 实现自定义异常状态码(`status`)和自定义异常信息(`message`)
* view中返回的`Object`若为`Model`,则会返回调用其`__str__`方法的结果
* 对于`view`中出现的其他异常，`Response`会返回`Unknown exception`
* 异常信息(`message`)实现了`i18n`


# Django中对异常的处理
## Django中对request的处理
* 首先执行`process_request`函数，然后在执行视图函数之前执行`process_view`函数，再执行视图函数，最后执行`process_response`函数
* `process_request`只返回`None`，所有中间件的`process_request`执行完之后，就匹配路由，找到对应的视图函数，在执行视图函数之前先执行中间件的 `process_view`函数
* 如果`process_view`返回 None，就继续执行后续的中间件的`process_view`方法，执行完所有的`process_view`函数之后执行视图函数
* 如果其中有个 process_view 返回了 HttpResponse，就不执行后续的 process_view 函数，会跳到第一个 process_response 函数，并继续往下执行

![Diango中中间件处理过程](../images/pasted-0.png)

## 中间件(类)中5种方法
中间件中可以定义5个方法:
* process_request(request)
* process_view(request, view_func, view_args, view_kwargs)
* process_exception(request, exception)
* process_template_response(request, response)
* process_response(request, response)

### process_request
1. 中间件在收到`request`请求之后执行
2. 按照`settings.py`中`MIDDLEWARE_CLASSES`的顺序，顺序执行
3. 如果该函数返回`None`，继续执行后面的中间件的`process_request`方法
4. 如果该函数返回`HttpResponse`，则不再继续执行后面的中间件的`process_request `方法

### process_view
1. 执行完所有中间件的`process_request`方法
2. 在`urls.py`中找到对应视图函数
3. 拿到视图函数的名称、参数，在执行视图函数之前执行
4. 如果返回`None`，则继续执行后面的中间件的`process_view`函数，然后执行下昂应的视图函数
5. 如果返回`HttpResponse`，则不执行后续的`process_view`函数，也不执行视图函数，然后执行所有的`response`中间件

### process_exception
1. 执行视图函数的过程中如果引发异常，则按照`settings.py`中`MIDDLEWARE_CLASSES`的顺序，倒序执行`process_exception`方法
2. 如果返回`None`，继续执行下一个中间件的`process_exception`方法 
3. 如果返回`HttpReponse`对象，则该中间件上方其他中间件的`process_exception`方法不会被调用
4. 一旦其中某个中间件有返回值，则调用`template_response`和`response`中间件
,否则启动[默认的异常处理](https://docs.djangoproject.com/zh-hans/2.1/ref/views/#error-views)

{% note info %}
最后半句个人理解:如果如果所有中间件的`process_exception`方法都执完后还没有返回值，则启动默认的异常处理
{% endnote %}

### process_template_response
1. 在视图函数执行结束之后执行
2. `response`是Django视图或者某一中间件的返回值(`TemplateResponse`对象或等价)
3. 只有`response`实现了`render`方法才会执行
4. 一旦所有的中间件的`template_response`被执行完，则调用`render`方法
5. 按照中间件的顺序，倒序执行

### process_response
1. 在视图函数执行结束之后执行
2. 必须有返回值，且返回类型必须是`HttpResponse`对象
3. 按照中间件的顺序，倒序执行

# 代码实现
## 文件
* middleware.py
```python
from django.utils.deprecation import MiddlewareMixin
from django.models import models
from django.core.serializers.json import DjangoJSONEncoder
from django.http import JsonResponse

class MyMiddleware(MiddlewareMixin):
    def process_exception(self, request, exception):
        if not isinstance(exception, BaseException):
            if settings.DEBUG:
                return JsonResponse({'result': '', 'msg': str(exception), 'status': 1000})
            else:
                return JsonResponse(UnknownException().as_dict())
        else:
            return JsonResponse(exception.as_dict())

    def process_response(self, request, response):
        procese_type = (list, tuple, dict, str, int)
        if isinstance(response, models.Model):
            response = str(response)
        if isinstance(response, procese_type):
            ret = {'result': response, 'msg': 'success', 'status': 200}
            return JsonResponse(ret, encoder=DjangoJSONEncoder)
		else:
			return response
```
* exceptions.py
```python
from abc import ABCMeta
from .message import ErrorMsg
class InterFaceAsDictInterFace:
    def as_dict(self):
        ret = {'result': '', 'msg': getattr(self, '__msg__', ''), 'status': getattr(self, '__status__', '')}
        return ret

class BaseException(Exception, InterFaceAsDictInterFace):
    __metaclass__ = ABCMeta

    def __init__(self, msg=None):
        super(BaseException, self).__init__()
        if msg is not None:
            self.__msg__ = msg

class UnknownException(InterFaceAsDictInterFace):
	__status__ = 1000
	__msg__ = ErrorMsg.UNKNOWN_EXCEPTION

class MyException(BaseException):
	__status__=1001
	__msg__=ErrorMsg.MY_EXCEPTION

```
* message.py

```python
from django.utils.translation import gettext as _
class ErrorMsg:
	UNKNOWN_EXCEPTION= _('Unknown exception.')
	MY_EXCEPTION = _('Test exception.')
```


## 修改settings文件
修改`setting`中的`MIDDLEWARE_CLASSES`变量
```python
MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'middleware.MyMiddleware',
]
```

# Todo
## 对前端Post请求进行参数校验
目前想出来了两种策略(假设`post_json`为序列化后的字典):
1. 视图函数中使用`get`从字典中获取参数，判断`required`的参数是否为空，`raise`自定义的异常，如:
```python
# exception.py
...
class ValidationError(BaseException):
	__msg__ = ErrorMsg.INVALID_ARGUMENT
	__status__ = 1001
...


# message.py
class ErrorMsg:
	UNKNOWN_EXCEPTION= _('Unknown exception.')
	INVALID_ARGUMENT = _('Invalid arguments.')
	REQUIRED_ARGUMENT = _('A {0} argument is required.')

# view.py
def test(request):
	...
	user_name = post_json.get('username','')# required
	pass_word = post_json.get('password','')# required
	user_type = post_json.get('user_type','')# not required
	if not username or not password:
		raise ValidationError(ErrorMsg.REQUIRED_ARGUMENT.format('username/passswordd'))
	...
```
2. 视图函数中对参数不做校验，只需在中间件添加一句，即可对视图函数中`raise`的`KeyError`进行统一处理
```python
# exception.py
...
class ValidationError(BaseException):
	__msg__ = ErrorMsg.INVALID_ARGUMENT
	__status__ = 1001
...

# middleware.py
...
def process_exception(self, request, exception):
 if isinstance(exception, KeyError):
	exception = ValidationError(ErrorMsg.REQUIRED_ARGUMENT.format(exception))
	...

# message.py
class ErrorMsg:
	UNKNOWN_EXCEPTION= _('Unknown exception.')
	INVALID_ARGUMENT = _('Invalid arguments.')
	REQUIRED_ARGUMENT = _('A {0} argument is required.')

# view.py
def test(request):
	...
	user_name = post_json['user_name'] # required
	user_type = post_json.get('user_type','')# not required
	...

```

## 视图函数返回
目前视图函数必须有返回值，不能为`None`，还不知道怎么解决

# 参考文献
* [Django 中间件官方文档](https://docs.djangoproject.com/zh-hans/2.1/topics/http/middleware/)
* [Django 国际化官方文档](https://docs.djangoproject.com/zh-hans/2.2/topics/i18n/translation/)
* [Github项目(django-exceptionbox)](https://github.com/shaowenchen/django-exceptionbox)
* [错误码设计以及 Django 的异常统一处理](https://www.chenshaowen.com/blog/error-code-design-and-unified-processing-in-django.html#32-ExceptionBox)
* [Django----中间件详解](https://www.cnblogs.com/huchong/p/7819296.html)