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
2. **postgres**: Uses PostgreSQL for storage. Recommended for production.
   Set `COMPOSE_PROFILES=postgres` in `.env`.

## Ports

| Port | Protocol | Description                               |
| ---- | -------- | ----------------------------------------- |
| 6006 | HTTP     | UI and OTLP HTTP collector (`/v1/traces`) |
| 4317 | gRPC     | OTLP gRPC collector                       |
| 9090 | HTTP     | Prometheus metrics (optional)             |

## Environment Variables

| Variable Name                    | Description                              | Default Value                                   |
| -------------------------------- | ---------------------------------------- | ----------------------------------------------- |
| COMPOSE_PROFILES                 | Active profiles (`sqlite` or `postgres`) | `sqlite`                                        |
| PHOENIX_VERSION                  | Phoenix image version                    | `20.8.0`                                        |
| PHOENIX_PORT_OVERRIDE            | Host port for Phoenix UI and HTTP API    | `6006`                                          |
| PHOENIX_GRPC_PORT_OVERRIDE       | Host port for OTLP gRPC collector        | `4317`                                          |
| PHOENIX_PROMETHEUS_PORT_OVERRIDE | Host port for Prometheus metrics         | `9090`                                          |
| PHOENIX_ENABLE_PROMETHEUS        | Enable Prometheus metrics endpoint       | `false`                                         |
| PHOENIX_SECRET                   | Secret used when upstream authentication is enabled; does not enable it | `"NOT_SECURE_0fdf298eefb2ceef8ab3d7bd5319060e"` |
| POSTGRES_VERSION                 | PostgreSQL image version                 | `17.2-alpine3.21`                               |
| POSTGRES_USER                    | PostgreSQL username                      | `postgres`                                      |
| POSTGRES_PASSWORD                | PostgreSQL password                      | `postgres`                                      |
| POSTGRES_DB                      | PostgreSQL database name                 | `phoenix`                                       |

## Volumes

- `phoenix_data`: Data volume for SQLite mode (mounted to `/data`).
- `phoenix_db_data`: Data volume for PostgreSQL mode.

## Getting Started

1. Copy the example environment file:

   ```bash
   cp .env.example .env
   ```

2. Select your deployment mode by setting `COMPOSE_PROFILES` in `.env` (the no-env default is `sqlite`). Use `COMPOSE_PROFILES=sqlite` for SQLite or `COMPOSE_PROFILES=postgres` for PostgreSQL; setting only `docker compose --profile postgres` is not the supported selection method.

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

## Upgrading to Phoenix 20.8.0

- Back up the `phoenix_data` named volume before SQLite migrations, or back up the PostgreSQL database before PostgreSQL migrations.
- An existing `.env` overrides the defaults in `docker-compose.yaml`. Update its `PHOENIX_VERSION` to `20.8.0`.
- Pull the new image, then start the existing profile workflow using the same `COMPOSE_PROFILES` value/profile for both commands. Existing PostgreSQL users must use `postgres`, not `sqlite`:

  ```bash
  docker compose pull
  docker compose up -d
  ```

- Do not run `docker compose down -v`; it removes persistent data. Do not downgrade after a database migration unless you restore a matching backup first.
- Review the [Phoenix migration guide](https://github.com/Arize-ai/phoenix/blob/main/MIGRATION.md) before migrating.

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
- Authentication is disabled by default, and `PHOENIX_SECRET` alone does not enable it. Do not expose an unprotected instance publicly.
- For public deployment, explicitly configure `PHOENIX_ENABLE_AUTH=true` in the Phoenix service environment and replace the default `PHOENIX_SECRET` with a persistent secret of at least 32 characters. The current Compose file does not forward `PHOENIX_ENABLE_AUTH`; follow the upstream authentication configuration instead of assuming adding it to `.env` is sufficient.
- Changing `PHOENIX_SECRET` can invalidate API keys and encrypted data.
- Consider using a reverse proxy with SSL/TLS in production.
- Regularly backup the PostgreSQL database.
