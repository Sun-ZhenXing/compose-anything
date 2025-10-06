# Bytebot

[English](./README.md) | [中文](./README.zh.md)

This service deploys Bytebot, an open-source AI desktop agent that automates computer tasks.

## Services

- `bytebot-desktop`: Containerized Linux desktop environment
- `bytebot-agent`: AI agent for task processing
- `bytebot-ui`: Web interface for task management
- `bytebot-db`: PostgreSQL database

## Environment Variables

| Variable Name                 | Description                    | Default Value |
| ----------------------------- | ------------------------------ | ------------- |
| BYTEBOT_VERSION               | Bytebot image version          | `edge`        |
| POSTGRES_VERSION              | PostgreSQL version             | `17-alpine`   |
| POSTGRES_USER                 | PostgreSQL username            | `bytebot`     |
| POSTGRES_PASSWORD             | PostgreSQL password            | `bytebotpass` |
| POSTGRES_DB                   | PostgreSQL database name       | `bytebot`     |
| ANTHROPIC_API_KEY             | Anthropic API key (for Claude) | `""`          |
| OPENAI_API_KEY                | OpenAI API key (for GPT)       | `""`          |
| GEMINI_API_KEY                | Google Gemini API key          | `""`          |
| BYTEBOT_DESKTOP_PORT_OVERRIDE | Desktop port override          | `9990`        |
| BYTEBOT_AGENT_PORT_OVERRIDE   | Agent port override            | `9991`        |
| BYTEBOT_UI_PORT_OVERRIDE      | UI port override               | `9992`        |

At least one AI API key is required.

## Volumes

- `bytebot_db_data`: PostgreSQL data

## Usage

### Start Bytebot

```bash
docker compose up -d
```

### Access

- Web UI: <http://localhost:9992>
- Agent API: <http://localhost:9991>
- Desktop VNC: <http://localhost:9990/vnc>

### Create Tasks

1. Open <http://localhost:9992>
2. Create a new task with natural language description
3. Watch the agent work in the desktop environment

## Features

- Natural language task automation
- Visual desktop environment with VNC
- Supports multiple AI models (Claude, GPT, Gemini)
- Web-based task management interface

## Notes

- Requires at least one AI API key to function
- Desktop environment uses shared memory (2GB)
- First startup may take a few minutes
- Suitable for development and testing

## Security

- Change default database password in production
- Keep AI API keys secure
- Consider using environment files instead of command-line arguments

## License

Bytebot is licensed under Apache License 2.0. See [Bytebot GitHub](https://github.com/bytebot-ai/bytebot) for more information.
