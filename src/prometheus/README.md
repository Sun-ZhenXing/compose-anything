# Prometheus

[English](./README.md) | [中文](./README.zh.md)

This service deploys Prometheus, an open-source system monitoring and alerting toolkit with a multi-dimensional data model and powerful query language.

## Services

- `prometheus`: The Prometheus server for scraping and storing time series data.

## Environment Variables

| Variable Name             | Description                                                   | Default Value           |
| ------------------------- | ------------------------------------------------------------- | ----------------------- |
| PROMETHEUS_VERSION        | Prometheus image version                                      | `v3.5.0`                |
| PROMETHEUS_PORT_OVERRIDE  | Host port mapping (maps to Prometheus port 9090 in container) | `9090`                  |
| PROMETHEUS_RETENTION_TIME | How long to retain data                                       | `15d`                   |
| PROMETHEUS_RETENTION_SIZE | Maximum storage size (empty = unlimited)                      | `""`                    |
| PROMETHEUS_EXTERNAL_URL   | External URL for Prometheus (used for links and redirects)    | `http://localhost:9090` |

Please modify the `.env` file as needed for your use case.

## Volumes

- `prometheus_data`: A volume for storing Prometheus time series data.
- `prometheus.yml`: Optional custom configuration file (mount to `/etc/prometheus/prometheus.yml`).
- `rules`: Optional directory for alerting and recording rules (mount to `/etc/prometheus/rules`).

## Default Configuration

The default Prometheus configuration includes:

- Scraping itself for metrics
- Global scrape interval of 15 seconds
- Basic web console access

## Configuration Files

### Custom Prometheus Configuration

Mount a custom `prometheus.yml` file to `/etc/prometheus/prometheus.yml`:

```yaml
volumes:
  - ./prometheus.yml:/etc/prometheus/prometheus.yml
```

Example `prometheus.yml`:

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets: ['localhost:9090']

  - job_name: node_exporter
    static_configs:
      - targets: ['node_exporter:9100']
```

### Alert Rules

Mount rules directory to `/etc/prometheus/rules`:

```yaml
volumes:
  - ./rules:/etc/prometheus/rules
```

## Data Retention

Configure data retention using environment variables:

- `PROMETHEUS_RETENTION_TIME`: Time-based retention (e.g., `30d`, `1y`)
- `PROMETHEUS_RETENTION_SIZE`: Size-based retention (e.g., `10GB`, `1TB`)

## API Access

- Web UI: `http://localhost:9090`
- API endpoint: `http://localhost:9090/api/v1/`
- Admin API is enabled for configuration reloads

## Security Notes

- Consider restricting access to the admin API in production
- Use authentication/authorization proxy for production deployments
- Monitor resource usage as Prometheus can consume significant storage and memory

## Common Use Cases

### Monitoring Docker Containers

Add cAdvisor to monitor container metrics:

```yaml
services:
  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    ports:
      - '8080:8080'
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
      - /dev/disk/:/dev/disk:ro
```

### Service Discovery

Use file-based service discovery or integrate with service discovery systems like Consul or Kubernetes.

## License

Prometheus is licensed under the Apache 2.0 license.
