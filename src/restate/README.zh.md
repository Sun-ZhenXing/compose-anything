# Restate 单节点服务器

Restate 是一个用于有状态服务的分布式工作流引擎，提供开箱即用的持久化执行、可靠消息传递和状态管理。

## 特性

- **持久化执行**：自动持久化执行状态并在失败时恢复
- **可靠消息传递**：内置消息传递保证
- **状态管理**：具有最小开销的强一致性状态
- **服务发现**：自动服务注册和发现
- **管理 API**：丰富的监控和管理服务 API

## 快速开始

1. 复制环境变量文件：

   ```bash
   cp .env.example .env
   ```

2. 启动服务：

   ```bash
   docker compose up -d
   ```

3. 验证服务运行：

   ```bash
   curl http://localhost:9070/health
   ```

## 服务端点

- **Ingress API**：`http://localhost:8080` - 调用服务的主要 API
- **Admin API**：`http://localhost:9070` - 管理和监控 API
- **节点通信**：端口 5122（内部）

## 环境变量

| 变量                    | 默认值         | 说明                                    |
| ----------------------- | -------------- | --------------------------------------- |
| `RESTATE_VERSION`       | `1.5.3`        | Restate 服务器版本                      |
| `INGRESS_PORT_OVERRIDE` | `8080`         | Ingress API 端口                        |
| `ADMIN_PORT_OVERRIDE`   | `9070`         | Admin API 端口                          |
| `NODE_PORT_OVERRIDE`    | `5122`         | 节点间通信端口                          |
| `RESTATE_LOG_FILTER`    | `restate=info` | 日志级别（trace/debug/info/warn/error） |
| `TZ`                    | `UTC`          | 时区                                    |

## 使用示例

### 部署服务

```bash
# 注册服务端点
curl -X POST http://localhost:9070/deployments \
  -H 'Content-Type: application/json' \
  -d '{"uri": "http://my-service:9080"}'
```

### 列出已部署的服务

```bash
curl http://localhost:9070/services
```

### 调用服务

```bash
curl -X POST http://localhost:8080/MyService/myMethod \
  -H 'Content-Type: application/json' \
  -d '{"key": "value"}'
```

## 数据持久化

Restate 数据存储在命名卷 `restate_data` 中。服务器使用节点名称 `restate-1` 以确保重启时的数据一致性。

要重置服务器并重新开始：

```bash
docker compose down -v
```

## 资源限制

- CPU：0.5-2.0 核心
- 内存：512MB-2GB

根据工作负载在 `docker-compose.yaml` 中调整这些限制。

## 监控

检查服务器健康状态：

```bash
curl http://localhost:9070/health
```

查看服务器指标（Prometheus 格式）：

```bash
curl http://localhost:9070/metrics
```

## 文档

- [官方文档](https://docs.restate.dev/)
- [部署指南](https://docs.restate.dev/server/deploy/docker)
- [配置参考](https://docs.restate.dev/references/server-config)
- [架构](https://docs.restate.dev/references/architecture)

## 许可证

此配置在项目许可证下提供。Restate 采用 [Business Source License 1.1](https://github.com/restatedev/restate/blob/main/LICENSE) 许可。

## 注意事项

- 对于生产部署，考虑使用 [Restate 集群](../restate-cluster/) 以实现高可用性
- 在生产环境中确保数据目录位于持久存储上
- `--node-name` 参数确保重启时的一致数据恢复
- 对于集群部署，请参见 [restate-cluster](../restate-cluster/) 配置
