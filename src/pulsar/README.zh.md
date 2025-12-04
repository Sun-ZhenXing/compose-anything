# Apache Pulsar

[English](./README.md) | [中文](./README.zh.md)

Apache Pulsar 是一个云原生的分布式消息和流处理平台。它结合了传统消息系统（如 RabbitMQ）的最佳特性和流处理系统（如 Kafka）的高吞吐量优势。

## 服务

### 默认（单机模式）

- `pulsar`：单节点 Pulsar 实例，适用于开发和测试。

### 集群模式（profile: `cluster`）

- `zookeeper`：用于集群协调的 ZooKeeper。
- `pulsar-init`：初始化集群元数据（仅运行一次）。
- `bookie`：用于持久化消息存储的 BookKeeper。
- `broker`：用于消息路由的 Pulsar Broker。

## 环境变量

| 变量名                            | 说明                                   | 默认值                                           |
| --------------------------------- | -------------------------------------- | ------------------------------------------------ |
| `PULSAR_VERSION`                  | Pulsar 镜像版本                        | `4.0.7`                                          |
| `TZ`                              | 时区                                   | `UTC`                                            |
| `PULSAR_BROKER_PORT_OVERRIDE`     | Pulsar Broker 主机端口（映射到 6650）  | `6650`                                           |
| `PULSAR_HTTP_PORT_OVERRIDE`       | HTTP/Admin API 主机端口（映射到 8080） | `8080`                                           |
| `PULSAR_STANDALONE_USE_ZOOKEEPER` | 单机模式使用 ZooKeeper（0 或 1）       | `0`                                              |
| `PULSAR_MEM`                      | 单机模式 JVM 内存设置                  | `-Xms512m -Xmx512m -XX:MaxDirectMemorySize=256m` |
| `PULSAR_CLUSTER_NAME`             | 集群名称（集群模式）                   | `cluster-a`                                      |

请根据实际需求修改 `.env` 文件。

## 卷

- `pulsar_data`：Pulsar 数据目录（单机模式）。
- `pulsar_conf`：Pulsar 配置目录（单机模式）。
- `zookeeper_data`：ZooKeeper 数据目录（集群模式）。
- `bookie_data`：BookKeeper 数据目录（集群模式）。

## 使用方法

### 单机模式（默认）

1. 启动 Pulsar 单机模式：

   ```bash
   docker compose up -d
   ```

2. 访问 Pulsar：
   - Broker：`pulsar://localhost:6650`
   - Admin API：`http://localhost:8080`

### 集群模式

1. 启动 Pulsar 集群：

   ```bash
   docker compose --profile cluster up -d
   ```

2. 等待所有服务健康：

   ```bash
   docker compose --profile cluster ps
   ```

## 管理与监控

### Pulsar Admin CLI

`pulsar-admin` CLI 是管理 Pulsar 的推荐工具，已包含在 Pulsar 容器中。

```bash
# 检查集群健康状态
docker exec pulsar bin/pulsar-admin brokers healthcheck

# 列出集群
docker exec pulsar bin/pulsar-admin clusters list

# 列出租户
docker exec pulsar bin/pulsar-admin tenants list

# 列出命名空间
docker exec pulsar bin/pulsar-admin namespaces list public

# 获取 broker 统计信息
docker exec pulsar bin/pulsar-admin broker-stats monitoring-metrics
```

### REST Admin API

Pulsar 提供了全面的 REST API 用于管理任务。

```bash
# 获取集群信息
curl http://localhost:8080/admin/v2/clusters

# 获取 broker 统计信息
curl http://localhost:8080/admin/v2/broker-stats/monitoring-metrics

# 列出租户
curl http://localhost:8080/admin/v2/tenants

# 列出命名空间
curl http://localhost:8080/admin/v2/namespaces/public

# 获取主题统计信息
curl http://localhost:8080/admin/v2/persistent/public/default/my-topic/stats
```

### 使用 Prometheus 监控

Pulsar 在 `/metrics` 端点暴露 Prometheus 指标：

```bash
# 访问 Pulsar 指标
curl http://localhost:8080/metrics
```

您可以集成 Prometheus 和 Grafana 进行可视化。Pulsar 提供了官方的 Grafana 仪表板。

## 测试 Pulsar

1. 创建命名空间：

   ```bash
   docker exec pulsar bin/pulsar-admin namespaces create public/test-namespace
   ```

2. 创建主题：

   ```bash
   docker exec pulsar bin/pulsar-admin topics create persistent://public/test-namespace/test-topic
   ```

3. 列出主题：

   ```bash
   docker exec pulsar bin/pulsar-admin topics list public/test-namespace
   ```

4. 生产消息：

   ```bash
   docker exec -it pulsar bin/pulsar-client produce persistent://public/test-namespace/test-topic --messages "Hello Pulsar"
   ```

5. 消费消息：

   ```bash
   docker exec -it pulsar bin/pulsar-client consume persistent://public/test-namespace/test-topic -s "test-subscription" -n 0
   ```

## 客户端库

Pulsar 支持多种客户端库：

- Java：`org.apache.pulsar:pulsar-client`
- Python：`pip install pulsar-client`
- Go：`github.com/apache/pulsar-client-go`
- Node.js：`pulsar-client`
- C++：原生客户端可用

示例（Python）：

```python
import pulsar

client = pulsar.Client('pulsar://localhost:6650')

# 生产者
producer = client.create_producer('persistent://public/default/my-topic')
producer.send('Hello Pulsar'.encode('utf-8'))

# 消费者
consumer = client.subscribe('persistent://public/default/my-topic', 'my-subscription')
msg = consumer.receive()
print(f"收到消息: {msg.data().decode('utf-8')}")
consumer.acknowledge(msg)

client.close()
```

## 配置

- 单机模式默认使用 RocksDB 作为元数据存储（推荐用于单节点）。
- 设置 `PULSAR_STANDALONE_USE_ZOOKEEPER=1` 可使用 ZooKeeper 作为元数据存储。
- 集群模式配置为单节点 BookKeeper（ensemble size = 1）。
- 生产环境请调整 quorum 设置并添加更多 bookie。

## 端口

| 服务          | 端口 | 说明                  |
| ------------- | ---- | --------------------- |
| Pulsar Broker | 6650 | 二进制协议            |
| Pulsar HTTP   | 8080 | REST Admin API 和指标 |

## 安全提示

- 此配置用于开发/测试目的。
- 生产环境请：
  - 为 broker 连接启用 TLS 加密。
  - 配置身份验证（JWT、OAuth2 等）。
  - 启用基于角色的访问控制授权。
  - 使用专用的 ZooKeeper 和 BookKeeper 集群。
  - 定期更新 Pulsar 版本以获取安全补丁。

## 许可证

Apache Pulsar 采用 Apache License 2.0 许可证。
