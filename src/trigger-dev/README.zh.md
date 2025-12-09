# Trigger.dev

[English](./README.md) | [中文](./README.zh.md)

Trigger.dev 是一个开源平台，用于在 TypeScript 中构建 AI 工作流和后台任务。它提供长时间运行的任务、重试机制、队列、可观测性和弹性扩展功能。

## 服务组件

### 核心服务（Webapp 栈）

| 服务                    | 描述                                      |
| ----------------------- | ----------------------------------------- |
| `webapp`                | 主 Trigger.dev 应用程序，包含仪表板和 API |
| `trigger-postgres`      | 带有逻辑复制的 PostgreSQL 数据库          |
| `trigger-redis`         | 用于缓存和任务队列的 Redis                |
| `trigger-clickhouse`    | 用于分析的 ClickHouse 数据库              |
| `trigger-minio`         | S3 兼容的对象存储                         |
| `trigger-minio-init`    | MinIO 存储桶初始化                        |
| `electric`              | 用于实时同步的 ElectricSQL                |
| `trigger-registry`      | 用于部署代码的私有 Docker 镜像仓库        |
| `trigger-registry-init` | 镜像仓库 htpasswd 初始化                  |

### Worker 服务（Supervisor 栈）

| 服务                  | 描述                                        |
| --------------------- | ------------------------------------------- |
| `supervisor`          | 执行任务的 Worker 编排器                    |
| `docker-socket-proxy` | 为 supervisor 提供安全的 Docker socket 代理 |

## 前置要求

- Docker 20.10.0+
- Docker Compose 2.20.0+
- 完整栈至少需要 6 vCPU 和 12 GB RAM

## 快速开始

1. 创建包含必要密钥的 `.env` 文件：

   ```bash
   cp .env.example .env
   ```

2. 生成必要的密钥：

   ```bash
   # 生成密钥
   echo "SESSION_SECRET=$(openssl rand -hex 16)" >> .env
   echo "MAGIC_LINK_SECRET=$(openssl rand -hex 16)" >> .env
   echo "ENCRYPTION_KEY=$(openssl rand -hex 16)" >> .env
   echo "POSTGRES_PASSWORD=$(openssl rand -hex 16)" >> .env
   ```

3. 启动所有服务：

   ```bash
   docker compose up -d
   ```

4. 等待服务健康运行：

   ```bash
   docker compose ps
   ```

5. 访问 `http://localhost:8030` 打开 webapp

6. 从 webapp 日志中获取首次登录的 magic link：

   ```bash
   docker compose logs -f webapp
   ```

## 环境变量

### 必需的密钥

| 变量                | 描述                                                |
| ------------------- | --------------------------------------------------- |
| `SESSION_SECRET`    | 会话加密密钥（运行：`openssl rand -hex 16`）        |
| `MAGIC_LINK_SECRET` | Magic link 加密密钥（运行：`openssl rand -hex 16`） |
| `ENCRYPTION_KEY`    | 密钥存储加密密钥（运行：`openssl rand -hex 16`）    |
| `POSTGRES_PASSWORD` | PostgreSQL 密码                                     |

### 域名配置

| 变量           | 默认值                  | 描述                               |
| -------------- | ----------------------- | ---------------------------------- |
| `APP_ORIGIN`   | `http://localhost:8030` | 公开的 webapp URL                  |
| `LOGIN_ORIGIN` | `http://localhost:8030` | 登录 URL（通常与 APP_ORIGIN 相同） |
| `API_ORIGIN`   | `http://localhost:8030` | API URL                            |

### 镜像版本

| 变量                 | 默认值                         | 描述                                  |
| -------------------- | ------------------------------ | ------------------------------------- |
| `TRIGGER_IMAGE_TAG`  | `v4.2.0`                       | Trigger.dev webapp 和 supervisor 版本 |
| `POSTGRES_VERSION`   | `17.2-alpine3.21`              | PostgreSQL 版本                       |
| `REDIS_VERSION`      | `7.4.3-alpine3.21`             | Redis 版本                            |
| `CLICKHOUSE_VERSION` | `25.3`                         | ClickHouse 版本                       |
| `MINIO_VERSION`      | `RELEASE.2025-04-22T22-12-26Z` | MinIO 版本                            |

### 端口配置

| 变量                 | 默认值 | 描述                |
| -------------------- | ------ | ------------------- |
| `TRIGGER_PORT`       | `8030` | Webapp 端口         |
| `MINIO_API_PORT`     | `9000` | MinIO API 端口      |
| `MINIO_CONSOLE_PORT` | `9001` | MinIO 控制台端口    |
| `REGISTRY_PORT`      | `5000` | Docker 镜像仓库端口 |

### 身份认证

