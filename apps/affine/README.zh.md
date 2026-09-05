# AFFiNE

[English](README.md) | [中文文档](README.zh.md)

AFFiNE 是一个结合文档、白板和数据库的协作知识库。

## 服务

- `affine`：AFFiNE `ghcr.io/toeverything/affine:0.27.4`，访问地址为 `http://localhost:3010`。
- `affine-migration`：运行数据库迁移和启动前初始化，成功退出后应用才会启动（状态码为 `0`）。
- `postgres`：包含 pgvector 的 PostgreSQL，镜像为 `pgvector/pgvector:0.8.1-pg16-bookworm`，仅限 Compose 网络访问。
- `redis`：Redis `redis:7.4.11-alpine3.21`，仅限 Compose 网络访问。

固定版本镜像支持 amd64 和 ARM64。本配置尚未进行运行时测试。

## 快速开始

```bash
cd apps/affine
docker compose up -d
```

默认配置仅供本地评估使用。生产环境请在首次启动前设置 `.env` 中的凭据。如需使用自定义配置进行首次启动：

```bash
cp .env.example .env
# PowerShell：Copy-Item .env.example .env
docker compose up -d
```

打开 <http://localhost:3010>，然后按照引导流程操作。

使用以下命令检查渲染后的配置、迁移状态和日志：

```bash
docker compose config -q
docker compose ps -a
docker compose logs affine-migration
docker compose logs -f affine
```

迁移成功后，`affine-migration` 应显示 `Exited (0)`。

## 配置

主要变量包括 `AFFINE_VERSION`、`AFFINE_PORT_OVERRIDE`、`AFFINE_BIND_HOST`、`AFFINE_SERVER_EXTERNAL_URL`、`AFFINE_POSTGRES_USER`、`AFFINE_POSTGRES_DB` 和 `AFFINE_POSTGRES_PASSWORD`。默认端口为 `3010`，默认仅绑定到 `127.0.0.1`。

PostgreSQL 凭据同时嵌入 `DATABASE_URL`。用户名、数据库名和密码只能使用 URI 非保留字符，包括字母、数字、`-` 和 `_`（推荐使用随机十六进制密码），确保插值后的 `DATABASE_URL` 有效。默认配置仅供本地评估使用；首次创建数据库前请设置强密码。仅修改 `.env` 不会改变 PostgreSQL 中已经保存的凭据。

默认通过 `AFFINE_INDEXER_ENABLED=false` 禁用搜索索引，不包含外部搜索引擎。

## 存储与安全

命名卷用于保存 AFFiNE 存储和配置、PostgreSQL 数据以及 Redis 数据。`docker compose down -v` 会删除这些数据。升级或删除前，请备份命名卷和数据库。

默认绑定地址仅供本机进行初始管理。如需远程访问，请修改 `AFFINE_BIND_HOST` 和 `AFFINE_SERVER_EXTERNAL_URL`，并将 AFFiNE 放在支持 WebSocket 的 HTTPS 反向代理后面。PostgreSQL 和 Redis 不发布主机端口；Redis 的明文本地连接仅适用于此私有 Compose 网络，不应与不受信任的容器共享。

由于镜像使用 `/root` 目录布局，AFFiNE 保留供应商镜像用户和可写根文件系统。PostgreSQL 保留默认用户及初始化所需能力；Redis 使用 `redis` 用户，只读根文件系统并保留可写数据卷。这些加固设置仅依据配置，尚未在运行时验证。

## 参考资料

- [AFFiNE 源码](https://github.com/toeverything/AFFiNE/tree/v0.27.4)
- [自托管 Compose 参考](https://raw.githubusercontent.com/toeverything/AFFiNE/v0.27.4/.docker/selfhost/compose.yml)
- [AFFiNE 文档](https://docs.affine.pro/)
