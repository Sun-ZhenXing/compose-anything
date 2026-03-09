# Convex

Convex 是一个开源的响应式数据库，旨在让 Web 应用开发者（无论是人类还是 LLM）的生活更加轻松。

## 功能特性

- **响应式查询**：当底层数据变化时，查询会自动更新
- **实时订阅**：无需手动轮询即可实现实时 UI 更新
- **无服务器函数**：使用 TypeScript/JavaScript 编写后端逻辑
- **自动缓存**：内置智能缓存以获得最佳性能
- **类型安全**：完整的 TypeScript 支持，并生成类型定义
- **可扩展架构**：专为高吞吐量应用而设计

## 快速开始

1. 复制 `.env.example` 到 `.env`：

   ```bash
   cp .env.example .env
   ```

2. 生成实例密钥（生产环境必需）：

   ```bash
   openssl rand -hex 32
   ```

   然后在 `.env` 文件中设置 `INSTANCE_SECRET`。

3. 启动 Convex：

   ```bash
   docker compose up -d
   ```

4. 等待服务健康（使用 `docker compose ps` 检查）

5. 访问 Dashboard：`http://localhost:6791`

6. 后端 API 地址：`http://localhost:3210`

## 默认配置

| 服务           | 端口 | 说明                     |
| -------------- | ---- | ------------------------ |
| Convex Backend | 3210 | 主 API 和 WebSocket 端点 |
| Site Proxy     | 3211 | 站点托管代理             |
| Dashboard      | 6791 | 管理 Convex 的 Web UI    |
| PostgreSQL     | 5432 | 数据库（内部）           |

**认证**：生产环境请设置 `INSTANCE_SECRET`。

## 环境变量

关键环境变量（完整列表请参见 `.env.example`）：

| 变量                              | 说明                              | 默认值                  |
| --------------------------------- | --------------------------------- | ----------------------- |
| `CONVEX_BACKEND_PORT_OVERRIDE`    | 后端 API 的主机端口               | `3210`                  |
| `CONVEX_SITE_PROXY_PORT_OVERRIDE` | 站点代理的主机端口                | `3211`                  |
| `CONVEX_DASHBOARD_PORT_OVERRIDE`  | Dashboard 的主机端口              | `6791`                  |
| `INSTANCE_NAME`                   | Convex 实例名称                   | `convex-self-hosted`    |
| `INSTANCE_SECRET`                 | 认证密钥                          | （必需）                |
| `CONVEX_CLOUD_ORIGIN`             | 后端访问 URL                      | `http://127.0.0.1:3210` |
| `CONVEX_SITE_ORIGIN`              | 站点代理访问 URL                  | `http://127.0.0.1:3211` |
| `POSTGRES_PASSWORD`               | PostgreSQL 密码                   | `convex`                |
| `RUST_LOG`                        | 日志级别（error/warn/info/debug） | `info`                  |
| `TZ`                              | 时区                              | `UTC`                   |

## 资源需求

**最低配置**：

- CPU：1 核
- 内存：1GB
- 磁盘：5GB

**推荐配置**：

- CPU：2+ 核
- 内存：2GB+
- 磁盘：20GB+

## 数据卷

- `convex_data`：Convex 后端数据存储
- `postgres_data`：PostgreSQL 数据库数据

## 在应用中使用

要将此自托管 Convex 后端与您的应用一起使用：

1. 在应用中设置 `CONVEX_SELF_HOSTED_URL` 环境变量：

   ```bash
   CONVEX_SELF_HOSTED_URL=http://localhost:3210
   ```

2. 设置 `CONVEX_SELF_HOSTED_ADMIN_KEY` 环境变量：

   ```bash
   CONVEX_SELF_HOSTED_ADMIN_KEY=your-instance-secret
   ```

3. 部署您的 Convex 函数：

   ```bash
   npx convex dev
   ```

更多详情，请参阅 [Convex 自托管文档](https://stack.convex.dev/self-hosted-develop-and-deploy)。

## 安全说明

- **生产环境务必设置强 `INSTANCE_SECRET`**
- 通过设置 `DO_NOT_REQUIRE_SSL=false` 并使用反向代理来启用 SSL/TLS
- 使用强数据库密码
- 限制对 Convex 服务的网络访问
- 生产环境考虑使用 AWS S3 进行外部存储

## 许可证

Apache-2.0（<https://github.com/get-convex/convex-backend/blob/main/LICENSE>）
