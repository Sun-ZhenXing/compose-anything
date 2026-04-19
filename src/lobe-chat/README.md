# LobeChat

[English](./README.md) | [中文](./README.zh.md)

Quick start: <https://lobehub.com/docs>.

This service deploys LobeChat in standalone (serverless) mode — a modern, high-performance AI chat interface that supports multiple LLM providers, vision models, and plugin extensibility. No database is required; all state is stored client-side.

## Services

- `lobe-chat`: The LobeChat web application.

## Quick Start

```bash
docker compose up -d
```

Open `http://localhost:3210`. Configure your LLM API keys in the settings panel (gear icon), or set them as environment variables before starting.

## Configuration

| Variable               | Description                                              | Default    |
| ---------------------- | -------------------------------------------------------- | ---------- |
| `LOBE_CHAT_VERSION`    | Image version                                            | `1.143.3`  |
| `TZ`                   | Container timezone                                       | `UTC`      |
| `LOBE_CHAT_PORT_OVERRIDE` | Host port for the web UI                              | `3210`     |
| `ACCESS_CODE`          | Optional password to restrict access (empty = open)      | *(empty)*  |
| `OPENAI_API_KEY`       | OpenAI API key                                           | *(empty)*  |
| `OPENAI_PROXY_URL`     | Custom OpenAI-compatible API base URL                    | *(empty)*  |
| `ANTHROPIC_API_KEY`    | Anthropic API key                                        | *(empty)*  |
| `GOOGLE_API_KEY`       | Google Gemini API key                                    | *(empty)*  |
| `LOBE_CHAT_CPU_LIMIT`  | CPU limit                                                | `0.5`      |
| `LOBE_CHAT_MEMORY_LIMIT` | Memory limit                                           | `512M`     |

## Ports

- **3210**: Web UI

## Notes

- This is the **standalone** (client-side) mode. No PostgreSQL, S3, or auth server is needed.
- Conversation history is stored in the browser; clearing browser data loses history.
- For multi-user deployments with persistent server-side data, see the [LobeChat database mode docs](https://lobehub.com/docs/self-hosting/server-database).
- The health check uses the `/api/health` endpoint.
