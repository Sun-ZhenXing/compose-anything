# OpenTelemetry Collector

[English](README.md) | [中文](README.zh.md)

OpenTelemetry Collector is a vendor-agnostic service for receiving, processing, and exporting telemetry data (traces, metrics, and logs). It supports multiple protocols and can send data to various backends.

## Features

- **Protocol Support**: OTLP, Jaeger, Zipkin, Prometheus, and more
- **Flexible Processing**: Filter, transform, and enrich telemetry data
- **Multiple Exporters**: Send data to various observability backends
- **High Performance**: Efficient data processing with low overhead
- **Extensible**: Rich ecosystem of receivers, processors, and exporters
- **Vendor Neutral**: Works with any OpenTelemetry-compatible backend

## Quick Start

1. Copy the environment file and adjust if needed:

   ```bash
   cp .env.example .env
   ```

2. Create a configuration file `config.yaml`:

   ```bash
   # See example below or use the provided template
   ```

3. Start the collector:

   ```bash
   docker compose up -d
   ```

## Default Ports

| Protocol           | Port  | Description                      |
| ------------------ | ----- | -------------------------------- |
| OTLP gRPC          | 4317  | OpenTelemetry Protocol over gRPC |
| OTLP HTTP          | 4318  | OpenTelemetry Protocol over HTTP |
| Jaeger gRPC        | 14250 | Jaeger gRPC receiver             |
| Jaeger Thrift HTTP | 14268 | Jaeger Thrift HTTP receiver      |
| Zipkin             | 9411  | Zipkin HTTP receiver             |
| Prometheus         | 8888  | Internal metrics endpoint        |
| Health Check       | 13133 | Health check endpoint            |

## Configuration

### Environment Variables

Key environment variables (see `.env.example` for complete list):

- `OTEL_COLLECTOR_VERSION`: Collector version (default: 0.115.1)
- `OTEL_COLLECTOR_OTLP_GRPC_PORT_OVERRIDE`: OTLP gRPC port (default: 4317)
- `OTEL_COLLECTOR_OTLP_HTTP_PORT_OVERRIDE`: OTLP HTTP port (default: 4318)
- `OTEL_COLLECTOR_GOMEMLIMIT`: Go memory limit for the collector

### Configuration File

Create a `config.yaml` file to define the collector pipeline. Here's a minimal example:

```yaml
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: 0.0.0.0:4317
      http:
        endpoint: 0.0.0.0:4318

processors:
  batch:
    timeout: 10s
    send_batch_size: 1024

exporters:
  logging:
    loglevel: info

  # Example: Export to Jaeger
  # otlp/jaeger:
  #   endpoint: jaeger:4317
  #   tls:
  #     insecure: true

  # Example: Export to Prometheus
  # prometheusremotewrite:
  #   endpoint: http://prometheus:9090/api/v1/write

extensions:
  health_check:
    endpoint: 0.0.0.0:13133
  pprof:
    endpoint: 0.0.0.0:1777

service:
  extensions: [health_check, pprof]
  pipelines:
    traces:
      receivers: [otlp]
      processors: [batch]
      exporters: [logging]
    metrics:
      receivers: [otlp]
      processors: [batch]
      exporters: [logging]
    logs:
      receivers: [otlp]
      processors: [batch]
      exporters: [logging]
```

For production use, configure appropriate exporters for your observability backend (e.g., Jaeger, Prometheus, Grafana Tempo, DataDog, etc.).

### Common Receivers

- **OTLP**: Native OpenTelemetry protocol (gRPC and HTTP)
- **Jaeger**: Jaeger native formats
- **Zipkin**: Zipkin JSON format
- **Prometheus**: Prometheus scraping
- **Kafka**: Receive from Kafka topics

### Common Processors

- **Batch**: Batch telemetry data before export
- **Memory Limiter**: Prevent out-of-memory situations
- **Resource Detection**: Automatically detect resource attributes
- **Attributes**: Modify attributes on telemetry data
- **Sampling**: Sample traces based on various strategies

### Common Exporters

- **OTLP**: Send to OTLP-compatible backends
- **Jaeger**: Export to Jaeger
- **Zipkin**: Export to Zipkin
- **Prometheus**: Expose metrics for Prometheus scraping
- **Prometheus Remote Write**: Push metrics to Prometheus
- **Logging**: Log telemetry to console (for debugging)

## Sending Data to the Collector

### Using OpenTelemetry SDKs

Configure your application to send data to the collector:

**Environment Variables**:

```bash
export OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317
export OTEL_EXPORTER_OTLP_PROTOCOL=grpc
```

**Python Example**:

```python
from opentelemetry import trace
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor

provider = TracerProvider()
processor = BatchSpanProcessor(OTLPSpanExporter(endpoint="localhost:4317", insecure=True))
provider.add_span_processor(processor)
trace.set_tracer_provider(provider)
```

**Node.js Example**:

```javascript
const { OTLPTraceExporter } = require('@opentelemetry/exporter-trace-otlp-grpc')
const { NodeTracerProvider } = require('@opentelemetry/sdk-trace-node')

const provider = new NodeTracerProvider()
const exporter = new OTLPTraceExporter({
  url: 'http://localhost:4317',
})
provider.addSpanProcessor(new BatchSpanProcessor(exporter))
provider.register()
```

## Resource Requirements

Minimum recommended resources:

- **CPU**: 0.5 cores
- **Memory**: 1GB RAM

For high-throughput environments, increase resources accordingly.

## Data Persistence

The collector itself is stateless. Data persistence depends on the configured exporters and backend systems.

## Security Considerations

- Configure TLS for production deployments
- Use authentication when available (e.g., API keys, mTLS)
- Restrict network access to necessary ports
- Consider using the `memory_limiter` processor to prevent OOM
- Review and minimize exposed ports
- Use secrets management for sensitive configuration

## Healthchecks

The collector exposes a health check endpoint on port 13133:

- `http://localhost:13133/` - Overall health status

## Monitoring the Collector

The collector exposes its own metrics on the Prometheus metrics endpoint (default port 8888):

- `http://localhost:8888/metrics`

Key metrics to monitor:

- `otelcol_receiver_accepted_spans`: Number of spans accepted
- `otelcol_receiver_refused_spans`: Number of spans refused
- `otelcol_exporter_sent_spans`: Number of spans sent
- `otelcol_processor_batch_batch_send_size`: Batch sizes

## Troubleshooting

1. **Data not being received**: Check receiver configuration and port bindings
2. **High memory usage**: Configure `memory_limiter` processor
3. **Slow processing**: Adjust batch processor settings
4. **Export failures**: Check exporter configuration and backend connectivity

## Performance Tuning

- Use the `batch` processor to improve efficiency
- Configure `memory_limiter` to prevent OOM
- Adjust queue sizes based on throughput requirements
- Use sampling processors for high-volume trace data
- Monitor collector metrics for bottlenecks

## License

OpenTelemetry Collector is licensed under the Apache 2.0 License. See the [official repository](https://github.com/open-telemetry/opentelemetry-collector) for more details.

## References

- [Official Documentation](https://opentelemetry.io/docs/collector/)
- [GitHub Repository](https://github.com/open-telemetry/opentelemetry-collector)
- [Collector Contrib Repository](https://github.com/open-telemetry/opentelemetry-collector-contrib)
- [Configuration Reference](https://opentelemetry.io/docs/collector/configuration/)
