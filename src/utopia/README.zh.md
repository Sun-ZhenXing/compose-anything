# Utopia

[English](./README.md) | [中文](./README.zh.md)

Utopia 是企业级 World Model / 知识工程底座（双时态知识图谱 ＋ 混合检索 ＋ Agent RAG），采用 Apache-2.0 协议。本配置同时启动 Utopia 服务端与 pgvector PostgreSQL 数据库。

> 版本警告：上游目前仅发布 `0.1.0-rc5`（2026-09-05，pre-release，无 stable 版本）。Schema 迁移只支持前向升级、不支持回滚，升级前务必备份数据库与数据卷。请不要使用 `latest`。

## 服务组成

- `app`：Utopia 服务端（含内置 Web 界面，端口 1516）
- `db`：PostgreSQL 16 ＋ pgvector 扩展（容器内 5432，宿主默认 1517）

## 快速开始

```bash
cp .env.example .env
docker compose up -d
```

然后打开 <http://localhost:1516>，注册首个用户，该用户即系统管理员。登录后进入 Administration → Models，配置 chat 与 embedding 模型（LLM / embedding 全部走外部 OpenAI 兼容 endpoint，无需本地模型与 GPU）。

## 环境变量

| 变量名                         | 说明                                            | 默认值                               |
| ------------------------------ | ----------------------------------------------- | ------------------------------------ |
| `TZ`                           | 时区                                            | `UTC`                                |
| `UTOPIA_VERSION`               | Utopia 应用镜像版本                             | `0.1.0-rc5`                          |
| `UTOPIA_DB_VERSION`            | 数据库镜像版本                                  | `pg16`                               |
| `UTOPIA_IMAGE`                 | 应用完整镜像地址                                | `ghcr.io/deeplethe/utopia:0.1.0-rc5` |
| `UTOPIA_DB_IMAGE`              | 数据库完整镜像地址                              | `pgvector/pgvector:pg16`             |
| `UTOPIA_PORT_OVERRIDE`         | 宿主端口映射（对应容器内应用端口 1516）         | `1516`                               |
| `UTOPIA_DB_PORT_OVERRIDE`      | 宿主端口映射（对应容器内 PostgreSQL 端口 5432） | `1517`                               |
| `UTOPIA_DB_PASSWORD`           | `utopia` 数据库用户口令（仅首次初始化生效）     | `utopia`                             |
| `UTOPIA_JWT_SECRET`            | JWT 签名密钥（留空则首次启动自动生成并入库）    | `""`                                 |
| `UTOPIA_SECRET_KEY`            | 应用密钥（留空则生成 `secret.key` 存于数据卷）  | `""`                                 |
| `UTOPIA_OPEN_REGISTRATION`     | 是否允许开放注册                                | `true`                               |
| `UTOPIA_DB_MAX_CONNECTIONS`    | 应用数据库连接池最大连接数                      | `32`                                 |
| `UTOPIA_CPU_LIMIT`             | 应用 CPU 上限                                   | `2`                                  |
| `UTOPIA_CPU_RESERVATION`       | 应用 CPU 预留                                   | `0.1`                                |
| `UTOPIA_MEMORY_LIMIT`          | 应用内存上限                                    | `2G`                                 |
| `UTOPIA_MEMORY_RESERVATION`    | 应用内存预留                                    | `256M`                               |
| `UTOPIA_DB_CPU_LIMIT`          | 数据库 CPU 上限                                 | `2`                                  |
| `UTOPIA_DB_CPU_RESERVATION`    | 数据库 CPU 预留                                 | `0.1`                                |
| `UTOPIA_DB_MEMORY_LIMIT`       | 数据库内存上限                                  | `2G`                                 |
| `UTOPIA_DB_MEMORY_RESERVATION` | 数据库内存预留                                  | `512M`                               |

默认配置开箱即用，本地体验可全部保持默认；共享或生产使用时建议至少修改 `UTOPIA_DB_PASSWORD`。

## 数据卷

- `utopia_data`：应用数据（`/app/data`），包括上传文件、Tantivy 检索索引与 `secret.key`。丢失后数据库中的引用会全部失效，务必与数据库一起备份。
- `utopia_db_data`：PostgreSQL 数据（`/var/lib/postgresql/data`）。

备份数据库：

```bash
docker compose exec db pg_dump -U utopia utopia > utopia-backup.sql
```

备份数据卷（示例）：

```bash
docker run --rm -v utopia_utopia_data:/data -v "%cd%:/backup" alpine tar czf /backup/utopia-data.tgz -C /data .
docker run --rm -v utopia_utopia_db_data:/data -v "%cd%:/backup" alpine tar czf /backup/utopia-db-data.tgz -C /data .
```

若项目目录前缀不同，请用 `docker volume ls` 确认实际卷名。

## 健康检查

- `db`：`pg_isready -U utopia -d utopia`。
- `app`：1516 端口 TCP 探测（slim 镜像不保证内置 curl / wget）。应用层健康端点为 `GET /api/v1/health`，返回 `{"status":"ok",...}`。

## 安全说明

- 无默认账号，首个注册用户即系统管理员；完成初始化后建议设置 `UTOPIA_OPEN_REGISTRATION=false`，关闭自主注册。
- `UTOPIA_JWT_SECRET`（存于数据库）与 `UTOPIA_SECRET_KEY`（数据卷中的 `secret.key`）留空时会在首次启动自动生成，生产使用建议显式设置并妥善备份。
- `UTOPIA_DB_PASSWORD` 仅在数据卷首次初始化时生效，之后改口令需同步修改数据库角色，或 `docker compose down -v` 重建数据卷（会删除全部数据）。
- `cap_drop: ["ALL"]` 仅应用于 `app`。`db` 未添加，因为 PostgreSQL 启动依赖 setuid / setgid 与文件属主相关能力，全量丢弃后容易无法启动。
- 无需 GPU，所有 LLM / embedding 调用都走外部 OpenAI 兼容 endpoint。
- 当前为 pre-release（`0.1.0-rc5`），可能存在破坏性变更，升级前务必备份（迁移不支持回滚）。

## 开源协议

Utopia 采用 [Apache-2.0 协议](https://github.com/deeplethe/utopia)。
