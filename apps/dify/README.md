# Dify

[English](./README.md) | [中文](./README.zh.md)

This service deploys Dify, an LLM app development platform that combines AI workflow, RAG pipeline, agent capabilities, model management, observability features and more.

## Services

- `dify-api`: API service for Dify
- `dify-worker`: Background worker for async tasks
- `dify-web`: Web frontend interface
- `dify-db`: PostgreSQL database
- `dify-redis`: Redis cache
- `dify-weaviate`: Weaviate vector database (optional profile)

## Environment Variables

| Variable Name      | Description                                | Default Value |
| ------------------ | ------------------------------------------ | ------------- |
| DIFY_VERSION       | Dify image version                         | `0.18.2`      |
| POSTGRES_USER      | PostgreSQL username                        | `dify`        |
| POSTGRES_PASSWORD  | PostgreSQL password                        | `difypass`    |
| POSTGRES_DB        | PostgreSQL database name                   | `dify`        |
| REDIS_PASSWORD     | Redis password (empty for no auth)         | `""`          |
| SECRET_KEY         | Secret key for encryption                  | (auto)        |
| LOG_LEVEL          | Log level                                  | `INFO`        |
| DIFY_PORT_OVERRIDE | Host port mapping for web interface        | `3000`        |
| STORAGE_TYPE       | Storage type (local, s3, azure-blob, etc.) | `local`       |
| VECTOR_STORE       | Vector store type (weaviate, milvus, etc.) | `weaviate`    |
| WEAVIATE_VERSION   | Weaviate version (if using weaviate)       | `1.28.12`     |

Please modify the `.env` file as needed for your use case.

## Volumes

- `dify_storage`: Storage for uploaded files and generated content
- `dify_db_data`: PostgreSQL data
- `dify_redis_data`: Redis persistence data
- `dify_weaviate_data`: Weaviate vector database data

## Usage

### Start Dify with Weaviate

```bash
docker compose --profile weaviate up -d
```

### Start Dify without Vector Database

```bash
docker compose up -d
```

### Access

- Web Interface: <http://localhost:3000>
- API Docs: <http://localhost:5001/docs>

### First Time Setup

1. Open <http://localhost:3000>
2. Create an admin account
3. Configure your LLM API keys (OpenAI, Azure OpenAI, Anthropic, etc.)
4. Start creating your AI applications

## Notes

- First startup may take a few minutes for database initialization
- Change `SECRET_KEY` in production for security
- For production deployment, consider using external PostgreSQL and Redis
- Supports multiple LLM providers: OpenAI, Azure OpenAI, Anthropic, Google, local models via Ollama, etc.
- Vector database is optional but recommended for RAG capabilities

## Security

- Change default passwords in production
- Use strong `SECRET_KEY`
- Enable authentication on Redis in production
- Consider using TLS for API connections in production

## License

Dify is licensed under Apache License 2.0. See [Dify GitHub](https://github.com/langgenius/dify) for more information.
