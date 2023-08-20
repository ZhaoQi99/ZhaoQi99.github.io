---
title: Django的一些魔改
author: Qi Zhao
comments: true
abbrlink: 2053290144
date: 2023-08-07 14:17:10
categories:
tags:
- Django
- Python

---

# 介绍

[Django](https://docs.djangoproject.com/zh-hans/4.2/)和[Django REST Framework](https://www.django-rest-framework.org/)都是功能很强大的框架,为我们的开发工作提供了极大的便利.但在某些特定需求下,难免存在一些限制和不便之处,为此我们需要进行一些自定义修改和拓展(~~魔改~~).

<!-- more -->

# 目录

* [Django](#django)
  
  * [Remove default table](#remove-default-table)
  
  * [Remove is_staff](#remove-is_staff)
    
    * [重写AdminSite]()
    
    * [property]()
  
  * [Exception Handle](#exception-handle)
    
    * Frontend
    
    * Backend

* [Django REST framework](#django-rest-framework)
  
  * [Pagination unlimited](#pagination-unlimited)

* [Django Admin](#django-admin)
  
  * [Display JSONField](#display-JSONField)
  
  * [Override UserAdmin](#override-user-admin)

# <a name="django">Django

## <a name="remove-default-table">Remove default Table

* TODO

## <a name="remove-is_staff">Remove is_staff

在Django中,默认使用[is_staff](https://docs.djangoproject.com/zh-hans/4.1/ref/contrib/auth/#django.contrib.auth.models.User.is_staff)字段来控制用户能否登录管理站点.但在实际应用中,我们可能希望只使用`is_superuser`一个字段来同时控制用户的管理员权限和登录管理站点的权限,可以通过以下两种方式实现.

### 重写AdminSite

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

### property

除了重写`AdminSite`类,还可以使用`property`来实现通过`is_superuser`字段控制用户访问Admin管理站点的权限.

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

此外,由于数据库中并不存在`is_staff`字段,Django默认的用户`Manager`的`create_user`和`create_superuser`方法中会给`is_staff`设置默认值并写入数据库,导致调用时出现报错.因此,我们还需重写`UserManager`中的`_create_user`方法.

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

## <a name="remove-unsed-user-field">Remove unused User field

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

## <a name="exception-handle">Exception Handle

### FrontEnd

TODO

### BackEnd

TODO

# <a name="django-rest-framework">Django REST framework

## <a name="pagination-unlimited">Pagination unlimited

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

# <a name="django-admin">Django Admin

## <a name="display-JSONField">Display JSONField

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

## <a name="override-user-admin">Override UserAdmin

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
