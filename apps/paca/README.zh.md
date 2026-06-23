# Paca

自托管的项目管理平台，专为人类与 AI 作为 Scrum 团队成员协作而设计。

## 服务

- `paca-postgres`：PostgreSQL 16 数据库，用于持久化存储。
- `paca-valkey`：Valkey 8 缓存与发布/订阅事件总线。
- `paca-minio`：兼容 S3 的 MinIO 对象存储，用于文件上传。
- `paca-api`：Go 语言 REST API 后端（内部端口 8080）。
- `paca-web`：React SPA 前端，通过内部 nginx 提供服务（内部端口 3000）。
- `paca-realtime`：Node.js Socket.IO 实时事件中心（内部端口 3001）。
- `paca-gateway`：Nginx 反向代理，将所有流量路由到正确的服务。

## 快速开始

1. 从示例文件创建 `.env` 并设置密钥：

```bash
cp .env.example .env
# 编辑 .env 文件，设置 PACA_JWT_SECRET、PACA_ENCRYPTION_KEY、PACA_ADMIN_PASSWORD 等
```

1. 启动服务栈：

```bash
docker compose up -d
```

1. 在浏览器中打开 `http://localhost`，使用配置的管理员凭据登录。

## 主要环境变量

| 变量                             | 说明                         | 默认值             |
| -------------------------------- | ---------------------------- | ------------------ |
| `PACA_PORT_OVERRIDE`             | 网关主机端口                 | `80`               |
| `PACA_VERSION`                   | 应用镜像标签                 | `latest`           |
| `PACA_POSTGRES_PASSWORD`         | PostgreSQL 密码              | `changeme`         |
| `PACA_ADMIN_USERNAME`            | 初始管理员用户名             | `admin`            |
| `PACA_ADMIN_PASSWORD`            | 初始管理员密码               | `changeme`         |
| `PACA_JWT_SECRET`                | JWT 签名密钥（至少 32 字符） | （占位符）         |
| `PACA_ENCRYPTION_KEY`            | 插件密钥 AES-256 加密密钥    | （空）             |
| `PACA_PUBLIC_URL`                | 公开访问的基础 URL           | `http://localhost` |
| `PACA_STORAGE_PROVIDER`          | 对象存储提供商               | `minio`            |
| `PACA_STORAGE_ACCESS_KEY_ID`     | 存储访问密钥 ID              | `minioadmin`       |
| `PACA_STORAGE_SECRET_ACCESS_KEY` | 存储访问密钥                 | `minioadmin`       |

## 存储

| 卷                      | 用途                    |
| ----------------------- | ----------------------- |
| `paca_postgres_data`    | PostgreSQL 数据库文件   |
| `paca_valkey_data`      | Valkey 追加日志文件     |
| `paca_minio_data`       | MinIO 对象存储数据      |
| `paca_backend_plugins`  | WASM 后端插件二进制文件 |
| `paca_frontend_plugins` | 前端插件静态资源        |
| `paca_mcp_plugins`      | MCP 插件包              |

## 使用外部服务

- **外部 PostgreSQL**：设置 `PACA_DATABASE_URL`，启动时添加 `--scale paca-postgres=0`。
- **AWS S3 替代 MinIO**：设置 `PACA_STORAGE_PROVIDER=s3`，启动时添加 `--scale paca-minio=0`。
- **外部 Valkey / Redis**：设置 `PACA_REDIS_URL`，启动时添加 `--scale paca-valkey=0`。

## 安全说明

- 使用 `openssl rand -hex 32` 生成强密钥。
- 在生产环境使用前务必修改所有默认密码。
- 通过 HTTPS 提供服务时，设置 `PACA_COOKIE_SECURE=true`。
- 网关默认绑定 80 端口；生产环境建议在前方使用带 TLS 的反向代理。
- 本服务栈中多个服务以 root 运行（nginx、postgres）；生产环境建议进一步加固。

## 扩缩容

可以按需禁用可选服务：

```bash
# 不使用 MinIO（改用 S3）
docker compose up -d --scale paca-minio=0

# 不使用 Web 前端（从 CDN 提供 SPA）
docker compose up -d --scale paca-web=0
```
