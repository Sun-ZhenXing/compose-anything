# Letta

[English](./README.md) | [中文](./README.zh.md)

快速开始：<https://docs.letta.com>。

此服务用于部署 Letta（前身为 MemGPT），一个用于构建具备长期记忆、持久状态和工具调用能力的有状态 AI Agent 框架。Letta 提供 REST API，支持以编程方式创建和管理 Agent。

## 服务

- `letta`：Letta Agent 服务器。

## 快速开始

```bash
docker compose up -d
```

Letta REST API 将在 `http://localhost:8283` 可用。你可以通过 [Letta Python SDK](https://github.com/letta-ai/letta) 或 [ADE Web 界面](https://app.letta.com) 与其交互。

如需连接本地 LLM（Ollama），请在启动前在 `.env` 文件中设置 `OLLAMA_BASE_URL`。

## 配置

| 变量                   | 说明                                                        | 默认值   |
| ---------------------- | ----------------------------------------------------------- | -------- |
| `LETTA_VERSION`        | 镜像版本                                                    | `0.16.7` |
| `TZ`                   | 容器时区                                                    | `UTC`    |
| `LETTA_PORT_OVERRIDE`  | REST API 的宿主机端口                                       | `8283`   |
| `OPENAI_API_KEY`       | OpenAI API Key（可选）                                      | *(空)*   |
| `ANTHROPIC_API_KEY`    | Anthropic API Key（可选）                                   | *(空)*   |
| `GROQ_API_KEY`         | Groq API Key（可选）                                        | *(空)*   |
| `OLLAMA_BASE_URL`      | Ollama 基础 URL，例如 `http://host.docker.internal:11434`   | *(空)*   |
| `LETTA_CPU_LIMIT`      | CPU 限制                                                    | `1`      |
| `LETTA_MEMORY_LIMIT`   | 内存限制                                                    | `1G`     |
| `LETTA_CPU_RESERVATION`| CPU 预留                                                    | `0.25`   |

## 数据卷

- `letta_data`：在 `/root/.letta` 持久化 Agent 状态、记忆和配置。

## 端口

- **8283**：REST API

## 说明

- 创建可用的 Agent 至少需要一个 LLM 提供商的 API Key（或 `OLLAMA_BASE_URL`）。
- 健康检查使用 `/health` 端点。