| 变量                        | 描述                                                |
| --------------------------- | --------------------------------------------------- |
| `WHITELISTED_EMAILS`        | 限制登录的正则表达式（例如：`^user@example\.com$`） |
| `AUTH_GITHUB_CLIENT_ID`     | GitHub OAuth 客户端 ID                              |
| `AUTH_GITHUB_CLIENT_SECRET` | GitHub OAuth 客户端密钥                             |

### 邮件配置

| 变量              | 默认值 | 描述                                    |
| ----------------- | ------ | --------------------------------------- |
| `EMAIL_TRANSPORT` | —      | 传输类型：`resend`、`smtp` 或 `aws-ses` |
| `FROM_EMAIL`      | —      | 发件人邮箱地址                          |
| `RESEND_API_KEY`  | —      | Resend API 密钥（如果使用 Resend）      |
| `SMTP_HOST`       | —      | SMTP 服务器主机                         |
| `SMTP_PORT`       | `587`  | SMTP 服务器端口                         |

## 数据卷

| 卷                        | 描述                   |
| ------------------------- | ---------------------- |
| `trigger_shared`          | Worker token 共享卷    |
| `trigger_postgres_data`   | PostgreSQL 数据        |
| `trigger_redis_data`      | Redis 数据             |
| `trigger_clickhouse_data` | ClickHouse 数据        |
| `trigger_clickhouse_logs` | ClickHouse 日志        |
| `trigger_minio_data`      | MinIO 对象存储         |
| `trigger_registry_data`   | Docker 镜像仓库数据    |
| `trigger_registry_auth`   | 镜像仓库 htpasswd 认证 |

## Worker Token

首次启动时，webapp 会生成 worker token 并保存到共享卷中。如果需要在单独的机器上运行 worker：

1. 从 webapp 日志中获取 token：

   ```bash
   docker compose logs webapp | grep -A15 "Worker Token"
   ```

2. 在远程 worker 的 `.env` 中设置 token：

   ```bash
   TRIGGER_WORKER_TOKEN=tr_wgt_xxxxx
   ```

## 镜像仓库设置

内置镜像仓库使用 htpasswd 认证。htpasswd 文件在首次启动时会根据环境变量中的凭据**自动生成**。

默认凭据：

- 用户名：`registry-user`（通过 `REGISTRY_USER` 设置）
- 密码：`very-secure-indeed`（通过 `REGISTRY_PASSWORD` 设置）

要使用自定义凭据，请在首次运行前在 `.env` 文件中设置：

```bash
REGISTRY_USER=my-user
REGISTRY_PASSWORD=my-secure-password
```

部署任务前，登录到镜像仓库：

```bash
docker login -u registry-user localhost:5000
```

## CLI 使用

使用自托管的 Trigger.dev 初始化项目：

```bash
npx trigger.dev@latest login -a http://localhost:8030
npx trigger.dev@latest init -p <project-ref> -a http://localhost:8030
```

部署任务：

```bash
npx trigger.dev@latest deploy --self-hosted
```

## GitHub OAuth 设置

1. 在 `https://github.com/settings/developers` 创建 GitHub OAuth 应用
2. 设置回调 URL：`http://localhost:8030/auth/github/callback`
3. 配置环境变量：

   ```env
   AUTH_GITHUB_CLIENT_ID=your_client_id
   AUTH_GITHUB_CLIENT_SECRET=your_client_secret
   ```

## 生产环境注意事项

- 为所有密钥使用强且唯一的密码
- 使用反向代理设置正确的 TLS/SSL
- 配置邮件传输以发送 magic link
- 使用外部托管数据库以实现高可用性
- 根据工作负载设置适当的资源限制
- 启用 `WHITELISTED_EMAILS` 限制访问
- 考虑禁用遥测：`TRIGGER_TELEMETRY_DISABLED=1`

## 扩展 Worker

添加更多 worker 容量：

1. 在不同机器上设置额外的 supervisor 实例
2. 为每个实例配置相同的 `TRIGGER_WORKER_TOKEN`
3. 为每个实例使用唯一的 `TRIGGER_WORKER_INSTANCE_NAME`

## 故障排除

### Magic link 未收到

- 检查 webapp 日志：`docker compose logs -f webapp`
- 如果未配置邮件传输，magic link 会记录在日志中
- 生产环境请设置邮件传输

### 部署在 push 步骤失败

- 确保已登录镜像仓库：`docker login localhost:5000`
- 检查镜像仓库健康状态：`docker compose ps trigger-registry`

### 服务无法启动

- 确保 `.env` 中设置了所有必需的密钥
- 检查日志：`docker compose logs -f`

## 参考链接

- [Trigger.dev 文档](https://trigger.dev/docs)
- [自托管指南](https://trigger.dev/docs/self-hosting/docker)
- [GitHub 仓库](https://github.com/triggerdotdev/trigger.dev)
