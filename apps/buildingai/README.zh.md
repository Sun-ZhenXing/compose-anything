# BuildingAI

BuildingAI 是一个智能 AI 应用开发平台，帮助开发者快速构建和部署 AI 驱动的应用程序。基于 NestJS + Vue 3 构建，为创建、管理和部署 AI 智能体提供全面的解决方案，拥有现代化的用户友好界面。

## 功能特性

- 🤖 **AI 智能体构建器**：使用拖放界面创建和自定义 AI 智能体
- 💬 **对话管理**：具有上下文感知的高级聊天界面
- 🔌 **MCP 服务器集成**：支持模型上下文协议（Model Context Protocol）服务器
- 🎨 **现代化 UI**：使用 Vue 3 和 Nuxt 构建，提供卓越的用户体验
- 🔒 **企业级就绪**：内置用户管理、身份验证和多租户支持
- 📊 **数据分析**：跟踪 AI 应用的使用情况和性能
- 🌐 **i18n 支持**：多语言界面支持
- 🔧 **可扩展**：插件系统支持自定义扩展

## 技术栈

- **后端**：NestJS 11.x + TypeORM 0.3.x
- **数据库**：PostgreSQL 17.x
- **缓存**：Redis 8.x
- **前端**：Vue.js 3.x + Nuxt + Vite 7.x
- **TypeScript**：5.x
- **Monorepo**：Turbo 2.x

## 快速开始

### 前置要求

- 已安装 Docker 和 Docker Compose
- 至少 4GB 可用内存
- 5GB 可用磁盘空间

### 部署步骤

1. 复制环境变量文件：

    ```bash
    cp .env.example .env
    ```

2. （可选）修改 `.env` 文件以自定义配置：
   - 设置 `DB_PASSWORD` 以增强数据库安全性
   - 设置 `REDIS_PASSWORD` 以增强 Redis 安全性
   - 如需使用不同端口，配置 `BUILDINGAI_PORT_OVERRIDE`
   - 如需使用自定义 npm 镜像源，设置 `NPM_REGISTRY_URL`

3. 启动服务：

    ```bash
    docker compose up -d
    ```

4. 等待服务就绪（首次启动可能需要几分钟）：

    ```bash
    docker compose logs -f buildingai
    ```

5. 访问 [http://localhost:4090/install](http://localhost:4090/install) 完成初始化设置向导。

### 默认端口

- **BuildingAI**：4090（Web 界面）
- **PostgreSQL**：5432（数据库）
- **Redis**：6379（缓存）

你可以在 `.env` 文件中覆盖这些端口。

## 配置说明

### 环境变量

所有配置都通过 `.env` 文件完成。查看 [.env.example](.env.example) 了解所有可用选项。

#### 关键设置

- `DB_USERNAME` / `DB_PASSWORD`：数据库凭据
- `REDIS_PASSWORD`：Redis 密码（可选，但生产环境建议设置）
- `SERVER_PORT`：内部应用端口
- `NPM_REGISTRY_URL`：自定义 npm 镜像源（在中国或私有网络中很有用）

### 资源限制

默认资源限制配置适用于中小型部署：

- **BuildingAI**：2 CPU 核心，3584MB 内存
- **PostgreSQL**：1 CPU 核心，512MB 内存
- **Redis**：0.25 CPU 核心，256MB 内存

根据你的工作负载在 `.env` 中调整这些设置。

## 数据持久化

所有数据存储在 Docker 卷中：

- `buildingai_data`：应用数据和上传文件
- `postgres_data`：数据库文件
- `redis_data`：Redis 持久化数据

### 备份

备份你的数据：

```bash
# 备份数据库
docker compose exec postgres pg_dump -U postgres buildingai > backup.sql

# 备份应用数据
docker run --rm -v buildingai_buildingai_data:/data -v $(pwd):/backup alpine tar czf /backup/buildingai-data.tar.gz -C /data .
```

### 恢复

```bash
# 恢复数据库
docker compose exec -T postgres psql -U postgres buildingai < backup.sql

# 恢复应用数据
docker run --rm -v buildingai_buildingai_data:/data -v $(pwd):/backup alpine tar xzf /backup/buildingai-data.tar.gz -C /data
```

## 维护

### 查看日志

```bash
# 所有服务
docker compose logs -f

# 特定服务
docker compose logs -f buildingai
```

### 重启服务

```bash
# 所有服务
docker compose restart

# 特定服务
docker compose restart buildingai
```

### 更新 BuildingAI

```bash
# 拉取最新镜像
docker compose pull

# 使用新镜像重启
docker compose up -d
```

### 停止服务

```bash
# 停止所有服务
docker compose down

# 停止并删除卷（警告：会删除所有数据）
docker compose down -v
```

## 故障排除

### BuildingAI 无法启动

1. 检查服务健康状态：

   ```bash
   docker compose ps
   ```

2. 检查日志中的错误：

   ```bash
   docker compose logs buildingai
   ```

3. 确保 PostgreSQL 和 Redis 健康：

   ```bash
   docker compose ps postgres redis
   ```

### 数据库连接错误

- 验证 `.env` 中的 `DB_USERNAME`、`DB_PASSWORD` 和 `DB_DATABASE`
- 检查 PostgreSQL 日志：`docker compose logs postgres`
- 确保 PostgreSQL 健康检查通过

### Redis 连接错误

- 如果设置了 `REDIS_PASSWORD`，确保所有服务中的配置一致
- 检查 Redis 日志：`docker compose logs redis`
- 验证 Redis 健康检查状态

### 性能问题

- 在 `.env` 中增加资源限制
- 监控资源使用情况：`docker stats`
- 检查磁盘空间是否充足

## 安全建议

生产环境部署时：

1. **设置强密码**：为 `DB_PASSWORD` 和 `REDIS_PASSWORD` 设置强密码
2. **不要暴露端口**：不要在外部暴露 PostgreSQL 和 Redis 端口（删除端口映射或使用防火墙规则）
3. **使用反向代理**：为 BuildingAI Web 界面使用带 HTTPS 的反向代理（nginx、Caddy）
4. **定期备份**：定期备份数据库和应用数据
5. **监控日志**：监控日志中的可疑活动
6. **保持更新**：定期更新镜像

## 链接

- [GitHub 仓库](https://github.com/BidingCC/BuildingAI)
- [官方网站](https://www.buildingai.cc/)
- [在线演示](http://demo.buildingai.cc/)
- [文档](https://www.buildingai.cc/docs/introduction/install)

## 许可证

请参考[原始仓库](https://github.com/BidingCC/BuildingAI)了解许可证信息。

## 支持

遇到问题和疑问：

- GitHub Issues：[BuildingAI Issues](https://github.com/BidingCC/BuildingAI/issues)
- 官方文档：[BuildingAI Docs](https://www.buildingai.cc/docs/)
