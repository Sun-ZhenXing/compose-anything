# Arize Phoenix

[English](./README.md) | [中文](./README.zh.md)

Arize Phoenix 是一个开源的 AI 可观测性平台，专为 LLM 应用设计。它提供追踪、评估、数据集和实验功能，帮助你构建和改进 AI 应用。

## 服务

- `phoenix`：Phoenix 主应用服务器，包含 UI 和 OpenTelemetry 采集器。
- `phoenix-db`：用于持久化存储的 PostgreSQL 数据库。

## 端口

| 端口 | 协议 | 描述                                   |
| ---- | ---- | -------------------------------------- |
| 6006 | HTTP | UI 和 OTLP HTTP 采集器（`/v1/traces`） |
| 4317 | gRPC | OTLP gRPC 采集器                       |

## 环境变量

| 变量名                     | 描述                              | 默认值            |
| -------------------------- | --------------------------------- | ----------------- |
| PHOENIX_VERSION            | Phoenix 镜像版本                  | `12.27.0-nonroot` |
| PHOENIX_PORT_OVERRIDE      | Phoenix UI 和 HTTP API 的主机端口 | `6006`            |
| PHOENIX_GRPC_PORT_OVERRIDE | OTLP gRPC 采集器的主机端口        | `4317`            |
| PHOENIX_ENABLE_PROMETHEUS  | 启用 Prometheus 指标端点          | `false`           |
| PHOENIX_SECRET             | 认证密钥（可选）                  | `""`              |
| POSTGRES_VERSION           | PostgreSQL 镜像版本               | `17.2-alpine3.21` |
| POSTGRES_USER              | PostgreSQL 用户名                 | `postgres`        |
| POSTGRES_PASSWORD          | PostgreSQL 密码                   | `postgres`        |
| POSTGRES_DB                | PostgreSQL 数据库名               | `phoenix`         |

## 数据卷

- `phoenix_db_data`：PostgreSQL 数据卷，用于持久化存储。

## 快速开始

1. 复制示例环境文件：

   ```bash
   cp .env.example .env
   ```

2. （可选）生产环境下，请设置安全的密码和密钥：

   ```bash
   # 生成认证密钥
   openssl rand -base64 32
   ```

3. 启动服务：

   ```bash
   docker compose up -d
   ```

4. 访问 Phoenix UI：`http://localhost:6006`

## 发送追踪数据

Phoenix 支持 OpenTelemetry 兼容的追踪数据。你可以通过以下方式发送追踪：

### HTTP（OTLP）

发送追踪到 `http://localhost:6006/v1/traces`

### gRPC（OTLP）

发送追踪到 `localhost:4317`

### Python 示例

```python
from phoenix.otel import register

tracer_provider = register(
    project_name="my-llm-app",
    endpoint="http://localhost:6006/v1/traces",
)
```

## 功能特性

- **追踪**：捕获和可视化 LLM 应用追踪，支持 OpenTelemetry。
- **评估**：使用内置或自定义评估器运行评估。
- **数据集**：创建和管理用于测试和评估的数据集。
- **实验**：运行实验以比较模型性能。
- **Playground**：交互式测试不同模型的提示词。

## 文档

更多信息请访问 [Phoenix 官方文档](https://docs.arize.com/phoenix)。

## 安全说明

- 生产环境请更改默认的 PostgreSQL 密码。
- 如果公开暴露 Phoenix，请设置 `PHOENIX_SECRET` 进行认证。
- 生产环境建议使用反向代理并启用 SSL/TLS。
- 定期备份 PostgreSQL 数据库。
