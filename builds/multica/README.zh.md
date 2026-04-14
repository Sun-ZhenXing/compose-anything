# Multica

[English](./README.md) | [中文](./README.zh.md)

Multica 是一个开源的托管 Agent 平台，能将编码 Agent 变成真正的团队成员。分配任务、跟踪进度、积累可复用技能——支持 Claude Code、Codex、OpenClaw 和 OpenCode。此 Compose 配置从源码构建 Go 后端和 Next.js 前端，启动带有 pgvector 扩展的 PostgreSQL，并暴露两个服务。

## 服务

- **multica-backend**：Go 后端（Chi 路由、sqlc、gorilla/websocket），启动时自动执行数据库迁移
- **multica-frontend**：Next.js 16 Web 应用（App Router，standalone 输出）
- **multica-postgres**：PostgreSQL 17，包含 pgvector 扩展

## 快速开始

1. 复制环境变量示例文件：

   ```bash
   cp .env.example .env
   ```

2. 编辑 `.env`，将 `MULTICA_JWT_SECRET` 修改为安全的随机值：

   ```bash
   MULTICA_JWT_SECRET=$(openssl rand -base64 32)
   ```

3. 启动服务（首次运行会从源码构建镜像，需要几分钟）：

   ```bash
   docker compose up -d
   ```

4. 打开 Multica：

   - 前端界面：<http://localhost:3000>
   - 后端 API：<http://localhost:8080>

## 默认端口

| 服务     | 端口 | 说明                  |
| -------- | ---- | --------------------- |
| Frontend | 3000 | Web 界面              |
| Backend  | 8080 | REST API 和 WebSocket |
| Postgres | 5432 | 仅内部访问            |

## 关键环境变量

| 变量                             | 说明                               | 默认值                    |
| -------------------------------- | ---------------------------------- | ------------------------- |
| `MULTICA_VERSION`                | 用于源码构建的 Git 引用            | `v0.1.32`                 |
| `MULTICA_BACKEND_PORT_OVERRIDE`  | 后端 API 对外端口                  | `8080`                    |
| `MULTICA_FRONTEND_PORT_OVERRIDE` | Web 界面对外端口                   | `3000`                    |
| `MULTICA_JWT_SECRET`             | JWT 签名密钥（生产环境必须修改）   | `change-me-in-production` |
| `MULTICA_POSTGRES_PASSWORD`      | PostgreSQL 密码                    | `multica`                 |
| `MULTICA_FRONTEND_ORIGIN`        | 前端 URL，用于 CORS 和 Cookie 设置 | `http://localhost:3000`   |
| `MULTICA_GOOGLE_CLIENT_ID`       | Google OAuth 客户端 ID（可选）     | -                         |
| `MULTICA_GOOGLE_CLIENT_SECRET`   | Google OAuth 客户端密钥（可选）    | -                         |
| `MULTICA_RESEND_API_KEY`         | Resend 邮件服务的 API Key（可选）  | -                         |
| `TZ`                             | 容器时区                           | `UTC`                     |

## 存储

| 卷               | 说明            |
| ---------------- | --------------- |
| `multica_pgdata` | PostgreSQL 数据 |

## 安全说明

- 在对外暴露服务前，务必修改 `MULTICA_JWT_SECRET`。
- 生产环境部署时请修改 `MULTICA_POSTGRES_PASSWORD`。
- Google OAuth 和邮件服务（Resend）均为可选配置，平台在没有它们的情况下也能正常运行。
- 首次构建需要从 GitHub 下载完整的 Multica 仓库并构建 Docker 镜像，因此需要联网，可能需要几分钟。

## 参考资料

- [Multica 仓库](https://github.com/multica-ai/multica)
- [自托管指南](https://github.com/multica-ai/multica/blob/main/SELF_HOSTING.md)
