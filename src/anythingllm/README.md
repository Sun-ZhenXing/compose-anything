# AnythingLLM

[English](./README.md) | [中文](./README.zh.md)

Quick start: <https://docs.anythingllm.com>.

This service deploys AnythingLLM, an all-in-one AI application that lets you chat with documents, use multiple LLM providers, and build custom AI agents — with a full RAG pipeline built in.

## Services

- `anythingllm`: The AnythingLLM web application.

## Quick Start

```bash
docker compose up -d
```

Open `http://localhost:3001` and complete the setup wizard to connect your LLM provider.

## Configuration

All LLM providers, vector databases, and agent settings are configured through the web UI after startup. No API keys are required in `.env` unless you want to pre-seed them via environment variables.

| Variable                      | Description                                     | Default  |
| ----------------------------- | ----------------------------------------------- | -------- |
| `ANYTHINGLLM_VERSION`         | Image version (`latest` — no stable tags exist) | `latest` |
| `TZ`                          | Container timezone                              | `UTC`    |
| `ANYTHINGLLM_PORT_OVERRIDE`   | Host port for the web UI                        | `3001`   |
| `ANYTHINGLLM_UID`             | UID for volume file ownership                   | `1000`   |
| `ANYTHINGLLM_GID`             | GID for volume file ownership                   | `1000`   |
| `ANYTHINGLLM_CPU_LIMIT`       | CPU limit                                       | `2`      |
| `ANYTHINGLLM_MEMORY_LIMIT`    | Memory limit                                    | `2G`     |
| `ANYTHINGLLM_CPU_RESERVATION` | CPU reservation                                 | `0.5`    |
| `ANYTHINGLLM_MEMORY_LIMIT`    | Memory reservation                              | `512M`   |

## Volumes

- `anythingllm_storage`: Persists all application data, uploaded documents, embeddings, and settings.

## Ports

- **3001**: Web UI

## Notes

- The `mintplexlabs/anythingllm` image does not publish stable semantic version tags; `latest` is the only reliable tag.
- Supports OpenAI, Anthropic, Ollama, LM Studio, and many other LLM backends — all configured from the UI.
- The health check uses the `/api/ping` endpoint.
