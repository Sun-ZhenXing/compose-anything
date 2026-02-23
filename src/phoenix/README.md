# Arize Phoenix

[English](./README.md) | [中文](./README.zh.md)

Arize Phoenix is an open-source AI observability platform for LLM applications. It provides tracing, evaluation, datasets, and experiments to help you build and improve AI applications.

## Services

- `phoenix`: The main Phoenix application server (SQLite version).
- `phoenix-pg`: The Phoenix application server configured for PostgreSQL (requires `postgres` profile).
- `phoenix-db`: PostgreSQL database for persistent storage (requires `postgres` profile).

## Profiles

This project supports two modes of operation via Docker Compose profiles:

1. **sqlite** (Default): Uses SQLite for storage. Simple and good for local development.
   Set `COMPOSE_PROFILES=sqlite` in `.env`.
2. **postgres** (or **pg**): Uses PostgreSQL for storage. Recommended for production.
   Set `COMPOSE_PROFILES=postgres` in `.env`.

## Ports

| Port | Protocol | Description                               |
| ---- | -------- | ----------------------------------------- |
| 6006 | HTTP     | UI and OTLP HTTP collector (`/v1/traces`) |
| 4317 | gRPC     | OTLP gRPC collector                       |
| 9090 | HTTP     | Prometheus metrics (optional)             |

## Environment Variables

| Variable Name                    | Description                              | Default Value     |
| -------------------------------- | ---------------------------------------- | ----------------- |
| COMPOSE_PROFILES                 | Active profiles (`sqlite` or `postgres`) | `sqlite`          |
| PHOENIX_VERSION                  | Phoenix image version                    | `12.35.0-nonroot` |
| PHOENIX_PORT_OVERRIDE            | Host port for Phoenix UI and HTTP API    | `6006`            |
| PHOENIX_GRPC_PORT_OVERRIDE       | Host port for OTLP gRPC collector        | `4317`            |
| PHOENIX_PROMETHEUS_PORT_OVERRIDE | Host port for Prometheus metrics         | `9090`            |
| PHOENIX_ENABLE_PROMETHEUS        | Enable Prometheus metrics endpoint       | `false`           |
| PHOENIX_SECRET                   | Secret for authentication (optional)     | `""`              |
| POSTGRES_VERSION                 | PostgreSQL image version                 | `17.2-alpine3.21` |
| POSTGRES_USER                    | PostgreSQL username                      | `postgres`        |
| POSTGRES_PASSWORD                | PostgreSQL password                      | `postgres`        |
| POSTGRES_DB                      | PostgreSQL database name                 | `phoenix`         |

## Volumes

- `phoenix_data`: Data volume for SQLite mode (mounted to `/data`).
- `phoenix_db_data`: Data volume for PostgreSQL mode.

## Getting Started

1. Copy the example environment file:

   ```bash
   cp .env.example .env
   ```

2. Select your deployment mode by editing `.env` (default is `sqlite`).

   **For SQLite (Default):**
   Ensure `.env` contains:

   ```dotenv
   COMPOSE_PROFILES=sqlite
   ```

   **For PostgreSQL:**
   Change `.env` to:

   ```dotenv
   COMPOSE_PROFILES=postgres
   ```

3. Start the services:

   ```bash
   docker compose up -d
   ```

4. Access Phoenix UI at `http://localhost:6006`

## Sending Traces

Phoenix supports OpenTelemetry-compatible traces. You can send traces using:

### HTTP (OTLP)

Send traces to `http://localhost:6006/v1/traces`

### gRPC (OTLP)

Send traces to `localhost:4317`

### Python Example

```python
from phoenix.otel import register

tracer_provider = register(
    project_name="my-llm-app",
    endpoint="http://localhost:6006/v1/traces",
)
```

## Features

- **Tracing**: Capture and visualize LLM application traces with OpenTelemetry support.
- **Evaluation**: Run evaluations using built-in or custom evaluators.
- **Datasets**: Create and manage datasets for testing and evaluation.
- **Experiments**: Run experiments to compare model performance.
- **Playground**: Test prompts with different models interactively.

## Documentation

For more information, visit the [official Phoenix documentation](https://docs.arize.com/phoenix).

## Security Notes

- Change default PostgreSQL password in production.
- Set `PHOENIX_SECRET` for authentication if exposing Phoenix publicly.
- Consider using a reverse proxy with SSL/TLS in production.
- Regularly backup the PostgreSQL database.
