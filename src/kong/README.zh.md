# Kong Gateway

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署 Kong Gateway，一个云原生 API 网关和服务网格，包含 PostgreSQL 数据库和可选的 Konga GUI。

## 服务

- `kong-db`：Kong 的 PostgreSQL 数据库
- `kong-migrations`：数据库迁移服务（运行一次）
- `kong`：Kong 网关服务
- `kong-gui`：用于 Kong 管理的 Konga GUI（配置文件：`gui`）

## 快速开始

```bash
docker compose up -d
```

启用 Konga GUI：

```bash
docker compose --profile gui up -d
```

## 环境变量

| 变量名                         | 说明                                           | 默认值                  |
| ------------------------------ | ---------------------------------------------- | ----------------------- |
| `GLOBAL_REGISTRY`              | 全局镜像仓库前缀                               | `""`                    |
| `KONG_VERSION`                 | Kong 镜像版本                                  | `3.8.0-alpine`          |
| `KONGA_VERSION`                | Konga GUI 镜像版本                             | `latest`                |
| `POSTGRES_VERSION`             | PostgreSQL 镜像版本                            | `16.6-alpine3.21`       |
| `KONG_DB_PASSWORD`             | Kong 数据库的 PostgreSQL 密码                  | `kongpass`              |
| `KONG_PROXY_PORT_OVERRIDE`     | Kong 代理主机端口（映射到端口 8000）           | `8000`                  |
| `KONG_PROXY_SSL_PORT_OVERRIDE` | Kong 代理 SSL 主机端口（映射到端口 8443）      | `8443`                  |
| `KONG_ADMIN_API_PORT_OVERRIDE` | Kong Admin API 主机端口（映射到端口 8001）     | `8001`                  |
| `KONG_ADMIN_SSL_PORT_OVERRIDE` | Kong Admin API SSL 主机端口（映射到端口 8444） | `8444`                  |
| `KONG_GUI_PORT_OVERRIDE`       | Konga GUI 主机端口（映射到端口 1337）          | `1337`                  |
| `KONG_ADMIN_LISTEN`            | Kong Admin API 监听地址                        | `0.0.0.0:8001`          |
| `KONG_ADMIN_GUI_URL`           | Kong Admin GUI URL                             | `http://localhost:8002` |
| `TZ`                           | 时区                                           | `UTC`                   |

请根据实际需求修改 `.env` 文件。

## 卷

- `kong_db_data`：Kong 的 PostgreSQL 数据
- `konga_data`：Konga 应用程序数据（使用 GUI 配置文件时）

## 端口

- `8000`：Kong 代理（HTTP）
- `8443`：Kong 代理（HTTPS）
- `8001`：Kong Admin API（HTTP）
- `8444`：Kong Admin API（HTTPS）
- `1337`：Konga GUI（可选，使用 `gui` 配置文件）

## 访问点

- Kong 代理：<http://localhost:8000>
- Kong Admin API：<http://localhost:8001>
- Konga GUI：<http://localhost:1337>（如已启用）

## 基本使用

### 添加服务

```bash
curl -i -X POST http://localhost:8001/services \
  --data name=example-service \
  --data url='http://example.com'
```

### 添加路由

```bash
curl -i -X POST http://localhost:8001/services/example-service/routes \
  --data 'paths[]=/example'
```

### 测试路由

```bash
curl -i http://localhost:8000/example
```

## 自定义配置

要使用自定义 Kong 配置文件，请在 `docker-compose.yaml` 中取消注释卷挂载：

```yaml
volumes:
  - ./kong.conf:/etc/kong/kong.conf:ro
```

## 安全提示

- 生产环境中请更改默认数据库密码
- 生产环境中为 Kong Admin API 启用身份验证
- 生产环境中所有通信使用 SSL/TLS
- 定期更新 Kong 及其插件以获取安全补丁
- 考虑使用 Kong 的 RBAC 和身份验证插件

## 许可证

Kong Gateway 采用 Apache License 2.0 许可。详情请参见 [Kong GitHub](https://github.com/Kong/kong)。
