# Gitea

[English](./README.md) | [中文](./README.zh.md)

此配置使用 rootless 镜像运行 Gitea 1.27.3，并使用 PostgreSQL 17.11 作为数据库。

## 服务

- `gitea`：Gitea Web 与 SSH 服务。
- `db`：PostgreSQL 数据库服务。
- `gitea_mcp`：Gitea MCP 服务，提供 streamable HTTP 端点。属于可选组件，仅在启用 `mcp` profile 时启动。

## 快速开始

复制环境变量示例文件是可选步骤。强烈建议在首次启动前修改 `POSTGRES_PASSWORD`；默认密码仅适合本地评估。

```bash
cp .env.example .env
# 在 .env 中修改 POSTGRES_PASSWORD。
docker compose up -d
```

服务健康后，访问 <http://localhost:3000>。

MCP 服务是可选的，默认不会启动。如需同时启动，请执行：

```bash
docker compose --profile mcp up -d
```

## 初始设置

在 Gitea 安装页面中使用以下数据库设置：

- 数据库类型：`PostgreSQL`
- 主机：`db:5432`
- 用户：`gitea`，或 `POSTGRES_USER` 的值
- 数据库名称：`gitea`，或 `POSTGRES_DB` 的值
- 密码：`POSTGRES_PASSWORD` 的值

第一个注册的用户将成为管理员。

## Gitea MCP 服务（可选）

`gitea_mcp` 服务以 streamable HTTP 方式运行官方 Gitea MCP 服务。它由 `mcp` profile 控制，因此直接执行 `docker compose up -d` 不会启动它。

```bash
docker compose --profile mcp up -d
```

启动后，MCP 端点位于 <http://localhost:3001/mcp>（仅接受 `POST`），健康检查端点为 <http://localhost:3001/healthz>。

认证方式有两种：

- 在 `.env` 中设置 `GITEA_MCP_ACCESS_TOKEN`，填入在 Gitea 的 **Settings > Applications** 中创建的 personal access token。之后所有请求都会使用该 token。
- 将 token 留空，由每个 MCP 客户端自行发送 `Authorization: Bearer <token>` 请求头。

该服务无状态，不保存任何数据。日志文件位于容器内部，容器重建后即丢失；可通过 `docker compose logs gitea_mcp` 查看。

## 配置

| 变量 | 默认值 | 说明 |
| --- | --- | --- |
| `GITEA_VERSION` | `1.27.3-rootless` | Gitea 镜像标签。 |
| `GITEA_DB_TYPE` | `postgres` | Gitea 数据库类型。 |
| `GITEA_POSTGRES_HOST` | `db:5432` | Compose 网络内的 PostgreSQL 地址。 |
| `POSTGRES_VERSION` | `17.11` | PostgreSQL 镜像版本。 |
| `POSTGRES_USER` | `gitea` | 数据库用户。 |
| `POSTGRES_PASSWORD` | `gitea` | 数据库密码，生产环境必须修改。 |
| `POSTGRES_DB` | `gitea` | 数据库名称。 |
| `GITEA_HTTP_PORT` | `3000` | Gitea HTTP 发布端口。 |
| `GITEA_SSH_PORT` | `2222` | Gitea SSH 发布端口。 |
| `GITEA_MCP_VERSION` | `1.7.0` | Gitea MCP 服务镜像标签。 |
| `GITEA_MCP_PORT_OVERRIDE` | `3001` | MCP HTTP 端点的宿主机端口。 |
| `GITEA_MCP_HOST` | `http://gitea:3000` | Compose 网络内访问 Gitea 的地址。 |
| `GITEA_MCP_ACCESS_TOKEN` | 空 | 用于所有请求的 Gitea personal access token。 |
| `GITEA_MCP_INSECURE` | `false` | 当 `GITEA_MCP_HOST` 使用 HTTPS 时跳过 TLS 校验。 |
| `GITEA_MCP_READONLY` | `false` | 隐藏会修改 Gitea 数据的 MCP 工具。 |

### 默认端口

| 服务 | 宿主机端口 | 容器端口 |
| --- | --- | --- |
| Gitea HTTP | `3000` | `3000` |
| Gitea SSH | `2222` | `2222` |
| Gitea MCP | `3001` | `8080` |
| PostgreSQL | 不发布 | `5432` |

## 存储

- `gitea_data`：保存 Gitea 仓库和应用数据。
- `gitea_config`：保存 Gitea 配置。
- `postgres`：保存 PostgreSQL 数据库文件。
- `gitea_mcp` 不使用 volume；MCP 服务不保存任何状态。

## 升级

从旧版本升级前，请备份 `postgres`、`gitea_data` 和 `gitea_config` volumes。Gitea 会在启动时自动执行数据库 migration；执行 migration 后不要直接降级，应恢复兼容版本的备份。

## 安全

Gitea 应用使用 rootless 镜像。默认数据库密码仅适合本地评估，生产环境必须修改。仅按需发布 HTTP 和 SSH 端口，并通过宿主机防火墙或代理规则限制网络访问。
