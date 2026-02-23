# OpenTelemetry Collector

[English](README.md) | [中文](README.zh.md)

OpenTelemetry Collector 是一个与供应商无关的服务，用于接收、处理和导出遥测数据（追踪、指标和日志）。它支持多种协议，可以将数据发送到各种后端系统。

## 功能特性

- **协议支持**：OTLP、Jaeger、Zipkin、Prometheus 等
- **灵活处理**：过滤、转换和丰富遥测数据
- **多种导出器**：将数据发送到各种可观测性后端
- **高性能**：高效的数据处理，开销低
- **可扩展**：丰富的接收器、处理器和导出器生态系统
- **供应商中立**：与任何兼容 OpenTelemetry 的后端配合使用

## 快速开始

1. 复制环境文件并根据需要调整：

   ```bash
   cp .env.example .env
   ```

2. 创建配置文件 `config.yaml`：

   ```bash
   # 参见下面的示例或使用提供的模板
   ```

3. 启动收集器：

   ```bash
   docker compose up -d
   ```

## 默认端口

| 协议               | 端口  | 描述                            |
| ------------------ | ----- | ------------------------------- |
| OTLP gRPC          | 4317  | 基于 gRPC 的 OpenTelemetry 协议 |
| OTLP HTTP          | 4318  | 基于 HTTP 的 OpenTelemetry 协议 |
| Jaeger gRPC        | 14250 | Jaeger gRPC 接收器              |
| Jaeger Thrift HTTP | 14268 | Jaeger Thrift HTTP 接收器       |
| Zipkin             | 9411  | Zipkin HTTP 接收器              |
| Prometheus         | 8888  | 内部指标端点                    |
| Health Check       | 13133 | 健康检查端点                    |

## 配置说明

### 环境变量

主要环境变量（完整列表请查看 `.env.example`）：

- `OTEL_COLLECTOR_VERSION`：收集器版本（默认：0.115.1）
- `OTEL_COLLECTOR_OTLP_GRPC_PORT_OVERRIDE`：OTLP gRPC 端口（默认：4317）
- `OTEL_COLLECTOR_OTLP_HTTP_PORT_OVERRIDE`：OTLP HTTP 端口（默认：4318）
- `OTEL_COLLECTOR_GOMEMLIMIT`：收集器的 Go 内存限制

### 配置文件

创建 `config.yaml` 文件来定义收集器管道。以下是一个最小示例：

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

  # 示例：导出到 Jaeger
  # otlp/jaeger:
  #   endpoint: jaeger:4317
  #   tls:
  #     insecure: true

  # 示例：导出到 Prometheus
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

对于生产环境，请为您的可观测性后端配置适当的导出器（例如 Jaeger、Prometheus、Grafana Tempo、DataDog 等）。

### 常用接收器

- **OTLP**：原生 OpenTelemetry 协议（gRPC 和 HTTP）
- **Jaeger**：Jaeger 原生格式
- **Zipkin**：Zipkin JSON 格式
- **Prometheus**：Prometheus 抓取
- **Kafka**：从 Kafka 主题接收

### 常用处理器

- **Batch**：在导出前批处理遥测数据
- **Memory Limiter**：防止内存溢出情况
- **Resource Detection**：自动检测资源属性
- **Attributes**：修改遥测数据的属性
- **Sampling**：基于各种策略对追踪进行采样

### 常用导出器

- **OTLP**：发送到兼容 OTLP 的后端
- **Jaeger**：导出到 Jaeger
- **Zipkin**：导出到 Zipkin
- **Prometheus**：公开指标供 Prometheus 抓取
- **Prometheus Remote Write**：推送指标到 Prometheus
- **Logging**：将遥测数据记录到控制台（用于调试）

## 向收集器发送数据

### 使用 OpenTelemetry SDK

配置您的应用程序将数据发送到收集器：

**环境变量**：

```bash
export OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317
export OTEL_EXPORTER_OTLP_PROTOCOL=grpc
```

**Python 示例**：

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

**Node.js 示例**：

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

## 资源需求

最低推荐资源：

- **CPU**：0.5 核
- **内存**：1GB RAM

对于高吞吐量环境，请相应增加资源。

## 数据持久化

收集器本身是无状态的。数据持久化取决于配置的导出器和后端系统。

## 安全注意事项

- 生产部署时配置 TLS
- 在可用时使用身份验证（例如 API 密钥、mTLS）
- 限制对必要端口的网络访问
- 考虑使用 `memory_limiter` 处理器防止 OOM
- 检查并最小化暴露的端口
- 对敏感配置使用密钥管理

## 健康检查

收集器在端口 13133 上公开健康检查端点：

- `http://localhost:13133/` - 整体健康状态

## 监控收集器

收集器在 Prometheus 指标端点（默认端口 8888）上公开自己的指标：

- `http://localhost:8888/metrics`

需要监控的关键指标：

- `otelcol_receiver_accepted_spans`：接受的 span 数量
- `otelcol_receiver_refused_spans`：拒绝的 span 数量
- `otelcol_exporter_sent_spans`：发送的 span 数量
- `otelcol_processor_batch_batch_send_size`：批处理大小

## 故障排查

1. **未接收到数据**：检查接收器配置和端口绑定
2. **内存使用过高**：配置 `memory_limiter` 处理器
3. **处理速度慢**：调整批处理器设置
4. **导出失败**：检查导出器配置和后端连接性

## 性能调优

- 使用 `batch` 处理器提高效率
- 配置 `memory_limiter` 防止 OOM
- 根据吞吐量要求调整队列大小
- 对高容量追踪数据使用采样处理器
- 监控收集器指标以发现瓶颈

## 许可证

OpenTelemetry Collector 采用 Apache 2.0 许可证。详情请参阅 [官方仓库](https://github.com/open-telemetry/opentelemetry-collector)。

## 参考资料

- [官方文档](https://opentelemetry.io/docs/collector/)
- [GitHub 仓库](https://github.com/open-telemetry/opentelemetry-collector)
- [Collector Contrib 仓库](https://github.com/open-telemetry/opentelemetry-collector-contrib)
- [配置参考](https://opentelemetry.io/docs/collector/configuration/)
