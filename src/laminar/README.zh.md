# Laminar

[English](./README.md) | [中文](./README.zh.md)

Laminar 是一个专为 AI Agent 打造的开源可观测性平台。它提供追踪、评估、AI 监控、SQL 数据访问、仪表板和数据标注功能。

## 功能特性

- **追踪（Tracing）**：基于 OpenTelemetry 的强大追踪 SDK —— 只需一行代码即可自动追踪 Vercel AI SDK、Browser Use、Stagehand、LangChain、OpenAI、Anthropic、Gemini 等。
- **评估（Evals）**：无倾向性的可扩展 SDK 和 CLI，用于在本地或 CI/CD 流水线中运行评估。
- **AI 监控**：使用自然语言描述定义事件，追踪问题和自定义行为。
- **SQL 访问**：使用内置 SQL 编辑器查询追踪、指标和事件。
- **仪表板**：用于追踪、指标和事件的强大仪表板构建器。
- **数据标注**：自定义数据渲染 UI，用于快速数据标注和数据集创建。
- **高性能**：使用 Rust 编写，具有自定义实时引擎和超快的全文搜索。

## 服务

| 服务           | 描述                                    | 端口      |
| -------------- | --------------------------------------- | --------- |
| `frontend`     | Laminar Web UI 和 Next.js 应用          | 5667      |
| `app-server`   | Rust 后端服务器（HTTP API、gRPC、实时） | 8000-8002 |
| `postgres`     | 用于持久化存储的 PostgreSQL 数据库      | -         |
| `clickhouse`   | 用于高性能分析的 ClickHouse             | -         |
| `quickwit`     | 用于全文搜索的 Quickwit                 | 7280      |
| `query-engine` | 用于数据处理的查询引擎                  | 8903      |

## 端口

| 端口 | 协议 | 描述                    |
| ---- | ---- | ----------------------- |
| 5667 | HTTP | Laminar Web UI          |
| 8000 | HTTP | 应用服务器 HTTP API     |
| 8001 | gRPC | 应用服务器 gRPC         |
| 8002 | HTTP | 应用服务器实时 API      |
| 7280 | HTTP | Quickwit REST API 和 UI |
| 8903 | HTTP | 查询引擎 API            |

## 环境变量

| 变量                                    | 描述                                | 默认值                               |
| --------------------------------------- | ----------------------------------- | ------------------------------------ |
| `LAMINAR_POSTGRES_VERSION`              | PostgreSQL 镜像版本                 | `16-alpine`                          |
| `LAMINAR_POSTGRES_USER`                 | PostgreSQL 用户名                   | `postgres`                           |
| `LAMINAR_POSTGRES_PASSWORD`             | PostgreSQL 密码                     | `change_me_in_production`            |
| `LAMINAR_CLICKHOUSE_VERSION`            | ClickHouse 镜像版本                 | `latest`                             |
| `LAMINAR_CLICKHOUSE_USER`               | ClickHouse 用户名                   | `clickhouse`                         |
| `LAMINAR_CLICKHOUSE_PASSWORD`           | ClickHouse 密码                     | `change_me_in_production`            |
| `LAMINAR_SHARED_SECRET_TOKEN`           | 服务间认证共享密钥                  | `shared_secret_change_in_production` |
| `LAMINAR_AEAD_SECRET_KEY`               | AEAD 加密密钥（64 位十六进制字符）  | -                                    |
| `LAMINAR_OPENAI_API_KEY`                | OpenAI API 密钥（可选）             | -                                    |
| `LAMINAR_GOOGLE_GENERATIVE_AI_API_KEY`  | Google AI 密钥（用于 Signals 功能） | -                                    |
| `LAMINAR_FRONTEND_PORT_OVERRIDE`        | Web UI 主机端口                     | `5667`                               |
| `LAMINAR_APP_SERVER_PORT_OVERRIDE`      | HTTP API 主机端口                   | `8000`                               |
| `LAMINAR_APP_SERVER_GRPC_PORT_OVERRIDE` | gRPC 主机端口                       | `8001`                               |
| `LAMINAR_APP_SERVER_RT_PORT_OVERRIDE`   | 实时 API 主机端口                   | `8002`                               |

## 数据卷

- `laminar_postgres_data`：PostgreSQL 数据
- `laminar_clickhouse_data`：ClickHouse 数据
- `laminar_clickhouse_logs`：ClickHouse 日志
- `laminar_quickwit_data`：Quickwit 数据

## 快速开始

1. 复制示例环境文件：

   ```bash
   cp .env.example .env
   ```

2. 编辑 `.env` 并设置必需的密钥：

   ```dotenv
   LAMINAR_POSTGRES_PASSWORD=your_secure_password
   LAMINAR_CLICKHOUSE_PASSWORD=your_secure_password
   LAMINAR_SHARED_SECRET_TOKEN=your_shared_secret
   LAMINAR_AEAD_SECRET_KEY=your_64_character_hex_key
   ```

   生成安全 AEAD 密钥：
   ```bash
   openssl rand -hex 32
   ```

3. 启动服务：

   ```bash
   docker compose up -d
   ```

4. 在浏览器中访问 http://localhost:5667

## 启用 AI 监控（Signals）

要启用 Signals 功能，请设置 Google Generative AI API 密钥：

```dotenv
LAMINAR_GOOGLE_GENERATIVE_AI_API_KEY=your_key_here
```

## SDK 配置

在使用自托管实例时使用 Laminar SDK：

**Python：**
```python
from lmnr import Laminar
Laminar.initialize(
    project_api_key="<LMNR_PROJECT_API_KEY>",
    base_url="http://localhost:8000"
)
```

**TypeScript：**
```typescript
import { Laminar } from '@lmnr-ai/lmnr';
Laminar.initialize({
    projectApiKey: process.env.LMNR_PROJECT_API_KEY,
    baseUrl: "http://localhost:8000"
});
```

## 文档

完整文档请访问：https://laminar.sh/docs

## 资源需求

最低推荐资源配置：

| 服务         | CPU  | 内存 |
| ------------ | ---- | ---- |
| frontend     | 0.25 | 256M |
| app-server   | 0.5  | 512M |
| postgres     | 0.25 | 256M |
| clickhouse   | 0.5  | 512M |
| quickwit     | 0.25 | 256M |
| query-engine | 0.25 | 128M |

最低总计：约 2 核 CPU，~2GB 内存

生产环境使用时，请根据数据量增加 ClickHouse 和 PostgreSQL 的资源。
