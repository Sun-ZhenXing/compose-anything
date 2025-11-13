# Open WebUI Rust

基于 Rust 的高性能 Open WebUI 实现，具有原生异步运行时和优化的资源效率。

## 概述

Open WebUI Rust 是 Open WebUI 后端的完整 Rust 重写版本，提供：

- **10-50 倍更快的响应时间**：API 端点性能显著提升
- **70% 更低的内存使用**：负载下内存占用大幅降低
- **原生并发**：基于 Tokio 的异步运行时
- **类型安全**：防止整类运行时错误
- **零拷贝流式传输**：聊天补全高效传输
- **生产就绪**：全面的错误处理机制

此部署包含：

- **Rust 后端**：高性能 API 服务器，支持 WebSocket
- **PostgreSQL**：数据持久化的主数据库
- **Redis**：缓存和 WebSocket 会话管理
- **Sandbox Executor**：安全的代码执行环境，具有 Docker 隔离
- **Frontend**：基于 SvelteKit 的用户界面，配备 Nginx 反向代理

## 特性

- ✅ **完全兼容** Open WebUI Python 后端的 API
- ✅ **原生 WebSocket/Socket.IO** 使用 Rust 实现
- ✅ **安全的代码执行**：通过隔离的 Docker 容器
- ✅ **多语言支持**：Python、JavaScript、Shell、Rust
- ✅ **RAG 和嵌入**：集成向量数据库
- ✅ **身份验证和授权**：JWT 令牌
- ✅ **速率限制和安全**：内置保护机制
- ✅ **全面的日志记录**：用于调试和监控

## 前置要求

- Docker 20.10+
- Docker Compose 2.0+
- 4GB+ 可用内存
- 访问 Docker 套接字（用于沙箱执行）

## 快速开始

### 1. 创建 `.env` 文件

```bash
cp .env.example .env
```

编辑 `.env` 并设置必需的变量：

```bash
# 重要：生成一个安全的密钥（至少 32 个字符）
WEBUI_SECRET_KEY=$(uuidgen | tr '[:upper:]' '[:lower:]' | tr -d '-')

# 可选：配置 OpenAI API
OPENAI_API_KEY=sk-your-api-key
OPENAI_API_BASE_URL=https://api.openai.com/v1
```

### 2. 启动服务

```bash
docker compose up -d
```

### 3. 访问应用程序

- **前端界面**：<http://localhost:3000>
- **Rust 后端 API**：<http://localhost:8080>
- **Sandbox Executor**：<http://localhost:8090>

### 4. 初始设置

1. 打开 <http://localhost:3000>
2. 创建管理员账户（第一个用户成为管理员）
3. 在设置中配置您的 AI 模型

## 架构

```text
┌─────────────┐
│  Frontend   │ :3000
│ (SvelteKit) │
└──────┬──────┘
       │
       ↓
┌─────────────┐     ┌──────────────┐
│Rust Backend │────→│  PostgreSQL  │ :5432
│   (API)     │     │  (Database)  │
└──────┬──────┘     └──────────────┘
       │
       ├───────────→┌──────────────┐
       │            │    Redis     │ :6379
       │            │   (Cache)    │
       │            └──────────────┘
       │
       └───────────→┌──────────────┐
                    │   Sandbox    │ :8090
                    │  Executor    │
                    └──────────────┘
```

## 配置

### 核心环境变量

| 变量                         | 默认值                | 描述                             |
| ---------------------------- | --------------------- | -------------------------------- |
| `WEBUI_SECRET_KEY`           | （必需）              | JWT 令牌的密钥（至少 32 个字符） |
| `POSTGRES_PASSWORD`          | `open_webui_password` | PostgreSQL 密码                  |
| `FRONTEND_PORT_OVERRIDE`     | `3000`                | 前端访问端口                     |
| `RUST_BACKEND_PORT_OVERRIDE` | `8080`                | 后端 API 端口                    |
| `TZ`                         | `UTC`                 | 时区设置                         |

### 功能开关

| 变量                      | 默认值  | 描述             |
| ------------------------- | ------- | ---------------- |
| `ENABLE_CODE_EXECUTION`   | `true`  | 启用安全代码执行 |
| `ENABLE_CODE_INTERPRETER` | `true`  | 启用代码解释器   |
| `ENABLE_IMAGE_GENERATION` | `false` | 启用图像生成     |
| `ENABLE_WEB_SEARCH`       | `false` | 启用网络搜索     |
| `ENABLE_SIGNUP`           | `true`  | 允许新用户注册   |

### 资源限制

每个服务都有可配置的 CPU 和内存限制：

```bash
# Rust 后端
RUST_BACKEND_CPU_LIMIT=2
RUST_BACKEND_MEMORY_LIMIT=2G

# PostgreSQL
POSTGRES_CPU_LIMIT=1
POSTGRES_MEMORY_LIMIT=1G

# Sandbox Executor
SANDBOX_EXECUTOR_CPU_LIMIT=2
SANDBOX_EXECUTOR_MEMORY_LIMIT=2G
```

