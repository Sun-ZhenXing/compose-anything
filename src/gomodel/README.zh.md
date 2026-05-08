# GoModel

[GoModel](https://github.com/ENTERPILOT/GoModel) 是一个用 Go 编写的快速、轻量级 AI 网关。它通过单一统一的 OpenAI 兼容 API，透明地将请求路由到 OpenAI、Anthropic、Gemini、Groq、xAI、DeepSeek、OpenRouter、Azure OpenAI、Oracle、Ollama、vLLM 等众多提供商。内置管理仪表盘，支持 Token 用量追踪、成本估算、审计日志和响应缓存。

## 服务组件

| 服务    | 端口 | 说明                                   |
| ------- | ---- | -------------------------------------- |
| GoModel | 8080 | OpenAI 兼容的 AI 网关 API 及管理仪表盘 |

## 快速开始

```bash
docker compose up -d
```

服务启动后可通过 `http://localhost:8080` 访问。**GoModel 启动必须配置至少一个 Provider 凭据**，若未配置任何提供商，服务将在启动时直接退出。默认以开放（无鉴权）模式运行，使用 SQLite 存储。

接入真实流量，请先从示例文件创建 `.env` 并填入至少一个提供商凭据：

```bash
cp .env.example .env
# 编辑 .env，设置 GOMODEL_MASTER_KEY 以及至少一个提供商 API Key
docker compose up -d
```

发起第一次 API 调用：

```bash
curl http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <GOMODEL_MASTER_KEY>" \
  -d '{
    "model": "gpt-4o",
    "messages": [{"role": "user", "content": "你好！"}]
  }'
```

管理仪表盘：`http://localhost:8080/admin/dashboard`

查看可用模型列表：`http://localhost:8080/v1/models`

## 关键环境变量

### 网关配置

| 变量                      | 默认值   | 说明                                             |
| ------------------------- | -------- | ------------------------------------------------ |
| `GOMODEL_VERSION`         | `0.1.27` | Docker 镜像版本                                  |
| `GOMODEL_PORT_OVERRIDE`   | `8080`   | API 宿主机端口                                   |
| `GOMODEL_MASTER_KEY`      | _（空）_ | API 鉴权密钥——**向本机以外的网络暴露时必须设置** |
| `GOMODEL_STORAGE_TYPE`    | `sqlite` | 存储后端：`sqlite`、`postgresql` 或 `mongodb`    |
| `GOMODEL_LOGGING_ENABLED` | `false`  | 是否启用完整的请求/响应审计日志                  |
| `TZ`                      | `UTC`    | 容器时区                                         |

### 提供商凭据

仅需设置你要使用的提供商密钥，未设置的条目会被静默忽略。

| 变量                                 | 提供商                   |
| ------------------------------------ | ------------------------ |
| `OPENAI_API_KEY`                     | OpenAI                   |
| `ANTHROPIC_API_KEY`                  | Anthropic                |
| `GEMINI_API_KEY`                     | Google Gemini            |
| `GROQ_API_KEY`                       | Groq                     |
| `XAI_API_KEY`                        | xAI（Grok）              |
| `DEEPSEEK_API_KEY`                   | DeepSeek                 |
| `OPENROUTER_API_KEY`                 | OpenRouter               |
| `ZAI_API_KEY`                        | Z.ai                     |
| `AZURE_API_KEY` + `AZURE_BASE_URL`   | Azure OpenAI             |
| `ORACLE_API_KEY` + `ORACLE_BASE_URL` | Oracle                   |
| `OLLAMA_BASE_URL`                    | Ollama（本地，无需密钥） |
| `VLLM_BASE_URL`                      | vLLM（本地，密钥可选）   |

完整变量列表（含 Azure、Oracle 及各提供商模型列表配置）请参见 `.env.example`。

## 存储

| 数据卷          | 挂载路径      | 说明                              |
| --------------- | ------------- | --------------------------------- |
| `gomodel_data`  | `/app/data`   | SQLite 数据库、用量数据及审计日志 |
| `gomodel_cache` | `/app/.cache` | 模型元数据注册表缓存              |

默认使用 SQLite 存储（`/app/data/gomodel.db`）。如需切换至 PostgreSQL 或 MongoDB，请设置 `GOMODEL_STORAGE_TYPE` 及对应的 `POSTGRES_URL` 或 `MONGODB_URL` 环境变量。

## API 端点

| 端点                        | 说明                                             |
| --------------------------- | ------------------------------------------------ |
| `GET /v1/models`            | 列出所有已配置提供商的可用模型                   |
| `POST /v1/chat/completions` | 聊天补全（支持流式输出）                         |
| `POST /v1/embeddings`       | 文本向量嵌入                                     |
| `POST /v1/responses`        | OpenAI Responses API                             |
| `GET /health`               | 健康探针                                         |
| `GET /admin/dashboard`      | 管理界面——用量、成本、审计日志                   |
| `GET /metrics`              | Prometheus 指标（需设置 `METRICS_ENABLED=true`） |

## 安全说明

- **`GOMODEL_MASTER_KEY` 默认为空。** 未设置时，所有 API 端点均可公开访问。在将服务暴露到 localhost 以外的网络前，请务必设置强密钥。
- 容器以非 root 用户（UID 65532）运行，根文件系统为只读。
- `cap_drop: [ALL]`——无需任何 Linux 特权能力。
- 请勿通过命令行传递 API 密钥；应使用 `.env` 文件或环境变量。
- 审计日志体（`LOGGING_LOG_BODIES`）可能记录提示词中的敏感信息和 API 密钥，请在具备完整数据保留管控的情况下再启用。

## 相关链接

- [GitHub 仓库](https://github.com/ENTERPILOT/GoModel)
- [官方文档](https://gomodel.enterpilot.io/docs)
- [Docker Hub](https://hub.docker.com/r/enterpilot/gomodel)
