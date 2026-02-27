# Opik

[English](./README.md) | [中文](./README.zh.md)

This service deploys [Opik](https://github.com/comet-ml/opik), an open-source platform for LLM observability, evaluation, and optimization. Opik helps you debug, evaluate, and monitor your LLM applications, RAG systems, and agentic workflows with comprehensive tracing, automated evaluations, and production-ready dashboards.

## Services

- **frontend**: Opik web UI (Nginx)
- **backend**: Main Opik backend API service (Java/Dropwizard)
- **python-backend**: Python backend for code execution and AI features
- **mysql**: MySQL database for state persistence
- **clickhouse**: ClickHouse analytics database for trace storage
- **redis**: Redis for caching and job queues
- **zookeeper**: ZooKeeper for ClickHouse coordination
- **minio**: S3-compatible object storage for attachments

## Quick Start

1. Copy `.env.example` to `.env`:

   ```bash
   cp .env.example .env
   ```

2. Update critical secrets in `.env` (optional for local development):

   ```bash
   # Generate secure passwords if needed
   MYSQL_ROOT_PASSWORD=your-secure-password
   MYSQL_PASSWORD=your-secure-password
   REDIS_PASSWORD=your-secure-password
   CLICKHOUSE_PASSWORD=your-secure-password
   MINIO_ROOT_PASSWORD=your-secure-password
   ```

3. Start the services:

   ```bash
   docker compose up -d
   ```

4. Access Opik at `http://localhost:5173`

## Core Environment Variables

| Variable                        | Description                      | Default   |
| ------------------------------- | -------------------------------- | --------- |
| `OPIK_VERSION`                  | Opik container image version     | `1.10.23` |
| `OPIK_PORT_OVERRIDE`            | Web UI port                      | `5173`    |
| `OPIK_BACKEND_PORT_OVERRIDE`    | Backend API port                 | `3003`    |
| `OPIK_USAGE_REPORT_ENABLED`     | Enable anonymous usage reporting | `true`    |
| `TOGGLE_WELCOME_WIZARD_ENABLED` | Show welcome wizard on first run | `true`    |

## Database Configuration

| Variable              | Description              | Default            |
| --------------------- | ------------------------ | ------------------ |
| `MYSQL_VERSION`       | MySQL version            | `8.4.2`            |
| `MYSQL_ROOT_PASSWORD` | MySQL root password      | `opik`             |
| `MYSQL_DATABASE`      | MySQL database name      | `opik`             |
| `MYSQL_USER`          | MySQL username           | `opik`             |
| `MYSQL_PASSWORD`      | MySQL password           | `opik`             |
| `CLICKHOUSE_VERSION`  | ClickHouse version       | `25.3.6.56-alpine` |
| `CLICKHOUSE_DB`       | ClickHouse database name | `opik`             |
| `CLICKHOUSE_USER`     | ClickHouse username      | `opik`             |
| `CLICKHOUSE_PASSWORD` | ClickHouse password      | `opik`             |

## Storage & Cache Configuration

| Variable                      | Description          | Default            |
| ----------------------------- | -------------------- | ------------------ |
| `REDIS_VERSION`               | Redis version        | `7.2.4-alpine3.19` |
| `REDIS_PASSWORD`              | Redis password       | `opik`             |
| `MINIO_ROOT_USER`             | MinIO admin username | `opikminio`        |
| `MINIO_ROOT_PASSWORD`         | MinIO admin password | `opikminio123`     |
| `MINIO_PORT_OVERRIDE`         | MinIO API port       | `9000`             |
| `MINIO_CONSOLE_PORT_OVERRIDE` | MinIO console port   | `9090`             |

## AI Features Configuration (Optional)

| Variable                    | Description                        | Default |
| --------------------------- | ---------------------------------- | ------- |
| `TOGGLE_OPIK_AI_ENABLED`    | Enable Opik AI features            | `false` |
| `TOGGLE_GUARDRAILS_ENABLED` | Enable guardrails                  | `false` |
| `OPENAI_API_KEY`            | OpenAI API key for AI features     | ``      |
| `ANTHROPIC_API_KEY`         | Anthropic API key for AI features  | ``      |
| `OPENROUTER_API_KEY`        | OpenRouter API key for AI features | ``      |

## Python Backend Configuration

| Variable                                    | Description                                 | Default   |
| ------------------------------------------- | ------------------------------------------- | --------- |
| `PYTHON_CODE_EXECUTOR_STRATEGY`             | Code execution strategy (process/container) | `process` |
| `PYTHON_CODE_EXECUTOR_CONTAINERS_NUM`       | Number of executor containers               | `5`       |
| `PYTHON_CODE_EXECUTOR_EXEC_TIMEOUT_IN_SECS` | Code execution timeout                      | `3`       |
| `PYTHON_CODE_EXECUTOR_ALLOW_NETWORK`        | Allow network access in code execution      | `false`   |
| `OPTSTUDIO_MAX_CONCURRENT_JOBS`             | Max concurrent optimization jobs            | `5`       |
| `OPTSTUDIO_LOG_LEVEL`                       | Optimization studio log level               | `INFO`    |
| `OPTSTUDIO_LLM_MAX_TOKENS`                  | Max tokens for LLM calls                    | `8192`    |

## Volumes

- `mysql_data`: MySQL database files
- `redis_data`: Redis persistence data
- `zookeeper_data`: ZooKeeper data
- `clickhouse_data`: ClickHouse data files
- `clickhouse_logs`: ClickHouse logs
- `clickhouse_config`: ClickHouse configuration
- `minio_data`: MinIO object storage data

## Resource Limits

All services have configurable CPU and memory limits:

| Service        | CPU Limit | Memory Limit |
| -------------- | --------- | ------------ |
| frontend       | 0.5       | 512M         |
| backend        | 2.0       | 2G           |
| python-backend | 1.0       | 1G           |
| mysql          | 1.0       | 1G           |
| clickhouse     | 2.0       | 4G           |
| redis          | 0.5       | 512M         |
| zookeeper      | 0.5       | 1G           |
| minio          | 1.0       | 1G           |

## SDK Configuration

To use the Opik Python SDK with this local deployment:

```python
import opik

# Configure for local deployment
opik.configure(use_local=True)

# Or set environment variables
import os
os.environ["OPIK_URL_OVERRIDE"] = "http://localhost:5173/api"
os.environ["OPIK_API_KEY"] = ""  # Leave empty for local deployment

# Start tracing
@opik.track
def my_llm_function(user_question: str) -> str:
    # Your LLM code here
    return "Hello"
```

## Documentation

- [Opik Documentation](https://www.comet.com/docs/opik/)
- [Python SDK Reference](https://www.comet.com/docs/opik/python-sdk-reference/)
- [GitHub Repository](https://github.com/comet-ml/opik)

## License

Opik is licensed under the Apache 2.0 License.
