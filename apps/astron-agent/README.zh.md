# astron-agent

[English](./README.md) | [中文](./README.zh.md)

本服务部署 [astron-agent](https://github.com/iflytek/astron-agent)，即科大讯飞开源的智能体工作流平台，可用于构建、发布和运行 AI 智能体与工作流。该技术栈内置 PostgreSQL、MySQL、Redis 和 MinIO 作为私有中间件，并将全部核心微服务置于 nginx 入口之后。内部凭据会在首次启动时自动生成，无需手工配置密钥。

## 服务列表

- **nginx**：反向代理，Web UI 统一入口。
- **console-frontend / console-hub**：控制台前端与后端 API。
- **core-tenant、core-database、core-rpa、core-link、core-aitools、core-agent、core-knowledge、core-workflow**：astron-agent 微服务。
- **postgres、mysql、redis、minio**：核心服务使用的私有中间件。
- **internal-credentials-init / minio-credentials-check**：一次性初始化与校验任务。
- **casdoor + casdoor-mysql**：可选登录组件，位于 `auth` profile 之后。

## 快速开始

1. 复制环境变量模板：

   ```bash
   cp .env.example .env
   ```

2. 启动整个技术栈：

   ```bash
   docker compose up -d
   ```

3. 打开 `http://localhost`（首次启动需要拉取约 10 个镜像，耗时数分钟）。

## 可选的 Casdoor 登录（auth profile）

默认情况下 console-hub 不启用登录提供方。如需启用内置的 Casdoor 单点登录：

```bash
docker compose --profile auth up -d
```

然后在 `.env` 中设置以下变量，使 console-hub 使用 Casdoor 校验 JWT：

```ini
OAUTH2_ISSUER_URI=http://localhost:8000
```

- Casdoor 管理界面：`http://localhost:8000`，默认账号 `admin`、密码 `123`——请立即修改密码。
- Casdoor 的回调地址由 `CONSOLE_DOMAIN` 在容器启动时生成（`${CONSOLE_DOMAIN}/callback`）。如果控制台不通过 `http://localhost` 访问，请在首次启动 Casdoor 前修改 `.env` 中的 `CONSOLE_DOMAIN` / `HOST_BASE_ADDRESS`。

## 核心环境变量

| 变量                            | 说明                                                     | 默认值                         |
| ------------------------------- | -------------------------------------------------------- | ------------------------------ |
| `ASTRON_AGENT_VERSION`          | astron-agent 镜像版本                                    | `1.1.2`                        |
| `ASTRON_PORT_OVERRIDE`          | Web UI（nginx）宿主机端口                                | `80`                           |
| `TZ`                            | 中间件容器时区                                           | `UTC`                          |
| `MINIO_PORT_OVERRIDE`           | MinIO API 宿主机端口（仅绑定本地回环）                   | `18998`                        |
| `MINIO_CONSOLE_PORT_OVERRIDE`   | MinIO 控制台宿主机端口（仅绑定本地回环）                 | `18999`                        |
| `CASDOOR_PORT_OVERRIDE`         | Casdoor 管理界面宿主机端口（仅 auth profile）            | `8000`                         |
| `POSTGRES_USER` / `POSTGRES_PASSWORD` | 内置 PostgreSQL 凭据                               | `spark` / `spark123`           |
| `MYSQL_ROOT_PASSWORD`           | 内置 MySQL root 密码                                     | `root123`                      |
| `REDIS_PASSWORD`                | 内置 Redis 密码                                          | `123`                          |
| `MINIO_ROOT_USER` / `MINIO_ROOT_PASSWORD` | 内置 MinIO 凭据                                | `minioadmin` / `minioadmin123` |
| `WORKFLOW_INTERNAL_API_KEY`     | 可选覆盖项；留空则自动生成                               | （空）                         |
| `TENANT_KEY` / `TENANT_SECRET`  | 可选覆盖项；留空则自动生成                               | （空）                         |
| `CONSOLE_DOMAIN`                | 控制台地址；决定 Casdoor 回调 URI                        | `http://localhost:80`          |
| `RPA_URL`                       | 外部 RPA 服务地址（本栈不包含 RPA 运行时）               | `https://newapi.iflyrpa.com`   |

完整变量列表（含可观测性 OTLP/Langfuse、Skill Sandbox 令牌及资源限制）见 `.env.example`。

## 存储卷

- `postgres_data`、`mysql_data`、`redis_data`、`minio_data`：中间件数据。
- `nginx_logs`：nginx 访问与错误日志。
- `workflow_internal_secrets`、`tenant_bootstrap_secrets`、`artifact_upload_secrets`、`sandbox_runtime_credential_secrets`：自动生成的内部凭据，以只读方式共享给消费方。
- `casdoor-logs`、`casdoor-mysql-data`：仅 auth profile 使用。

## 端口

- **80**：通过 nginx 访问的 Web UI（可用 `ASTRON_PORT_OVERRIDE` 覆盖）。
- **18998 / 18999**：MinIO API 与控制台，仅绑定 `127.0.0.1`。
- **8000**：Casdoor 管理界面（仅 auth profile）。

服务间流量全部走私有的 `astron-agent-network`，不发布其他端口。

## 资源需求

| 服务分组                            | CPU 上限 | 内存上限  |
| ----------------------------------- | -------- | --------- |
| 每个 core-* 业务服务（共 8 个）      | 2.0      | 2-4 GB    |
| console-hub                         | 2.0      | 2 GB      |
| mysql（含 casdoor-mysql）           | 1.5      | 2 GB      |
| postgres / minio / casdoor          | 1.0      | 1 GB      |
| nginx / console-frontend / redis    | 0.5-1.0  | 512 MB    |

该技术栈约运行 17 个容器，建议预留 **8 GB 以上内存**和数 GB 磁盘空间。所有资源限制均可通过 `.env` 中的 `*_CPU_LIMIT` / `*_MEMORY_LIMIT` 变量调整。

## 注意事项

- 内部凭据（`TENANT_KEY`、`TENANT_SECRET`、`WORKFLOW_INTERNAL_API_KEY`、Skill Sandbox 令牌）在首次启动时生成一次并持久化到命名卷中，除非确有需要，否则保持留空即可。
- 本栈不包含 RPA 执行组件；请将 `RPA_URL` 指向自建部署或公有云服务，详见 [astron-rpa](https://github.com/iflytek/astron-rpa)。
- MinIO 维护端口刻意只绑定 `127.0.0.1`。若需将控制台暴露到 localhost 之外，请置于带认证的反向代理与 TLS 之后，并同步调整 `CONSOLE_DOMAIN` / `OSS_REMOTE_ENDPOINT`。
- 各服务会把日志写入 `./config/<service>/logs/` 下的宿主机目录；Docker 会在首次启动时自动创建这些目录。
- 首次启动需拉取约 10 个镜像，所有服务变为健康状态可能需要数分钟。

## 文档

- [astron-agent GitHub](https://github.com/iflytek/astron-agent)
- [部署指南（含登录）](https://github.com/iflytek/astron-agent/blob/main/docs/DEPLOYMENT_GUIDE_WITH_AUTH.md)
- [配置参考](https://github.com/iflytek/astron-agent/blob/main/docs/CONFIGURATION.md)
