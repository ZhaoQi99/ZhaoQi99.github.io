title: 常用Docker容器启动命令
author: Zhao Qi
abbrlink: docker
tags:
  - Docker
  - 容器
categories: []
top: true
date: 2021-02-26 21:40:00
description: 常用Docker容器启动命令😊
---

# 数据库

## 关系型数据库

### MySQL

```bash
docker run  -p 3306:3306 --name mysql \
    -v "$(pwd)/mysql":/var/lib/mysql \
    -e MYSQL_ROOT_PASSWORD=123456 -d mysql:5.7
```

### Postgres

```bash
docker run  --name postgres \
    -v "$(pwd)/postgres":/var/lib/postgresql/data \
    -e POSTGRES_PASSWORD=123456 \
    -p 5432:5432 -d postgres
```

<!--more-->

### PgAdmin

```bash
docker run -p 8080:80  --name=pgadmin  \
    -e "PGADMIN_DEFAULT_EMAIL=admin@zhaoqi.vip" \
    -e "PGADMIN_DEFAULT_PASSWORD=123456"  -d dpage/pgadmin4
```

## 时序数据库

### Prometheus

```bash
docker run -d --name=prometheus -p 9090:9090 \
    -v $PWD/prometheus:/etc/prometheus \
    prom/prometheus
```

### InfluxDB

```bash
docker run -d -p 8086:8086 --name influxdb  \
    -v $PWD/influxdb:/var/lib/influxdb  influxdb
```

### OpenTSDB

```bash
 docker run --name opentsdb -dp 4242:4242 petergrace/opentsdb-docker
```

# DevOps

## 监控

### Cadvisor

```bash
docker run -d --volume=/:/rootfs:ro \
    --volume=/var/run:/var/run:ro \
    --volume=/sys:/sys:ro \
    --volume=/var/lib/docker/:/var/lib/docker:ro \
    --volume=/dev/disk/:/dev/disk:ro \
    --publish=8080:8080  --detach=true  --name=cadvisor \
    google/cadvisor:latest
```

### node_exporter

```bash
docker run -d \
  -p 9100:9100 \
  --name node-exporter \
  --pid="host" \
  -v "/:/host:ro,rslave" \
  prom/node-exporter:latest \
  --path.rootfs=/host
```

### Grafana

```bash
docker run -d -p 3000:3000 --name grafana \
    -v $PWD/grafana:/var/lib/grafana \
    -v $PWD/grafana/etc:/etc/grafana grafana/grafana
```

## Git

### Gitlab

```bash
docker run -d  -p 8001:8001 -p 222:22 --name gitlab   \
    -v "$(pwd)/gitlab/config":/etc/gitlab \
    -v "$(pwd)/gitlab/logs":/var/log/gitlab \
    -v "$(pwd)/gitlab/data":/var/opt/gitlab \
    --restart=always gitlab/gitlab-ce
```

## Docker

### Portainer [[docs](https://documentation.portainer.io/v2.0/deploy/ceinstalldocker)]

```shell
docker run -p 9000:9000 -p 8000:8008 --name portainer \
-v /var/run/docker.sock:/var/run/docker.sock \
-v "$(pwd)/portainer"/data:/data \
-d portainer/portainer-ce \
--tunnel-port 8008 # 默认8000
```

# 工具

## 测试

### hoppscotch(postwoman)

```json
docker run -p 3000:3000 hoppscotch/hoppscotch:latest
```

# 其他

## LDAP

### ldap

```bash
docker run -d -p 389:389 \
    -v $PWD/ldap/ldap:/var/lib/ldap \
    -v $PWD/ldap/slapd.d:/etc/ldap/slapd.d \
    --name ldap \
    --env LDAP_TLS=false \
    --env LDAP_ORGANISATION="zhaoqi" \
    --env LDAP_DOMAIN="zhaoqi.vip" \
    --env LDAP_ADMIN_PASSWORD="123456" \
    --env LDAP_CONFIG_PASSWORD="123456" \
    --restart=always osixia/openldap
```

