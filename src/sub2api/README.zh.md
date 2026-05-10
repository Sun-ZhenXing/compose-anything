# Sub2API

[English](./README.md) | [中文](./README.zh.md)

快速开始：<https://github.com/Wei-Shaw/sub2api>。

此服务用于部署 Sub2API。它是一个面向订阅额度管理场景的 AI API 网关，并同时包含 PostgreSQL 与 Redis 依赖。Compose 配置默认启用 `AUTO_SETUP=true`，因此首次启动时会自动完成初始化。

## 服务

- `sub2api`：Web UI 与 API 服务。
- `postgres`：用于持久化业务数据的 PostgreSQL 数据库。
- `redis`：用于缓存与队列的 Redis 服务。

## 快速开始

```bash
docker compose up -d
docker compose logs --tail=100 sub2api
```

当容器进入健康状态后，打开 `http://localhost:8080`。

如果 `SUB2API_ADMIN_PASSWORD` 留空，Sub2API 会在首次启动时自动生成管理员密码。查看 `sub2api` 日志，并搜索 `admin password` 即可获取。

## 配置

| 变量                          | 说明                                   | 默认值                |
| ----------------------------- | -------------------------------------- | --------------------- |
| `SUB2API_VERSION`             | Sub2API 镜像版本                       | `0.1.124`             |
| `SUB2API_PORT_OVERRIDE`       | Web UI 与 API 的宿主机端口             | `8080`                |
| `SUB2API_POSTGRES_PASSWORD`   | 应用与 PostgreSQL 容器共用的数据库密码 | `sub2api`             |
| `SUB2API_REDIS_PASSWORD`      | 可选的 Redis 密码                      | *(空)*                |
| `SUB2API_ADMIN_EMAIL`         | 初始管理员邮箱                         | `admin@sub2api.local` |
| `SUB2API_ADMIN_PASSWORD`      | 初始管理员密码                         | *(留空时自动生成)*    |
| `SUB2API_JWT_SECRET`          | 用于保持会话稳定的固定 JWT 密钥        | *(空)*                |
| `SUB2API_TOTP_ENCRYPTION_KEY` | 用于保持 2FA 数据稳定的固定密钥        | *(空)*                |
| `SUB2API_RUN_MODE`            | 应用运行模式（`standard` 或 `simple`） | `standard`            |
| `TZ`                          | 容器时区                               | `UTC`                 |

## 端口

- `8080`：Sub2API 的 Web UI 与 API。

## 存储

- `sub2api_data`：运行时数据与自动生成的配置。
- `sub2api_postgres_data`：PostgreSQL 数据目录。
- `sub2api_redis_data`：Redis 持久化数据。

## 安全说明

- 如果需要在可信环境之外暴露服务，请先修改 `SUB2API_POSTGRES_PASSWORD`。
- 生产环境中建议为 `SUB2API_JWT_SECRET` 与 `SUB2API_TOTP_ENCRYPTION_KEY` 设置固定值。留空虽然便于快速体验，但重启后会导致已有登录会话或 2FA 状态失效。
- 此配置仅向宿主机暴露 Sub2API 的 HTTP 端口；PostgreSQL 与 Redis 仅在内部 Compose 网络中可见。
