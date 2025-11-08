# Apache Kafka

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署 Apache Kafka，一个分布式流处理平台，同时包含 Zookeeper 和可选的 Kafka UI。

## 服务

- `zookeeper`：用于 Kafka 协调的 Zookeeper 服务
- `kafka`：Kafka 代理服务
- `kafka-ui`：可选的 Kafka 管理 Web UI（配置文件：`ui`）

## 环境变量

| 变量名                             | 说明                                      | 默认值          |
| ---------------------------------- | ----------------------------------------- | --------------- |
| `KAFKA_VERSION`                    | Kafka 镜像版本                            | `7.8.0`         |
| `KAFKA_UI_VERSION`                 | Kafka UI 镜像版本                         | `latest`        |
| `ZOOKEEPER_CLIENT_PORT_OVERRIDE`   | Zookeeper 主机端口映射（映射到端口 2181） | `2181`          |
| `KAFKA_BROKER_PORT_OVERRIDE`       | Kafka 主机端口映射（映射到端口 9092）     | `9092`          |
| `KAFKA_JMX_PORT_OVERRIDE`          | JMX 主机端口映射（映射到端口 9999）       | `9999`          |
| `KAFKA_UI_PORT_OVERRIDE`           | Kafka UI 主机端口映射（映射到端口 8080）  | `8080`          |
| `KAFKA_NUM_PARTITIONS`             | 自动创建主题的默认分区数                  | `3`             |
| `KAFKA_DEFAULT_REPLICATION_FACTOR` | 默认副本因子                              | `1`             |
| `KAFKA_AUTO_CREATE_TOPICS_ENABLE`  | 启用自动创建主题                          | `true`          |
| `KAFKA_DELETE_TOPIC_ENABLE`        | 启用主题删除                              | `true`          |
| `KAFKA_LOG_RETENTION_HOURS`        | 日志保留时间（小时）                      | `168`           |
| `KAFKA_LOG_SEGMENT_BYTES`          | 日志段大小（字节）                        | `1073741824`    |
| `KAFKA_HEAP_OPTS`                  | Kafka 的 JVM 堆选项                       | `-Xmx1G -Xms1G` |
| `KAFKA_UI_READONLY`                | 将 Kafka UI 设置为只读模式                | `false`         |

请根据实际需求修改 `.env` 文件。

## 卷

- `zookeeper_data`：Zookeeper 数据目录
- `zookeeper_log`：Zookeeper 日志目录
- `kafka_data`：Kafka 数据目录

## 使用方法

1. 启动 Kafka 和 Zookeeper：

   ```bash
   docker compose up -d
   ```

2. 启动并包含 Kafka UI（可选）：

   ```bash
   docker compose --profile ui up -d
   ```

3. 访问 Kafka UI：`http://localhost:8080`（如已启用）

## 测试 Kafka

1. 创建主题：

   ```bash
   docker exec kafka kafka-topics --create --topic test-topic --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
   ```

2. 列出主题：

   ```bash
   docker exec kafka kafka-topics --list --bootstrap-server localhost:9092
   ```

3. 生产消息：

   ```bash
   docker exec -it kafka kafka-console-producer --topic test-topic --bootstrap-server localhost:9092
   ```

4. 消费消息：

   ```bash
   docker exec -it kafka kafka-console-consumer --topic test-topic --from-beginning --bootstrap-server localhost:9092
   ```

## 配置

- Kafka 默认配置为单节点部署
- 生产环境请考虑调整副本因子和其他设置
- 可通过环境变量添加自定义 Kafka 配置

## 安全提示

- 此配置用于开发/测试目的
- 生产环境请启用 SSL/SASL 身份验证
- 保护 Zookeeper 通信安全
- 定期更新 Kafka 版本以获取安全补丁
