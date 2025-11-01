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

4. 等待服务就绪

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
| `LANGFLOW_VERSION`            | Langflow 镜像版本              | `latest`   |
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

### 添加 API 密钥

您可以通过两种方式为 LLM 提供商添加 API 密钥：

#### 方法 1：全局变量（推荐）

1. 点击您的个人资料图标 → Settings
2. 进入 "Global Variables"
3. 添加您的 API 密钥（例如 `OPENAI_API_KEY`）
4. 在组件中使用 `{OPENAI_API_KEY}` 引用它们

#### 方法 2：环境变量

添加到您的 `.env` 文件：

```text
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
GOOGLE_API_KEY=...
```

Langflow 会自动从这些创建全局变量。

### 使用 API

从 UI 获取您的 API 令牌：

1. 点击您的个人资料图标 → Settings
2. 进入 "API Keys"
3. 创建新的 API 密钥

示例：运行流

```bash
curl -X POST http://localhost:7860/api/v1/run/YOUR_FLOW_ID \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"input_value": "Hello"}'
```

### 自定义组件

1. 为您的组件创建一个目录
2. 在 `.env` 中设置 `LANGFLOW_COMPONENTS_PATH`
3. 使用您的组件类创建 Python 文件
4. 重启 Langflow 以加载它们

示例组件结构：

```python
from langflow import CustomComponent

class MyComponent(CustomComponent):
    display_name = "My Component"
    description = "Does something cool"
    
    def build(self):
        # Your component logic
        return result
```

## 安全注意事项

1. **密钥**：为生产环境生成强 `LANGFLOW_SECRET_KEY`：

   ```bash
   python -c "from secrets import token_urlsafe; print(token_urlsafe(32))"
   ```

2. **身份验证**：设置 `LANGFLOW_AUTO_LOGIN=false` 以要求登录
3. **数据库密码**：使用强 PostgreSQL 密码
4. **API 密钥**：将敏感密钥存储为全局变量，而不是在流中
5. **SSL/TLS**：在生产环境中使用带 HTTPS 的反向代理
6. **网络访问**：使用防火墙规则限制访问

## 升级

升级 Langflow：

1. 在 `.env` 中更新 `LANGFLOW_VERSION`（或使用 `latest`）
2. 拉取并重启：

   ```bash
   docker compose pull
   docker compose up -d
   ```

3. 检查日志：

   ```bash
   docker compose logs -f langflow
   ```

## 故障排除

**服务无法启动：**

- 检查日志：`docker compose logs langflow`
- 验证数据库：`docker compose ps postgres`
- 确保分配了足够的资源

**无法访问 UI：**

- 检查端口 7860 未被占用：`netstat -an | findstr 7860`
- 验证防火墙设置
- 检查容器健康：`docker compose ps`

**API 密钥不工作：**

- 验证密钥已在全局变量中设置
- 检查变量名称在组件中匹配
- 确保 `LANGFLOW_STORE_ENVIRONMENT_VARIABLES=true`

**流执行错误：**

- 检查组件配置
- 在 UI 中每个组件下查看日志
- 验证 API 密钥有足够的额度/权限

## 参考资料

- 官方网站：<https://langflow.org>
- 文档：<https://docs.langflow.org>
- GitHub：<https://github.com/langflow-ai/langflow>
- Discord 社区：<https://discord.gg/EqksyE2EX9>
- Docker Hub：<https://hub.docker.com/r/langflowai/langflow>

## 许可证

Langflow 使用 MIT 许可证。详情请参阅 [LICENSE](https://github.com/langflow-ai/langflow/blob/main/LICENSE)。
