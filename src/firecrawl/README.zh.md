# Firecrawl

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署 Firecrawl，一个由 Playwright 和无头浏览器驱动的网页抓取和爬取 API。

## 服务

- `api`: Firecrawl API 主服务器,集成了工作进程
- `redis`: 用于作业队列和缓存的 Redis
- `playwright-service`: 用于浏览器自动化的 Playwright 服务
- `nuq-postgres`: 用于队列管理和数据存储的 PostgreSQL 数据库

## 环境变量

| 变量名                  | 说明                          | 默认值     |
| ----------------------- | ----------------------------- | ---------- |
| FIRECRAWL_VERSION       | Firecrawl 镜像版本            | `latest`   |
| REDIS_VERSION           | Redis 镜像版本                | `alpine`   |
| PLAYWRIGHT_VERSION      | Playwright 服务版本           | `latest`   |
| NUQ_POSTGRES_VERSION    | NUQ PostgreSQL 镜像版本       | `latest`   |
| POSTGRES_USER           | PostgreSQL 用户名             | `postgres` |
| POSTGRES_PASSWORD       | PostgreSQL 密码               | `postgres` |
| POSTGRES_DB             | PostgreSQL 数据库名称         | `postgres` |
| POSTGRES_PORT_OVERRIDE  | PostgreSQL 端口映射           | `5432`     |
| INTERNAL_PORT           | 内部 API 端口                 | `3002`     |
| FIRECRAWL_PORT_OVERRIDE | 外部 API 端口映射             | `3002`     |
| EXTRACT_WORKER_PORT     | 提取工作进程端口              | `3004`     |
| WORKER_PORT             | 工作进程端口                  | `3005`     |
| USE_DB_AUTHENTICATION   | 启用数据库身份验证            | `false`    |
| OPENAI_API_KEY          | OpenAI API 密钥（可选）       | `""`       |
| OPENAI_BASE_URL         | OpenAI API 基础 URL（可选）   | `""`       |
| MODEL_NAME              | AI 模型名称（可选）           | `""`       |
| MODEL_EMBEDDING_NAME    | 嵌入模型名称（可选）          | `""`       |
| OLLAMA_BASE_URL         | Ollama 基础 URL（可选）       | `""`       |
| BULL_AUTH_KEY           | Bull 队列管理面板身份验证密钥 | `@`        |
| TEST_API_KEY            | 测试 API 密钥（可选）         | `""`       |
| SLACK_WEBHOOK_URL       | Slack Webhook 通知（可选）    | `""`       |
| POSTHOG_API_KEY         | PostHog API 密钥（可选）      | `""`       |
| POSTHOG_HOST            | PostHog 主机（可选）          | `""`       |
| SUPABASE_ANON_TOKEN     | Supabase 匿名令牌（可选）     | `""`       |
| SUPABASE_URL            | Supabase URL（可选）          | `""`       |
| SUPABASE_SERVICE_TOKEN  | Supabase 服务令牌（可选）     | `""`       |
| SELF_HOSTED_WEBHOOK_URL | 自托管 Webhook URL（可选）    | `""`       |
| SERPER_API_KEY          | Serper 搜索 API 密钥（可选）  | `""`       |
| SEARCHAPI_API_KEY       | SearchAPI 密钥（可选）        | `""`       |
| LOGGING_LEVEL           | 日志级别                      | `info`     |
| PROXY_SERVER            | 代理服务器 URL（可选）        | `""`       |
| PROXY_USERNAME          | 代理用户名（可选）            | `""`       |
| PROXY_PASSWORD          | 代理密码（可选）              | `""`       |
| BLOCK_MEDIA             | 阻止媒体内容                  | `true`     |
| SEARXNG_ENDPOINT        | SearXNG 端点（可选）          | `""`       |
| SEARXNG_ENGINES         | SearXNG 引擎（可选）          | `""`       |
| SEARXNG_CATEGORIES      | SearXNG 分类（可选）          | `""`       |

请根据实际需求修改 `.env` 文件。

## 卷

- `redis_data`: 用于作业队列和缓存的 Redis 数据存储
- `postgres_data`: 用于队列管理和元数据的 PostgreSQL 数据存储

## 使用方法

### 启动服务

```bash
docker compose up -d
```

### 访问 API

Firecrawl API 可在以下地址访问:

```text
http://localhost:3002
```

### 管理面板

访问 Bull 队列管理面板:

```text
http://localhost:3002/admin/@/queues
```

如果修改了 `BULL_AUTH_KEY`,请将 `@` 替换为您的值。

### API 调用示例

**抓取单个页面:**

```bash
curl -X POST http://localhost:3002/v1/scrape \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://example.com"
  }'
```

**爬取网站:**

```bash
curl -X POST http://localhost:3002/v1/crawl \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://example.com",
    "limit": 100
  }'
```

**提取结构化数据:**

```bash
curl -X POST http://localhost:3002/v1/extract \
  -H "Content-Type: application/json" \
  -d '{
    "urls": ["https://example.com"],
    "schema": {
      "type": "object",
      "properties": {
        "title": {"type": "string"},
        "description": {"type": "string"}
      }
    }
  }'
```

## 功能

- **网页抓取**: 从任何网页提取干净的内容
- **网站爬取**: 递归爬取整个网站
- **JavaScript 渲染**: 完全支持动态 JavaScript 渲染的页面
- **Markdown 输出**: 将网页内容清晰地转换为 markdown
- **结构化数据提取**: 使用 JSON Schema 提取数据
- **队列管理**: 内置 Bull 作业队列
- **速率限制**: 可配置的速率限制
- **代理支持**: 所有请求的可选代理配置
- **AI 驱动功能**: 可选的 OpenAI 集成以进行高级提取

## 架构

此部署使用官方 Firecrawl 架构:

- **API 服务器**: 处理 HTTP 请求并管理作业队列
- **工作进程**: 内置于主容器中,处理抓取作业
- **PostgreSQL**: 存储队列元数据和作业信息
- **Redis**: 处理作业队列和缓存
- **Playwright 服务**: 提供浏览器自动化功能

## 注意事项

- 该服务使用官方的 `ghcr.io/firecrawl/firecrawl` 镜像
- PostgreSQL 使用官方的 `ghcr.io/firecrawl/nuq-postgres` 镜像进行队列管理（NUQ - Not Quite Bull）
- Redis 默认不使用密码（运行在私有网络上）
- 对于生产环境,启用 `USE_DB_AUTHENTICATION` 并配置 Supabase
- 在生产部署中应更改 `BULL_AUTH_KEY`
- AI 功能需要 `OPENAI_API_KEY` 或 `OLLAMA_BASE_URL`
- 所有工作进程都在单个 API 容器中使用 harness 模式运行

## 许可证

Firecrawl 使用 AGPL-3.0 许可证授权。