### 沙箱安全

配置沙箱执行限制：

```bash
SANDBOX_MAX_EXECUTION_TIME=60        # 最大执行时间（秒）
SANDBOX_MAX_MEMORY_MB=512           # 每次执行的最大内存
SANDBOX_MAX_CONCURRENT_EXECUTIONS=10 # 最大并行执行数
SANDBOX_NETWORK_MODE=none           # 禁用网络访问
```

## 使用示例

### 基础聊天

```bash
curl -X POST http://localhost:8080/api/chat/completions \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-3.5-turbo",
    "messages": [{"role": "user", "content": "你好！"}]
  }'
```

### 代码执行

```bash
curl -X POST http://localhost:8090/api/v1/execute \
  -H "Content-Type: application/json" \
  -d '{
    "language": "python",
    "code": "print(\"Hello from sandbox!\")"
  }'
```

## 监控

### 查看日志

```bash
# 所有服务
docker compose logs -f

# 特定服务
docker compose logs -f rust-backend
docker compose logs -f sandbox-executor
```

### 检查服务健康状态

```bash
# Rust 后端
curl http://localhost:8080/health

# Sandbox Executor
curl http://localhost:8090/api/v1/health

# PostgreSQL
docker compose exec postgres pg_isready
```

### 资源使用情况

```bash
docker stats
```

## 维护

### 备份数据库

```bash
docker compose exec postgres pg_dump -U open_webui open_webui > backup.sql
```

### 恢复数据库

```bash
cat backup.sql | docker compose exec -T postgres psql -U open_webui open_webui
```

### 更新服务

```bash
docker compose pull
docker compose up -d
```

### 清理重置

```bash
# 停止并删除所有数据
docker compose down -v

# 全新启动
docker compose up -d
```

## 故障排除

### 无法连接到服务

检查所有容器是否健康：

```bash
docker compose ps
```

### JWT 令牌错误

确保 `WEBUI_SECRET_KEY` 已设置并在重启后保持一致。

### 代码执行失败

1. 验证 Docker 套接字是否可访问
2. 检查 sandbox executor 日志：`docker compose logs sandbox-executor`
3. 确保运行时镜像可用：`docker images | grep sandbox-runtime`

### 内存使用过高

在 `.env` 中调整资源限制：

```bash
RUST_BACKEND_MEMORY_LIMIT=1G
SANDBOX_EXECUTOR_MEMORY_LIMIT=1G
```

## 安全注意事项

### 生产部署

1. **更改默认密码**

   ```bash
   POSTGRES_PASSWORD=$(openssl rand -base64 32)
   WEBUI_SECRET_KEY=$(openssl rand -base64 48)
   ```

2. **限制网络访问**

   ```bash
   CORS_ALLOW_ORIGIN=https://yourdomain.com
   ```

3. **初始设置后禁用注册**

   ```bash
   ENABLE_SIGNUP=false
   ```

4. **使用反向代理启用 HTTPS**（nginx、Traefik、Caddy）

5. **限制沙箱资源**

   ```bash
   SANDBOX_MAX_EXECUTION_TIME=30
   SANDBOX_MAX_MEMORY_MB=256
   SANDBOX_NETWORK_MODE=none
   ```

### Docker 套接字访问

Sandbox Executor 需要访问 Docker 套接字（`/var/run/docker.sock`）以实现容器隔离。这是一个特权操作，应该：

- 仅在受信任的环境中使用
- 通过适当的网络隔离进行保护
- 监控可疑活动

考虑使用以下替代方案：

- Docker-in-Docker（DinD）以获得更好的隔离
- 带有 Pod 安全策略的 Kubernetes
- 在单独节点上的专用沙箱服务

## 性能

典型资源使用情况：

| 服务             | CPU（空闲） | 内存（空闲） | CPU（负载） | 内存（负载） |
| ---------------- | ----------- | ------------ | ----------- | ------------ |
| Rust Backend     | ~1%         | 50MB         | 10-30%      | 200MB        |
| PostgreSQL       | ~1%         | 50MB         | 5-15%       | 300MB        |
| Redis            | <1%         | 10MB         | 2-5%        | 50MB         |
| Sandbox Executor | <1%         | 30MB         | 变化        | 512MB        |
| Frontend         | <1%         | 50MB         | 5-10%       | 200MB        |

## 许可证

本项目遵循原 Open WebUI 的许可证。

## 相关项目

- [Open WebUI](https://github.com/open-webui/open-webui) - 原始 Python 实现
- [Open WebUI Rust](https://github.com/knoxchat/open-webui-rust) - 官方 Rust 后端仓库

## 支持

问题和疑问：

- [Open WebUI Rust Issues](https://github.com/knoxchat/open-webui-rust/issues)
- [Open WebUI 文档](https://docs.openwebui.com/)
