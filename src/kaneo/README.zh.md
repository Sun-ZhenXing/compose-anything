# Kaneo

[English](./README.md) | [中文](./README.zh.md)

此服务部署 [Kaneo](https://kaneo.app)，一个开源的看板与项目管理平台。Kaneo 提供工作区、项目、可定制工作流、标签和工时统计，并支持 GitHub、Gitea、Slack、Discord 和 Telegram 集成。它还支持 SSO（OIDC），并内置了位于 `/api/mcp` 的 MCP 服务器。

## 服务

- `kaneo`: Kaneo 应用服务器（Web 界面 + API）。
- `postgres`: 存储所有 Kaneo 数据的 PostgreSQL 数据库。

## 快速开始

1. 从示例文件创建 `.env` 文件：

   ```bash
   cp .env.example .env
   ```

2. 编辑 `.env` 并设置必需值：

   ```env
   AUTH_SECRET=your-32-char-minimum-random-secret
   POSTGRES_PASSWORD=your-secure-db-password
   ```

   使用 `openssl rand -hex 32` 生成密钥。关于 `AUTH_SECRET` 的重要性，请参阅[安全提示](#安全提示)。

3. 启动服务：

   ```bash
   docker compose up -d
   ```

4. 在浏览器中打开 `http://localhost:5173`。

5. 第一个注册的用户将成为工作区所有者。注册默认开放；创建账户后，请在 `kaneo` 服务的环境变量中添加 `DISABLE_REGISTRATION=true`（或设置对应的应用选项）以关闭注册。

## 环境变量

| 变量名               | 描述                             | 默认值                  |
| -------------------- | -------------------------------- | ----------------------- |
| KANEO_VERSION        | Kaneo 镜像版本                   | `2.16.2`                |
| POSTGRES_VERSION     | PostgreSQL 镜像版本              | `16.14-alpine`          |
| KANEO_PORT_OVERRIDE  | Kaneo Web 界面的主机端口         | `5173`                  |
| KANEO_CLIENT_URL     | 客户端访问 Kaneo 的公开 URL      | `http://localhost:5173` |
| AUTH_SECRET          | 会话签名密钥（必需，至少 32 个字符） | *(无)*              |
| POSTGRES_DB          | PostgreSQL 数据库名              | `kaneo`                 |
| POSTGRES_USER        | PostgreSQL 用户名                | `kaneo`                 |
| POSTGRES_PASSWORD    | PostgreSQL 密码                  | `kaneo123`              |
| KANEO_CPU_LIMIT      | Kaneo CPU 限制                   | `1.0`                   |
| KANEO_MEMORY_LIMIT   | Kaneo 内存限制                   | `1G`                    |
| POSTGRES_CPU_LIMIT   | PostgreSQL CPU 限制              | `1.0`                   |
| POSTGRES_MEMORY_LIMIT| PostgreSQL 内存限制              | `1G`                    |

## 存储

所有应用数据都存储在由 `postgres` 服务管理的 `postgres_data` 命名卷中。

默认情况下，附加到描述和评论中的上传文件保存在容器内部的临时文件系统中。如需持久化上传文件，请在 Kaneo 设置中配置 S3 兼容的对象存储（例如 MinIO）——应用不配置也可以正常运行，但容器重建后上传文件将会丢失。

## 安全提示

- **开放注册**: 注册默认开放，任何能够访问应用的人都可以创建账户。请先注册您的账户，然后关闭注册（例如设置 `DISABLE_REGISTRATION=true`）。
- **AUTH_SECRET**: 必填项，且至少需要 32 个字符。如果未设置或发生更改，所有用户会话将在重启后失效。请使用 `openssl rand -hex 32` 生成。
- **POSTGRES_PASSWORD**: 在将服务暴露到 localhost 之外之前，请更改默认密码（`kaneo123`）。
- **镜像来源**: 镜像从 GitHub Container Registry（`ghcr.io/usekaneo/kaneo`）拉取，并固定为版本 `2.16.2`。健康检查探测 `http://127.0.0.1:5173/api/health`。
