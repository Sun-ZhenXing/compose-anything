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

## Quick Start

1. Copy the environment file and adjust if needed:

   ```bash
   cp .env.example .env
   ```

2. Create required configuration files:

   ```bash
   mkdir -p query-service frontend
   # Download or create configuration files as needed
   ```

3. Start the services:

   ```bash
   docker compose up -d
   ```

4. Access SigNoz UI at `http://localhost:3301`

## Default Ports

| Service               | Port | Description          |
| --------------------- | ---- | -------------------- |
| Frontend UI           | 3301 | SigNoz web interface |
| OTel Collector (gRPC) | 4317 | OTLP gRPC receiver   |
| OTel Collector (HTTP) | 4318 | OTLP HTTP receiver   |

## Configuration

### Environment Variables

Key environment variables (see `.env.example` for complete list):

- `SIGNOZ_PORT_OVERRIDE`: Frontend UI port (default: 3301)
- `SIGNOZ_OTEL_GRPC_PORT_OVERRIDE`: OTLP gRPC receiver port (default: 4317)
- `SIGNOZ_OTEL_HTTP_PORT_OVERRIDE`: OTLP HTTP receiver port (default: 4318)
- `SIGNOZ_CLICKHOUSE_VERSION`: ClickHouse version
- `SIGNOZ_QUERY_SERVICE_VERSION`: Query service version
- `SIGNOZ_FRONTEND_VERSION`: Frontend version

### Required Configuration Files

This setup requires several configuration files:

1. **clickhouse-config.xml**: ClickHouse server configuration
2. **clickhouse-users.xml**: ClickHouse user configuration
3. **otel-collector-config.yaml**: OTel Collector pipeline configuration
4. **query-service/prometheus.yml**: Query service Prometheus configuration
5. **frontend/nginx-config.conf**: Nginx configuration for frontend

You can obtain these files from the [official SigNoz repository](https://github.com/SigNoz/signoz/tree/main/deploy/docker/clickhouse-setup).

### Sending Telemetry Data

To send telemetry data to SigNoz, configure your application to use OpenTelemetry with the following endpoints:

- **gRPC**: `localhost:4317`
- **HTTP**: `localhost:4318`

Example for Node.js:

```javascript
const { OTLPTraceExporter } = require('@opentelemetry/exporter-trace-otlp-grpc')
const { NodeTracerProvider } = require('@opentelemetry/sdk-trace-node')

const exporter = new OTLPTraceExporter({
  url: 'http://localhost:4317',
})
```

## Architecture

SigNoz consists of the following components:

1. **ClickHouse**: Time-series database for storing traces, metrics, and logs
2. **OTel Collector**: Receives, processes, and exports telemetry data
3. **Query Service**: Queries data from ClickHouse
4. **Frontend**: Web UI for visualization and analysis
5. **Alert Manager**: Manages and sends alerts

## Resource Requirements

Minimum recommended resources:

- **CPU**: 4 cores
- **Memory**: 8GB RAM
- **Storage**: 20GB for data

## Data Persistence

Data is persisted in Docker volumes:

- `clickhouse_data`: ClickHouse database files
- `signoz_data`: SigNoz application data
- `alertmanager_data`: Alert manager data

## Security Considerations

- Change default credentials if applicable
- Use environment variables for sensitive configuration
- Consider using secrets management for production deployments
- Restrict network access to necessary ports only
- Enable authentication for production use

## Healthchecks

All services include healthchecks to ensure proper startup and dependency management:

- ClickHouse: HTTP health endpoint
- OTel Collector: HTTP health endpoint
- Query Service: HTTP health endpoint
- Frontend: HTTP health endpoint
- Alert Manager: HTTP health endpoint

## Troubleshooting

1. **Services not starting**: Check logs with `docker compose logs`
2. **No data visible**: Verify OTel Collector configuration and application instrumentation
3. **High memory usage**: Adjust ClickHouse memory limits or data retention policies

## License

SigNoz is licensed under the MIT License. See the [official repository](https://github.com/SigNoz/signoz) for more details.

## References

- [Official Documentation](https://signoz.io/docs/)
- [GitHub Repository](https://github.com/SigNoz/signoz)
- [OpenTelemetry Documentation](https://opentelemetry.io/docs/)
