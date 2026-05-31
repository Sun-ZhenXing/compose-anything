# Archon

[English](./README.md) | [中文](./README.zh.md)

快速开始：<https://archon.diy/docs/deployment/docker>。

此服务用于部署 Archon，一个面向 AI 编码代理的开源工作流引擎。该栈使用官方预构建的 Web UI + API 镜像，通过 Docker 卷持久化 Archon 的工作状态，默认使用 SQLite 实现零配置启动，并提供可选的 `with-db` profile 用于本地 PostgreSQL。

## 服务

- **archon**：Archon Web UI 和 API 服务器。
- **postgres**：可选的 PostgreSQL 17 后端，适合共享访问或更高并发的工作流场景。

## 快速开始

1. 将 `.env.example` 复制为 `.env`：

   ```bash
   cp .env.example .env
   ```

2. 在 `.env` 中至少设置一种 AI 凭据。

   对于 Docker 部署，优先使用 `CLAUDE_CODE_OAUTH_TOKEN` 或 `CLAUDE_API_KEY`。如果你要使用 GitHub 仓库或 Webhook，请将 `GH_TOKEN` 和 `GITHUB_TOKEN` 设置为同一个个人访问令牌。

3. 启动 Archon：

   ```bash
   docker compose up -d
   ```

4. 打开 `http://localhost:3000`。

## 可选的本地 PostgreSQL

如果你想用本地 PostgreSQL 代替 SQLite，请在 `.env` 中设置：

```ini
DATABASE_URL=postgresql://postgres:postgres@postgres:5432/remote_coding_agent
```

然后启动可选 profile：

```bash
docker compose --profile with-db up -d
```

## 核心环境变量

| 变量                      | 说明                                                 | 默认值            |
| ------------------------- | ---------------------------------------------------- | ----------------- |
| `ARCHON_VERSION`          | Archon 镜像标签                                      | `latest`          |
| `ARCHON_PORT_OVERRIDE`    | Archon Web UI 和 API 的宿主机端口                    | `3000`            |
| `CLAUDE_CODE_OAUTH_TOKEN` | Docker 部署推荐使用的 Claude Code OAuth Token        | 占位符            |
| `CLAUDE_API_KEY`          | Anthropic API Key，作为 OAuth 的替代方案             | *(空)*            |
| `DEFAULT_AI_ASSISTANT`    | 新会话的默认助手                                     | `claude`          |
| `DATABASE_URL`            | PostgreSQL 连接串；留空时使用 SQLite                 | *(空)*            |
| `GH_TOKEN`                | 用于克隆私有仓库和 GitHub CLI 的 GitHub 个人访问令牌 | *(空)*            |
| `GITHUB_TOKEN`            | GitHub 适配器复用的同一个 GitHub Token               | *(空)*            |
| `ARCHON_DATA`             | 可选的 `/.archon` 宿主机路径；留空时使用命名卷       | Docker 托管命名卷 |
| `ARCHON_USER_HOME`        | 可选的 `/home/appuser` 宿主机路径；留空时使用命名卷  | Docker 托管命名卷 |
| `POSTGRES_PASSWORD`       | 可选本地 PostgreSQL 容器的密码                       | `postgres`        |

## 数据卷

- `archon_data`：`/.archon` 下的 SQLite 数据库、已注册代码库、工作区、worktree 和其他 Archon 数据。
- `archon_user_home`：持久化的 `/home/appuser` 状态，包括 Claude/Codex 登录信息、`~/.gitconfig`、shell 历史和用户安装的 Archon 资源。
- `archon_postgres_data`：启用 `with-db` profile 时使用的 PostgreSQL 数据目录。

## 端口

- **3000**：Archon Web UI 和 API
- **5432**：可选的本地 PostgreSQL，仅在启用 `with-db` profile 时绑定到 `127.0.0.1`

## 资源需求

| 服务     | CPU 限制 | 内存限制 |
| -------- | -------- | -------- |
| archon   | 2        | 4 GB     |
| postgres | 1        | 1 GB     |

Archon 镜像内置了 Chromium 和 Git 工具链。建议至少分配 **4+ GB RAM** 和 **2+ CPU 核心**；如果你要同时运行多个工作流或浏览器驱动的验证任务，请继续上调资源。

## 说明

- 默认启动路径会把数据写入 `/.archon/archon.db` 中的 SQLite；只有在需要 PostgreSQL 时才设置 `DATABASE_URL`。
- 这个栈为全新 PostgreSQL 数据卷挂载了当前的 `000_combined.sql` 初始化脚本。如果未来上游版本新增了增量 PostgreSQL 迁移，请在升级已有 PostgreSQL 数据卷前，从 Archon 上游仓库应用新的 SQL 文件。
- 如果你要把 Archon 暴露到 localhost 之外，请放到带认证的反向代理之后。

## 文档

- [Archon Docker 指南](https://archon.diy/docs/deployment/docker)
- [Archon 数据库参考](https://archon.diy/docs/reference/database)
- [GitHub 仓库](https://github.com/coleam00/Archon)
