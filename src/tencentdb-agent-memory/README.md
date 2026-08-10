# TencentDB Agent Memory

[English](./README.md) | [中文](./README.zh.md)

This service deploys TencentDB Agent Memory, a layered long-term memory system for AI agents built by Tencent Cloud. It gives agents persistent, structured memory across four abstraction levels — conversation → atomic facts → scenes → persona — plus symbolic short-term memory via context offloading. Data persists to an embedded SQLite + sqlite-vec database and local Markdown files.

The service contains no LLM itself: it consumes an external OpenAI-compatible LLM API, so an API key is required.

## Services

- `tencentdb-agent-memory`: The memory Gateway (port 8420), running in standalone mode with an embedded SQLite database. No external database or Redis is required.

## Quick Start

```bash
cp .env.example .env
# Set TDAI_LLM_API_KEY in .env (required - the service has no model of its own)
docker compose up -d
```

The gateway is an API service, not a web UI. Verify it is running:

```bash
curl http://localhost:8420/health
```

Expected response: `{"status":"ok",...}`.

## Environment Variables

| Variable Name              | Description                                                                 | Default Value                   |
| -------------------------- | --------------------------------------------------------------------------- | ------------------------------- |
| `GLOBAL_REGISTRY`          | Global registry prefix for all images                                       | `""`                            |
| `TDAI_MEMORY_VERSION`      | Image version                                                               | `1.0.0`                         |
| `TDAI_LLM_API_KEY`         | LLM API key (required, no default; any OpenAI-compatible provider)          | `""`                            |
| `TDAI_LLM_BASE_URL`        | Base URL of the OpenAI-compatible LLM API                                   | `https://api.openai.com/v1`     |
| `TDAI_LLM_MODEL`           | LLM model name                                                              | `gpt-4o`                        |
| `TDAI_LLM_MAX_TOKENS`      | Maximum tokens per LLM request                                              | `4096`                          |
| `TDAI_GATEWAY_API_KEY`     | Optional Bearer auth token for the gateway API (empty = open access)        | `""`                            |
| `TDAI_MEMORY_PORT_OVERRIDE`| Host port mapping (maps to gateway port 8420 in the container)              | `8420`                          |
| `TZ`                       | Timezone                                                                    | `UTC`                           |
| `TDAI_MEMORY_CPU_LIMIT`    | CPU limit                                                                   | `1.00`                          |
| `TDAI_MEMORY_CPU_RESERVATION` | CPU reservation                                                          | `0.10`                          |
| `TDAI_MEMORY_LIMIT`        | Memory limit                                                                | `1G`                            |
| `TDAI_MEMORY_RESERVATION`  | Memory reservation                                                          | `256M`                          |

Set `TDAI_LLM_BASE_URL` to your provider, e.g. `https://api.deepseek.com/v1` or `https://api.lkeap.cloud.tencent.com/v1`.

Please modify the `.env` file as needed for your use case.

## Storage

- `tdai_memory_data`: A named volume mounted at `/data/tdai-memory` holding the embedded database and Markdown files: `vectors.db`, `conversations/`, `records/`, `scene_blocks/`, and `persona.md`.

## Security Notes

- `TDAI_LLM_API_KEY` is required — the service has no bundled model and cannot function without an LLM API key.
- The gateway API is open by default (no auth). Set `TDAI_GATEWAY_API_KEY` to a random long string when the gateway is exposed to a network. The `/health` endpoint is always open.
- Check the project license before redistribution: the default branch `README.docker.md` states a proprietary Tencent Cloud license while the main branch is MIT.

## Integration

TencentDB Agent Memory is designed for integration with agent frameworks, e.g. the OpenClaw plugin and the Hermes provider.

## License

This service folder is provided under the repository's license. TencentDB Agent Memory itself — verify its license before redistribution (see Security Notes).
