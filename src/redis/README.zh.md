# Redis

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署 Redis，一个高性能的内存键值存储，用于缓存、会话管理和消息队列。

## 服务

- `redis`：Redis 服务（端口 6379）

## 快速开始

```bash
docker compose up -d
```

## 环境变量

| 变量名                     | 说明                                         | 默认值             |
| -------------------------- | -------------------------------------------- | ------------------ |
| `GLOBAL_REGISTRY`          | 全局镜像仓库前缀                             | `""`               |
| `REDIS_VERSION`            | Redis 镜像版本                               | `8.2.1-alpine3.22` |
| `REDIS_PASSWORD`           | Redis 认证密码（留空表示不启用认证）         | `""`               |
| `REDIS_PORT_OVERRIDE`      | 主机端口映射（映射到容器内 Redis 端口 6379） | `6379`             |
| `TZ`                       | 时区                                         | `UTC`              |
| `SKIP_FIX_PERMS`           | 跳过权限修复（设置为 1 跳过）                | `""`               |
| `REDIS_CPU_LIMIT`          | CPU 限制                                     | `0.50`             |
| `REDIS_CPU_RESERVATION`    | CPU 预留                                     | `0.25`             |
| `REDIS_MEMORY_LIMIT`       | 内存限制                                     | `256M`             |
| `REDIS_MEMORY_RESERVATION` | 内存预留                                     | `128M`             |

请根据实际需求修改 `.env` 文件。

## 卷

- `redis_data`：用于存储 Redis 数据文件的命名卷

## 自定义配置

如需使用自定义的 `redis.conf` 文件，请在 `docker-compose.yaml` 中取消注释卷挂载：

```yaml
volumes:
  - ./redis.conf:/etc/redis/redis.conf
```

然后修改 `command` 部分以使用自定义配置：

```yaml
command: redis-server /etc/redis/redis.conf
```

## 安全提示

- 默认情况下，Redis 不启用认证。请设置 `REDIS_PASSWORD` 以启用认证。
- Redis 使用官方镜像中的默认用户运行。
- 生产环境部署建议使用 TLS/SSL。

## 许可证

Redis 是开源软件，采用 [BSD 3-Clause License](https://redis.io/docs/about/license/) 许可。
