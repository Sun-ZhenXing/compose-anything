# Skyvern

[English](./README.md) | [中文](./README.zh.md)

快速开始：<https://docs.skyvern.com>。

此服务用于部署 Skyvern，一个由 AI 驱动的浏览器自动化平台，使用 LLM 和计算机视觉在 Web 浏览器中执行任务。无需编写自定义脚本，即可填写表单、导航网站和完成多步骤工作流。

## 服务

- **skyvern**：集成了 Playwright + Chromium 的 Skyvern API 服务器。
- **skyvern-ui**：用于任务管理和浏览器会话查看的 React Web UI。
- **postgres**：PostgreSQL 数据库，用于存储任务历史和状态。

## 快速开始

1. 将 `.env.example` 复制为 `.env`：

   ```bash
   cp .env.example .env
   ```

2. 在 `.env` 中设置 LLM API Key 并更改 Skyvern API Key：

   ```
   SKYVERN_API_KEY=your-strong-api-key
   OPENAI_API_KEY=sk-...
   ```

3. 启动服务：

   ```bash
   docker compose up -d
   ```

4. 打开 `http://localhost:8080` 访问 Web UI，或通过 `http://localhost:8000` 向 API 发送任务。

## 核心环境变量

| 变量                       | 说明                                                    | 默认值                   |
| -------------------------- | ------------------------------------------------------- | ------------------------ |
| `SKYVERN_VERSION`          | 镜像版本（同时适用于 skyvern 和 skyvern-ui）            | `v1.0.31`                |
| `SKYVERN_PORT_OVERRIDE`    | API 宿主机端口                                          | `8000`                   |
| `SKYVERN_UI_PORT_OVERRIDE` | Web UI 宿主机端口                                       | `8080`                   |
| `SKYVERN_API_KEY`          | 请求 Skyvern 服务器的认证 API Key——**请修改**           | 占位符                   |
| `BROWSER_TYPE`             | 浏览器类型：`chromium-headless`、`chromium` 或 `chrome` | `chromium-headless`      |
| `OPENAI_API_KEY`           | OpenAI API Key（推荐，效果最佳）                        | *(空)*                   |
| `ANTHROPIC_API_KEY`        | Anthropic API Key（OpenAI 的替代方案）                  | *(空)*                   |
| `POSTGRES_PASSWORD`        | PostgreSQL 密码                                         | `skyvern`                |
| `VITE_API_BASE_URL`        | 从用户浏览器访问的 Skyvern API URL                      | `http://localhost:8000`  |
| `VITE_WSS_BASE_URL`        | 实时会话流的 WebSocket URL                              | `ws://localhost:8000`    |

## 数据卷

- `skyvern_artifacts`：下载的文件和任务产物。
- `skyvern_videos`：浏览器会话录像。
- `skyvern_har`：用于调试的 HTTP 存档（HAR）文件。
- `skyvern_postgres_data`：PostgreSQL 数据持久化。

## 端口

- **8000**：Skyvern REST API
- **8080**：Skyvern Web UI

## 资源需求

| 服务       | CPU 限制 | 内存限制 |
| ---------- | -------- | -------- |
| skyvern    | 2        | 4 GB     |
| skyvern-ui | 0.5      | 256 MB   |
| postgres   | 1        | 1 GB     |

`skyvern` 服务包含 Playwright 和 Chromium，需分配 **4+ GB RAM** 和 **2+ CPU 核心**以保证浏览器自动化的稳定运行。

## 说明

- 数据库迁移通过 Alembic 在启动时自动运行。
- 如果部署在反向代理后，请将 `VITE_API_BASE_URL` 和 `VITE_WSS_BASE_URL` 更新为你的公网域名。
- API 请求中必须在 `x-api-key` 请求头中包含 `SKYVERN_API_KEY`。

## 文档

- [Skyvern 文档](https://docs.skyvern.com)
- [GitHub](https://github.com/Skyvern-AI/skyvern)
