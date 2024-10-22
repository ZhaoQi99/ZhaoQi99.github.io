---
title: Django的一些魔改
author: Qi Zhao
comments: true
abbrlink: 2053290144
date: 2023-08-07 14:17:10
categories:
  - Django
tags:
  - Django
  - Python
  - Django REST Framework

---

# <a name="介绍">介绍</a>

[Django](https://docs.djangoproject.com/zh-hans/4.2/)和[Django REST Framework](https://www.django-rest-framework.org/)都是功能很强大的框架,为我们的开发工作提供了极大的便利.但在某些特定需求下,难免存在一些限制和不便之处,为此我们需要进行一些自定义修改和拓展(~~魔改~~).

<!-- more -->

# <a name="目录">目录</a>

- [介绍](#介绍)
- [目录](#目录)
- [Django](#django)
  - [Remove default Table](#remove-default-table)
  - [Remove is\_staff](#remove-is_staff)
    - [重写AdminSite](#重写adminsite)
    - [property](#property)
  - [Remove unused User field](#remove-unused-user-field)
  - [Exception Handle](#exception-handle)
    - [BackEnd](#exception-handle-backend)
      - [DRF中错误响应的结构](#drf中错误响应的结构)
      - [ValidationError的使用](#validationerror的使用)
      - [Custom exception handling](#custom-exception-handling)
    - [FrontEnd](#exception-handle-frontend)
- [Django REST framework](#django-rest-framework)
  - [Pagination unlimited](#pagination-unlimited)
- [Django Admin](#django-admin)
  - [Display JSONField](#display-jsonfield)
  - [Override UserAdmin](#override-useradmin)

# <a name="django">Django</a>

## <a name="remove-default-table">Remove default Table</a>

Django默认会在数据库中创建9张表,然而我们一般只使用Django作为后端接口来为前端提供服务,可能用不到这些默认生成的表.因此,为了节(技)省(术)资(洁)源(癖),我们可以禁用一些用不到的功能来避免在数据库中创建这些表.
Admin管理站点依赖的表:

- django_seesion
- django_admin_log
- django_content_type

如果既不需要使用Admin管理站点功能,也不需要使用session做会话保持,还需从`settings.py`文件配置的`MIDDLEWARE`中删除`django.contrib.sessions.middleware.SessionMiddleware`,以及从`INSTALLED_APPS`中删除`django.contrib.sessions`.
将`User`中的`groups`和`user_permissions`设置为`None`可以阻止Django创建user_groups,user_user_permissions两张表

<details open>
<summary>user.py</summary>

```python
from django.contrib.auth.models import AbstractUser

class User(AbstractUser):
    ...
    groups = []
    user_permissions = []
    ...
```

</details>

⚠️在公司生产环境中,如果不使用migrate命令,可以手动删除以下四张表:

* auth_group
* auth_permission
* auth_group_permissions
* django_migrations

## <a name="remove-is_staff">Remove is_staff</a>

在Django中,默认使用[is_staff](https://docs.djangoproject.com/zh-hans/4.1/ref/contrib/auth/#django.contrib.auth.models.User.is_staff)字段来控制用户能否登录管理站点.但在实际应用中,我们可能希望只使用`is_superuser`一个字段来同时控制用户的管理员权限和登录管理站点的权限,有以下两种实现方式.

### <a name="重写adminsite">重写AdminSite</a>

重写AdminSite中判断权限的逻辑,将其修改为判断`is_superuser`.参考[覆盖默认的管理站点 | Django 管理站点 | Django 文档](https://docs.djangoproject.com/zh-hans/4.2/ref/contrib/admin/#overriding-the-default-admin-site).

<details open>
<summary>myproject/admin.py</summary>

```python
from django.contrib import admin
from django.core.handlers.wsgi import WSGIRequest

class MyAdminSite(admin.AdminSite):
    def has_permission(self, request: WSGIRequest) -> bool:
        return request.user.is_active and request.user.is_superuser
```

</details>

### <a name="property">property</a>

除了重写`AdminSite`类,还可以借助`property`来实现.

<details open>
<summary>user.py</summary>

```python
from django.contrib.auth.models import AbstractUser

class User(AbstractUser):
    ...
    @property
    def is_staff(self):
        return self.is_superuser
```

</details>

这种方式会有副作用,它会从Django的用户模型中移除`is_staff`字段.由于Django默认的`UserAdmin`还会展示`is_staff`字段,所以在Admin站点中访问用户页面时会报错,解决方案可参考下一节[Remove unused User field](#remove-unsed-user-field).

此外,Django默认的用户`Manager`类中的`create_user`和`create_superuser`方法内部会调用`_create_user`方法给`is_staff`字段设置默认值并写入数据库.但实际上数据库中并不存在`is_staff`字段,从而导致报错.因此,我们还需重写`UserManager`中的`_create_user`方法.

<details>
<summary>models/user.py</summary>

```python
from django.contrib.auth.models import UserManager as BaseUserManager

class UserManager(BaseUserManager, SoftDeleteManagerMixin):

    def _create_user(self, username, email, password, **extra_fields):
        extra_fields.pop("is_staff")
        return super()._create_user(username, email, password, **extra_fields)

class User(AbstractUser):
    objects = UserManager()
    ...
```

</details>


<div class="note warning">
  <p>Update 2023.09.03</p>
  遇到了玄学错误...<br/>
  还是老老实实用"重写AdminSite"吧....
</div>

当通过将`User`中的`user_permissions`设置为`None`的方式来移除Django默认创建的表时.
如果一个已经登录过AdminSite站点的用户,从超级用户变为普通用户后,没有清理Cookie就去访问Admin站点会报错(预期效果如下图).原因是此时用户是`is_authenticated`的,从而绕过了`has_permission`的检查.对于普通用户,AdminSite类中的`get_app_list`方法内部调用的`has_module_permission`会尝试访问`user_user_permissions`从而导致报错;对于超级用户,`has_module_permission`则会直接返回为True.
可以通过重写AdminSite的`get_app_list`方法来解决.    
    ```python
  class MyAdminSite(admin.AdminSite):
  		...
        def get_app_list(self, request: WSGIRequest):
        if request.user.is_superuser is False:
            return []
        return super().get_app_list(request)
    ```
{% asset_img admin.png %}

## <a name="remove-unsed-user-field">Remove unused User field</a>

Django默认的用户模型中提供了一些附加字段,如`first_name`、`last_name`等.如果想移除这些不需要的字段,可以在`Model`中将它们设置为`None`,将这些字段从数据库中删除.

```python
from django.contrib.auth.models import AbstractUser

class User(AbstractUser):
    ...
    first_name = None
    last_name = None
    ...
```

由于Django默认的`UserAdmin`可能会尝试展示已被移除的字段,导致报错,因此我们还需要自定义`UserAdmin`来覆盖原有逻辑,如`list_display`、`fieldsets`等.完整例子见[UserAdmin](#override-user-admin)

<details open>
<summary>admin/user.py</summary>

```python
from django.contrib.auth.admin import UserAdmin as DjangoUserAdmin

class UserAdmin(DjangoUserAdmin):
    ...
```

</details>

## <a name="exception-handle">Exception Handle</a>

### <a name="exception-handle-backend">BackEnd</a>

#### <a name="drf中错误响应的结构">DRF中错误响应的结构</a>

首先,我们先了解一下[DRF中错误响应](https://www.django-rest-framework.org/api-guide/exceptions/#exceptions)的结构:

* 对于大多数异常,DRF会返回一个形如`{"detail": "Method 'DELETE' not allowed."}`的结构,一定包含`detail`键.

* 对于`ValidationError`,会返回一个以字段名称作为key,错误信息数组为value的结构;不属于某个特定字段的异常会使用setting中`NON_FIELD_ERRORS_KEY`的值(默认值为`non_field_errors·`)作为key.

<details open>
<summary>ValidationError Response</summary>

```json
{
    "field1": [
        "Error message 1",
        "Error message 2"
    ],
    "field2": [
        "Error message 3"
    ],
    ...
}
{
    "non_field_errors": [
        "Error message",
    ],
}
```

</details>

#### <a name="validationerror的使用">ValidationError的使用</a>

[ValidationError](https://www.django-rest-framework.org/api-guide/exceptions/#validationerror)(detail, code=None)必须传入detail参数,detail可以是list或dict,也可以是嵌套结构.

我们可以通过serializers中的`validate_<field_name>`方法对特定的[某个字段进行验证](https://www.django-rest-framework.org/api-guide/serializers/#field-level-validation),raise异常时detail参数可以为str/list,DRF最终会将其转换为`{'<filed_name>': ['xxxx', 'yyyy']}`的结构.

* `ValidationError('Invalid <filed_name>.')` -> `{'<filed_name>': ['Invalid <filed_name>.']}`
* `ValidationError(['Invalid msg 1','Invalid msg 2'])` -> `{'<filed_name>': ['Invalid msg 1', 'Invalid msg 2']}`

也可以在`validate`方法中对多个字段进行验证,此时raise异常时detail参数可以为str/list/dict.

* `ValidationError({'title': 'Invalid title'})` -> `{'title': ['Invalid title']}`
* `ValidationError({'title': ['Invalid title','Invalid title 2']})` -> `{'title': ['Invalid title','Invalid title 2']}`
* `ValidationError('Error message1')` -> `{'non_field_errors': ['Error message1']}`
* `ValidationError(['Error message1','Error message2'])` -> `{'non_field_errors': ['Error message1', 'Error message2']}`

#### <a name="custom-exception-handling">Custom exception handling</a>

有时候我们不得不在serializers的create/update中方法中raise ValidationError,此时DRF返回的结果为["Error in create"],与上
述结构不符.

```python
class TestSerializer(serializers.Serializer):
    ...
    def create(self, validated_data):
        ....
        raise serializers.ValidationError('Error in create.')
```

因此,我们还需要[自定义异常处理](https://www.django-rest-framework.org/api-guide/exceptions/#custom-exception-handling)来处理这种情况,以此保证错误响应结构的统一.
以及对于非预期的异常进行统一处理,将错误信息存储于`detail`字段中,并返回500 Internal Server Error.

<details>
<summary>lib.rest_framework.exception_handler.py</summary>

```python
from django.conf import settings
from rest_framework import exceptions, serializers, status
from rest_framework.response import Response
from rest_framework.views import exception_handler

def custom_exception_handler(exc, context):
    if isinstance(exc, exceptions.ValidationError):
        exc = exceptions.ValidationError(detail=serializers.as_serializer_error(exc))

    response = exception_handler(exc, context)

    if response is None:
        # request = context["request"] # Logging or other things
        if settings.DEBUG is True:
            return Response(
                {"detail": str(exc)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )
        else:
            return Response(
                {"detail": "Server Error (500)"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )
    return response
```

</details>

### <a name="exception-handle-frontend">FrontEnd</a>

前端的错误响应处理则主要分为三种类型:

* 400 Bad Request
  * 优先从detail字段获取异常信息
  * detail字段为空时,用`NON_FIELD_ERRORS_KEY`(这里设置为errors)的值作为异常信息
  * 否则,遍历错误响应数据,逐行展示每个字段的错误信息
* 401 Unauthorized
  * 登录接口的请求直接reject
  * 非登录接口的GET请求,提示用户重新登录
  * 非登录接口的非GET请求,提示用户选择"直接重新登录"/"在新窗口登录",防止用户填写的表单数据丢失
* 其他 -> 直接依据HTTP状态码弹窗提示即可

<details>
<summary>request.js</summary>

```js
import axios from 'axios';
import { MessageBox, Message } from 'element-ui'

const service = axios.create({
  ...
});

service.interceptors.response.use(
  (response) => {
    return response.data;
  },
  (error) => {
    let msg = '';
    const status = error.response.status;
    const method = error.response.config.method;
    const data = error.response.data;
    const { errors = [], detail = null } = data;
    if (status === 400) {
      if (detail !== null) {
        msg = detail;
      } else if (errors.length > 0) {
        msg = errors.join('<br />');
      } else if (typeof data === 'object') {
        msg = Object.entries(data)
          .map(([key, value]) => `${key}: ${JSON.stringify(value)}`)
          .join('<br />')
      }
    } else if (status === 401) {
      if (error.response.config.url !== '/account/login/') {
        if (method.toUpperCase() === 'GET') {
          MessageBox.alert('由于用户长时间未操作,请重新登录!', '错误提示', {
            type: 'warning',
            confirmButtonText: '重新登录',
          })
            .then(() => {
              // 重新登录
            })
            .catch(() => {
              // Close
            })
        } else {
          MessageBox.alert(
            '登录状态已失效,您可在新窗口登录成功后返回当前页面',
            '提示',
            {
              type: 'warning',
              distinguishCancelAndClose: true,
              confirmButtonText: '在新窗口登录',
              cancelButtonText: '直接重新登录',
              showCancelButton: true,
            }
          )
            .then(() => {
              // 在新窗口登录
              window.open(window.location.href, '_blank')
            })
            .catch((action) => {
              if (action === 'cancel') {
                // 直接重新登录
              } else {
                // Close
                Message({
                  message: '取消!',
                  type: 'info',
                });
              }
            });
        }
        return Promise.reject(error);
      }
      return Promise.reject(error);
    } else if (status === 403) {
      msg = '你没有权限, 请联系管理员';
    } else if (status === 500) {
      msg = '服务器内部错误';
    } else if (status === 502 || status === 504) {
      msg = '服务器开小差了';
    } else {
      msg = `HTTP ${status}-错误${detail ? ':' + detail : ''}`;
    }
    Message({
      message: msg,
      type: 'error',
      duration: 5 * 1000,
    });
    return Promise.reject(error);
  }
);
```

</details>

# <a name="django-rest-framework">Django REST framework</a>

## <a name="pagination-unlimited">Pagination unlimited</a>

在一些场景中(如下拉框选项),我们可能需要一次性从分页接口获取所有数据,通常的做法是前端传递一个非常非常大的page_size.借助DRF（Django Rest Framework）中的自定义分页类,我们可以更优雅的实现无限制分页,具体步骤如下:

* 创建新的分页类,并在`settings.py`中配置
* 后端通过特定的参数(如`pagination_unlimited`)来表示开启无限制分页,在需要开启的视图中声明为True
* 前端传递一个特定的参数(如`unlimited`)来表示无限制的分页,以获取所有数据
* [Pagination - Django REST framework](https://www.django-rest-framework.org/api-guide/pagination/#using-your-custom-pagination-class)

<details open>
<summary>Setting pagination class in settings.py</summary>

```python
REST_FRAMEWORK = {
    ...
  "DEFAULT_PAGINATION_CLASS": "lib.rest_framework.pagination.PageNumberPagination",
  "PAGE_SIZE": 25
    ...
}
```

</details>

<details>
<summary>lib/rest_framewor/pagination.py</summary>

```python
from rest_framework import pagination

class PageNumberPagination(pagination.PageNumberPagination):
    page_size_query_param = "page_size"
    unlimited_query_param = "unlimited"
    unlimited_query_description = (
        "A boolean value to indicate whether return all results."
    )
    unlimited_view_attribute = "pagination_unlimited"

    def get_schema_operation_parameters(self, view):
        parameters = super().get_schema_operation_parameters(view)
        if getattr(view, self.unlimited_view_attribute, None) is True:
            parameters.append(
                {
                    "name": self.unlimited_query_param,
                    "required": False,
                    "in": "query",
                    "description": self.unlimited_query_description,
                    "schema": {
                        "type": "boolean",
                    },
                }
            )
        return parameters

    def get_unlimited(self, request):
        unlimited = request.query_params.get(self.unlimited_query_param, None)

        if unlimited is None:
            return False
        if unlimited.lower() in ("1", "true"):
            return True
        elif unlimited.lower() in ("0", "false"):
            return False
        return None

    def paginate_queryset(self, queryset, request, view=None):
        self.request = request
        unlimited = self.get_unlimited(request)
        if (
            unlimited is True
            and getattr(view, self.unlimited_view_attribute, None) is True
        ):
            page_size = queryset.count()
            paginator = self.django_paginator_class(queryset, page_size)
            self.page = paginator.page(1)
            return list(self.page)
        return super().paginate_queryset(queryset, request, view)
```

</details>

<details>
<summary>views.py</summary>

```python
from rest_framework import viewsets

class TestViewSet(viewsets.ModelViewSet):
    ...
    pagination_unlimited = True
    ...

class TestViewSet(viewsets.ModelViewSet):
    ...
    @property
    def pagination_unlimited(self):
        if self.action == "XXXX":
            return True
        return False
    ...
```

</details>

# <a name="django-admin">Django Admin</a>

## <a name="display-JSONField">Display JSONField</a>

在Django Admin中更友好的展示`JSONField`字段的值.

```python
import json

from django.contrib import admin
from django.utils.safestring import mark_safe

class TestAdmin(admin.ModelAdmin):
    ...
    readonly_fields = ("pretty_config",)

    def pretty_config(self, obj):
        result = json.dumps(
            obj.config, indent=2, sort_keys=True, ensure_ascii=False
        )
        return mark_safe(f"<pre>{result}</pre>")x 
```

## <a name="override-user-admin">Override UserAdmin</a>

基于[django@517d3bb](https://github.com/django/django/blob/517d3bb4dd17e9c51690c98d747b86a0ed8b2fbf/django/contrib/auth/admin.py#L44)的`UserAdmin`源码,移除无关字段的`UserAdmin`如下.

<details>
<summary>admin/user.py</summary>

```python
class UserAdmin(DjangoUserAdmin):
    fieldsets = (
        (None, {"fields": ("username", "password")}),
        (
            _("Personal info"),
            {
                "fields": (
                    # "first_name",
                    # "last_name",
                    "email",
                )
            },
        ),
        (
            _("Permissions"),
            {
                "fields": (
                    "is_active",
                    # "is_staff",
                    "is_superuser",
                    # "groups",
                    # "user_permissions",
                ),
            },
        ),
        (_("Important dates"), {"fields": ("last_login", "date_joined")}),
    )

    list_display = (
        "username",
        "email",
        # "first_name",
        # "last_name",
        # "is_staff",
    )
    search_fields = (
        "username",
        # "first_name",
        # "last_name",
        "email",
    )
    filter_horizontal = (
        # "groups",
        # "user_permissions",
    )
    list_filter = (
        # "is_staff",
        "is_superuser",
        "is_active",
        # "groups",
    )
```

</details>
