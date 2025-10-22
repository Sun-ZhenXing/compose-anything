# RocketMQ

Apache RocketMQ is a distributed messaging and streaming platform with low latency, high performance and reliability, trillion-level capacity and flexible scalability.

## Usage

```bash
docker compose up -d
```

## Components

This setup includes:

- **NameServer**: Manages broker routing information
- **Broker**: Stores and delivers messages
- **Dashboard**: Web UI for monitoring and management

## Configuration

The broker configuration is in `broker.conf`. Key settings:

- `brokerClusterName`: Cluster name
- `brokerName`: Broker name
- `autoCreateTopicEnable`: Auto-create topics (enabled by default)
- `flushDiskType`: Disk flush strategy (`ASYNC_FLUSH` for better performance)

## Ports

- `9876`: NameServer port
- `10909`: Broker listening port (fastRemotingServer)
- `10911`: Broker port (remoting server)
- `10912`: Broker HA port
- `8080`: Dashboard Web UI

## Access

### Dashboard

Access the RocketMQ Dashboard at: <http://localhost:8080>

### Command Line Tools

Execute admin commands:

```bash
# List clusters
docker compose exec broker mqadmin clusterList -n namesrv:9876

# List topics
docker compose exec broker mqadmin topicList -n namesrv:9876

# Create topic
docker compose exec broker mqadmin updateTopic -n namesrv:9876 -c DefaultCluster -t TestTopic

# Query message
docker compose exec broker mqadmin queryMsgById -n namesrv:9876 -i <messageId>
```

## Example: Send and Receive Messages

```bash
# Send messages
docker compose exec broker sh /home/rocketmq/rocketmq/bin/tools.sh org.apache.rocketmq.example.quickstart.Producer

# Consume messages
docker compose exec broker sh /home/rocketmq/rocketmq/bin/tools.sh org.apache.rocketmq.example.quickstart.Consumer
```

## Client Connection

Configure your RocketMQ client to connect to:

- NameServer: `localhost:9876`

## Notes

- This is a single-master setup suitable for development
- For production, use a multi-master or multi-master-multi-slave setup
- Adjust JVM heap sizes in `JAVA_OPT_EXT` based on your needs
- Data is persisted in named volumes

## References

- [RocketMQ Official Documentation](https://rocketmq.apache.org/docs/quick-start/)
- [RocketMQ Docker Hub](https://hub.docker.com/r/apache/rocketmq)
- [RocketMQ Dashboard](https://github.com/apache/rocketmq-dashboard)
