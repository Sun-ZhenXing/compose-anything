# OpenLIT

OpenLIT 是一个开源的 AI 工程平台，为大型语言模型（LLM）、GPU 和向量数据库提供 OpenTelemetry 原生的可观测性、监控和管理工具。

## 功能特性

- **📈 分析仪表板**：通过详细的仪表板监控 AI 应用程序的健康状况和性能，跟踪指标、成本和用户交互
- **🔌 OpenTelemetry 原生可观测性 SDK**：供应商中立的 SDK，可将跟踪和指标发送到现有的可观测性工具
- **💲 成本跟踪**：使用自定义定价文件为特定模型定制成本估算，实现精确预算
- **🐛 异常监控**：通过跟踪常见异常和错误快速发现并解决问题
- **💭 提示词管理**：使用 Prompt Hub 管理和版本化提示词，确保应用程序之间的一致性和便捷访问
- **🔑 API 密钥和密钥管理**：集中安全地处理 API 密钥和密钥
- **🎮 实验不同的 LLM**：使用 OpenGround 并排探索、测试和比较各种 LLM
- **🚀 OpAMP 管理的 Fleet Hub**：使用 OpAMP（开放代理管理协议）集中管理和监控整个基础设施中的 OpenTelemetry Collector，并支持安全的 TLS 通信

## 快速开始

1. 复制 `.env.example` 为 `.env` 并根据需要自定义：

   ```bash
   cp .env.example .env
   ```

2. 启动服务：

   ```bash
   docker compose up -d
   ```

3. 访问 OpenLIT：`http://localhost:3000`

4. 使用默认凭据登录：
   - 邮箱：`user@openlit.io`
   - 密码：`openlituser`

## 组件说明

此部署包含以下组件：

- **OpenLIT 平台**：提供 UI 和 API 的主应用程序（端口：3000）
- **ClickHouse**：存储遥测数据的数据库（端口：8123、9000）
- **OTLP 接收器**：
  - gRPC：端口 4317
  - HTTP：端口 4318

## 与应用程序集成

将 OpenLIT 集成到 AI 应用程序：

### Python SDK

```bash
pip install openlit
```

```python
import openlit

openlit.init(
    otlp_endpoint="http://localhost:4318"
)
```

### TypeScript SDK

```bash
npm install openlit
```

```typescript
import Openlit from 'openlit';

Openlit.init({
    otlpEndpoint: 'http://localhost:4318'
});
```

## 环境变量

关键配置选项（查看 `.env.example` 获取所有选项）：

| 变量                              | 说明                                 | 默认值       |
| --------------------------------- | ------------------------------------ | ------------ |
| `OPENLIT_VERSION`                 | OpenLIT 镜像版本                     | `latest`     |
| `CLICKHOUSE_VERSION`              | ClickHouse 版本                      | `24.4.1`     |
| `OPENLIT_PORT_OVERRIDE`           | 主机上的 UI 端口                     | `3000`       |
| `OPENLIT_OTLP_HTTP_PORT_OVERRIDE` | OTLP HTTP 端口                       | `4318`       |
| `OPENLIT_OTLP_GRPC_PORT_OVERRIDE` | OTLP gRPC 端口                       | `4317`       |
| `OPENLIT_DB_PASSWORD`             | ClickHouse 密码                      | `OPENLIT`    |
| `OPAMP_ENVIRONMENT`               | OpAMP 模式（development/production） | `production` |

## 资源需求

默认资源分配：

- **OpenLIT**：
  - 限制：1 CPU、2GB 内存
  - 预留：0.25 CPU、512MB 内存
- **ClickHouse**：
  - 限制：2 CPU、4GB 内存
  - 预留：0.5 CPU、2GB 内存

根据工作负载在 `.env` 文件中调整这些值。

## OAuth 配置（可选）

要启用 OAuth 身份验证：

1. 配置 Google OAuth：

   ```env
   GOOGLE_CLIENT_ID=your-client-id
   GOOGLE_CLIENT_SECRET=your-client-secret
   ```

2. 配置 GitHub OAuth：

   ```env
   GITHUB_CLIENT_ID=your-client-id
   GITHUB_CLIENT_SECRET=your-client-secret
   ```

## OpAMP Fleet Hub

OpenLIT 包含用于集中管理 OpenTelemetry Collector 的 OpAMP 服务器：

- Fleet Hub 访问地址：`http://localhost:3000/fleet-hub`
- OpAMP 端点：`wss://localhost:4320/v1/opamp`（生产模式）
- API 端点：`http://localhost:8080`

对于生产部署，请确保正确的 TLS 配置：

```env
OPAMP_ENVIRONMENT=production
OPAMP_TLS_INSECURE_SKIP_VERIFY=false
OPAMP_TLS_REQUIRE_CLIENT_CERT=true
```

## 支持的集成

OpenLIT 为 50 多种 LLM 提供商、向量数据库和框架提供自动仪表化，包括：

- **LLM 提供商**：OpenAI、Anthropic、Cohere、Azure OpenAI、Google Vertex AI、Bedrock 等
- **向量数据库**：Pinecone、Weaviate、ChromaDB、Qdrant、Milvus 等
- **框架**：LangChain、LlamaIndex、Haystack、AutoGen、CrewAI 等

## 健康检查

OpenLIT 服务包含健康检查以确保正确启动。当满足以下条件时，服务被视为健康：

- Web 界面在配置的端口上响应
- 间隔：30 秒
- 超时：10 秒
- 启动期：60 秒

## 数据持久化

数据持久化在 Docker 卷中：

- `clickhouse_data`：ClickHouse 数据库文件
- `openlit_data`：OpenLIT 应用程序数据，包括 SQLite 数据库

## 监控

监控部署：

```bash
# 查看日志
docker compose logs -f openlit

# 检查服务状态
docker compose ps

# 查看资源使用情况
docker stats
```

## 安全注意事项

1. **更改默认密码**：在生产环境中更新 `OPENLIT_DB_PASSWORD`
2. **TLS 配置**：对于生产环境，请在 OpAMP 中使用正确的 TLS 证书
3. **OAuth**：考虑启用 OAuth 以增强安全性
4. **网络**：默认情况下，服务在所有接口上公开。在生产环境中考虑使用反向代理

## 故障排除

### 服务无法启动

- 检查日志：`docker compose logs openlit`
- 验证 ClickHouse 是否健康：`docker compose ps`
- 确保端口未被占用

### 无法连接到 OTLP 端点

- 验证防火墙设置
- 检查 `.env` 中的端口配置
- 确保应用程序中的端点 URL 正确

### 资源使用率高

- 在 `.env` 中调整资源限制
- 使用以下命令监控：`docker stats`
- 考虑为大型工作负载扩展 ClickHouse 资源

## 文档

- 官方文档：<https://docs.openlit.io/>
- GitHub 仓库：<https://github.com/openlit/openlit>
- Python SDK：<https://github.com/openlit/openlit/tree/main/sdk/python>
- TypeScript SDK：<https://github.com/openlit/openlit/tree/main/sdk/typescript>

## 许可证

OpenLIT 采用 Apache-2.0 许可证。

## 支持

- [Slack 社区](https://join.slack.com/t/openlit/shared_invite/zt-2etnfttwg-TjP_7BZXfYg84oAukY8QRQ)
- [Discord](https://discord.gg/CQnXwNT3)
- [GitHub Issues](https://github.com/openlit/openlit/issues)
- [X/Twitter](https://twitter.com/openlit_io)
