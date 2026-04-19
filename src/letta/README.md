# Letta

[English](./README.md) | [中文](./README.zh.md)

Quick start: <https://docs.letta.com>.

This service deploys Letta (formerly MemGPT), a framework for building stateful AI agents with long-term memory, persistent state, and tool use. Letta exposes a REST API for creating and managing agents programmatically.

## Services

- `letta`: The Letta agent server.

## Quick Start

```bash
docker compose up -d
```

The Letta REST API will be available at `http://localhost:8283`. You can interact with it via the [Letta Python SDK](https://github.com/letta-ai/letta) or the [ADE web interface](https://app.letta.com).

To connect a local LLM (Ollama), set `OLLAMA_BASE_URL` in your `.env` file before starting.

## Configuration

| Variable               | Description                                              | Default  |
| ---------------------- | -------------------------------------------------------- | -------- |
| `LETTA_VERSION`        | Image version                                            | `0.16.7` |
| `TZ`                   | Container timezone                                       | `UTC`    |
| `LETTA_PORT_OVERRIDE`  | Host port for the REST API                               | `8283`   |
| `OPENAI_API_KEY`       | OpenAI API key (optional)                                | *(empty)*|
| `ANTHROPIC_API_KEY`    | Anthropic API key (optional)                             | *(empty)*|
| `GROQ_API_KEY`         | Groq API key (optional)                                  | *(empty)*|
| `OLLAMA_BASE_URL`      | Ollama base URL, e.g. `http://host.docker.internal:11434`| *(empty)*|
| `LETTA_CPU_LIMIT`      | CPU limit                                                | `1`      |
| `LETTA_MEMORY_LIMIT`   | Memory limit                                             | `1G`     |
| `LETTA_CPU_RESERVATION`| CPU reservation                                          | `0.25`   |

## Volumes

- `letta_data`: Persists agent state, memory, and configuration at `/root/.letta`.

## Ports

- **8283**: REST API

## Notes

- At least one LLM provider API key (or `OLLAMA_BASE_URL`) is required to create functioning agents.
- The health check uses the `/health` endpoint.
