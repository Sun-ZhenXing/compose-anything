# Arize Phoenix

[English](./README.md) | [中文](./README.zh.md)

Arize Phoenix 是一个开源的 AI 可观测性平台，专为 LLM 应用设计。它提供追踪、评估、数据集和实验功能，帮助你构建和改进 AI 应用。

## 服务

- `phoenix`：Phoenix 主应用服务器（SQLite 版本）。
- `phoenix-pg`：配置为使用 PostgreSQL 的 Phoenix 应用服务器（需要 `postgres` 配置文件）。
- `phoenix-db`：用于持久化存储的 PostgreSQL 数据库（需要 `postgres` 配置文件）。

## 配置文件 (Profiles)

本项目支持通过 Docker Compose 配置文件使用两种运行模式：

1. **sqlite**（默认）：使用 SQLite 存储。简单易用，适合本地开发。
   在 `.env` 中设置 `COMPOSE_PROFILES=sqlite`。
2. **postgres**（或 **pg**）：使用 PostgreSQL 存储。推荐用于生产环境。
   在 `.env` 中设置 `COMPOSE_PROFILES=postgres`。

## 端口

| 端口 | 协议 | 描述                                   |
| ---- | ---- | -------------------------------------- |
| 6006 | HTTP | UI 和 OTLP HTTP 采集器（`/v1/traces`） |
| 4317 | gRPC | OTLP gRPC 采集器                       |
| 9090 | HTTP | Prometheus 指标（可选）                |

## 环境变量

| 变量名                           | 描述                                     | 默认值            |
| -------------------------------- | ---------------------------------------- | ----------------- |
| COMPOSE_PROFILES                 | 激活的配置文件（`sqlite` 或 `postgres`） | `sqlite`          |
| PHOENIX_VERSION                  | Phoenix 镜像版本                         | `12.35.0-nonroot` |
| PHOENIX_PORT_OVERRIDE            | Phoenix UI 和 HTTP API 的主机端口        | `6006`            |
| PHOENIX_GRPC_PORT_OVERRIDE       | OTLP gRPC 采集器的主机端口               | `4317`            |
| PHOENIX_PROMETHEUS_PORT_OVERRIDE | Prometheus 指标的主机端口                | `9090`            |
| PHOENIX_ENABLE_PROMETHEUS        | 启用 Prometheus 指标端点                 | `false`           |
| PHOENIX_SECRET                   | 认证密钥（可选）                         | `""`              |
| POSTGRES_VERSION                 | PostgreSQL 镜像版本                      | `17.2-alpine3.21` |
| POSTGRES_USER                    | PostgreSQL 用户名                        | `postgres`        |
| POSTGRES_PASSWORD                | PostgreSQL 密码                          | `postgres`        |
| POSTGRES_DB                      | PostgreSQL 数据库名                      | `phoenix`         |

## 数据卷

- `phoenix_data`：SQLite 模式的数据卷（挂载到 `/data`）。
- `phoenix_db_data`：PostgreSQL 模式的数据卷。

## 快速开始

1. 复制示例环境文件：

   ```bash
   cp .env.example .env
   ```

2. 通过编辑 `.env` 选择部署模式（默认为 `sqlite`）。

   **使用 SQLite（默认）：**
   确保 `.env` 包含：

   ```dotenv
   COMPOSE_PROFILES=sqlite
   ```

   **使用 PostgreSQL：**
   将 `.env` 修改为：

   ```dotenv
   COMPOSE_PROFILES=postgres
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
