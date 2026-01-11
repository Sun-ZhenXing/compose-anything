# Grafana Tempo

[English Documentation](README.md)

Grafana Tempo 是一个开源、易于使用且高度可扩展的分布式追踪后端。Tempo 非常经济高效，仅需对象存储即可运行，并与 Grafana、Prometheus 和 Loki 深度集成。

## 特性

- **成本效益**：使用对象存储（支持 S3、GCS、Azure、文件系统）
- **易于操作**：除对象存储外无其他依赖
- **多租户**：内置多租户支持
- **多种协议**：支持 OTLP、Jaeger 和 Zipkin
- **TraceQL**：用于追踪数据的强大查询语言
- **指标生成**：可从追踪生成 RED 指标

## 快速开始

1. 复制示例环境文件：

    ```bash
    cp .env.example .env
    ```

2. 启动服务：

    ```bash
    docker compose up -d
    ```

3. 验证服务正在运行：

    ```bash
    docker compose ps
    curl http://localhost:3200/ready
    ```

## 配置

### 环境变量

| 变量                                     | 默认值  | 描述                    |
| ---------------------------------------- | ------- | ----------------------- |
| `TEMPO_VERSION`                          | `2.7.2` | Tempo 版本              |
| `TEMPO_HTTP_PORT_OVERRIDE`               | `3200`  | HTTP API 端口           |
| `TEMPO_GRPC_PORT_OVERRIDE`               | `9095`  | gRPC 端口               |
| `TEMPO_OTLP_HTTP_PORT_OVERRIDE`          | `4318`  | OTLP HTTP 接收器端口    |
| `TEMPO_OTLP_GRPC_PORT_OVERRIDE`          | `4317`  | OTLP gRPC 接收器端口    |
| `TEMPO_ZIPKIN_PORT_OVERRIDE`             | `9411`  | Zipkin 接收器端口       |
| `TEMPO_JAEGER_THRIFT_HTTP_PORT_OVERRIDE` | `14268` | Jaeger Thrift HTTP 端口 |
| `TEMPO_JAEGER_GRPC_PORT_OVERRIDE`        | `14250` | Jaeger gRPC 端口        |
| `TZ`                                     | `UTC`   | 时区                    |
| `TEMPO_CPU_LIMIT`                        | `1.0`   | CPU 限制                |
| `TEMPO_MEMORY_LIMIT`                     | `1G`    | 内存限制                |
| `TEMPO_CPU_RESERVATION`                  | `0.25`  | CPU 预留                |
| `TEMPO_MEMORY_RESERVATION`               | `256M`  | 内存预留                |

### 支持的追踪协议

- **OTLP**（OpenTelemetry 协议）：端口 4317（gRPC），4318（HTTP）
- **Zipkin**：端口 9411
- **Jaeger**：端口 14250（gRPC），14268（Thrift HTTP）

### 默认配置

该服务包含一个基本配置文件（`tempo-config.yaml`），该文件：

- 启用所有主要追踪接收器（OTLP、Jaeger、Zipkin）
- 使用本地文件系统存储
- 配置追踪保留和压缩
- 启用从追踪生成指标（需要 Prometheus）

对于生产部署，您应该根据需求自定义配置。

## 与 Grafana 集成

1. 在 Grafana 中添加 Tempo 作为数据源：
   - URL：`http://tempo:3200`（如果在同一 Docker 网络中运行）
   - 或者：`http://localhost:3200`（从主机访问）

2. 使用 TraceQL 或追踪 ID 查询追踪

3. 启用追踪到日志和追踪到指标的关联

## 向 Tempo 发送追踪

### OpenTelemetry SDK

配置您的应用程序向 Tempo 发送追踪：

```python
from opentelemetry import trace
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor

# 配置 OTLP 导出器
otlp_exporter = OTLPSpanExporter(
    endpoint="http://localhost:4317",
    insecure=True
)

# 设置追踪器提供程序
trace.set_tracer_provider(TracerProvider())
trace.get_tracer_provider().add_span_processor(
    BatchSpanProcessor(otlp_exporter)
)
```

### 使用 cURL（测试）

通过 HTTP 发送测试追踪：

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

### Jaeger 客户端库

配置 Jaeger 客户端向 Tempo 的 Jaeger 兼容端点发送：

```yaml
JAEGER_AGENT_HOST: localhost
JAEGER_AGENT_PORT: 14250
```

## 存储

追踪存储在名为 `tempo_data` 的 Docker 卷中。

## 指标生成

Tempo 可以从追踪生成 RED（速率、错误、持续时间）指标。默认配置尝试将这些指标发送到 `http://prometheus:9090` 的 Prometheus。如果您没有运行 Prometheus，您可以：

1. 从 `tempo-config.yaml` 中删除 `remote_write` 部分
2. 设置 Prometheus 以接收来自 Tempo 的指标

## 健康检查

该服务包含健康检查，每 30 秒监控一次 `/ready` 端点。

## 资源需求

- **最低要求**：256MB RAM，0.25 CPU
- **推荐配置**：1GB RAM，1 CPU（用于中等追踪量）
- **生产环境**：根据追踪摄入速率和保留期限进行扩展

## 安全注意事项

默认配置：

- 以非 root 用户运行（UID:GID 10001:10001）
- 为不同协议暴露多个端口
- 使用文件系统存储（不适用于分布式部署）

对于生产环境：

- 使用对象存储（S3、GCS、Azure Blob）
- 启用身份验证和加密
- 实施适当的网络安全和访问控制
- 配置适当的保留策略
- 考虑以分布式模式运行以实现高可用性

## TraceQL 示例

在 Grafana 中使用 TraceQL 查询追踪：

```traceql
# 查找慢追踪
{ duration > 1s }

# 查找有错误的追踪
{ status = error }

# 查找特定服务的追踪
{ resource.service.name = "frontend" }

# 复杂查询
{ resource.service.name = "frontend" && duration > 100ms && status = error }
```

## 文档

- [官方文档](https://grafana.com/docs/tempo/latest/)
- [TraceQL 查询语言](https://grafana.com/docs/tempo/latest/traceql/)
- [配置参考](https://grafana.com/docs/tempo/latest/configuration/)
- [GitHub 仓库](https://github.com/grafana/tempo)

## 许可证

Tempo 使用 [AGPLv3 许可证](https://github.com/grafana/tempo/blob/main/LICENSE)。
