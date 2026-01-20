# Pogocache

[Pogocache](https://github.com/tidwall/pogocache) 是一款从零开始构建的高速缓存软件，专注于低延迟和 CPU 效率。它是一个高性能、多协议的 Redis 替代方案。

## 特性

- **极速**：比 Memcached、Valkey、Redis、Dragonfly 和 Garnet 更快。
- **多协议支持**：支持 Redis RESP、Memcached、PostgreSQL 线缆协议和 HTTP。
- **持久化**：支持 AOF 风格的持久化。
- **资源高效**：极低的 CPU 和内存开销。

## 部署

```bash
docker compose up -d
```

## 配置说明

| 变量名                    | 默认值  | 描述                                   |
| ------------------------- | ------- | -------------------------------------- |
| `POGOCACHE_VERSION`       | `1.3.1` | Pogocache 镜像版本                     |
| `POGOCACHE_PORT_OVERRIDE` | `9401`  | 主机端口                               |
| `POGOCACHE_EXTRA_ARGS`    |         | 额外的命令行参数（例如 `--auth pass`） |

## 访问方式

- **Redis**：`redis-cli -p 9401`
- **Postgres**：`psql -h localhost -p 9401`
- **HTTP**：`curl http://localhost:9401/key`
- **Memcached**：`telnet localhost 9401`

## 持久化

默认情况下，数据持久化到命名卷 `pogocache_data` 中的 `/data/pogocache.db`。
