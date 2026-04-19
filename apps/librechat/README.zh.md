# LibreChat

[English](./README.md) | [中文](./README.zh.md)

快速开始：<https://docs.librechat.ai>。

此服务用于部署 LibreChat，一个开源 AI 对话平台，在单一统一界面中支持 OpenAI、Anthropic、Google、Ollama 等众多提供商，具备对话历史、文件上传、代码执行和多用户支持。

## 服务

- **librechat**：LibreChat Web 应用（Node.js）。
- **mongodb**：用于存储对话和用户数据的 MongoDB 数据库。
- **meilisearch**：用于消息索引的全文搜索引擎。

## 快速开始

1. 将 `.env.example` 复制为 `.env`：

   ```bash
   cp .env.example .env
   ```

2. 更新 `.env` 中的密钥（使用 `openssl rand -hex 32` 生成）：

   ```
   JWT_SECRET、JWT_REFRESH_SECRET、MEILI_MASTER_KEY、CREDS_KEY、CREDS_IV
   ```

3. 启动服务：

   ```bash
   docker compose up -d
   ```

4. 打开 `http://localhost:3080`，注册第一个用户账号。

## 核心环境变量

| 变量                     | 说明                                                    | 默认值   |
| ------------------------ | ------------------------------------------------------- | -------- |
| `LIBRECHAT_VERSION`      | 镜像版本                                                | `v0.8.4` |
| `LIBRECHAT_PORT_OVERRIDE`| Web UI 宿主机端口                                       | `3080`   |
| `JWT_SECRET`             | JWT 签名密钥（至少 32 字符）——**请修改**                | 占位符   |
| `JWT_REFRESH_SECRET`     | JWT 刷新签名密钥——**请修改**                            | 占位符   |
| `MEILI_MASTER_KEY`       | Meilisearch 主密钥——**请修改**                          | 占位符   |
| `CREDS_KEY`              | 存储凭证的加密密钥（恰好 32 字符）                      | 占位符   |
| `CREDS_IV`               | 加密 IV（恰好 16 字符）                                 | 占位符   |
| `ALLOW_REGISTRATION`     | 允许新用户注册                                          | `true`   |
| `OPENAI_API_KEY`         | OpenAI API Key（可选；也可在 UI 中配置）                | *(空)*   |
| `ANTHROPIC_API_KEY`      | Anthropic API Key（可选）                               | *(空)*   |

## 数据卷

- `librechat_images`：用户上传的图片，由 Web UI 提供服务。
- `librechat_logs`：应用日志文件。
- `librechat_mongo_data`：MongoDB 数据持久化。
- `librechat_meilisearch_data`：Meilisearch 索引数据。

## 端口

- **3080**：LibreChat Web UI

## 安全说明

- 在对外暴露之前，请生成所有密钥：`openssl rand -hex 32`。
- `CREDS_KEY` 和 `CREDS_IV` 用于加密存储的 API Key——丢失后存储的凭证将无法恢复。
- 创建管理员账号后，将 `ALLOW_REGISTRATION` 设为 `false` 以禁止新用户注册。

## 资源需求

| 服务        | CPU 限制 | 内存限制 |
| ----------- | -------- | -------- |
| librechat   | 2        | 2 GB     |
| mongodb     | 1        | 1 GB     |
| meilisearch | 0.5      | 512 MB   |

推荐总计：**4+ GB RAM**。

## 文档

- [LibreChat 文档](https://docs.librechat.ai)
- [GitHub](https://github.com/danny-avila/LibreChat)
