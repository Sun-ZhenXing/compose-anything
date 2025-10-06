# Langfuse

[English](./README.md) | [中文](./README.zh.md)

此服务部署 Langfuse,一个用于 LLM 应用可观测性、指标、评估和提示管理的开源平台。

## 服务

- `langfuse-server`: Langfuse 主应用服务器。
- `langfuse-db`: Langfuse 的 PostgreSQL 数据库。

## 环境变量

| 变量名                                | 描述                            | 默认值                  |
| ------------------------------------- | ------------------------------- | ----------------------- |
| LANGFUSE_VERSION                      | Langfuse 镜像版本               | `3.115.0`               |
| LANGFUSE_PORT                         | Langfuse Web 界面的主机端口映射 | `3000`                  |
| POSTGRES_VERSION                      | PostgreSQL 镜像版本             | `17.2-alpine3.21`       |
| POSTGRES_USER                         | PostgreSQL 用户名               | `postgres`              |
| POSTGRES_PASSWORD                     | PostgreSQL 密码                 | `postgres`              |
| POSTGRES_DB                           | PostgreSQL 数据库名             | `langfuse`              |
| NEXTAUTH_URL                          | Langfuse 实例的公开 URL         | `http://localhost:3000` |
| NEXTAUTH_SECRET                       | NextAuth.js 密钥(必需,需要生成) | `""`                    |
| SALT                                  | 加密盐值(必需,需要生成)         | `""`                    |
| TELEMETRY_ENABLED                     | 启用遥测                        | `true`                  |
| LANGFUSE_ENABLE_EXPERIMENTAL_FEATURES | 启用实验性功能                  | `false`                 |

**重要提示**: 在生产环境中必须设置 `NEXTAUTH_SECRET` 和 `SALT`。使用以下命令生成:

```bash
# 生成 NEXTAUTH_SECRET
openssl rand -base64 32

# 生成 SALT
openssl rand -base64 32
```

请创建 `.env` 文件并根据需要进行修改。

## 数据卷

- `langfuse_db_data`: 用于存储 PostgreSQL 数据的卷。

## 快速开始

1. 创建包含必需密钥的 `.env` 文件:

   ```env
   NEXTAUTH_SECRET=your-generated-secret-here
   SALT=your-generated-salt-here
   POSTGRES_PASSWORD=your-secure-password
   ```

2. 启动服务:

   ```bash
   docker compose up -d
   ```

3. 访问 `http://localhost:3000`

4. 在设置页面创建您的第一个账户

## 文档

更多信息请访问 [Langfuse 官方文档](https://langfuse.com/docs)。

## 安全提示

- 在生产环境中更改默认密码
- 为 `NEXTAUTH_SECRET` 和 `SALT` 使用强随机生成的值
- 在生产环境中考虑使用带 SSL/TLS 的反向代理
- 定期备份 PostgreSQL 数据库
