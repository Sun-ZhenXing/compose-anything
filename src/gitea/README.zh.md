# Gitea

[English](./README.md) | [中文](./README.zh.md)

此配置使用 rootless 镜像运行 Gitea 1.27.0，并使用 PostgreSQL 17.6 作为数据库。

## 服务

- `gitea`：Gitea Web 与 SSH 服务。
- `db`：PostgreSQL 数据库服务。

## 快速开始

复制环境变量示例文件是可选步骤。强烈建议在首次启动前修改 `POSTGRES_PASSWORD`；默认密码仅适合本地评估。

```bash
cp .env.example .env
# 在 .env 中修改 POSTGRES_PASSWORD。
docker compose up -d
```

服务健康后，访问 <http://localhost:3000>。

## 初始设置

在 Gitea 安装页面中使用以下数据库设置：

- 数据库类型：`PostgreSQL`
- 主机：`db:5432`
- 用户：`gitea`，或 `POSTGRES_USER` 的值
- 数据库名称：`gitea`，或 `POSTGRES_DB` 的值
- 密码：`POSTGRES_PASSWORD` 的值

第一个注册的用户将成为管理员。

## 配置

| 变量 | 默认值 | 说明 |
| --- | --- | --- |
| `GITEA_VERSION` | `1.27.0-rootless` | Gitea 镜像标签。 |
| `GITEA_DB_TYPE` | `postgres` | Gitea 数据库类型。 |
| `GITEA_POSTGRES_HOST` | `db:5432` | Compose 网络内的 PostgreSQL 地址。 |
| `POSTGRES_VERSION` | `17.6` | PostgreSQL 镜像版本。 |
| `POSTGRES_USER` | `gitea` | 数据库用户。 |
| `POSTGRES_PASSWORD` | `gitea` | 数据库密码，生产环境必须修改。 |
| `POSTGRES_DB` | `gitea` | 数据库名称。 |
| `GITEA_HTTP_PORT` | `3000` | Gitea HTTP 发布端口。 |
| `GITEA_SSH_PORT` | `2222` | Gitea SSH 发布端口。 |

### 默认端口

| 服务 | 宿主机端口 | 容器端口 |
| --- | --- | --- |
| Gitea HTTP | `3000` | `3000` |
| Gitea SSH | `2222` | `2222` |
| PostgreSQL | 不发布 | `5432` |

## 存储

- `gitea_data`：保存 Gitea 仓库和应用数据。
- `gitea_config`：保存 Gitea 配置。
- `postgres`：保存 PostgreSQL 数据库文件。

## 升级

从旧版本升级前，请备份 `postgres`、`gitea_data` 和 `gitea_config` volumes。Gitea 会在启动时自动执行数据库 migration；执行 migration 后不要直接降级，应恢复兼容版本的备份。

## 安全

Gitea 应用使用 rootless 镜像。默认数据库密码仅适合本地评估，生产环境必须修改。仅按需发布 HTTP 和 SSH 端口，并通过宿主机防火墙或代理规则限制网络访问。
