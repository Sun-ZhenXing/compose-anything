# AnythingLLM

[English](./README.md) | [中文](./README.zh.md)

快速开始：<https://docs.anythingllm.com>。

此服务用于部署 AnythingLLM，一款集文档问答、多 LLM 提供商接入和自定义 AI Agent 于一体的全能 AI 应用，内置完整的 RAG 流水线。

## 服务

- `anythingllm`：AnythingLLM Web 应用。

## 快速开始

```bash
docker compose up -d
```

打开 `http://localhost:3001`，按照设置向导连接你的 LLM 提供商。

## 配置

所有 LLM 提供商、向量数据库和 Agent 设置均通过启动后的 Web UI 进行配置，无需在 `.env` 中预设 API Key（除非你希望通过环境变量预填充）。

| 变量                          | 说明                                | 默认值   |
| ----------------------------- | ----------------------------------- | -------- |
| `ANYTHINGLLM_VERSION`         | 镜像版本（无语义化稳定标签，使用 `latest`） | `latest` |
| `TZ`                          | 容器时区                            | `UTC`    |
| `ANYTHINGLLM_PORT_OVERRIDE`   | Web UI 的宿主机端口                 | `3001`   |
| `ANYTHINGLLM_UID`             | 数据卷文件所有者 UID               | `1000`   |
| `ANYTHINGLLM_GID`             | 数据卷文件所有者 GID               | `1000`   |
| `ANYTHINGLLM_CPU_LIMIT`       | CPU 限制                            | `2`      |
| `ANYTHINGLLM_MEMORY_LIMIT`    | 内存限制                            | `2G`     |
| `ANYTHINGLLM_CPU_RESERVATION` | CPU 预留                            | `0.5`    |
| `ANYTHINGLLM_MEMORY_LIMIT`    | 内存预留                            | `512M`   |

## 数据卷

- `anythingllm_storage`：持久化所有应用数据、上传的文档、嵌入向量和配置。

## 端口

- **3001**：Web UI

## 说明

- `mintplexlabs/anythingllm` 镜像未发布语义化稳定标签，`latest` 是唯一可靠的标签。
- 支持 OpenAI、Anthropic、Ollama、LM Studio 等众多 LLM 后端，均可在 UI 中配置。
- 健康检查使用 `/api/ping` 端点。
