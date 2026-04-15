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

## 服务列表

| 服务                             | 镜像                                  | 描述                                     |
| -------------------------------- | ------------------------------------- | ---------------------------------------- |
| `signoz`                         | signoz/signoz:v0.118.0                | 后端、前端 UI 和告警管理器的合体镜像     |
| `otel-collector`                 | signoz/signoz-otel-collector:v0.144.2 | 接收、处理和导出遥测数据                 |
| `clickhouse`                     | clickhouse/clickhouse-server:25.5.6   | 存储追踪、指标和日志的时序数据库         |
| `zookeeper-1`                    | signoz/zookeeper:3.7.1                | ZooKeeper，用于 ClickHouse 副本元数据    |
| `init-clickhouse`                | clickhouse/clickhouse-server:25.5.6   | 一次性初始化，下载 histogramQuantile UDF |
| `signoz-telemetrystore-migrator` | signoz/signoz-otel-collector:v0.144.2 | 一次性 ClickHouse Schema 迁移            |

## 快速开始

1. 复制环境文件并设置 JWT 密钥：

   ```bash
   cp .env.example .env
   # 编辑 .env，将 SIGNOZ_JWT_SECRET 设置为随机字符串
   ```

2. 启动服务：

   ```bash
   docker compose up -d
   ```

3. 访问 SigNoz UI：`http://localhost:8080`

> **注意**：首次启动时，`init-clickhouse` 需要从 GitHub 下载约 10 MB 的二进制文件，请确保网络可访问。

## 默认端口

| 服务                  | 端口 | 描述             |
| --------------------- | ---- | ---------------- |
| SigNoz UI             | 8080 | SigNoz Web 界面  |
| OTel Collector (gRPC) | 4317 | OTLP gRPC 接收器 |
| OTel Collector (HTTP) | 4318 | OTLP HTTP 接收器 |

## 配置说明

### 主要环境变量

| 变量                             | 默认值                      | 描述                                |
| -------------------------------- | --------------------------- | ----------------------------------- |
| `SIGNOZ_JWT_SECRET`              | `please-change-this-secret` | JWT 签名密钥 — **生产环境必须修改** |
| `SIGNOZ_PORT_OVERRIDE`           | `8080`                      | SigNoz UI 宿主机端口                |
| `SIGNOZ_OTEL_GRPC_PORT_OVERRIDE` | `4317`                      | OTLP gRPC 接收器宿主机端口          |
| `SIGNOZ_OTEL_HTTP_PORT_OVERRIDE` | `4318`                      | OTLP HTTP 接收器宿主机端口          |
| `SIGNOZ_VERSION`                 | `v0.118.0`                  | SigNoz 镜像版本                     |
| `SIGNOZ_OTEL_COLLECTOR_VERSION`  | `v0.144.2`                  | OTel Collector 镜像版本             |
| `SIGNOZ_CLICKHOUSE_VERSION`      | `25.5.6`                    | ClickHouse 镜像版本                 |
| `TZ`                             | `UTC`                       | 时区                                |

完整变量列表（含资源限制）请查看 `.env.example`。

### 发送遥测数据

将应用程序的 OpenTelemetry SDK 配置为向以下端点导出数据：

- **gRPC**：`http://localhost:4317`
- **HTTP**：`http://localhost:4318`

## 架构说明

```text
用户 → SigNoz UI（8080）→ signoz 后端
                  ↓
应用 → OTel Collector（4317/4318）→ ClickHouse
                                          ↑
                             Zookeeper（副本元数据）
```

启动顺序：

1. `init-clickhouse` 下载 histogramQuantile 二进制文件，`zookeeper-1` 同步启动
2. `clickhouse` 在初始化完成且 ZooKeeper 健康后启动
3. `signoz-telemetrystore-migrator` 执行 Schema 迁移
4. `signoz` 和 `otel-collector` 启动

## 数据持久化

数据持久化在 Docker 命名卷中：

| 卷名                      | 内容                           |
| ------------------------- | ------------------------------ |
| `clickhouse_data`         | ClickHouse 数据库文件          |
| `clickhouse_user_scripts` | histogramQuantile UDF 二进制   |
| `signoz_data`             | SigNoz SQLite 数据库及应用数据 |
| `zookeeper_data`          | ZooKeeper 状态数据             |

## 安全注意事项

- **生产环境必须将 `SIGNOZ_JWT_SECRET` 修改为唯一的随机值**
- 生产环境中限制端口仅对可信网络暴露
- 生产环境建议在反向代理后面启用 TLS 终止

## 故障排查

1. **服务未启动**：运行 `docker compose logs` 检查连接错误
2. **init-clickhouse 失败**：没有网络访问权限，无法下载 UDF 二进制文件
3. **otel-collector 不健康**：可能正在等待迁移完成，通过 `docker compose logs signoz-telemetrystore-migrator` 检查
4. **无数据显示**：验证 OTel Collector 配置和应用程序的 OpenTelemetry 仪器化

## 参考资料

- [官方文档](https://signoz.io/docs/)
- [GitHub 仓库](https://github.com/SigNoz/signoz)
- [OpenTelemetry 文档](https://opentelemetry.io/docs/)
