# OpenObserve

[OpenObserve](https://openobserve.ai/) is a cloud-native observability platform built specifically for logs, metrics, traces, analytics, and more. It provides 10x easier deployment, 140x lower storage costs, and high performance compared to traditional observability solutions like Elasticsearch, Splunk, and Datadog.

## Features

- **Unified Observability**: Logs, metrics, traces, and frontend monitoring (RUM) in a single platform
- **Cost Efficiency**: 140x lower storage costs compared to Elasticsearch through Parquet columnar storage and S3-native architecture
- **High Performance**: Better query performance than Elasticsearch while using 1/4th the hardware resources
- **Single Binary**: Start with a single binary that scales to terabytes, or deploy in High Availability mode for petabyte-scale workloads
- **Easy to Use**: No complex tuning required, intuitive UI, SQL and PromQL support
- **OpenTelemetry Native**: Built-in OTLP ingestion for logs, metrics, and traces
- **Flexible Storage**: Supports local disk, S3, MinIO, GCS, or Azure Blob Storage
- **Production Ready**: Thousands of deployments worldwide, largest deployment processes 2 PB/day

## Quick Start

1. Copy the environment example file:

   ```bash
   cp .env.example .env
   ```

2. Edit `.env` and configure:
   - `ZO_ROOT_USER_EMAIL`: Admin email (change default)
   - `ZO_ROOT_USER_PASSWORD`: Admin password (change default, minimum 8 characters with special chars)
   - `OPENOBSERVE_PORT_OVERRIDE`: Web UI port (default: 5080)

3. Start OpenObserve:

   ```bash
   docker compose up -d
   ```

4. Access the web UI at `http://localhost:5080`

5. Log in with your configured credentials

## Configuration

### Basic Configuration

| Environment Variable        | Description                     | Default             |
| --------------------------- | ------------------------------- | ------------------- |
| `OPENOBSERVE_VERSION`       | OpenObserve image version       | `v0.50.0`           |
| `OPENOBSERVE_PORT_OVERRIDE` | Web UI port                     | `5080`              |
| `ZO_ROOT_USER_EMAIL`        | Root user email                 | `admin@example.com` |
| `ZO_ROOT_USER_PASSWORD`     | Root user password              | `Complexpass#123`   |
| `ZO_DATA_DIR`               | Data directory inside container | `/data`             |

### S3 Object Storage (Optional)

For production deployments, configure S3-compatible object storage:

| Environment Variable | Description    |
| -------------------- | -------------- |
| `ZO_S3_BUCKET_NAME`  | S3 bucket name |
| `ZO_S3_REGION_NAME`  | S3 region      |
| `ZO_S3_ACCESS_KEY`   | S3 access key  |
| `ZO_S3_SECRET_KEY`   | S3 secret key  |

When S3 is configured, OpenObserve will use it for data storage instead of local volumes.

### Resource Limits

Adjust CPU and memory limits based on your workload:

| Environment Variable             | Description        | Default |
| -------------------------------- | ------------------ | ------- |
| `OPENOBSERVE_CPU_LIMIT`          | Maximum CPU cores  | `2.0`   |
| `OPENOBSERVE_CPU_RESERVATION`    | Reserved CPU cores | `0.5`   |
| `OPENOBSERVE_MEMORY_LIMIT`       | Maximum memory     | `2G`    |
| `OPENOBSERVE_MEMORY_RESERVATION` | Reserved memory    | `512M`  |

## Data Ingestion

OpenObserve supports multiple ingestion methods:

### OpenTelemetry (OTLP)

Send OTLP data to `http://localhost:5080/api/default/` with authentication.

### Logs via HTTP

```bash
curl -u admin@example.com:Complexpass#123 \
  -H "Content-Type: application/json" \
  http://localhost:5080/api/default/logs/_json \
  -d '[{"message": "Hello OpenObserve", "level": "info"}]'
```

### Prometheus Remote Write

Configure Prometheus to use OpenObserve as a remote write target.

See the [official documentation](https://openobserve.ai/docs/ingestion/) for more ingestion methods.

## Architecture

OpenObserve achieves its performance and cost efficiency through:

- **Parquet columnar storage**: Efficient compression and query performance
- **S3-native design**: Leverages inexpensive object storage with intelligent caching
- **Built in Rust**: Memory-safe, high-performance implementation
- **Intelligent partitioning and indexing**: Reduces search space by up to 99% for most queries
- **Stateless architecture**: Enables rapid scaling and disaster recovery

## Volumes

- `openobserve_data`: Stores all data when using local disk storage (not used when S3 is configured)

## Security Considerations

1. **Change default credentials**: Always modify `ZO_ROOT_USER_EMAIL` and `ZO_ROOT_USER_PASSWORD` in production
2. **Password requirements**: Use strong passwords with minimum 8 characters including special characters
3. **Network security**: Consider using a reverse proxy with TLS for production deployments
4. **S3 credentials**: Store S3 credentials securely, consider using IAM roles when possible
5. **Data immutability**: All ingested data is immutable by design for audit compliance

## Upgrading

To upgrade to a new version:

1. Update `OPENOBSERVE_VERSION` in `.env`
2. Pull the new image and restart:

   ```bash
   docker compose pull
   docker compose up -d
   ```

OpenObserve handles schema migrations automatically, no manual steps required.

## Enterprise Features

The Enterprise edition includes:

- Single Sign-On (SSO): OIDC, OAuth, SAML, LDAP/AD
- Advanced RBAC: Role-based access control with custom roles
- Audit trails: Immutable audit logs
- Federated search: Query across multiple clusters
- Sensitive Data Redaction: Automatic PII redaction
- Priority support with SLA guarantees

See [pricing page](https://openobserve.ai/downloads/) for details.

## License

- Open Source Edition: AGPL-3.0
- Enterprise Edition: Commercial license

## Links

- [Official Website](https://openobserve.ai/)
- [Documentation](https://openobserve.ai/docs/)
- [GitHub Repository](https://github.com/openobserve/openobserve)
- [Slack Community](https://short.openobserve.ai/community)
- [Customer Stories](https://openobserve.ai/customer-stories/)

## Support

- Community support via [Slack](https://short.openobserve.ai/community)
- GitHub [Issues](https://github.com/openobserve/openobserve/issues)
- GitHub [Discussions](https://github.com/openobserve/openobserve/discussions)
- Enterprise support available with commercial license
