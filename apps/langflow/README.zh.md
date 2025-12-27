# Langflow

Langflow 是一个低代码可视化框架，用于构建 AI 应用。它基于 Python，与任何模型、API 或数据库无关，可轻松构建 RAG 应用、多智能体系统和自定义 AI 工作流。

## 功能特点

- **可视化流构建器**：拖放界面构建 AI 应用
- **多模型支持**：支持 OpenAI、Anthropic、Google、HuggingFace 等
- **RAG 组件**：内置向量数据库和检索支持
- **自定义组件**：创建您自己的 Python 组件
- **智能体支持**：构建具有记忆和工具的多智能体系统
- **实时监控**：跟踪执行并调试流程
- **API 集成**：用于编程访问的 REST API

## 快速开始

1. 复制 `.env.example` 到 `.env`：

   ```bash
   copy .env.example .env
   ```

2. （可选）编辑 `.env` 自定义设置：
   - 为生产环境生成安全的 `LANGFLOW_SECRET_KEY`
   - 设置 `LANGFLOW_AUTO_LOGIN=false` 以要求身份验证
   - 配置超级用户凭证
   - 为 LLM 提供商添加 API 密钥

3. 启动 Langflow：

   ```bash
   docker compose up -d
   ```

4. 等待服务就绪（通常需要 1-2 分钟）

5. 访问 Langflow UI：`http://localhost:7860`

6. 开始构建您的 AI 应用！

## 默认配置

| 服务       | 端口 | 说明           |
| ---------- | ---- | -------------- |
| Langflow   | 7860 | Web UI 和 API  |
| PostgreSQL | 5432 | 数据库（内部） |

**默认凭证**（如果启用了身份验证）：

- 用户名：`langflow`
- 密码：`langflow`

## 环境变量

主要环境变量（完整列表请参阅 `.env.example`）：

| 变量                          | 说明                           | 默认值     |
| ----------------------------- | ------------------------------ | ---------- |
| `LANGFLOW_VERSION`            | Langflow 镜像版本              | `1.1.1`    |
| `LANGFLOW_PORT_OVERRIDE`      | UI 的主机端口                  | `7860`     |
| `POSTGRES_PASSWORD`           | 数据库密码                     | `langflow` |
| `LANGFLOW_AUTO_LOGIN`         | 自动登录（禁用以启用身份验证） | `true`     |
| `LANGFLOW_SUPERUSER`          | 超级用户用户名                 | `langflow` |
| `LANGFLOW_SUPERUSER_PASSWORD` | 超级用户密码                   | `langflow` |
| `LANGFLOW_SECRET_KEY`         | 会话密钥                       | （空）     |
| `LANGFLOW_COMPONENTS_PATH`    | 自定义组件目录                 | （空）     |
| `LANGFLOW_LOAD_FLOWS_PATH`    | 自动加载流目录                 | （空）     |
| `TZ`                          | 时区                           | `UTC`      |

## 资源需求

**最低要求**：

- CPU：1 核心
- 内存：1GB
- 磁盘：5GB

**推荐配置**：

- CPU：2+ 核心
- 内存：2GB+
- 磁盘：20GB+

## 数据卷

- `postgres_data`：PostgreSQL 数据库数据
- `langflow_data`：Langflow 配置、流和日志

## 使用 Langflow

### 构建您的第一个流

1. 访问 UI：`http://localhost:7860`
2. 点击 "New Flow" 或使用模板
3. 从侧边栏拖动组件到画布
4. 通过在端口之间拖动来连接组件
5. 配置组件参数
6. 点击 "Run" 测试您的流
7. 使用 API 或与您的应用集成

### 添加 LLM 提供商

要使用外部 LLM 提供商，请配置其 API 密钥：

1. 在 Langflow UI 中，转到 Settings > Global Variables
2. 添加您的 API 密钥（例如，`OPENAI_API_KEY`、`ANTHROPIC_API_KEY`）
3. 在您的流组件中引用这些变量

或者，将它们添加到您的 `.env` 文件并重启：

```bash
# LLM API 密钥示例（添加到 .env）
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
GOOGLE_API_KEY=...
```

### 自定义组件

要添加自定义组件：

1. 为您的组件创建一个目录（例如，`./custom_components`）
2. 更新 `.env`：

   ```bash
   LANGFLOW_COMPONENTS_PATH=/app/langflow/custom_components
   ```

3. 在 `docker-compose.yaml` 中挂载目录：

   ```yaml
   volumes:
     - ./custom_components:/app/langflow/custom_components
   ```

4. 重启 Langflow

### 自动加载流

要在启动时自动加载流：

1. 将您的流导出为 JSON 文件
2. 创建一个目录（例如，`./flows`）
3. 更新 `.env`：

   ```bash
   LANGFLOW_LOAD_FLOWS_PATH=/app/langflow/flows
   ```

