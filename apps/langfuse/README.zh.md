# Langfuse

[English](./README.md) | [中文](./README.zh.md)

此服务部署 Langfuse，一个用于 LLM 应用可观测性、指标、评估和提示管理的开源平台。

## 服务

- **langfuse-worker**：处理 LLM 操作的后台工作者服务
- **langfuse-web**：Langfuse 主 Web 应用服务器
- **postgres**：PostgreSQL 数据库
- **clickhouse**：用于事件存储的 ClickHouse 分析数据库
- **minio**：兼容 S3 的对象存储，用于媒体和导出
- **redis**：用于缓存和作业队列的内存数据存储

## 快速开始

1. 将 `.env.example` 复制为 `.env`：

   ```bash
   cp .env.example .env
   ```

2. 在 `.env` 中更新关键的密钥：

   ```bash
   # 生成安全的密钥
   NEXTAUTH_SECRET=$(openssl rand -base64 32)
   ENCRYPTION_KEY=$(openssl rand -hex 32)
   POSTGRES_PASSWORD=your-secure-password
   CLICKHOUSE_PASSWORD=your-secure-password
   MINIO_ROOT_PASSWORD=your-secure-password
   REDIS_AUTH=your-secure-redis-password
   ```

3. 启动服务：

   ```bash
   docker compose up -d
   ```

4. 访问 `http://localhost:3000` 打开 Langfuse

## 核心环境变量

| 变量                                    | 描述                                  | 默认值                  |
| --------------------------------------- | ------------------------------------- | ----------------------- |
| `LANGFUSE_VERSION`                      | Langfuse 容器镜像版本                 | `3`                     |
| `LANGFUSE_PORT`                         | Web 界面端口                          | `3000`                  |
| `NEXTAUTH_URL`                          | Langfuse 实例的公开 URL               | `http://localhost:3000` |
| `NEXTAUTH_SECRET`                       | NextAuth.js 密钥（生产环境必需）      | `mysecret`              |
| `ENCRYPTION_KEY`                        | 敏感数据加密密钥（64 个十六进制字符） | `0...0`                 |
| `SALT`                                  | 密码哈希盐值                          | `mysalt`                |
| `TELEMETRY_ENABLED`                     | 启用匿名遥测                          | `true`                  |
| `LANGFUSE_ENABLE_EXPERIMENTAL_FEATURES` | 启用测试版功能                        | `true`                  |

## 数据库配置

| 变量                  | 描述            | 默认值       |
| --------------------- | --------------- | ------------ |
| `POSTGRES_VERSION`    | PostgreSQL 版本 | `17`         |
| `POSTGRES_USER`       | 数据库用户      | `postgres`   |
| `POSTGRES_PASSWORD`   | 数据库密码      | `postgres`   |
| `POSTGRES_DB`         | 数据库名称      | `postgres`   |
| `CLICKHOUSE_USER`     | ClickHouse 用户 | `clickhouse` |
| `CLICKHOUSE_PASSWORD` | ClickHouse 密码 | `clickhouse` |

## 存储和缓存配置

| 变量                  | 描述               | 默认值          |
| --------------------- | ------------------ | --------------- |
| `MINIO_ROOT_USER`     | MinIO 管理员用户名 | `minio`         |
| `MINIO_ROOT_PASSWORD` | MinIO 管理员密码   | `miniosecret`   |
| `REDIS_AUTH`          | Redis 密码         | `myredissecret` |

## S3/媒体配置

| 变量                                | 描述              | 默认值                  |
| ----------------------------------- | ----------------- | ----------------------- |
| `LANGFUSE_S3_MEDIA_UPLOAD_ENDPOINT` | 媒体上传 S3 端点  | `http://localhost:9090` |
| `LANGFUSE_S3_EVENT_UPLOAD_ENDPOINT` | 事件上传 S3 端点  | `http://minio:9000`     |
| `LANGFUSE_S3_BATCH_EXPORT_ENABLED`  | 启用批量导出到 S3 | `false`                 |

## 数据卷

- `langfuse_postgres_data`：PostgreSQL 数据持久化
- `langfuse_clickhouse_data`：ClickHouse 事件数据
- `langfuse_clickhouse_logs`：ClickHouse 日志
- `langfuse_minio_data`：MinIO 对象存储数据

## 资源限制

所有服务都有可配置的 CPU 和内存限制：

- **langfuse-worker**：2 个 CPU 核心，2GB RAM
- **langfuse-web**：2 个 CPU 核心，2GB RAM
- **clickhouse**：2 个 CPU 核心，4GB RAM
- **minio**：1 个 CPU 核心，1GB RAM
- **redis**：1 个 CPU 核心，512MB RAM
- **postgres**：2 个 CPU 核心，2GB RAM

通过修改 `.env` 中的 `*_CPU_LIMIT`、`*_MEMORY_LIMIT`、`*_CPU_RESERVATION` 和 `*_MEMORY_RESERVATION` 变量来调整限制。

## 网络访问

- **langfuse-web**（端口 3000）：对所有接口开放，用于外部访问
- **minio**（端口 9090）：对所有接口开放，用于媒体上传
- **所有其他服务**：绑定到 `127.0.0.1`（仅限本地）

在生产环境中，使用防火墙或反向代理限制外部访问。

## 生产部署

用于生产部署的建议：

1. **安全性**：
   - 使用 `openssl rand -base64 32` 和 `openssl rand -hex 32` 生成强密钥
   - 使用具有 SSL/TLS 的反向代理（nginx、Caddy）
   - 更改所有默认密码
   - 通过将 `NEXTAUTH_URL` 设置为您的域来启用 HTTPS

2. **数据持久化**：
   - 对数据使用外部卷或云存储
   - 配置定期 PostgreSQL 备份
   - 监控 ClickHouse 磁盘使用情况

3. **性能**：
   - 根据工作负载增加资源限制
   - 大规模部署时考虑使用专用 ClickHouse 集群
   - 如需要，配置 Redis 持久化

## 端口

- **3000**：Langfuse Web 界面（外部）
- **3030**：Langfuse 工作者 API（仅限本地）
- **5432**：PostgreSQL（仅限本地）
- **8123**：ClickHouse HTTP（仅限本地）
- **9000**：ClickHouse 原生协议（仅限本地）
- **9090**：MinIO S3 API（外部）
- **9091**：MinIO 控制台（仅限本地）
- **6379**：Redis（仅限本地）

## 健康检查

所有服务都包括健康检查，失败时会自动重新启动。

## 文档

- [Langfuse 文档](https://langfuse.com/docs)
- [Langfuse GitHub](https://github.com/langfuse/langfuse)

## 故障排除

### 服务无法启动

- 查看日志：`docker compose logs <service-name>`
- 确保设置了所有必需的环境变量
- 验证磁盘空间和系统资源是否充足

### 数据库连接错误

- 验证 `POSTGRES_PASSWORD` 在服务之间匹配
- 检查 PostgreSQL 服务是否健康：`docker compose ps`
- 确保端口未被占用

### MinIO 权限问题

- 清除 MinIO 数据并重新启动：`docker compose down -v`
- 在 `.env` 中重新生成 MinIO 凭证
