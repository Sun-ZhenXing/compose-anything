# Grafana Loki

[中文文档](README.zh.md)

Grafana Loki is a horizontally scalable, highly available, multi-tenant log aggregation system inspired by Prometheus. It is designed to be very cost effective and easy to operate. Unlike other logging systems, Loki does not index the contents of the logs, but rather a set of labels for each log stream.

## Features

- **Cost-effective**: Only indexes metadata instead of full text, significantly reducing storage costs
- **LogQL**: Powerful query language similar to PromQL for filtering and aggregating logs
- **Multi-tenancy**: Built-in support for multi-tenant deployments
- **Grafana Integration**: Native integration with Grafana for visualization
- **Scalable**: Can scale horizontally to handle large volumes of logs

## Quick Start

1. Copy the example environment file:

    ```bash
    cp .env.example .env
    ```

2. Start the service:

    ```bash
    docker compose up -d
    ```

3. Verify the service is running:

    ```bash
    docker compose ps
    curl http://localhost:3100/ready
    ```

## Configuration

### Environment Variables

| Variable                  | Default | Description        |
| ------------------------- | ------- | ------------------ |
| `LOKI_VERSION`            | `3.3.2` | Loki version       |
| `LOKI_PORT_OVERRIDE`      | `3100`  | HTTP API port      |
| `TZ`                      | `UTC`   | Timezone           |
| `LOKI_CPU_LIMIT`          | `1.0`   | CPU limit          |
| `LOKI_MEMORY_LIMIT`       | `1G`    | Memory limit       |
| `LOKI_CPU_RESERVATION`    | `0.25`  | CPU reservation    |
| `LOKI_MEMORY_RESERVATION` | `256M`  | Memory reservation |

### Default Configuration

The service includes a basic configuration file (`loki-config.yaml`) that:

- Disables authentication (suitable for development/testing)
- Uses local filesystem storage
- Configures a single replica (monolithic mode)
- Sets up basic caching for query performance

For production deployments, you should customize the configuration based on your requirements.

## Integration with Grafana

1. Add Loki as a data source in Grafana:
   - URL: `http://loki:3100` (if running in the same Docker network)
   - Or: `http://localhost:3100` (from host machine)

2. Create dashboards and explore logs using LogQL queries

## Sending Logs to Loki

### Using Promtail

Promtail is the recommended agent for shipping logs to Loki:

```yaml
services:
  promtail:
    image: grafana/promtail:3.3.2
    volumes:
      - /var/log:/var/log:ro
      - ./promtail-config.yaml:/etc/promtail/config.yaml
    command: -config.file=/etc/promtail/config.yaml
```

### Using Docker Driver

You can configure Docker to send logs directly to Loki:

```yaml
logging:
  driver: loki
  options:
    loki-url: "http://localhost:3100/loki/api/v1/push"
    loki-batch-size: "400"
```

### Using HTTP API

Send logs directly via HTTP POST:

```bash
curl -H "Content-Type: application/json" -XPOST -s "http://localhost:3100/loki/api/v1/push" --data-raw \
  '{"streams": [{ "stream": { "job": "test" }, "values": [ [ "$(date +%s)000000000", "test log message" ] ] }]}'
```

## Storage

Logs and metadata are stored in a Docker volume named `loki_data`.

## Health Check

The service includes a health check that monitors the `/ready` endpoint every 30 seconds.

## Resource Requirements

- **Minimum**: 256MB RAM, 0.25 CPU
- **Recommended**: 1GB RAM, 1 CPU (for moderate log volumes)
- **Production**: Scale based on log ingestion rate and retention period

## Security Considerations

The default configuration:

- Runs as non-root user (UID:GID 10001:10001)
- Disables authentication (suitable for development only)
- Uses filesystem storage (not suitable for distributed deployments)

For production:

- Enable authentication and multi-tenancy
- Use object storage (S3, GCS, Azure Blob, etc.)
- Implement proper network security and access controls
- Configure retention policies to manage storage costs

## Documentation

- [Official Documentation](https://grafana.com/docs/loki/latest/)
- [LogQL Query Language](https://grafana.com/docs/loki/latest/query/)
- [Best Practices](https://grafana.com/docs/loki/latest/operations/best-practices/)
- [GitHub Repository](https://github.com/grafana/loki)

## License

Loki is licensed under the [AGPLv3 License](https://github.com/grafana/loki/blob/main/LICENSE).