4. 在 `docker-compose.yaml` 中挂载目录：

   ```yaml
   volumes:
     - ./flows:/app/langflow/flows
   ```

5. 重启 Langflow

## API 使用

Langflow 提供 REST API 用于以编程方式运行流。

### 获取流 ID

1. 在 UI 中打开您的流
2. 流 ID 在 URL 中：`http://localhost:7860/flow/{flow_id}`

### 通过 API 运行流

```bash
curl -X POST http://localhost:7860/api/v1/run/{flow_id} \
  -H "Content-Type: application/json" \
  -d '{
    "inputs": {
      "input_field": "your input value"
    }
  }'
```

### 使用身份验证

如果启用了身份验证，首先获取令牌：

```bash
# 登录
curl -X POST http://localhost:7860/api/v1/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "langflow",
    "password": "langflow"
  }'

# 在后续请求中使用令牌
curl -X POST http://localhost:7860/api/v1/run/{flow_id} \
  -H "Authorization: Bearer {token}" \
  -H "Content-Type: application/json" \
  -d '{
    "inputs": {
      "input_field": "your input value"
    }
  }'
```

## 生产部署

对于生产部署：

1. **启用身份验证**：

   ```bash
   LANGFLOW_AUTO_LOGIN=false
   LANGFLOW_SUPERUSER=admin
   LANGFLOW_SUPERUSER_PASSWORD=<强密码>
   ```

2. **设置密钥**：

   ```bash
   # 生成安全密钥
   python -c "from secrets import token_urlsafe; print(token_urlsafe(32))"
   
   # 添加到 .env
   LANGFLOW_SECRET_KEY=<生成的密钥>
   ```

3. **使用强数据库密码**：

   ```bash
   POSTGRES_PASSWORD=<强密码>
   ```

4. **启用 SSL/TLS**：使用带有 SSL 证书的反向代理（nginx、traefik）

5. **配置资源限制**：根据您的工作负载调整 CPU 和内存限制

6. **备份数据库**：定期备份 PostgreSQL 数据卷

## 故障排除

### Langflow 无法启动

- 查看日志：`docker compose logs langflow`
- 确保 PostgreSQL 健康：`docker compose ps postgres`
- 验证端口 7860 未被使用

### 组件未加载

- 检查自定义组件路径是否正确
- 确保在自定义组件中安装了 Python 依赖项
- 检查日志中的组件错误

### 性能缓慢

- 在 `.env` 中增加资源限制
- 如果内存不足，减少 `LANGFLOW_WORKERS`
- 优化您的流（减少不必要的组件）

### 数据库连接错误

- 验证 PostgreSQL 正在运行：`docker compose ps postgres`
- 检查 `.env` 中的数据库凭证
- 确保 `LANGFLOW_DATABASE_URL` 正确

## 维护

### 备份

备份数据卷：

```bash
docker compose down
docker run --rm -v compose-anything_postgres_data:/data -v $(pwd):/backup alpine tar czf /backup/postgres-backup.tar.gz -C /data .
docker run --rm -v compose-anything_langflow_data:/data -v $(pwd):/backup alpine tar czf /backup/langflow-backup.tar.gz -C /data .
docker compose up -d
```

### 恢复

从备份恢复：

```bash
docker compose down
docker run --rm -v compose-anything_postgres_data:/data -v $(pwd):/backup alpine sh -c "cd /data && tar xzf /backup/postgres-backup.tar.gz"
docker run --rm -v compose-anything_langflow_data:/data -v $(pwd):/backup alpine sh -c "cd /data && tar xzf /backup/langflow-backup.tar.gz"
docker compose up -d
```

### 升级

升级 Langflow：

1. 在 `.env` 中更新版本：

   ```bash
   LANGFLOW_VERSION=1.2.0
   ```

2. 拉取新镜像并重启：

   ```bash
   docker compose pull
   docker compose up -d
   ```

3. 检查发布说明中的重大更改

## 常用命令

```bash
# 查看日志
docker compose logs -f langflow

# 重启 Langflow
docker compose restart langflow

# 访问 PostgreSQL
docker compose exec postgres psql -U langflow -d langflow

# 检查资源使用
docker stats

# 清理
docker compose down -v  # 警告：删除所有数据
```

## 参考资料

- [官方文档](https://docs.langflow.org/)
- [GitHub 仓库](https://github.com/langflow-ai/langflow)
- [组件文档](https://docs.langflow.org/components/)
- [API 文档](https://docs.langflow.org/api/)
- [社区 Discord](https://discord.gg/langflow)

## 许可证

MIT - 查看 [LICENSE](https://github.com/langflow-ai/langflow/blob/main/LICENSE)
