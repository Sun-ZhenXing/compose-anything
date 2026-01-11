# SigNoz

[English](README.md) | [中文](README.zh.md)

SigNoz 是一个开源的可观测性平台，为分布式应用程序提供监控和故障排查能力。它在单一平台中提供追踪、指标和日志功能，类似于 DataDog 或 New Relic。

## 功能特性

- **分布式追踪**：跨微服务追踪请求
- **指标监控**：收集和可视化应用程序及基础设施指标
- **日志管理**：集中式日志聚合和分析
- **服务地图**：可视化服务依赖关系和性能
- **告警**：基于指标和追踪配置告警
- **OpenTelemetry 原生**：构建在 OpenTelemetry 标准之上

## 快速开始

1. 复制环境文件并根据需要调整：

   ```bash
   cp .env.example .env
   ```

2. 创建所需的配置文件：

   ```bash
   mkdir -p query-service frontend
   # 根据需要下载或创建配置文件
   ```

3. 启动服务：

   ```bash
   docker compose up -d
   ```

4. 访问 SigNoz UI：`http://localhost:3301`

## 默认端口

| 服务                  | 端口 | 描述             |
| --------------------- | ---- | ---------------- |
| Frontend UI           | 3301 | SigNoz Web 界面  |
| OTel Collector (gRPC) | 4317 | OTLP gRPC 接收器 |
| OTel Collector (HTTP) | 4318 | OTLP HTTP 接收器 |

## 配置说明

### 环境变量

主要环境变量（完整列表请查看 `.env.example`）：

- `SIGNOZ_PORT_OVERRIDE`：前端 UI 端口（默认：3301）
- `SIGNOZ_OTEL_GRPC_PORT_OVERRIDE`：OTLP gRPC 接收器端口（默认：4317）
- `SIGNOZ_OTEL_HTTP_PORT_OVERRIDE`：OTLP HTTP 接收器端口（默认：4318）
- `SIGNOZ_CLICKHOUSE_VERSION`：ClickHouse 版本
- `SIGNOZ_QUERY_SERVICE_VERSION`：查询服务版本
- `SIGNOZ_FRONTEND_VERSION`：前端版本

### 必需的配置文件

此设置需要以下配置文件：

1. **clickhouse-config.xml**：ClickHouse 服务器配置
2. **clickhouse-users.xml**：ClickHouse 用户配置
3. **otel-collector-config.yaml**：OTel Collector 管道配置
4. **query-service/prometheus.yml**：查询服务 Prometheus 配置
5. **frontend/nginx-config.conf**：前端 Nginx 配置

您可以从 [SigNoz 官方仓库](https://github.com/SigNoz/signoz/tree/main/deploy/docker/clickhouse-setup) 获取这些文件。

### 发送遥测数据

要向 SigNoz 发送遥测数据，请配置您的应用程序使用 OpenTelemetry 并使用以下端点：

- **gRPC**：`localhost:4317`
- **HTTP**：`localhost:4318`

Node.js 示例：

```javascript
const { NodeTracerProvider } = require('@opentelemetry/sdk-trace-node');
const { OTLPTraceExporter } = require('@opentelemetry/exporter-trace-otlp-grpc');

const exporter = new OTLPTraceExporter({
  url: 'http://localhost:4317',
});
```

## 架构说明

SigNoz 由以下组件组成：

1. **ClickHouse**：用于存储追踪、指标和日志的时序数据库
2. **OTel Collector**：接收、处理和导出遥测数据
3. **Query Service**：从 ClickHouse 查询数据
4. **Frontend**：用于可视化和分析的 Web UI
5. **Alert Manager**：管理和发送告警

## 资源需求

最低推荐资源：

- **CPU**：4 核
- **内存**：8GB RAM
- **存储**：20GB 数据存储空间

## 数据持久化

数据持久化在 Docker 卷中：

- `clickhouse_data`：ClickHouse 数据库文件
- `signoz_data`：SigNoz 应用程序数据
- `alertmanager_data`：告警管理器数据

## 安全注意事项

- 如适用，请更改默认凭据
- 使用环境变量配置敏感信息
- 生产环境部署时考虑使用密钥管理
- 仅限制必要端口的网络访问
- 生产环境请启用身份验证

## 健康检查

所有服务都包含健康检查以确保正确启动和依赖管理：

- ClickHouse：HTTP 健康端点
- OTel Collector：HTTP 健康端点
- Query Service：HTTP 健康端点
- Frontend：HTTP 健康端点
- Alert Manager：HTTP 健康端点

## 故障排查

1. **服务未启动**：使用 `docker compose logs` 检查日志
2. **无数据显示**：验证 OTel Collector 配置和应用程序仪器化
3. **内存使用过高**：调整 ClickHouse 内存限制或数据保留策略

## 许可证

SigNoz 采用 MIT 许可证。详情请参阅 [官方仓库](https://github.com/SigNoz/signoz)。

## 参考资料

- [官方文档](https://signoz.io/docs/)
- [GitHub 仓库](https://github.com/SigNoz/signoz)
- [OpenTelemetry 文档](https://opentelemetry.io/docs/)
