# Memos

[English](./README.md) | [中文](./README.zh.md)

Memos 是一个隐私优先的轻量级笔记服务。

## 服务

- `memos`：Memos `0.30.0`，默认使用 SQLite。

## 快速开始

```bash
# 可选：只有需要修改默认值时才创建 .env。
# 不创建此文件也可以直接运行 docker compose up -d。
cp .env.example .env
docker compose up -d
docker compose ps
```

打开 <http://localhost:5230>。首次启动时创建管理员账户。在将服务暴露到本地主机之外前，请配置注册限制，并通过 HTTPS 提供服务。

默认绑定地址是 `127.0.0.1`。只有在明确需要远程访问时，才将 `MEMOS_BIND_ADDRESS` 设置为 `0.0.0.0`，并优先放在 HTTPS 反向代理之后。

## 配置

| 变量 | 默认值 | 说明 |
| --- | --- | --- |
| `MEMOS_VERSION` | `0.30.0` | 官方 `neosmemo/memos` 镜像标签。 |
| `MEMOS_BIND_ADDRESS` | `127.0.0.1` | 主机绑定地址。 |
| `MEMOS_PORT_OVERRIDE` | `5230` | 主机端口；Memos 的容器内端口固定为 `5230`。 |
| `MEMOS_DRIVER` | `sqlite` | `sqlite`、`postgres` 或 `mysql`。 |
| `MEMOS_DSN` | 空 | PostgreSQL 或 MySQL 的外部数据库连接字符串。 |
| `MEMOS_INSTANCE_URL` | 空 | 实例规范公网 URL；公开备忘录、Explore 和 RSS 功能需要设置。 |
| `TZ` | `UTC` | 容器时区。 |
| `MEMOS_CPU_LIMIT` / `MEMOS_MEMORY_LIMIT` | `1.0` / `512M` | 资源限制。 |
| `MEMOS_CPU_RESERVATION` / `MEMOS_MEMORY_RESERVATION` | `0.1` / `128M` | 资源预留。 |

`MEMOS_ADDR`、`MEMOS_PORT` 和 `MEMOS_DATA` 是固定的容器内部配置：`0.0.0.0`、`5230` 和 `/var/opt/memos`，不能通过 `.env` 配置。已移除的旧版 `MEMOS_MODE` 变量会被忽略。

当 `MEMOS_INSTANCE_URL` 为空时，私有模式下即使是 PUBLIC 备忘录也需要登录，且无法使用 Explore 和 RSS。设置规范公网 URL 后，仅当备忘录可见性允许时才可匿名访问，不会将所有备忘录公开。

## 存储与更新

命名卷 `memos_data` 将 SQLite 数据和本地资源保存于 `/var/opt/memos`。使用外部数据库时仍需要此卷保存本地资源。升级前备份命名卷和数据库；真实数据环境不要使用 `docker compose down -v`。

Memos 会自动执行数据库迁移。升级前请先备份；不支持降级。升级到 `0.30.0` 前，请查看 [升级指南](https://usememos.com/docs/operations/upgrade) 和 [v0.30.0 更新说明](https://github.com/usememos/memos/releases/tag/v0.30.0)：`0.28` 的 SSO 用户可能需要先使用密码登录并重新关联 SSO，保存的筛选器表达式从 `now()` 改为 `now`，时间戳 CEL 行为发生变化，旧版共享备忘录 API 和 MCP 客户端可能需要更新。

更新时修改 `MEMOS_VERSION`，备份数据，然后运行：

```bash
docker compose pull
docker compose up -d
```

## 安全

官方入口点会短暂使用初始化所有权所需的权限，然后降权到 UID/GID `10001`。Compose 配置仅保留启动所需的能力，使用只读容器文件系统和 `/tmp` 临时文件系统，并默认绑定到本地主机。

## 链接

- [Memos 官方网站](https://usememos.com/)
- [Memos 官方文档](https://usememos.com/docs)
- [Memos GitHub 仓库](https://github.com/usememos/memos)
- [MIT License](https://github.com/usememos/memos/blob/main/LICENSE)
