# GoModel

[GoModel](https://github.com/ENTERPILOT/GoModel) is a fast, lightweight AI gateway written in Go. It exposes a single unified OpenAI-compatible API that transparently routes requests to OpenAI, Anthropic, Gemini, Groq, xAI, DeepSeek, OpenRouter, Azure OpenAI, Oracle, Ollama, vLLM, and more. It ships a built-in admin dashboard with token usage tracking, cost estimation, audit logging, and response caching.

## Services

| Service | Port | Description                                          |
| ------- | ---- | ---------------------------------------------------- |
| GoModel | 8080 | OpenAI-compatible AI gateway API and admin dashboard |

## Quick Start

```bash
docker compose up -d
```

The gateway is available at `http://localhost:8080`. By default it starts in open (unauthenticated) mode with SQLite storage and no provider keys configured.

To route real traffic, create a `.env` file from the example and add at least one provider credential:

```bash
cp .env.example .env
# Edit .env — set GOMODEL_MASTER_KEY and at least one provider API key
docker compose up -d
```

Make your first API call:

```bash
curl http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <GOMODEL_MASTER_KEY>" \
  -d '{
    "model": "gpt-4o",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

Admin dashboard: `http://localhost:8080/admin/dashboard`

List available models: `http://localhost:8080/v1/models`

## Key Environment Variables

### Gateway

| Variable                  | Default   | Description                                                        |
| ------------------------- | --------- | ------------------------------------------------------------------ |
| `GOMODEL_VERSION`         | `0.1.25`  | Docker image version                                               |
| `GOMODEL_PORT_OVERRIDE`   | `8080`    | Host port for the API                                              |
| `GOMODEL_MASTER_KEY`      | _(empty)_ | API authentication key — **set this for any non-local deployment** |
| `GOMODEL_STORAGE_TYPE`    | `sqlite`  | Storage backend: `sqlite`, `postgresql`, or `mongodb`              |
| `GOMODEL_LOGGING_ENABLED` | `false`   | Enable full audit logging of requests and responses                |
| `TZ`                      | `UTC`     | Container timezone                                                 |

### Provider Credentials

Set the keys for whichever providers you want to use. Unset entries are silently ignored.

| Variable                             | Provider                      |
| ------------------------------------ | ----------------------------- |
| `OPENAI_API_KEY`                     | OpenAI                        |
| `ANTHROPIC_API_KEY`                  | Anthropic                     |
| `GEMINI_API_KEY`                     | Google Gemini                 |
| `GROQ_API_KEY`                       | Groq                          |
| `XAI_API_KEY`                        | xAI (Grok)                    |
| `DEEPSEEK_API_KEY`                   | DeepSeek                      |
| `OPENROUTER_API_KEY`                 | OpenRouter                    |
| `ZAI_API_KEY`                        | Z.ai                          |
| `AZURE_API_KEY` + `AZURE_BASE_URL`   | Azure OpenAI                  |
| `ORACLE_API_KEY` + `ORACLE_BASE_URL` | Oracle                        |
| `OLLAMA_BASE_URL`                    | Ollama (local, no key needed) |
| `VLLM_BASE_URL`                      | vLLM (local, key optional)    |

See `.env.example` for the full list including Azure, Oracle, and per-provider model lists.

## Storage

| Volume          | Mount         | Description                                |
| --------------- | ------------- | ------------------------------------------ |
| `gomodel_data`  | `/app/data`   | SQLite database, usage, and audit log data |
| `gomodel_cache` | `/app/.cache` | Model metadata registry cache              |

The default storage backend is SQLite (`/app/data/gomodel.db`). Switch to PostgreSQL or MongoDB by setting `GOMODEL_STORAGE_TYPE` and the corresponding `POSTGRES_URL` or `MONGODB_URL` environment variable.

## API Endpoints

| Endpoint                    | Description                                         |
| --------------------------- | --------------------------------------------------- |
| `GET /v1/models`            | List available models from all configured providers |
| `POST /v1/chat/completions` | Chat completions (streaming supported)              |
| `POST /v1/embeddings`       | Text embeddings                                     |
| `POST /v1/responses`        | OpenAI Responses API                                |
| `GET /health`               | Health probe                                        |
| `GET /admin/dashboard`      | Admin UI — usage, costs, audit log                  |
| `GET /metrics`              | Prometheus metrics (when `METRICS_ENABLED=true`)    |

## Security Notes

- **`GOMODEL_MASTER_KEY` is unset by default.** Without it, all API endpoints are publicly accessible. Set a strong secret before exposing the service on any network beyond localhost.
- The container runs as a non-root user (UID 65532) on a read-only root filesystem.
- `cap_drop: [ALL]` — no Linux capabilities required.
- Never pass API keys via the command line; use the `.env` file or environment variables.
- Audit log bodies (`LOGGING_LOG_BODIES`) may capture PII and API keys embedded in prompts — keep it disabled unless you control the data retention pipeline.

## Links

- [GitHub Repository](https://github.com/ENTERPILOT/GoModel)
- [Documentation](https://gomodel.enterpilot.io/docs)
- [Docker Hub](https://hub.docker.com/r/enterpilot/gomodel)
