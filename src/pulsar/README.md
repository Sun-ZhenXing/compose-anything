# Apache Pulsar

[English](./README.md) | [中文](./README.zh.md)

Apache Pulsar is a cloud-native, distributed messaging and streaming platform. It combines the best features of traditional messaging systems like RabbitMQ with the high-throughput of stream processing systems like Kafka.

## Services

### Default (Standalone Mode)

- `pulsar`: Single-node Pulsar instance for development and testing.

### Cluster Mode (profile: `cluster`)

- `zookeeper`: ZooKeeper for cluster coordination.
- `pulsar-init`: Initializes cluster metadata (runs once).
- `bookie`: BookKeeper for persistent message storage.
- `broker`: Pulsar Broker for message routing.

## Environment Variables

| Variable Name                     | Description                                 | Default Value                                    |
| --------------------------------- | ------------------------------------------- | ------------------------------------------------ |
| `PULSAR_VERSION`                  | Pulsar image version                        | `4.0.7`                                          |
| `TZ`                              | Timezone                                    | `UTC`                                            |
| `PULSAR_BROKER_PORT_OVERRIDE`     | Host port for Pulsar broker (maps to 6650)  | `6650`                                           |
| `PULSAR_HTTP_PORT_OVERRIDE`       | Host port for HTTP/Admin API (maps to 8080) | `8080`                                           |
| `PULSAR_STANDALONE_USE_ZOOKEEPER` | Use ZooKeeper in standalone mode (0 or 1)   | `0`                                              |
| `PULSAR_MEM`                      | JVM memory settings for standalone          | `-Xms512m -Xmx512m -XX:MaxDirectMemorySize=256m` |
| `PULSAR_CLUSTER_NAME`             | Cluster name (cluster mode)                 | `cluster-a`                                      |

Please modify the `.env` file as needed for your use case.

## Volumes

- `pulsar_data`: Pulsar data directory (standalone mode).
- `pulsar_conf`: Pulsar configuration directory (standalone mode).
- `zookeeper_data`: ZooKeeper data directory (cluster mode).
- `bookie_data`: BookKeeper data directory (cluster mode).

## Usage

### Standalone Mode (Default)

1. Start Pulsar in standalone mode:

   ```bash
   docker compose up -d
   ```

2. Access Pulsar:
   - Broker: `pulsar://localhost:6650`
   - Admin API: `http://localhost:8080`

### Cluster Mode

1. Start Pulsar cluster:

   ```bash
   docker compose --profile cluster up -d
   ```

2. Wait for all services to be healthy:

   ```bash
   docker compose --profile cluster ps
   ```

## Management and Monitoring

### Pulsar Admin CLI

The `pulsar-admin` CLI is the recommended tool for managing Pulsar. It's included in the Pulsar container.

```bash
# Check cluster health
docker exec pulsar bin/pulsar-admin brokers healthcheck

# List clusters
docker exec pulsar bin/pulsar-admin clusters list

# List tenants
docker exec pulsar bin/pulsar-admin tenants list

# List namespaces
docker exec pulsar bin/pulsar-admin namespaces list public

# Get broker stats
docker exec pulsar bin/pulsar-admin broker-stats monitoring-metrics
```

### REST Admin API

Pulsar provides a comprehensive REST API for management tasks.

```bash
# Get cluster information
curl http://localhost:8080/admin/v2/clusters

# Get broker stats
curl http://localhost:8080/admin/v2/broker-stats/monitoring-metrics

# List tenants
curl http://localhost:8080/admin/v2/tenants

# List namespaces
curl http://localhost:8080/admin/v2/namespaces/public

# Get topic stats
curl http://localhost:8080/admin/v2/persistent/public/default/my-topic/stats
```

### Monitoring with Prometheus

Pulsar exposes Prometheus metrics at the `/metrics` endpoint:

```bash
# Access Pulsar metrics
curl http://localhost:8080/metrics
```

You can integrate with Prometheus and Grafana for visualization. Pulsar provides official Grafana dashboards.

## Testing Pulsar

1. Create a namespace:

   ```bash
   docker exec pulsar bin/pulsar-admin namespaces create public/test-namespace
   ```

2. Create a topic:

   ```bash
   docker exec pulsar bin/pulsar-admin topics create persistent://public/test-namespace/test-topic
   ```

3. List topics:

   ```bash
   docker exec pulsar bin/pulsar-admin topics list public/test-namespace
   ```

4. Produce messages:

   ```bash
   docker exec -it pulsar bin/pulsar-client produce persistent://public/test-namespace/test-topic --messages "Hello Pulsar"
   ```

5. Consume messages:

   ```bash
   docker exec -it pulsar bin/pulsar-client consume persistent://public/test-namespace/test-topic -s "test-subscription" -n 0
   ```

## Client Libraries

Pulsar supports multiple client libraries:

- Java: `org.apache.pulsar:pulsar-client`
- Python: `pip install pulsar-client`
- Go: `github.com/apache/pulsar-client-go`
- Node.js: `pulsar-client`
- C++: Native client available

Example (Python):

```python
import pulsar

client = pulsar.Client('pulsar://localhost:6650')

# Producer
producer = client.create_producer('persistent://public/default/my-topic')
producer.send('Hello Pulsar'.encode('utf-8'))

# Consumer
consumer = client.subscribe('persistent://public/default/my-topic', 'my-subscription')
msg = consumer.receive()
print(f"Received: {msg.data().decode('utf-8')}")
consumer.acknowledge(msg)

client.close()
```

## Configuration

- Standalone mode uses RocksDB as metadata store by default (recommended for single-node).
- Set `PULSAR_STANDALONE_USE_ZOOKEEPER=1` to use ZooKeeper as metadata store.
- Cluster mode is configured for single-node BookKeeper (ensemble size = 1).
- For production, adjust quorum settings and add more bookies.

## Ports

| Service       | Port | Description              |
| ------------- | ---- | ------------------------ |
| Pulsar Broker | 6650 | Binary protocol          |
| Pulsar HTTP   | 8080 | REST Admin API & Metrics |

## Security Notes

- This configuration is for development/testing purposes.
- For production:
  - Enable TLS encryption for broker connections.
  - Configure authentication (JWT, OAuth2, etc.).
  - Enable authorization with role-based access control.
  - Use dedicated ZooKeeper and BookKeeper clusters.
  - Regularly update Pulsar version for security patches.

## License

Apache Pulsar is licensed under the Apache License 2.0.
