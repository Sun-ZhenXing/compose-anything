# Redis

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署 Redis，一个用于缓存和消息队列的内存键值数据库。

## 服务

- `redis`: Redis 服务。

## 环境变量

| 变量名              | 说明                                         | 默认值             |
| ------------------- | -------------------------------------------- | ------------------ |
| REDIS_VERSION       | Redis 镜像版本                               | `8.2.1-alpine3.22` |
| SKIP_FIX_PERMS      | 跳过权限修复，设置为 1 跳过                  | `""`               |
| REDIS_PASSWORD      | 默认 "default" 用户的密码                    | `""`               |
| REDIS_PORT_OVERRIDE | 主机端口映射（映射到容器内 Redis 端口 6379） | 6379               |

请根据实际需求修改 `.env` 文件。

## 卷

- `redis_data`: 用于存储 Redis 数据的卷。
- `redis.conf`: 可选的自定义配置文件（挂载到 `/etc/redis/redis.conf`）。
