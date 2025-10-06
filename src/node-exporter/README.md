# Node Exporter

[English](./README.md) | [中文](./README.zh.md)

This service deploys Prometheus Node Exporter, which exposes hardware and OS metrics from *NIX kernels.

## Services

- `node-exporter`: Prometheus Node Exporter service

## Environment Variables

| Variable Name               | Description           | Default Value |
| --------------------------- | --------------------- | ------------- |
| NODE_EXPORTER_VERSION       | Node Exporter version | `v1.8.2`      |
| NODE_EXPORTER_PORT_OVERRIDE | Host port mapping     | `9100`        |

Please modify the `.env` file as needed for your use case.

## Usage

### Start Node Exporter

```bash
docker compose up -d
```

### Access Metrics

- Metrics endpoint: <http://localhost:9100/metrics>

### Configure Prometheus

Add this scrape config to your Prometheus configuration:

```yaml
scrape_configs:
  - job_name: 'node'
    static_configs:
      - targets: ['localhost:9100']
```

## Metrics Collected

Node Exporter collects a wide variety of system metrics:

- **CPU**: usage, frequency, temperature
- **Memory**: usage, available, cached
- **Disk**: I/O, space usage
- **Network**: traffic, errors
- **File system**: mount points, usage
- **Load**: system load averages
- **And many more**

## Network Mode

For more accurate metrics, you can run Node Exporter with host network mode. Uncomment in `docker-compose.yaml`:

```yaml
network_mode: host
```

Note: When using host network mode, port mapping is not needed.

## Notes

- Node Exporter should run on each host you want to monitor
- The service needs access to host filesystem and processes
- Metrics are exposed in Prometheus format
- No authentication is provided by default

## Security

- Bind to localhost only if running Prometheus on the same host
- Use firewall rules to restrict access to the metrics endpoint
- Consider using a reverse proxy with authentication for production
- Monitor access logs for suspicious activity

## License

Node Exporter is licensed under Apache License 2.0. See [Node Exporter GitHub](https://github.com/prometheus/node_exporter) for more information.
