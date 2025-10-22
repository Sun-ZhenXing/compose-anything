# RocketMQ

Apache RocketMQ 是一个分布式消息和流平台，具有低延迟、高性能和可靠性，万亿级容量和灵活的可扩展性。

## 使用方法

```bash
docker compose up -d
```

## 组件说明

此配置包含：

- **NameServer**：管理 Broker 路由信息
- **Broker**：存储和传递消息
- **Dashboard**：监控和管理的 Web UI

## 配置说明

Broker 配置在 `broker.conf` 文件中，主要设置：

- `brokerClusterName`：集群名称
- `brokerName`：Broker 名称
- `autoCreateTopicEnable`：自动创建主题（默认启用）
- `flushDiskType`：磁盘刷新策略（`ASYNC_FLUSH` 性能更好）

## 端口说明

- `9876`：NameServer 端口
- `10909`：Broker 监听端口（fastRemotingServer）
- `10911`：Broker 端口（remoting server）
- `10912`：Broker HA 端口
- `8080`：Dashboard Web UI

## 访问方式

### Dashboard

访问 RocketMQ Dashboard：<http://localhost:8080>

### 命令行工具

执行管理命令：

```bash
# 列出集群
docker compose exec broker mqadmin clusterList -n namesrv:9876

# 列出主题
docker compose exec broker mqadmin topicList -n namesrv:9876

# 创建主题
docker compose exec broker mqadmin updateTopic -n namesrv:9876 -c DefaultCluster -t TestTopic

# 查询消息
docker compose exec broker mqadmin queryMsgById -n namesrv:9876 -i <messageId>
```

## 示例：发送和接收消息

```bash
# 发送消息
docker compose exec broker sh /home/rocketmq/rocketmq/bin/tools.sh org.apache.rocketmq.example.quickstart.Producer

# 消费消息
docker compose exec broker sh /home/rocketmq/rocketmq/bin/tools.sh org.apache.rocketmq.example.quickstart.Consumer
```

## 客户端连接

配置 RocketMQ 客户端连接到：

- NameServer：`localhost:9876`

## 注意事项

- 这是一个单主配置，适合开发环境
- 生产环境建议使用多主或多主多从配置
- 根据需要在 `JAVA_OPT_EXT` 中调整 JVM 堆大小
- 数据持久化在命名卷中

## 参考资料

- [RocketMQ 官方文档](https://rocketmq.apache.org/docs/quick-start/)
- [RocketMQ Docker Hub](https://hub.docker.com/r/apache/rocketmq)
- [RocketMQ Dashboard](https://github.com/apache/rocketmq-dashboard)
