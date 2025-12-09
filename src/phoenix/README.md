# Arize Phoenix

[English](./README.md) | [中文](./README.zh.md)

Arize Phoenix is an open-source AI observability platform for LLM applications. It provides tracing, evaluation, datasets, and experiments to help you build and improve AI applications.

## Services

- `phoenix`: The main Phoenix application server with UI and OpenTelemetry collectors.
- `phoenix-db`: PostgreSQL database for persistent storage.

## Ports

| Port | Protocol | Description                               |
| ---- | -------- | ----------------------------------------- |
| 6006 | HTTP     | UI and OTLP HTTP collector (`/v1/traces`) |
| 4317 | gRPC     | OTLP gRPC collector                       |

## Environment Variables

| Variable Name              | Description                           | Default Value     |
| -------------------------- | ------------------------------------- | ----------------- |
| PHOENIX_VERSION            | Phoenix image version                 | `version-12.19.0` |
| PHOENIX_PORT_OVERRIDE      | Host port for Phoenix UI and HTTP API | `6006`            |
| PHOENIX_GRPC_PORT_OVERRIDE | Host port for OTLP gRPC collector     | `4317`            |
| PHOENIX_ENABLE_PROMETHEUS  | Enable Prometheus metrics endpoint    | `false`           |
| PHOENIX_SECRET             | Secret for authentication (optional)  | `""`              |
| POSTGRES_VERSION           | PostgreSQL image version              | `17.2-alpine3.21` |
| POSTGRES_USER              | PostgreSQL username                   | `postgres`        |
| POSTGRES_PASSWORD          | PostgreSQL password                   | `postgres`        |
| POSTGRES_DB                | PostgreSQL database name              | `phoenix`         |

## Volumes

- `phoenix_db_data`: PostgreSQL data volume for persistent storage.

## Getting Started

1. Copy the example environment file:

   ```bash
   cp .env.example .env
   ```

2. (Optional) For production, set a secure password and secret:

   ```bash
   # Generate a secret for authentication
   openssl rand -base64 32
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
