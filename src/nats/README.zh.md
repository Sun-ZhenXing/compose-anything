# NATS

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署启用 JetStream 的 NATS Server，一个轻量、高性能的消息系统，支持发布/订阅、请求/响应以及持久化事件流。

## 服务

- `nats`：NATS 服务（客户端端口 4222，监控端口 8222 仅供内部访问）

## 快速开始

```bash
docker compose up -d
```

检查服务是否健康：

```bash
docker compose ps
docker compose exec nats wget -qO- http://127.0.0.1:8222/healthz
```

## 使用示例

使用 [NATS CLI](https://github.com/nats-io/natscli) 连接已发布的客户端端口：

```bash
# 在一个终端中订阅
nats --server nats://admin:password@localhost:4222 sub 'hello.>'

# 在另一个终端中发布
nats --server nats://admin:password@localhost:4222 pub hello.world 'Hello NATS'
```

JetStream 的流和消费者数据会持久化在 `nats_data` 卷中。

## 环境变量

| 变量名                     | 说明                                      | 默认值              |
| -------------------------- | ----------------------------------------- | ------------------- |
| `GLOBAL_REGISTRY`          | 全局镜像仓库前缀                          | `""`                |
| `NATS_VERSION`             | NATS Server 镜像版本                      | `2.15.3-alpine3.22` |
| `NATS_USER`                | 客户端认证用户名                          | `admin`             |
| `NATS_PASSWORD`            | 客户端认证密码                            | `password`          |
| `NATS_PORT_OVERRIDE`       | 客户端连接的主机端口（映射到容器内 4222） | `4222`              |
| `TZ`                       | 时区                                      | `UTC`               |
| `NATS_CPU_LIMIT`           | CPU 限制                                  | `1.0`               |
| `NATS_CPU_RESERVATION`     | CPU 预留                                  | `0.1`               |
| `NATS_MEMORY_LIMIT`        | 内存限制                                  | `1G`                |
| `NATS_MEMORY_RESERVATION`  | 内存预留                                  | `256M`              |

请根据实际需求修改 `.env` 文件。

## 端口

| 端口   | 用途                | 是否在主机上暴露 |
| ------ | ------------------- | ---------------- |
| `4222` | 客户端连接          | 是               |
| `8222` | HTTP 监控与健康检查 | 否               |

监控端点仅保留在 Compose 内部网络中。如果需要在主机上采集指标或接入监控面板，再将其发布出来。

## 卷

- `nats_data`：用于存储 JetStream 数据的命名卷，挂载到容器内的 `/data`

## 安全提示

- 默认凭据 `admin` / `password` 仅用于本地评估。将端口暴露到 localhost 之外前，请修改 `NATS_USER` 和 `NATS_PASSWORD`。
- 8222 端口的监控端点不启用认证，因此默认不在主机上发布。
- 官方 NATS 镜像默认以 root 用户运行。本配置移除了所有 Linux capabilities，并将根文件系统设为只读，以降低风险。如需更严格的隔离，可以增加一个初始化步骤，把数据卷的所有者改为固定 UID，然后使用 `user: "1000:1000"` 运行服务。
- 在对不可信网络开放客户端流量前，请在反向代理处终止 TLS，或为 NATS 配置 TLS。

## 许可证

NATS Server 是开源软件，采用 [Apache License 2.0](https://github.com/nats-io/nats-server/blob/main/LICENSE) 许可。