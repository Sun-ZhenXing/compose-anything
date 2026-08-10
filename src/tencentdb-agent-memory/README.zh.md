# TencentDB Agent Memory

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署腾讯云开源的 TencentDB Agent Memory，一个为 AI 智能体设计的分层长期记忆系统。它为智能体提供跨四个抽象层级的持久化、结构化记忆——对话 → 原子事实 → 场景 → 人设（Persona）——并通过上下文卸载（Context Offloading）提供符号化短期记忆。数据持久化到内置的 SQLite + sqlite-vec 数据库以及本地 Markdown 文件。

该服务本身不包含任何 LLM：它需要调用外部 OpenAI 兼容的 LLM API，因此必须提供 API 密钥。

## 服务

- `tencentdb-agent-memory`：记忆网关（Memory Gateway，端口 8420），以 standalone 模式运行，使用内置 SQLite 数据库，无需外部数据库或 Redis。

## 快速开始

```bash
cp .env.example .env
# 在 .env 中设置 TDAI_LLM_API_KEY（必填——该服务自身不包含模型）
docker compose up -d
```

网关是 API 服务，而不是 Web 界面。通过以下命令验证其运行状态：

```bash
curl http://localhost:8420/health
```

预期响应：`{"status":"ok",...}`。

## 环境变量

| 变量名                        | 说明                                                             | 默认值                            |
| ----------------------------- | ---------------------------------------------------------------- | --------------------------------- |
| `GLOBAL_REGISTRY`             | 全局镜像仓库前缀                                                 | `""`                              |
| `TDAI_MEMORY_VERSION`         | 镜像版本                                                         | `1.0.0`                           |
| `TDAI_LLM_API_KEY`            | LLM API 密钥（必填，无默认值；任意 OpenAI 兼容的提供商均可）     | `""`                              |
| `TDAI_LLM_BASE_URL`           | OpenAI 兼容 LLM API 的基础 URL                                   | `https://api.openai.com/v1`       |
| `TDAI_LLM_MODEL`              | LLM 模型名称                                                     | `gpt-4o`                          |
| `TDAI_LLM_MAX_TOKENS`         | 每次 LLM 请求的最大 token 数                                     | `4096`                            |
| `TDAI_GATEWAY_API_KEY`        | 网关 API 的可选 Bearer 认证令牌（留空表示开放访问）              | `""`                              |
| `TDAI_MEMORY_PORT_OVERRIDE`   | 主机端口映射（映射到容器内网关端口 8420）                        | `8420`                            |
| `TZ`                          | 时区                                                             | `UTC`                             |
| `TDAI_MEMORY_CPU_LIMIT`       | CPU 限制                                                         | `1.00`                            |
| `TDAI_MEMORY_CPU_RESERVATION` | CPU 预留                                                         | `0.10`                            |
| `TDAI_MEMORY_LIMIT`           | 内存限制                                                         | `1G`                              |
| `TDAI_MEMORY_RESERVATION`     | 内存预留                                                         | `256M`                            |

请将 `TDAI_LLM_BASE_URL` 设置为您的提供商地址，例如 `https://api.deepseek.com/v1` 或 `https://api.lkeap.cloud.tencent.com/v1`。

请根据实际需求修改 `.env` 文件。

## 存储

- `tdai_memory_data`：挂载到 `/data/tdai-memory` 的命名卷，存储内置数据库和 Markdown 文件：`vectors.db`、`conversations/`、`records/`、`scene_blocks/` 和 `persona.md`。

## 安全提示

- `TDAI_LLM_API_KEY` 为必填项——该服务没有内置模型，没有 LLM API 密钥将无法工作。
- 网关 API 默认开放（无认证）。当网关暴露到网络时，请将 `TDAI_GATEWAY_API_KEY` 设置为随机长字符串。`/health` 端点始终开放。
- 再分发前请核查项目许可证：默认分支的 `README.docker.md` 声明为腾讯云专有许可证，而 main 分支为 MIT 许可证。

## 集成

TencentDB Agent Memory 专为与智能体框架集成而设计，例如 OpenClaw 插件和 Hermes provider。

## 许可证

本服务目录遵循仓库的许可证。TencentDB Agent Memory 本身——再分发前请核查其许可证（参见安全提示）。
