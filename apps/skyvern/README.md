# Skyvern

[English](./README.md) | [中文](./README.zh.md)

Quick start: <https://docs.skyvern.com>.

This service deploys Skyvern, an AI-powered browser automation platform that uses LLMs and computer vision to execute tasks in web browsers. It can fill forms, navigate websites, and complete multi-step workflows without custom scripts.

## Services

- **skyvern**: The Skyvern API server with embedded Playwright + Chromium.
- **skyvern-ui**: React-based web UI for task management and browser session viewing.
- **postgres**: PostgreSQL database for task history and state.

## Quick Start

1. Copy `.env.example` to `.env`:

   ```bash
   cp .env.example .env
   ```

2. Set your LLM API key and change the Skyvern API key in `.env`:

   ```
   SKYVERN_API_KEY=your-strong-api-key
   OPENAI_API_KEY=sk-...
   ```

3. Start the services:

   ```bash
   docker compose up -d
   ```

4. Open `http://localhost:8080` for the web UI, or send tasks to the API at `http://localhost:8000`.

## Core Environment Variables

| Variable                | Description                                                          | Default              |
| ----------------------- | -------------------------------------------------------------------- | -------------------- |
| `SKYVERN_VERSION`       | Image version (applies to both skyvern and skyvern-ui)               | `v1.0.31`            |
| `SKYVERN_PORT_OVERRIDE` | Host port for the API                                                | `8000`               |
| `SKYVERN_UI_PORT_OVERRIDE` | Host port for the web UI                                          | `8080`               |
| `SKYVERN_API_KEY`       | API key for authenticating requests to the Skyvern server — **CHANGEME** | placeholder      |
| `BROWSER_TYPE`          | Browser type: `chromium-headless`, `chromium`, or `chrome`           | `chromium-headless`  |
| `OPENAI_API_KEY`        | OpenAI API key (recommended for best results)                        | *(empty)*            |
| `ANTHROPIC_API_KEY`     | Anthropic API key (alternative to OpenAI)                            | *(empty)*            |
| `POSTGRES_PASSWORD`     | PostgreSQL password                                                  | `skyvern`            |
| `VITE_API_BASE_URL`     | Skyvern API URL as seen from the user's browser                      | `http://localhost:8000` |
| `VITE_WSS_BASE_URL`     | WebSocket URL for live session streaming                             | `ws://localhost:8000`   |

## Volumes

- `skyvern_artifacts`: Downloaded files and task artifacts.
- `skyvern_videos`: Browser session recordings.
- `skyvern_har`: HTTP Archive (HAR) files for debugging.
- `skyvern_postgres_data`: PostgreSQL data persistence.

## Ports

- **8000**: Skyvern REST API
- **8080**: Skyvern web UI

## Resource Requirements

| Service    | CPU Limit | Memory Limit |
| ---------- | --------- | ------------ |
| skyvern    | 2         | 4 GB         |
| skyvern-ui | 0.5       | 256 MB       |
| postgres   | 1         | 1 GB         |

The `skyvern` service includes Playwright and Chromium. Allocate **4+ GB RAM** and **2+ CPU cores** for reliable browser automation.

## Notes

- Database migrations run automatically on startup via Alembic.
- If deploying behind a reverse proxy, update `VITE_API_BASE_URL` and `VITE_WSS_BASE_URL` to your public domain.
- The `SKYVERN_API_KEY` must be included in API requests as the `x-api-key` header.

## Documentation

- [Skyvern Docs](https://docs.skyvern.com)
- [GitHub](https://github.com/Skyvern-AI/skyvern)
