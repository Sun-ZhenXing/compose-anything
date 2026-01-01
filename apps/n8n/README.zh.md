# n8n

[English](./README.md) | [中文](./README.zh.md)

此服务部署 n8n,一个具有原生 AI 功能的公平代码工作流自动化平台。

## 服务

- `n8n`: n8n 主应用服务器。
- `n8n-db`: n8n 的 PostgreSQL 数据库(可选,默认使用 SQLite)。

## 配置文件

- `default`: 使用 SQLite 运行 n8n(不需要外部数据库)。
- `postgres`: 使用 PostgreSQL 数据库运行 n8n。

要使用 PostgreSQL,请使用以下命令启动:

```bash
docker compose --profile postgres up -d
```

## 环境变量

| 变量名                  | 描述                             | 默认值                   |
| ----------------------- | -------------------------------- | ------------------------ |
| N8N_VERSION             | n8n 镜像版本                     | `1.114.0`                |
| N8N_PORT                | n8n Web 界面的主机端口映射       | `5678`                   |
| N8N_BASIC_AUTH_ACTIVE   | 启用基本认证                     | `true`                   |
| N8N_BASIC_AUTH_USER     | 基本认证用户名(认证启用时必需)   | `""`                     |
| N8N_BASIC_AUTH_PASSWORD | 基本认证密码(认证启用时必需)     | `""`                     |
| N8N_HOST                | 主机地址                         | `0.0.0.0`                |
| N8N_PROTOCOL            | 协议(http 或 https)              | `http`                   |
| WEBHOOK_URL             | 外部访问的 Webhook URL           | `http://localhost:5678/` |
| GENERIC_TIMEZONE        | n8n 时区                         | `UTC`                    |
| TZ                      | 系统时区                         | `UTC`                    |
| DB_TYPE                 | 数据库类型(sqlite 或 postgresdb) | `sqlite`                 |
| DB_POSTGRESDB_DATABASE  | PostgreSQL 数据库名              | `n8n`                    |
| DB_POSTGRESDB_HOST      | PostgreSQL 主机                  | `n8n-db`                 |
| DB_POSTGRESDB_PORT      | PostgreSQL 端口                  | `5432`                   |
| DB_POSTGRESDB_USER      | PostgreSQL 用户名                | `n8n`                    |
| DB_POSTGRESDB_PASSWORD  | PostgreSQL 密码                  | `n8n123`                 |
| POSTGRES_VERSION        | PostgreSQL 镜像版本              | `17.2-alpine3.21`        |
| EXECUTIONS_MODE         | 执行模式(regular 或 queue)       | `regular`                |
| N8N_ENCRYPTION_KEY      | 凭据加密密钥                     | `""`                     |

请创建 `.env` 文件并根据需要进行修改。

## 数据卷

- `n8n_data`: 用于存储 n8n 数据(工作流、凭据等)的卷。
- `n8n_db_data`: 用于存储 PostgreSQL 数据的卷(使用 PostgreSQL 配置文件时)。

## 快速开始

### SQLite(默认)

1. 创建包含认证凭据的 `.env` 文件:

   ```env
   N8N_BASIC_AUTH_USER=admin
   N8N_BASIC_AUTH_PASSWORD=your-secure-password
   ```

2. 启动服务:

   ```bash
   docker compose up -d
   ```

3. 访问 `http://localhost:5678`

### PostgreSQL

1. 创建包含认证和数据库凭据的 `.env` 文件:

   ```env
   N8N_BASIC_AUTH_USER=admin
   N8N_BASIC_AUTH_PASSWORD=your-secure-password
   DB_TYPE=postgresdb
   DB_POSTGRESDB_PASSWORD=your-db-password
   ```

2. 使用 PostgreSQL 配置文件启动服务:

   ```bash
   docker compose --profile postgres up -d
   ```

3. 访问 `http://localhost:5678`

## 功能特性

- **可视化工作流构建器**: 使用直观的拖放界面创建工作流
- **400+ 集成**: 连接到流行的服务和 API
- **原生 AI**: 内置 LangChain 支持用于 AI 工作流
- **按需编码**: 编写 JavaScript/Python 或使用可视化节点
- **自托管**: 完全控制您的数据和部署
- **Webhook 支持**: 通过外部事件触发工作流
- **定时执行**: 按计划运行工作流

## 文档

更多信息请访问 [n8n 官方文档](https://docs.n8n.io/)。

## 社区资源

- [n8n 社区论坛](https://community.n8n.io/)
- [工作流模板](https://n8n.io/workflows)
- [集成列表](https://n8n.io/integrations)

## 安全提示

- 在生产环境中始终设置 `N8N_BASIC_AUTH_USER` 和 `N8N_BASIC_AUTH_PASSWORD`
- 在生产环境中使用 HTTPS(设置 `N8N_PROTOCOL=https`)
- 考虑设置 `N8N_ENCRYPTION_KEY` 用于凭据加密
- 定期备份 n8n 数据卷
- 保持 n8n 更新到最新稳定版本
