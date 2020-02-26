title: Docker搭建Gitlab仓库
author: Zhao Qi
abbrlink: 151510421
tags:
  - Gitlab
  - Docker
categories: []
date: 2020-02-26 11:49:00
---
# 安装
1. 拉取Gitlab镜像
`docker pull gitlab/gitlab-ce`

{% asset_img pasted-1.png %}

2. 创建文件夹
`mkdir gitlab`
<!--more-->

3. 创建容器
```bash
docker run -d  -p 8001:8001 -p 222:22 --name gitlab   \
    -v "$(pwd)/gitlab/config":/etc/gitlab \
    -v "$(pwd)/gitlab/logs":/var/log/gitlab \
    -v "$(pwd)/gitlab/data":/var/opt/gitlab \
    --restart=always gitlab/gitlab-ce
```

{% note info %}
也可以将8001修改为其他端口
{% endnote %}

# 配置
1. 修改配置文件
`vi gitlab/config/gitlab.rb`
`external_url 'http://www.xxx.com:8001'` or `external_url 'http://{ip}:8001'`

2. 重启容器
`docker restart gitlab`

# 使用
1. 首次打开时需要设置管理员密码
{% asset_img pasted-2.jpg %}
2. 查看Clone信息
{% asset_img pasted-0.png %}