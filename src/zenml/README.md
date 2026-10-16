# ZenML

[English](./README.md) | [中文](./README.zh.md)

This service deploys ZenML, an open-source MLOps pipeline platform, with a MySQL backend and optional Adminer, observability (OpenTelemetry/Prometheus), and SQLite dev variants.

## Features

- **Pipeline Orchestration**: Define, run, and manage ML pipelines as code
- **Versioning**: Track artifacts, models, and pipeline versions
- **Stack Management**: Compose orchestrators, artifact stores, and other stack components
- **Web Dashboard**: Manage stacks, pipelines, and runs from the browser
- **Persistent Storage**: MySQL for server metadata
- **Observability**: Optional OpenTelemetry traces and Prometheus metrics

## Quick Start

```bash
cp .env.example .env
docker compose up -d
```

Then open the ZenML dashboard at:

```text
http://localhost:8080
```

On first start, follow the dashboard flow to create the default user, or pre-configure credentials via the `ZENML_DEFAULT_USER_NAME` and `ZENML_DEFAULT_USER_PASSWORD` environment variables (see `.env.example`).

> **Note**: Keep the `zenml` Python client version aligned with the server version (pinned to `0.98.0` in this stack). Version mismatches can cause API incompatibilities.

## Default Configuration

| Port | Purpose                        |
| ---- | ------------------------------ |
| 8080 | ZenML dashboard and REST API (`/health` endpoint available) |

## Environment Variables

| Variable                     | Description                      | Default Value |
| ---------------------------- | -------------------------------- | ------------- |
| ZENML_VERSION                | ZenML server image version       | `0.98.0`      |
| MYSQL_VERSION                | MySQL image version              | `8.4`         |
| MYSQL_ROOT_PASSWORD          | MySQL root password              | `zenml-root-pw` |
| MYSQL_DATABASE               | MySQL database name              | `zenml`       |
| MYSQL_USER                   | MySQL username                   | `zenml`       |
| MYSQL_PASSWORD               | MySQL password                   | `zenml`       |
| ZENML_DEFAULT_USER_NAME      | First-run default username       | `default`     |
| ZENML_DEFAULT_USER_PASSWORD  | First-run default user password  | `(empty)`     |
| ZENML_PORT_OVERRIDE          | ZenML server port (UI + API)     | `8080`        |
| ADMINER_PORT_OVERRIDE        | Adminer web UI port              | `8081`        |

See [.env.example](./.env.example) for the exhaustive list of variables.

## Profiles

| Profile   | Services                    | Command                                        |
| --------- | --------------------------- | ---------------------------------------------- |
| (default) | `zenml`, `mysql`            | `docker compose up -d`                          |
| `dev`     | `zenml-sqlite`, `adminer`   | `docker compose --profile dev up -d`            |
| `metrics` | `otel-collector`, `prometheus` | `docker compose --profile metrics up -d`     |

> **Note**: The `zenml-sqlite` dev variant shares port 8080 with the default `zenml` service — never enable both at the same time.

## Resource Requirements

- The ZenML server requests meaningful CPU/memory limits defined in `docker-compose.yaml`; ensure the host has at least 2 GB of free memory.
- MySQL requires additional headroom for the InnoDB buffer pool.

## Volumes

- `mysql_data`: MySQL data storage.
- `zenml_data`: ZenML local store for the SQLite dev variant.
- `prometheus_data`: Prometheus time-series data (metrics profile).

## Security Considerations

- Set a strong `ZENML_DEFAULT_USER_PASSWORD` before first start; the default user is only created once.
- The JWT signing key and secrets encryption key are generated/persisted by the server — back them up or set them explicitly via environment variables; losing them invalidates existing sessions and encrypted secrets.
- Change all default MySQL passwords for production use.
- The ZenML server image runs as a non-root user where supported.

## Troubleshooting

- **Dashboard not reachable**: Wait for the server to become healthy (`docker compose ps`); the first startup may take a minute while the database initializes.
- **Login fails on first run**: If you did not set `ZENML_DEFAULT_USER_*`, follow the first-run flow in the dashboard to create credentials.
- **Client/server mismatch errors**: Ensure your `zenml` Python client is pinned to `0.98.0` (e.g. `pip install "zenml[server]==0.98.0"`).
- **Platform support**: The `zenmldocker/zenml-server` image is published for `linux/amd64` only; ARM64 hosts need emulation (`docker run --platform linux/amd64`) or an external server deployment.

## References

- [ZenML GitHub Repository](https://github.com/zenml-io/zenml)
- [Deploy with Docker documentation](https://docs.zenml.io/deploying-zenml/deploying-zenml)
- [Docker Hub: zenmldocker/zenml-server](https://hub.docker.com/r/zenmldocker/zenml-server)

## License

ZenML is licensed under the Apache License 2.0.
