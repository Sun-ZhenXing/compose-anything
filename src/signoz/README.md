# SigNoz

[English](README.md) | [中文](README.zh.md)

SigNoz is an open-source observability platform that provides monitoring and troubleshooting capabilities for distributed applications. It offers traces, metrics, and logs in a single platform, similar to DataDog or New Relic.

## Features

- **Distributed Tracing**: Track requests across microservices
- **Metrics Monitoring**: Collect and visualize application and infrastructure metrics
- **Log Management**: Centralized log aggregation and analysis
- **Service Maps**: Visualize service dependencies and performance
- **Alerts**: Configure alerts based on metrics and traces
- **OpenTelemetry Native**: Built on top of OpenTelemetry standards

## Services

| Service                          | Image                                 | Description                                            |
| -------------------------------- | ------------------------------------- | ------------------------------------------------------ |
| `signoz`                         | signoz/signoz:v0.118.0                | All-in-one backend, frontend UI, and alert manager     |
| `otel-collector`                 | signoz/signoz-otel-collector:v0.144.2 | Receives, processes, and exports telemetry data        |
| `clickhouse`                     | clickhouse/clickhouse-server:25.5.6   | Time-series database for traces, metrics, and logs     |
| `zookeeper-1`                    | signoz/zookeeper:3.7.1                | ZooKeeper for ClickHouse replication metadata          |
| `init-clickhouse`                | clickhouse/clickhouse-server:25.5.6   | One-shot init that downloads the histogramQuantile UDF |
| `signoz-telemetrystore-migrator` | signoz/signoz-otel-collector:v0.144.2 | One-shot schema migration for ClickHouse               |

## Quick Start

1. Copy the environment file and set the JWT secret:

   ```bash
   cp .env.example .env
   # Edit .env and set SIGNOZ_JWT_SECRET to a random string
   ```

2. Start the services:

   ```bash
   docker compose up -d
   ```

3. Access SigNoz UI at `http://localhost:8080`

> **Note**: On first start, `init-clickhouse` must download a binary from GitHub (~10 MB). Ensure internet access is available.

## Default Ports

| Service               | Port | Description          |
| --------------------- | ---- | -------------------- |
| SigNoz UI             | 8080 | SigNoz web interface |
| OTel Collector (gRPC) | 4317 | OTLP gRPC receiver   |
| OTel Collector (HTTP) | 4318 | OTLP HTTP receiver   |

## Configuration

### Key Environment Variables

| Variable                         | Default                     | Description                                    |
| -------------------------------- | --------------------------- | ---------------------------------------------- |
| `SIGNOZ_JWT_SECRET`              | `please-change-this-secret` | JWT secret for token signing — **change this** |
| `SIGNOZ_PORT_OVERRIDE`           | `8080`                      | SigNoz UI host port                            |
| `SIGNOZ_OTEL_GRPC_PORT_OVERRIDE` | `4317`                      | OTLP gRPC receiver host port                   |
| `SIGNOZ_OTEL_HTTP_PORT_OVERRIDE` | `4318`                      | OTLP HTTP receiver host port                   |
| `SIGNOZ_VERSION`                 | `v0.118.0`                  | SigNoz image version                           |
| `SIGNOZ_OTEL_COLLECTOR_VERSION`  | `v0.144.2`                  | OTel Collector image version                   |
| `SIGNOZ_CLICKHOUSE_VERSION`      | `25.5.6`                    | ClickHouse image version                       |
| `TZ`                             | `UTC`                       | Timezone                                       |

See `.env.example` for the complete list including resource limits.

### Sending Telemetry Data

Configure your application's OpenTelemetry SDK to export to:

- **gRPC**: `http://localhost:4317`
- **HTTP**: `http://localhost:4318`

## Architecture

```text
User → SigNoz UI (8080) → signoz backend
              ↓
App  → OTel Collector (4317/4318) → ClickHouse
                                         ↑
                          Zookeeper (replication metadata)
```

Startup order:

1. `init-clickhouse` downloads histogramQuantile binary → `zookeeper-1` starts
2. `clickhouse` starts (after init completes and zookeeper is healthy)
3. `signoz-telemetrystore-migrator` runs schema migrations
4. `signoz` and `otel-collector` start


## Data Persistence

Data is persisted in Docker named volumes:

| Volume                    | Contents                              |
| ------------------------- | ------------------------------------- |
| `clickhouse_data`         | ClickHouse database files             |
| `clickhouse_user_scripts` | histogramQuantile UDF binary          |
| `signoz_data`             | SigNoz SQLite DB and application data |
| `zookeeper_data`          | ZooKeeper state                       |

## Security Considerations

- **Change `SIGNOZ_JWT_SECRET`** to a unique random value before production use
- Restrict port exposure to trusted networks in production
- Run behind a reverse proxy with TLS termination for production

## Troubleshooting

1. **Services not starting**: `docker compose logs` — check for connection errors
2. **init-clickhouse fails**: No internet access — the UDF binary cannot be downloaded
3. **otel-collector unhealthy**: May be waiting for migrations to settle; check with `docker compose logs signoz-telemetrystore-migrator`
4. **No data visible**: Verify OTel Collector configuration and application instrumentation

## References

- [Official Documentation](https://signoz.io/docs/)
- [GitHub Repository](https://github.com/SigNoz/signoz)
- [OpenTelemetry Documentation](https://opentelemetry.io/docs/)
