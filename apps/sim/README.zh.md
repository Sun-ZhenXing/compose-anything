# Sim - AI Agent Workflow Builder

开源 AI 智能体工作流构建和部署平台。从初创公司到世界 500 强企业的开发者都在 Sim 平台上部署智能体工作流。

## 功能特性

- **可视化工作流构建器**：通过拖拽界面构建多步骤 AI 智能体和工具
- **LLM 编排**：协调 LLM 调用、工具、Webhook 和外部 API
- **计划执行**：支持事件驱动和定时调度的智能体执行
- **RAG 支持**：一流的检索增强生成（RAG）支持
- **多租户**：基于工作空间的团队访问模型
- **100+ 集成**：连接流行的服务和 API

## 系统要求

| 资源   | 最低要求  | 推荐配置         |
| ------ | --------- | ---------------- |
| CPU    | 2 核      | 4 核及以上       |
| 内存   | 12 GB     | 16 GB 及以上     |
| 存储   | 20 GB SSD | 50 GB 及以上 SSD |
| Docker | 20.10+    | 最新版本         |

## 快速开始

```bash
# 复制环境配置文件
cp .env.example .env

# 重要：在生产环境中生成安全密钥
sed -i "s/your_auth_secret_here/$(openssl rand -hex 32)/" .env
sed -i "s/your_encryption_key_here/$(openssl rand -hex 32)/" .env

# 启动服务
docker compose up -d

# 查看日志
docker compose logs -f simstudio
```

访问应用：[http://localhost:3000](http://localhost:3000)

## 配置说明

### 必需的环境变量

在部署前，请在 `.env` 文件中更新这些关键设置：

```bash
# 安全密钥（必需 - 使用以下命令生成：openssl rand -hex 32）
BETTER_AUTH_SECRET=<your-secret-here>
ENCRYPTION_KEY=<your-secret-here>

# 应用 URL（生产环境需更新）
NEXT_PUBLIC_APP_URL=https://sim.yourdomain.com
BETTER_AUTH_URL=https://sim.yourdomain.com
NEXT_PUBLIC_SOCKET_URL=https://sim.yourdomain.com

# 数据库凭据（生产环境需更改默认值）
POSTGRES_USER=postgres
POSTGRES_PASSWORD=<strong-password>
POSTGRES_DB=simstudio
```

### 使用 Ollama

Sim 可以配合本地 AI 模型使用 [Ollama](https://ollama.ai)：

**外部 Ollama（运行在宿主机上）**：

```bash
# macOS/Windows
OLLAMA_URL=http://host.docker.internal:11434

# Linux - 使用宿主机实际 IP
OLLAMA_URL=http://192.168.1.100:11434
```

> **注意**：在 Docker 内部，`localhost` 指向容器本身。请使用 `host.docker.internal`（macOS/Windows）或宿主机 IP 地址（Linux）。

### 端口配置

默认端口可通过环境变量覆盖：

```bash
SIM_PORT_OVERRIDE=3000              # 主应用
SIM_REALTIME_PORT_OVERRIDE=3002     # 实时服务器
POSTGRES_PORT_OVERRIDE=5432         # PostgreSQL 数据库
```

### 资源限制

根据工作负载调整资源分配：

```bash
# 主应用
SIM_CPU_LIMIT=4.0
SIM_MEMORY_LIMIT=8G

# 实时服务器
SIM_REALTIME_CPU_LIMIT=2.0
SIM_REALTIME_MEMORY_LIMIT=4G

# PostgreSQL
POSTGRES_CPU_LIMIT=2.0
POSTGRES_MEMORY_LIMIT=2G
```

## 服务架构

部署包含 4 个服务：

1. **simstudio**：主 Next.js 应用（端口 3000）
2. **realtime**：WebSocket 实时功能服务器（端口 3002）
3. **migrations**：数据库架构管理（仅运行一次）
4. **db**：PostgreSQL 17 with pgvector 扩展（端口 5432）

## 常用操作

### 查看日志

```bash
# 所有服务
docker compose logs -f

# 特定服务
docker compose logs -f simstudio
```

### 停止服务

```bash
docker compose down
```

### 更新到最新版本

```bash
docker compose pull
docker compose up -d
```

### 备份数据库

```bash
docker compose exec db pg_dump -U postgres simstudio > backup_$(date +%Y%m%d).sql
```

### 恢复数据库

```bash
cat backup.sql | docker compose exec -T db psql -U postgres simstudio
```

## 安全注意事项

- **更改默认凭据**：在生产环境中更新 `POSTGRES_PASSWORD`
- **生成强密钥**：使用 `openssl rand -hex 32` 生成所有密钥值
- **使用 HTTPS**：配置反向代理（Nginx/Caddy）和 SSL 证书
- **网络隔离**：将数据库保持在内部网络
- **定期备份**：自动化数据库备份
- **定期更新**：拉取最新镜像获取安全补丁

## 生产环境部署

生产环境部署建议：

1. **使用反向代理**（Nginx、Caddy、Traefik）进行 SSL/TLS 终止
2. **配置防火墙**限制数据库访问
3. **设置监控**（健康检查、指标、日志）
4. **启用备份**（自动化 PostgreSQL 备份）
5. **使用外部数据库**以获得更好的性能和可靠性（可选）

Caddy 配置示例：

```caddy
sim.yourdomain.com {
    reverse_proxy localhost:3000

    handle /socket.io/* {
        reverse_proxy localhost:3002
    }
}
```

## 故障排查

### 模型不显示在下拉列表中

如果使用宿主机上的外部 Ollama，请确保 `OLLAMA_URL` 使用 `host.docker.internal` 或宿主机 IP 地址，而不是 `localhost`。

### 数据库连接错误

- 验证 PostgreSQL 健康状态：`docker compose ps`
- 检查数据库日志：`docker compose logs db`
- 确保迁移完成：`docker compose logs migrations`

### 端口冲突

如果端口已被占用，可以覆盖它们：

```bash
SIM_PORT_OVERRIDE=3100 \
SIM_REALTIME_PORT_OVERRIDE=3102 \
POSTGRES_PORT_OVERRIDE=5433 \
docker compose up -d
```

## 相关资源

- **官方文档**：[https://docs.sim.ai](https://docs.sim.ai)
- **GitHub 仓库**：[https://github.com/simstudioai/sim](https://github.com/simstudioai/sim)
- **云托管版本**：[https://sim.ai](https://sim.ai)
- **自托管指南**：[https://docs.sim.ai/self-hosting](https://docs.sim.ai/self-hosting)

## 许可证

此配置遵循 Sim 项目许可。请查看[官方仓库](https://github.com/simstudioai/sim)了解许可证详情。

## 支持

如有问题和疑问：

- GitHub Issues：[https://github.com/simstudioai/sim/issues](https://github.com/simstudioai/sim/issues)
- 文档：[https://docs.sim.ai](https://docs.sim.ai)
