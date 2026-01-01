# Dify

[English](./README.md) | [中文](./README.zh.md)

这个服务部署 Dify,一个 LLM 应用开发平台,结合了 AI 工作流、RAG 管道、代理能力、模型管理、可观测性功能等。

## 服务

- `dify-api`: Dify API 服务
- `dify-worker`: 后台异步任务 Worker
- `dify-web`: Web 前端界面
- `dify-db`: PostgreSQL 数据库
- `dify-redis`: Redis 缓存
- `dify-weaviate`: Weaviate 向量数据库(可选 profile)

## 环境变量

| 变量名             | 描述                              | 默认值     |
| ------------------ | --------------------------------- | ---------- |
| DIFY_VERSION       | Dify 镜像版本                     | `0.18.2`   |
| POSTGRES_USER      | PostgreSQL 用户名                 | `dify`     |
| POSTGRES_PASSWORD  | PostgreSQL 密码                   | `difypass` |
| POSTGRES_DB        | PostgreSQL 数据库名               | `dify`     |
| REDIS_PASSWORD     | Redis 密码(留空则不需要认证)      | `""`       |
| SECRET_KEY         | 加密密钥                          | (自动)     |
| LOG_LEVEL          | 日志级别                          | `INFO`     |
| DIFY_PORT_OVERRIDE | Web 界面主机端口映射              | `3000`     |
| STORAGE_TYPE       | 存储类型(local, s3, azure-blob等) | `local`    |
| VECTOR_STORE       | 向量库类型(weaviate, milvus等)    | `weaviate` |
| WEAVIATE_VERSION   | Weaviate 版本(如果使用weaviate)   | `1.28.12`  |

请根据您的需求修改 `.env` 文件。

## 数据卷

- `dify_storage`: 上传文件和生成内容的存储
- `dify_db_data`: PostgreSQL 数据
- `dify_redis_data`: Redis 持久化数据
- `dify_weaviate_data`: Weaviate 向量数据库数据

## 使用方法

### 启动 Dify 与 Weaviate

```bash
docker compose --profile weaviate up -d
```

### 启动 Dify 不含向量数据库

```bash
docker compose up -d
```

### 访问

- Web 界面: <http://localhost:3000>
- API 文档: <http://localhost:5001/docs>

### 首次设置

1. 打开 <http://localhost:3000>
2. 创建管理员账户
3. 配置您的 LLM API 密钥(OpenAI、Azure OpenAI、Anthropic 等)
4. 开始创建您的 AI 应用

## 注意事项

- 首次启动可能需要几分钟进行数据库初始化
- 生产环境请修改 `SECRET_KEY` 以提高安全性
- 生产环境建议使用外部 PostgreSQL 和 Redis
- 支持多种 LLM 提供商:OpenAI、Azure OpenAI、Anthropic、Google、通过 Ollama 的本地模型等
- 向量数据库是可选的,但建议用于 RAG 功能

## 安全性

- 生产环境请修改默认密码
- 使用强 `SECRET_KEY`
- 生产环境在 Redis 上启用认证
- 生产环境考虑为 API 连接使用 TLS

## 许可证

Dify 采用 Apache License 2.0 许可。更多信息请参见 [Dify GitHub](https://github.com/langgenius/dify)。
