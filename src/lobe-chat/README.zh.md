# LobeChat

[English](./README.md) | [中文](./README.zh.md)

快速开始：<https://lobehub.com/docs>。

此服务以独立（无服务器）模式部署 LobeChat，这是一款现代高性能的 AI 对话界面，支持多 LLM 提供商、视觉模型和插件扩展。无需数据库，所有状态均存储在客户端。

## 服务

- `lobe-chat`：LobeChat Web 应用。

## 快速开始

```bash
docker compose up -d
```

打开 `http://localhost:3210`。在设置面板（齿轮图标）中配置 LLM API Key，或在启动前通过环境变量设置。

## 配置

| 变量                      | 说明                                       | 默认值    |
| ------------------------- | ------------------------------------------ | --------- |
| `LOBE_CHAT_VERSION`       | 镜像版本                                   | `1.143.3` |
| `TZ`                      | 容器时区                                   | `UTC`     |
| `LOBE_CHAT_PORT_OVERRIDE` | Web UI 的宿主机端口                        | `3210`    |
| `ACCESS_CODE`             | 可选访问密码（空则开放访问）               | *(空)*    |
| `OPENAI_API_KEY`          | OpenAI API Key                             | *(空)*    |
| `OPENAI_PROXY_URL`        | 自定义 OpenAI 兼容 API 基础 URL            | *(空)*    |
| `ANTHROPIC_API_KEY`       | Anthropic API Key                          | *(空)*    |
| `GOOGLE_API_KEY`          | Google Gemini API Key                      | *(空)*    |
| `LOBE_CHAT_CPU_LIMIT`     | CPU 限制                                   | `0.5`     |
| `LOBE_CHAT_MEMORY_LIMIT`  | 内存限制                                   | `512M`    |

## 端口

- **3210**：Web UI

## 说明

- 此为**独立**（客户端）模式，无需 PostgreSQL、S3 或认证服务器。
- 对话历史存储在浏览器中，清除浏览器数据将丢失历史记录。
- 如需多用户部署及服务端持久化数据，请参阅 [LobeChat 数据库模式文档](https://lobehub.com/docs/self-hosting/server-database)。
- 健康检查使用 `/api/health` 端点。
