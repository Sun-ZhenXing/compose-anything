# Grafana Tempo

[中文文档](README.zh.md)

Grafana Tempo is an open-source, easy-to-use, and high-scale distributed tracing backend. Tempo is cost-efficient, requiring only object storage to operate, and is deeply integrated with Grafana, Prometheus, and Loki.

## Features

- **Cost-effective**: Uses object storage (supports S3, GCS, Azure, filesystem)
- **Easy to operate**: No dependencies other than object storage
- **Multi-tenant**: Built-in multi-tenancy support
- **Multiple protocols**: Supports OTLP, Jaeger, and Zipkin
- **TraceQL**: Powerful query language for trace data
- **Metrics generation**: Can generate RED metrics from traces

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
    curl http://localhost:3200/ready
    ```

## Configuration

### Environment Variables

| Variable                                 | Default | Description             |
| ---------------------------------------- | ------- | ----------------------- |
| `TEMPO_VERSION`                          | `2.7.2` | Tempo version           |
| `TEMPO_HTTP_PORT_OVERRIDE`               | `3200`  | HTTP API port           |
| `TEMPO_GRPC_PORT_OVERRIDE`               | `9095`  | gRPC port               |
| `TEMPO_OTLP_HTTP_PORT_OVERRIDE`          | `4318`  | OTLP HTTP receiver port |
| `TEMPO_OTLP_GRPC_PORT_OVERRIDE`          | `4317`  | OTLP gRPC receiver port |
| `TEMPO_ZIPKIN_PORT_OVERRIDE`             | `9411`  | Zipkin receiver port    |
| `TEMPO_JAEGER_THRIFT_HTTP_PORT_OVERRIDE` | `14268` | Jaeger Thrift HTTP port |
| `TEMPO_JAEGER_GRPC_PORT_OVERRIDE`        | `14250` | Jaeger gRPC port        |
| `TZ`                                     | `UTC`   | Timezone                |
| `TEMPO_CPU_LIMIT`                        | `1.0`   | CPU limit               |
| `TEMPO_MEMORY_LIMIT`                     | `1G`    | Memory limit            |
| `TEMPO_CPU_RESERVATION`                  | `0.25`  | CPU reservation         |
| `TEMPO_MEMORY_RESERVATION`               | `256M`  | Memory reservation      |

### Supported Trace Protocols

- **OTLP** (OpenTelemetry Protocol): Port 4317 (gRPC), 4318 (HTTP)
- **Zipkin**: Port 9411
- **Jaeger**: Port 14250 (gRPC), 14268 (Thrift HTTP)

### Default Configuration

The service includes a basic configuration file (`tempo-config.yaml`) that:

- Enables all major trace receivers (OTLP, Jaeger, Zipkin)
- Uses local filesystem storage
- Configures trace retention and compaction
- Enables metrics generation from traces (requires Prometheus)

For production deployments, you should customize the configuration based on your requirements.

## Integration with Grafana

1. Add Tempo as a data source in Grafana:
   - URL: `http://tempo:3200` (if running in the same Docker network)
   - Or: `http://localhost:3200` (from host machine)

2. Query traces using TraceQL or trace IDs

3. Enable trace-to-logs and trace-to-metrics correlation

## Sending Traces to Tempo

### OpenTelemetry SDK

Configure your application to send traces to Tempo:

```python
from opentelemetry import trace
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor

# Configure the OTLP exporter
otlp_exporter = OTLPSpanExporter(
    endpoint="http://localhost:4317",
    insecure=True
)

# Set up the tracer provider
trace.set_tracer_provider(TracerProvider())
trace.get_tracer_provider().add_span_processor(
    BatchSpanProcessor(otlp_exporter)
)
```

### Using cURL (Testing)

Send a test trace via HTTP:

```bash
curl -X POST http://localhost:4318/v1/traces \
  -H "Content-Type: application/json" \
  -d '{
    "resourceSpans": [{
      "resource": {
        "attributes": [{
          "key": "service.name",
          "value": {"stringValue": "test-service"}
        }]
      },
      "scopeSpans": [{
        "spans": [{
          "traceId": "5B8EFFF798038103D269B633813FC60C",
          "spanId": "EEE19B7EC3C1B174",
          "name": "test-span",
          "startTimeUnixNano": "1544712660000000000",
          "endTimeUnixNano": "1544712661000000000",
          "kind": 1
        }]
      }]
    }]
  }'
```

### Jaeger Client Libraries

Configure Jaeger clients to send to Tempo's Jaeger-compatible endpoints:

```yaml
JAEGER_AGENT_HOST: localhost
JAEGER_AGENT_PORT: 14250
```

## Storage

Traces are stored in a Docker volume named `tempo_data`.

## Metrics Generation

Tempo can generate RED (Rate, Errors, Duration) metrics from traces. The default configuration attempts to send these to Prometheus at `http://prometheus:9090`. If you don't have Prometheus running, you can:

1. Remove the `remote_write` section from `tempo-config.yaml`
2. Set up Prometheus to receive metrics from Tempo

## Health Check

The service includes a health check that monitors the `/ready` endpoint every 30 seconds.

## Resource Requirements

- **Minimum**: 256MB RAM, 0.25 CPU
- **Recommended**: 1GB RAM, 1 CPU (for moderate trace volumes)
- **Production**: Scale based on trace ingestion rate and retention period

## Security Considerations

The default configuration:

- Runs as non-root user (UID:GID 10001:10001)
- Exposes multiple ports for different protocols
- Uses filesystem storage (not suitable for distributed deployments)

For production:

- Use object storage (S3, GCS, Azure Blob)
- Enable authentication and encryption
- Implement proper network security and access controls
- Configure appropriate retention policies
- Consider running in distributed mode for high availability

## TraceQL Examples

Query traces using TraceQL in Grafana:

```traceql
# Find slow traces
{ duration > 1s }

# Find traces with errors
{ status = error }

# Find traces for a specific service
{ resource.service.name = "frontend" }

# Complex query
{ resource.service.name = "frontend" && duration > 100ms && status = error }
```

## Documentation

- [Official Documentation](https://grafana.com/docs/tempo/latest/)
- [TraceQL Query Language](https://grafana.com/docs/tempo/latest/traceql/)
- [Configuration Reference](https://grafana.com/docs/tempo/latest/configuration/)
- [GitHub Repository](https://github.com/grafana/tempo)

## License

Tempo is licensed under the [AGPLv3 License](https://github.com/grafana/tempo/blob/main/LICENSE).
