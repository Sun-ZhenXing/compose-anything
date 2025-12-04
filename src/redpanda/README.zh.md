# Redpanda

[English](README.md) | [中文](README.zh.md)

Redpanda 是一个与 Kafka 兼容的流数据平台，专为性能和开发者体验而构建。它设计简单易部署和管理，不依赖 JVM 或 Zookeeper。

## 特性

- **Kafka API 兼容**：可与现有的 Kafka 客户端和工具配合使用
- **高性能**：使用 C++ 构建，实现最大吞吐量和低延迟
- **无需 Zookeeper**：内置共识机制的简化架构
- **Schema Registry**：内置 Schema Registry 支持
- **开发者友好**：易于部署和管理，配置最少
- **Redpanda Console**：用于监控和管理的现代化 Web UI

## 快速开始

1. 复制环境文件并根据需要自定义：

   ```bash
   cp .env.example .env
   ```

2. 启动服务：

   ```bash
   docker compose up -d
   ```

3. 访问 Redpanda Console：<http://localhost:8080>

4. 验证集群健康状态：

   ```bash
   docker compose exec redpanda rpk cluster health
   ```

## 服务端点

- **Kafka API**（外部）：`localhost:19092`
- **Schema Registry**：`localhost:18081`
- **HTTP Proxy**：`localhost:18082`
- **Admin API**：`localhost:19644`
- **Redpanda Console**：`http://localhost:8080`

## 基本使用

### 创建主题

```bash
docker compose exec redpanda rpk topic create my-topic
```

### 列出主题

```bash
docker compose exec redpanda rpk topic list
```

### 生产消息

```bash
docker compose exec redpanda rpk topic produce my-topic
```

输入消息后按 Ctrl+C 退出。

### 消费消息

```bash
docker compose exec redpanda rpk topic consume my-topic
```

## 环境变量

| 变量                             | 默认值    | 说明                                        |
| -------------------------------- | --------- | ------------------------------------------- |
| `REDPANDA_VERSION`               | `v24.3.1` | Redpanda 版本                               |
| `REDPANDA_CONSOLE_VERSION`       | `v2.8.2`  | Redpanda Console 版本                       |
| `TZ`                             | `UTC`     | 时区                                        |
| `REDPANDA_KAFKA_PORT_OVERRIDE`   | `19092`   | Kafka API 外部端口                          |
| `REDPANDA_SCHEMA_PORT_OVERRIDE`  | `18081`   | Schema Registry 端口                        |
| `REDPANDA_PROXY_PORT_OVERRIDE`   | `18082`   | HTTP Proxy 端口                             |
| `REDPANDA_ADMIN_PORT_OVERRIDE`   | `19644`   | Admin API 端口                              |
| `REDPANDA_CONSOLE_PORT_OVERRIDE` | `8080`    | Console UI 端口                             |
| `REDPANDA_SMP`                   | `1`       | 用于处理的 CPU 核心数                       |
| `REDPANDA_MEMORY`                | `1G`      | 内存分配                                    |
| `REDPANDA_LOG_LEVEL`             | `info`    | 日志级别（trace、debug、info、warn、error） |

## 资源配置

默认资源限制：

- **Redpanda**：
  - CPU：1.0-2.0 核
  - 内存：1G-2G

- **Console**：
  - CPU：0.25-0.5 核
  - 内存：256M-512M

根据您的工作负载需求在 `.env` 文件中调整这些值。

## 生产环境注意事项

### 性能调优

1. **CPU 核心**：增加 `REDPANDA_SMP` 以匹配可用的 CPU 核心
2. **内存**：使用 `REDPANDA_MEMORY` 分配更多内存以获得更好的性能
3. **存储**：在生产环境中使用高性能存储（SSD/NVMe）

### 集群模式

此配置在单节点开发模式下运行 Redpanda。对于生产集群：

1. 移除 `--mode dev-container` 标志
2. 配置多个 Redpanda 实例
3. 设置适当的副本因子
4. 配置适当的安全性（SASL、TLS）

### 安全性

在生产环境中使用时，请考虑：

1. 启用 SASL 认证
2. 配置 TLS 加密
3. 设置 ACL 进行授权
4. 限制网络访问

## 监控

Redpanda Console 提供全面的监控界面，包括：

- 集群概览和健康状态
- 主题管理和检查
- 消费者组监控
- Schema Registry 管理
- 消息浏览器

通过端口 19644 的 Redpanda Admin API 可以获取其他指标。

## 数据持久化

数据存储在 Docker 命名卷 `redpanda_data` 中。备份或迁移：

```bash
# 备份
docker run --rm -v redpanda_redpanda_data:/data -v $(pwd):/backup alpine tar czf /backup/redpanda-backup.tar.gz -C /data .

# 恢复
docker run --rm -v redpanda_redpanda_data:/data -v $(pwd):/backup alpine tar xzf /backup/redpanda-backup.tar.gz -C /data
```

## 故障排除

### 容器启动失败

1. 检查可用内存：Redpanda 至少需要 1GB
2. 验证端口可用性
3. 查看日志：`docker compose logs redpanda`

### 无法连接到 Kafka

1. 确保端口正确映射
2. 验证防火墙设置
3. 检查 advertised listeners 配置

### 性能问题

1. 增加 `REDPANDA_SMP` 以使用更多 CPU 核心
2. 使用 `REDPANDA_MEMORY` 分配更多内存
3. 在 Console 中监控资源使用情况

## 参考资料

- [Redpanda 文档](https://docs.redpanda.com/)
- [Redpanda GitHub](https://github.com/redpanda-data/redpanda)
- [Redpanda Console](https://docs.redpanda.com/current/manage/console/)
- [rpk CLI 参考](https://docs.redpanda.com/current/reference/rpk/)

## 许可证

Redpanda 使用 [Redpanda Business Source License](https://github.com/redpanda-data/redpanda/blob/dev/licenses/bsl.md) 许可。
