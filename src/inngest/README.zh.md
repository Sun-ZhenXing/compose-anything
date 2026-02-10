# Inngest

[English](./README.md) | [中文](./README.zh.md)

[Inngest](https://www.inngest.com/) 是一个开源的持久化工作流引擎，用于构建可靠的应用程序。它提供事件驱动的函数，支持自动重试、调度、扇出以及内置的监控和调试仪表板。

## 服务

- `inngest`：Inngest 服务器，包含 API、仪表板和 Connect WebSocket 网关（端口 8288、8289）
- `postgres`：PostgreSQL 数据库，用于数据持久化
- `redis`：Redis，用于队列和运行状态管理

## 快速开始

```bash
# 复制环境配置文件
copy .env.example .env

# 启动所有服务
docker compose up -d
```

启动后，通过 `http://localhost:8288` 访问 Inngest 仪表板。

## 环境变量

| 变量名                             | 说明                                        | 默认值        |
| ---------------------------------- | ------------------------------------------- | ------------- |
| `GLOBAL_REGISTRY`                  | 全局镜像仓库前缀                            | `""`          |
| `INNGEST_VERSION`                  | Inngest 镜像版本                            | `v1.16.3`     |
| `INNGEST_EVENT_KEY`                | 事件提交认证密钥（十六进制字符串）          | `deadbeef...` |
| `INNGEST_SIGNING_KEY`              | 服务器与应用间的签名密钥（十六进制字符串）  | `01234567...` |
| `INNGEST_LOG_LEVEL`                | 日志级别（trace、debug、info、warn、error） | `info`        |
| `INNGEST_PORT_OVERRIDE`            | API 和仪表板的主机端口                      | `8288`        |
| `INNGEST_GATEWAY_PORT_OVERRIDE`    | Connect WebSocket 网关的主机端口            | `8289`        |
| `INNGEST_PG_VERSION`               | PostgreSQL 镜像版本                         | `17.6-alpine` |
| `INNGEST_PG_USER`                  | PostgreSQL 用户名                           | `inngest`     |
| `INNGEST_PG_PASSWORD`              | PostgreSQL 密码                             | `inngest`     |
| `INNGEST_PG_DB`                    | PostgreSQL 数据库名                         | `inngest`     |
| `INNGEST_REDIS_VERSION`            | Redis 镜像版本                              | `7.4-alpine`  |
| `TZ`                               | 时区                                        | `UTC`         |
| `INNGEST_CPU_LIMIT`                | Inngest CPU 限制                            | `1.00`        |
| `INNGEST_CPU_RESERVATION`          | Inngest CPU 预留                            | `0.50`        |
| `INNGEST_MEMORY_LIMIT`             | Inngest 内存限制                            | `512M`        |
| `INNGEST_MEMORY_RESERVATION`       | Inngest 内存预留                            | `256M`        |
| `INNGEST_PG_CPU_LIMIT`             | PostgreSQL CPU 限制                         | `0.50`        |
| `INNGEST_PG_CPU_RESERVATION`       | PostgreSQL CPU 预留                         | `0.25`        |
| `INNGEST_PG_MEMORY_LIMIT`          | PostgreSQL 内存限制                         | `256M`        |
| `INNGEST_PG_MEMORY_RESERVATION`    | PostgreSQL 内存预留                         | `128M`        |
| `INNGEST_REDIS_CPU_LIMIT`          | Redis CPU 限制                              | `0.50`        |
| `INNGEST_REDIS_CPU_RESERVATION`    | Redis CPU 预留                              | `0.25`        |
| `INNGEST_REDIS_MEMORY_LIMIT`       | Redis 内存限制                              | `128M`        |
| `INNGEST_REDIS_MEMORY_RESERVATION` | Redis 内存预留                              | `64M`         |

请根据实际需求修改 `.env` 文件。

## 卷

- `inngest_pg_data`：用于存储 PostgreSQL 数据的命名卷
- `inngest_redis_data`：用于存储 Redis 数据的命名卷

## 配置 Inngest SDK

要将你的应用连接到自托管的 Inngest 服务器，请在应用中设置以下环境变量：

```bash
INNGEST_EVENT_KEY=<你的事件密钥>
INNGEST_SIGNING_KEY=<你的签名密钥>
INNGEST_DEV=0
INNGEST_BASE_URL=http://<inngest_host>:8288
```

例如，对于 Node.js 应用：

```bash
INNGEST_EVENT_KEY=deadbeefcafebabe0123456789abcdef \
INNGEST_SIGNING_KEY=0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef \
INNGEST_DEV=0 \
INNGEST_BASE_URL=http://localhost:8288 \
node ./server.js
```

## 安全提示

- **生产环境使用前请务必更改默认密钥。** 事件密钥和签名密钥必须是偶数位的有效十六进制字符串。可使用 `openssl rand -hex 32` 生成安全密钥。
- 生产环境部署前请在 `.env` 中**更改默认的 PostgreSQL 密码**。
- Inngest 镜像支持 `amd64` 和 `arm64` 架构。
- 生产环境建议使用 TLS/SSL 终止（例如通过反向代理）。

## 参考链接

- [官方文档](https://www.inngest.com/docs)
- [自托管指南](https://www.inngest.com/docs/self-hosting)
- [GitHub 仓库](https://github.com/inngest/inngest)
- [SDK 文档](https://www.inngest.com/docs/sdk/overview)

## 许可证

Inngest 采用 [Elastic License 2.0（ELv2）](https://github.com/inngest/inngest/blob/main/LICENSE.md) 发布，部分组件采用 [Apache-2.0](https://github.com/inngest/inngest/blob/main/LICENSE-APACHE.md) 许可。
