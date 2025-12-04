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

### 管理工具（profile: `manager`）

- `pulsar-manager`：Pulsar 集群管理 Web UI。

## 环境变量

| 变量名                            | 说明                                      | 默认值                                           |
| --------------------------------- | ----------------------------------------- | ------------------------------------------------ |
| `PULSAR_VERSION`                  | Pulsar 镜像版本                           | `4.0.7`                                          |
| `PULSAR_MANAGER_VERSION`          | Pulsar Manager 镜像版本                   | `v0.4.0`                                         |
| `TZ`                              | 时区                                      | `UTC`                                            |
| `PULSAR_BROKER_PORT_OVERRIDE`     | Pulsar Broker 主机端口（映射到 6650）     | `6650`                                           |
| `PULSAR_HTTP_PORT_OVERRIDE`       | HTTP/Admin API 主机端口（映射到 8080）    | `8080`                                           |
| `PULSAR_MANAGER_PORT_OVERRIDE`    | Pulsar Manager UI 主机端口（映射到 9527） | `9527`                                           |
| `PULSAR_STANDALONE_USE_ZOOKEEPER` | 单机模式使用 ZooKeeper（0 或 1）          | `0`                                              |
| `PULSAR_MEM`                      | 单机模式 JVM 内存设置                     | `-Xms512m -Xmx512m -XX:MaxDirectMemorySize=256m` |
| `PULSAR_CLUSTER_NAME`             | 集群名称（集群模式）                      | `cluster-a`                                      |

请根据实际需求修改 `.env` 文件。

## 卷

- `pulsar_data`：Pulsar 数据目录（单机模式）。
- `pulsar_conf`：Pulsar 配置目录（单机模式）。
- `zookeeper_data`：ZooKeeper 数据目录（集群模式）。
- `bookie_data`：BookKeeper 数据目录（集群模式）。
- `pulsar_manager_data`：Pulsar Manager 数据目录。

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

### 使用 Pulsar Manager

1. 启动并包含 Pulsar Manager：

   ```bash
   docker compose --profile manager up -d
   ```

   或者与集群模式一起使用：

   ```bash
   docker compose --profile cluster --profile manager up -d
   ```

2. 初始化 Pulsar Manager 管理员用户（仅首次）：

   ```bash
   CSRF_TOKEN=$(curl -s http://localhost:7750/pulsar-manager/csrf-token)
   curl -H "X-XSRF-TOKEN: $CSRF_TOKEN" \
        -H "Cookie: XSRF-TOKEN=$CSRF_TOKEN" \
        -H "Content-Type: application/json" \
        -X PUT http://localhost:7750/pulsar-manager/users/superuser \
        -d '{"name": "admin", "password": "apachepulsar", "description": "admin user", "email": "admin@example.com"}'
   ```

3. 访问 Pulsar Manager：`http://localhost:9527`
   - 默认凭据：`admin` / `apachepulsar`

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

| 服务           | 端口 | 说明           |
| -------------- | ---- | -------------- |
| Pulsar Broker  | 6650 | 二进制协议     |
| Pulsar HTTP    | 8080 | REST Admin API |
| Pulsar Manager | 9527 | Web UI         |
| Pulsar Manager | 7750 | 后端 API       |

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
