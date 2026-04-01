# Shannon

[English](./README.md) | [中文](./README.zh.md)

本服务部署 [Shannon](https://github.com/Kocoro-lab/Shannon)，一个面向生产环境的多智能体编排框架。Shannon 通过 Temporal 工作流引擎提供时光回溯调试能力、按任务 / 智能体的硬性 Token 预算控制、实时可观测性仪表盘、WASI 沙箱安全代码执行、OPA 策略治理以及多租户隔离，并原生支持 OpenAI、Anthropic、Google、DeepSeek 及本地模型。

> **注意：** `agent-core` 服务仅构建了 `linux/amd64` 镜像。在 Apple Silicon（ARM64）上，Docker Desktop 会自动通过 Rosetta 进行仿真运行。

## 服务说明

- **gateway**：HTTP API 网关 —— 所有客户端请求的主入口（端口 `8080`）
- **orchestrator**：基于 Temporal 的核心工作流编排引擎
- **llm-service**：LLM 提供商抽象层，支持模型路由、故障转移和预算控制
- **agent-core**：基于 Rust 的智能体执行运行时，支持 WASI 沙箱
- **postgres**：带 pgvector 扩展的 PostgreSQL，用于状态和向量存储
- **redis**：Redis，用于缓存、任务队列和限流
- **qdrant**：Qdrant 向量数据库，用于语义记忆
- **temporal**：Temporal 工作流引擎，提供可持久、容错的任务执行
- **temporal-ui**：Temporal Web UI，用于工作流调试（通过 `metrics` profile 启用）

## 快速开始

### 前置条件

- Docker 及 Docker Compose v2
- `curl`（用于下载配置文件）
- 至少一个 LLM API 密钥（OpenAI、Anthropic、Google 等）

### 1. 运行初始化

```bash
make setup
```

该命令会从 Shannon 代码仓库下载所需的 `config/models.yaml` 和 `config/features.yaml` 配置文件，并创建本地 `.env` 文件。

### 2. 填写 LLM API 密钥

编辑 `.env` 文件，至少设置一个 LLM 提供商的密钥：

```env
# 至少选择一个：
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
```

在生产环境中，还需要更新 `JWT_SECRET` 并将 `GATEWAY_SKIP_AUTH` 设为 `0`。

### 3. 启动服务

```bash
make up
```

通过 `http://localhost:8080` 访问 Shannon API。

### 4. （可选）启用 Temporal UI 仪表盘

若需同时启动 Temporal 工作流调试界面：

```bash
make up-monitoring
```

通过 `http://localhost:8088` 访问 Temporal UI。

## 核心环境变量

| 变量名                      | 说明                                      | 默认值                                         |
| --------------------------- | ----------------------------------------- | ---------------------------------------------- |
| `SHANNON_VERSION`           | 所有 Shannon 服务镜像的版本号             | `v0.3.1`                                       |
| `OPENAI_API_KEY`            | OpenAI API 密钥（至少需要一个提供商密钥） | ``                                             |
| `ANTHROPIC_API_KEY`         | Anthropic API 密钥                        | ``                                             |
| `GOOGLE_API_KEY`            | Google AI API 密钥                        | ``                                             |
| `JWT_SECRET`                | JWT Token 签名密钥                        | `development-only-secret-change-in-production` |
| `GATEWAY_SKIP_AUTH`         | 跳过身份验证（生产环境请设为 `0`）        | `1`                                            |
| `GATEWAY_PORT_OVERRIDE`     | API 网关的宿主机端口                      | `8080`                                         |
| `TEMPORAL_UI_PORT_OVERRIDE` | Temporal UI 的宿主机端口                  | `8088`                                         |

## 数据库配置

| 变量名              | 说明                | 默认值       |
| ------------------- | ------------------- | ------------ |
| `POSTGRES_VERSION`  | pgvector 镜像标签   | `pg16`       |
| `POSTGRES_USER`     | PostgreSQL 用户名   | `shannon`    |
| `POSTGRES_PASSWORD` | PostgreSQL 密码     | `shannon`    |
| `POSTGRES_DB`       | PostgreSQL 数据库名 | `shannon`    |
| `REDIS_VERSION`     | Redis 镜像标签      | `7.2-alpine` |
| `QDRANT_VERSION`    | Qdrant 镜像标签     | `v1.17`      |

## 智能体配置

| 变量名                     | 说明                        | 默认值    |
| -------------------------- | --------------------------- | --------- |
| `DEFAULT_MODEL_TIER`       | 默认模型复杂度层级          | `small`   |
| `SHANNON_USE_WASI_SANDBOX` | 启用 WASI 沙箱执行代码      | `1`       |
| `WASI_MEMORY_LIMIT_MB`     | WASI 沙箱内存限制（MB）     | `512`     |
| `WASI_TIMEOUT_SECONDS`     | WASI 沙箱执行超时时间（秒） | `60`      |
| `TEMPORAL_NAMESPACE`       | Temporal 工作流命名空间     | `default` |

## 可观测性（可选）

| 变量名                        | 说明                        | 默认值  |
| ----------------------------- | --------------------------- | ------- |
| `OTEL_ENABLED`                | 启用 OpenTelemetry 链路追踪 | `false` |
| `OTEL_EXPORTER_OTLP_ENDPOINT` | OTLP 采集器端点             | ``      |

## 安全说明

- 默认情况下，`GATEWAY_SKIP_AUTH=1` 会禁用 JWT 身份验证，便于本地开发。
- **生产环境**请将 `GATEWAY_SKIP_AUTH` 设为 `0`，并使用强密钥替换 `JWT_SECRET`。
- `.env.example` 中的密码仅供本地开发使用，在部署到共享或公开环境前务必修改。

## 配置文件说明

Shannon 使用 `./config/` 目录下的 YAML 配置文件：

- `config/models.yaml` —— LLM 提供商、模型层级、定价及路由规则
- `config/features.yaml` —— 功能开关、执行模式及工作流设置

这些文件通过 `make setup` 从 Shannon 官方代码仓库下载，可根据需要自定义。

## 开源协议

Shannon 采用 [Apache 2.0 协议](https://github.com/Kocoro-lab/Shannon/blob/main/LICENSE) 开源。
