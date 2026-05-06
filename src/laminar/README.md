# Laminar

[English](./README.md) | [中文](./README.zh.md)

Laminar is an open-source observability platform purpose-built for AI agents. It provides tracing, evaluations, AI monitoring, SQL access to data, dashboards, and data annotation capabilities.

## Features

- **Tracing**: OpenTelemetry-native powerful tracing SDK - 1 line of code to automatically trace Vercel AI SDK, Browser Use, Stagehand, LangChain, OpenAI, Anthropic, Gemini, and more.
- **Evals**: Unopinionated, extensible SDK and CLI for running evals locally or in CI/CD pipeline.
- **AI Monitoring**: Define events with natural language descriptions to track issues and custom behavior.
- **SQL Access**: Query traces, metrics, and events with a built-in SQL editor.
- **Dashboards**: Powerful dashboard builder for traces, metrics, and events.
- **Data Annotation**: Custom data rendering UI for fast data annotation and dataset creation.
- **High Performance**: Written in Rust with custom realtime engine and ultra-fast full-text search.

## Services

| Service        | Description                                     | Port      |
| -------------- | ----------------------------------------------- | --------- |
| `frontend`     | Laminar web UI and Next.js application          | 5667      |
| `app-server`   | Rust backend server (HTTP API, gRPC, Real-time) | 8000-8002 |
| `postgres`     | PostgreSQL database for persistent storage      | -         |
| `clickhouse`   | ClickHouse for high-performance analytics       | -         |
| `quickwit`     | Quickwit for full-text search                   | 7280      |
| `query-engine` | Query engine for data processing                | 8903      |

## Ports

| Port | Protocol | Description              |
| ---- | -------- | ------------------------ |
| 5667 | HTTP     | Laminar Web UI           |
| 8000 | HTTP     | App Server HTTP API      |
| 8001 | gRPC     | App Server gRPC          |
| 8002 | HTTP     | App Server Real-time API |
| 7280 | HTTP     | Quickwit REST API and UI |
| 8903 | HTTP     | Query Engine API         |

## Environment Variables

| Variable                                | Description                          | Default                              |
| --------------------------------------- | ------------------------------------ | ------------------------------------ |
| `LAMINAR_POSTGRES_VERSION`              | PostgreSQL image version             | `16-alpine`                          |
| `LAMINAR_POSTGRES_USER`                 | PostgreSQL username                  | `postgres`                           |
| `LAMINAR_POSTGRES_PASSWORD`             | PostgreSQL password                  | `change_me_in_production`            |
| `LAMINAR_CLICKHOUSE_VERSION`            | ClickHouse image version             | `latest`                             |
| `LAMINAR_CLICKHOUSE_USER`               | ClickHouse username                  | `clickhouse`                         |
| `LAMINAR_CLICKHOUSE_PASSWORD`           | ClickHouse password                  | `change_me_in_production`            |
| `LAMINAR_SHARED_SECRET_TOKEN`           | Shared secret for inter-service auth | `shared_secret_change_in_production` |
| `LAMINAR_AEAD_SECRET_KEY`               | AEAD encryption key (64 hex chars)   | -                                    |
| `LAMINAR_OPENAI_API_KEY`                | OpenAI API key (optional)            | -                                    |
| `LAMINAR_GOOGLE_GENERATIVE_AI_API_KEY`  | Google AI key for Signals feature    | -                                    |
| `LAMINAR_FRONTEND_PORT_OVERRIDE`        | Host port for Web UI                 | `5667`                               |
| `LAMINAR_APP_SERVER_PORT_OVERRIDE`      | Host port for HTTP API               | `8000`                               |
| `LAMINAR_APP_SERVER_GRPC_PORT_OVERRIDE` | Host port for gRPC                   | `8001`                               |
| `LAMINAR_APP_SERVER_RT_PORT_OVERRIDE`   | Host port for Real-time API          | `8002`                               |

## Volumes

- `laminar_postgres_data`: PostgreSQL data
- `laminar_clickhouse_data`: ClickHouse data
- `laminar_clickhouse_logs`: ClickHouse logs
- `laminar_quickwit_data`: Quickwit data

## Quick Start

1. Copy the example environment file:

   ```bash
   cp .env.example .env
   ```

2. Edit `.env` and set required secrets:

   ```dotenv
   LAMINAR_POSTGRES_PASSWORD=your_secure_password
   LAMINAR_CLICKHOUSE_PASSWORD=your_secure_password
   LAMINAR_SHARED_SECRET_TOKEN=your_shared_secret
   LAMINAR_AEAD_SECRET_KEY=your_64_character_hex_key
   ```

   To generate a secure AEAD key:
   ```bash
   openssl rand -hex 32
   ```

3. Start the services:

   ```bash
   docker compose up -d
   ```

4. Access the UI at http://localhost:5667

## Enabling AI Monitoring (Signals)

To enable the Signals feature, set your Google Generative AI API key:

```dotenv
LAMINAR_GOOGLE_GENERATIVE_AI_API_KEY=your_key_here
```

## SDK Configuration

When using Laminar SDK with self-hosted instance:

**Python:**
```python
from lmnr import Laminar
Laminar.initialize(
    project_api_key="<LMNR_PROJECT_API_KEY>",
    base_url="http://localhost:8000"
)
```

**TypeScript:**
```typescript
import { Laminar } from '@lmnr-ai/lmnr';
Laminar.initialize({
    projectApiKey: process.env.LMNR_PROJECT_API_KEY,
    baseUrl: "http://localhost:8000"
});
```

## Documentation

For full documentation, visit: https://laminar.sh/docs

## Resource Requirements

Minimum recommended resources:

| Service      | CPU  | Memory |
| ------------ | ---- | ------ |
| frontend     | 0.25 | 256M   |
| app-server   | 0.5  | 512M   |
| postgres     | 0.25 | 256M   |
| clickhouse   | 0.5  | 512M   |
| quickwit     | 0.25 | 256M   |
| query-engine | 0.25 | 128M   |

Total minimum: ~2 CPU cores, ~2GB RAM

For production use, increase ClickHouse and PostgreSQL resources based on data volume.
