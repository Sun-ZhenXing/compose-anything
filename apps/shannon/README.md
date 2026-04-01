# Shannon

[English](./README.md) | [中文](./README.zh.md)

This service deploys [Shannon](https://github.com/Kocoro-lab/Shannon), a production-oriented multi-agent orchestration framework. Shannon provides time-travel debugging via Temporal workflows, hard token budgets per task/agent, real-time observability dashboards, WASI sandbox for secure code execution, OPA policy governance, and multi-tenant isolation — all with native support for OpenAI, Anthropic, Google, DeepSeek, and local models.

> **Note:** The `agent-core` service is only built for `linux/amd64`. On Apple Silicon (ARM64), Docker Desktop uses Rosetta emulation automatically.

## Services

- **gateway**: HTTP API gateway — primary entry point for all client requests (port `8080`)
- **orchestrator**: Core workflow orchestration engine powered by Temporal
- **llm-service**: LLM provider abstraction with model routing, fallback, and budget control
- **agent-core**: Rust-based agent execution runtime with WASI sandbox support
- **postgres**: PostgreSQL with pgvector extension for state and vector storage
- **redis**: Redis for caching, job queues, and rate limiting
- **qdrant**: Qdrant vector database for semantic memory
- **temporal**: Temporal workflow engine for durable, fault-tolerant task execution
- **temporal-ui**: Temporal Web UI for workflow debugging (enabled via `metrics` profile)

## Quick Start

### Prerequisites

- Docker & Docker Compose v2
- `curl` (for the setup script)
- At least one LLM API key (OpenAI, Anthropic, Google, etc.)

### 1. Run Setup

```bash
make setup
```

This downloads the required `config/models.yaml` and `config/features.yaml` from the Shannon repository and creates a local `.env` file.

### 2. Add Your LLM API Key

Edit `.env` and set at least one LLM provider key:

```env
# Choose at least one:
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
```

Also update `JWT_SECRET` and set `GATEWAY_SKIP_AUTH=0` for production deployments.

### 3. Start Services

```bash
make up
```

Access the Shannon API at `http://localhost:8080`.

### 4. (Optional) Enable Temporal UI Dashboard

To also start the Temporal workflow debugging UI:

```bash
make up-monitoring
```

Access Temporal UI at `http://localhost:8088`.

## Core Environment Variables

| Variable                    | Description                                | Default                                        |
| --------------------------- | ------------------------------------------ | ---------------------------------------------- |
| `SHANNON_VERSION`           | Version for all Shannon service images     | `v0.3.1`                                       |
| `OPENAI_API_KEY`            | OpenAI API key (at least one key required) | ``                                             |
| `ANTHROPIC_API_KEY`         | Anthropic API key                          | ``                                             |
| `GOOGLE_API_KEY`            | Google AI API key                          | ``                                             |
| `JWT_SECRET`                | Secret for JWT token signing               | `development-only-secret-change-in-production` |
| `GATEWAY_SKIP_AUTH`         | Skip auth (set to `0` to enable in prod)   | `1`                                            |
| `GATEWAY_PORT_OVERRIDE`     | Host port for the API gateway              | `8080`                                         |
| `TEMPORAL_UI_PORT_OVERRIDE` | Host port for the Temporal UI              | `8088`                                         |

## Database Configuration

| Variable            | Description              | Default      |
| ------------------- | ------------------------ | ------------ |
| `POSTGRES_VERSION`  | pgvector image tag       | `pg16`       |
| `POSTGRES_USER`     | PostgreSQL username      | `shannon`    |
| `POSTGRES_PASSWORD` | PostgreSQL password      | `shannon`    |
| `POSTGRES_DB`       | PostgreSQL database name | `shannon`    |
| `REDIS_VERSION`     | Redis image tag          | `7.2-alpine` |
| `QDRANT_VERSION`    | Qdrant image tag         | `v1.17`      |

## Agent Configuration

| Variable                   | Description                            | Default   |
| -------------------------- | -------------------------------------- | --------- |
| `DEFAULT_MODEL_TIER`       | Default model complexity tier          | `small`   |
| `SHANNON_USE_WASI_SANDBOX` | Enable WASI sandbox for code execution | `1`       |
| `WASI_MEMORY_LIMIT_MB`     | Memory limit for WASI sandbox (MB)     | `512`     |
| `WASI_TIMEOUT_SECONDS`     | Execution timeout for WASI sandbox     | `60`      |
| `TEMPORAL_NAMESPACE`       | Temporal namespace for workflows       | `default` |

## Observability (Optional)

| Variable                      | Description                  | Default |
| ----------------------------- | ---------------------------- | ------- |
| `OTEL_ENABLED`                | Enable OpenTelemetry tracing | `false` |
| `OTEL_EXPORTER_OTLP_ENDPOINT` | OTLP collector endpoint      | ``      |

## Security Notes

- By default, `GATEWAY_SKIP_AUTH=1` disables JWT authentication for easy local development.
- **For production**, set `GATEWAY_SKIP_AUTH=0` and use a strong `JWT_SECRET`.
- Passwords in `.env.example` are for local development only — always change them before deploying to a shared or public environment.

## Configuration Files

Shannon uses YAML configuration files under `./config/`:

- `config/models.yaml` — LLM providers, model tiers, pricing, and routing rules
- `config/features.yaml` — Feature flags, execution modes, and workflow settings

These are downloaded from the official Shannon repository by `make setup` and can be customized as needed.

## License

Shannon is licensed under the [Apache 2.0 License](https://github.com/Kocoro-lab/Shannon/blob/main/LICENSE).