### phpldapadmin

```bash
docker run -dit -p 19999:80 \
    --link ldap \
    --name ldap_mgr \
    --env PHPLDAPADMIN_HTTPS=false \
    --env PHPLDAPADMIN_LDAP_HOSTS=ldap \
    --restart=always osixia/phpldapadmin
```

# 搭配Traefik

## Traefik

```yaml
version: '3'

services:
  reverse-proxy:
    # The official v2 Traefik docker image
    image: traefik
    # Enables the web UI and tells Traefik to listen to docker
    command: --api.insecure=true --providers.docker
    ports:
      # The HTTP port
      - "80:80"
      # The Web UI (enabled by --api.insecure=true)
      - "8080:8080"
    volumes:
      # So that Traefik can listen to the Docker events
      - "/var/run/docker.sock:/var/run/docker.sock"
    labels:
      # Frontend
      - "traefik.enable=true"
      - "traefik.http.routers.traefik.rule=Host(`traefik.cloud.tencent.com`)"
      - "traefik.http.services.traefik.loadbalancer.server.port=8080"
```

## Route

```yaml
version: '3'
services:
  portainer:
    image: portainer/portainer-ce:2.9.3
    #command: -H unix:///var/run/docker.sock
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./portainer:/data
    labels:
      # Frontend
      - "traefik.enable=true"
      - "traefik.http.routers.frontend.rule=Host(`portainer.cloud.tencent.com`)"
      - "traefik.http.services.frontend.loadbalancer.server.port=9000"
      - "traefik.http.routers.frontend.service=frontend"

      # Edge
      - "traefik.http.routers.edge.rule=Host(`portainer.cloud.tencent.com`)"
      - "traefik.http.services.edge.loadbalancer.server.port=8000"
      - "traefik.http.routers.edge.service=edge"
  cadvisor:
    image: google/cadvisor:latest
    container_name: cadvisor
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:rw
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.cadvisor.rule=Host(`cadvisor.cloud.tencent.com`)"
      - "traefik.http.services.cadvisor.loadbalancer.server.port=8080"
  prometheus:
    image: prom/prometheus
    volumes:
      - ./prometheus:/etc/prometheus
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.prometheus.rule=Host(`prometheus.cloud.tencent.com`)"
      - "traefik.http.services.prometheus.loadbalancer.server.port=9090"
    extra_hosts:
      - "prometheus.cloud.tencent.com:172.17.0.1"
      - "cadvisor.cloud.tencent.com:172.17.0.1"
      - "node-exporter.cloud.tencent.com:172.17.0.1"
  influxdb:
    image: influxdb
    volumes:
      - ./influxdb:/var/lib/influxdb
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.influxdb.rule=Host(`influxdb.cloud.tencent.com`)"
      - "traefik.http.services.influxdb.loadbalancer.server.port=8086"
    extra_hosts:
      - "prometheus.cloud.tencent.com:172.17.0.1"
      - "influxdb.cloud.tencent.com:172.17.0.1"
  grafana:
    image: grafana/grafana
    volumes:
      - ./grafana:/var/lib/grafana
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.grafana.rule=Host(`grafana.cloud.tencent.com`)"
      - "traefik.http.services.grafana.loadbalancer.server.port=3000"
    extra_hosts:
      - "prometheus.cloud.tencent.com:172.17.0.1"
      - "influxdb.cloud.tencent.com:172.17.0.1"
  node-exporter:
    image: prom/node-exporter
    container_name: node-exporter
    command:
      - '--path.rootfs=/host'
    volumes:
      - '/:/host:ro,rslave'
    pid: host
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.node-exporter.rule=Host(`node-exporter.cloud.tencent.com`)"
      - "traefik.http.services.node-exporter.loadbalancer.server.port=9100"
```