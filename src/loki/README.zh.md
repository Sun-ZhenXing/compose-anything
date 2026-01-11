# Grafana Loki

[English Documentation](README.md)

Grafana Loki 是一个受 Prometheus 启发的水平可扩展、高可用、多租户日志聚合系统。它被设计为非常高效且易于操作。与其他日志系统不同，Loki 不索引日志的内容，而是为每个日志流索引一组标签。

## 特性

- **成本效益**：仅索引元数据而非全文，显著降低存储成本
- **LogQL**：类似于 PromQL 的强大查询语言，用于过滤和聚合日志
- **多租户**：内置对多租户部署的支持
- **Grafana 集成**：与 Grafana 原生集成进行可视化
- **可扩展**：可以水平扩展以处理大量日志

## 快速开始

1. 复制示例环境文件：

    ```bash
    cp .env.example .env
    ```

2. 启动服务：

    ```bash
    docker compose up -d
    ```

3. 验证服务正在运行：

    ```bash
    docker compose ps
    curl http://localhost:3100/ready
    ```

## 配置

### 环境变量

| 变量                      | 默认值  | 描述          |
| ------------------------- | ------- | ------------- |
| `LOKI_VERSION`            | `3.3.2` | Loki 版本     |
| `LOKI_PORT_OVERRIDE`      | `3100`  | HTTP API 端口 |
| `TZ`                      | `UTC`   | 时区          |
| `LOKI_CPU_LIMIT`          | `1.0`   | CPU 限制      |
| `LOKI_MEMORY_LIMIT`       | `1G`    | 内存限制      |
| `LOKI_CPU_RESERVATION`    | `0.25`  | CPU 预留      |
| `LOKI_MEMORY_RESERVATION` | `256M`  | 内存预留      |

### 默认配置

该服务包含一个基本配置文件（`loki-config.yaml`），该文件：

- 禁用身份验证（适用于开发/测试）
- 使用本地文件系统存储
- 配置单副本（单体模式）
- 设置基本缓存以提高查询性能

对于生产部署，您应该根据需求自定义配置。

## 与 Grafana 集成

1. 在 Grafana 中添加 Loki 作为数据源：
   - URL：`http://loki:3100`（如果在同一 Docker 网络中运行）
   - 或者：`http://localhost:3100`（从主机访问）

2. 使用 LogQL 查询创建仪表板和探索日志

## 向 Loki 发送日志

### 使用 Promtail

Promtail 是向 Loki 发送日志的推荐代理：

```yaml
services:
  promtail:
    image: grafana/promtail:3.3.2
    volumes:
      - /var/log:/var/log:ro
      - ./promtail-config.yaml:/etc/promtail/config.yaml
    command: -config.file=/etc/promtail/config.yaml
```

### 使用 Docker 驱动

您可以配置 Docker 直接向 Loki 发送日志：

```yaml
logging:
  driver: loki
  options:
    loki-url: "http://localhost:3100/loki/api/v1/push"
    loki-batch-size: "400"
```

### 使用 HTTP API

通过 HTTP POST 直接发送日志：

```bash
curl -H "Content-Type: application/json" -XPOST -s "http://localhost:3100/loki/api/v1/push" --data-raw \
  '{"streams": [{ "stream": { "job": "test" }, "values": [ [ "$(date +%s)000000000", "test log message" ] ] }]}'
```

## 存储

日志和元数据存储在名为 `loki_data` 的 Docker 卷中。

## 健康检查

该服务包含健康检查，每 30 秒监控一次 `/ready` 端点。

## 资源需求

- **最低要求**：256MB RAM，0.25 CPU
- **推荐配置**：1GB RAM，1 CPU（用于中等日志量）
- **生产环境**：根据日志摄入速率和保留期限进行扩展

## 安全注意事项

默认配置：

- 以非 root 用户运行（UID:GID 10001:10001）
- 禁用身份验证（仅适用于开发环境）
- 使用文件系统存储（不适用于分布式部署）

对于生产环境：

- 启用身份验证和多租户
- 使用对象存储（S3、GCS、Azure Blob 等）
- 实施适当的网络安全和访问控制
- 配置保留策略以管理存储成本

## 文档

- [官方文档](https://grafana.com/docs/loki/latest/)
- [LogQL 查询语言](https://grafana.com/docs/loki/latest/query/)
- [最佳实践](https://grafana.com/docs/loki/latest/operations/best-practices/)
- [GitHub 仓库](https://github.com/grafana/loki)

## 许可证

Loki 使用 [AGPLv3 许可证](https://github.com/grafana/loki/blob/main/LICENSE)。
