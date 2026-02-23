# Redpanda

[English](README.md) | [中文](README.zh.md)

Redpanda is a Kafka-compatible streaming data platform built for performance and developer experience. It is designed to be simple to deploy and manage, with no dependencies on JVM or Zookeeper.

## Features

- **Kafka API Compatible**: Works with existing Kafka clients and tools
- **High Performance**: Built in C++ for maximum throughput and low latency
- **No Zookeeper**: Simplified architecture with built-in consensus
- **Schema Registry**: Built-in schema registry support
- **Developer Friendly**: Easy to deploy and manage with minimal configuration
- **Redpanda Console**: Modern web UI for monitoring and management

## Quick Start

1. Copy the environment file and customize if needed:

   ```bash
   cp .env.example .env
   ```

2. Start the services:

   ```bash
   # Start only Redpanda (without console)
   docker compose up -d

   # Or start with Redpanda Console UI
   docker compose --profile console up -d
   ```

3. If started with console profile, access Redpanda Console at <http://localhost:8080>

4. Verify the cluster is healthy:

   ```bash
   docker compose exec redpanda rpk cluster health
   ```

## Profiles

This configuration supports the following Docker Compose profiles:

- **console**: Enables the Redpanda Console web UI for monitoring and management
  - To start with console: `docker compose --profile console up -d`
  - To start without console: `docker compose up -d`

## Service Endpoints

- **Kafka API** (external): `localhost:19092`
- **Schema Registry**: `localhost:18081`
- **HTTP Proxy**: `localhost:18082`
- **Admin API**: `localhost:19644`
- **Redpanda Console** (when console profile is enabled): `http://localhost:8080`

## Basic Usage

### Create a topic

```bash
docker compose exec redpanda rpk topic create my-topic
```

### List topics

```bash
docker compose exec redpanda rpk topic list
```

### Produce messages

```bash
docker compose exec redpanda rpk topic produce my-topic
```

Type messages and press Ctrl+C to exit.

### Consume messages

```bash
docker compose exec redpanda rpk topic consume my-topic
```

## Environment Variables

| Variable                         | Default   | Description                                 |
| -------------------------------- | --------- | ------------------------------------------- |
| `REDPANDA_VERSION`               | `v24.3.1` | Redpanda version                            |
| `REDPANDA_CONSOLE_VERSION`       | `v3.3.2`  | Redpanda Console version                    |
| `TZ`                             | `UTC`     | Timezone                                    |
| `REDPANDA_KAFKA_PORT_OVERRIDE`   | `19092`   | Kafka API external port                     |
| `REDPANDA_SCHEMA_PORT_OVERRIDE`  | `18081`   | Schema Registry port                        |
| `REDPANDA_PROXY_PORT_OVERRIDE`   | `18082`   | HTTP Proxy port                             |
| `REDPANDA_ADMIN_PORT_OVERRIDE`   | `19644`   | Admin API port                              |
| `REDPANDA_CONSOLE_PORT_OVERRIDE` | `8080`    | Console UI port                             |
| `REDPANDA_SMP`                   | `1`       | Number of CPU cores for processing          |
| `REDPANDA_MEMORY`                | `1G`      | Memory allocation                           |
| `REDPANDA_LOG_LEVEL`             | `info`    | Log level (trace, debug, info, warn, error) |

## Resource Configuration

Default resource limits:

- **Redpanda**:
  - CPU: 1.0-2.0 cores
  - Memory: 1G-2G

- **Console**:
  - CPU: 0.25-0.5 cores
  - Memory: 256M-512M

Adjust these values in `.env` file based on your workload requirements.

## Production Considerations

### Performance Tuning

1. **CPU Cores**: Increase `REDPANDA_SMP` to match available CPU cores
2. **Memory**: Allocate more memory with `REDPANDA_MEMORY` for better performance
3. **Storage**: Use high-performance storage (SSD/NVMe) for production

### Cluster Mode

This configuration runs Redpanda in single-node development mode. For production clusters:

1. Remove `--mode dev-container` flag
2. Configure multiple Redpanda instances
3. Set appropriate replication factors
4. Configure proper security (SASL, TLS)

### Security

For production use, consider:

1. Enable SASL authentication
2. Configure TLS for encryption
3. Set up ACLs for authorization
4. Restrict network access

## Monitoring

Redpanda Console provides a comprehensive monitoring interface including:

- Cluster overview and health
- Topic management and inspection
- Consumer group monitoring
- Schema registry management
- Message browser

Additional metrics are available through Redpanda's Admin API at port 19644.

## Data Persistence

Data is stored in a Docker named volume `redpanda_data`. To backup or migrate:

```bash
# Backup
docker run --rm -v redpanda_redpanda_data:/data -v $(pwd):/backup alpine tar czf /backup/redpanda-backup.tar.gz -C /data .

# Restore
docker run --rm -v redpanda_redpanda_data:/data -v $(pwd):/backup alpine tar xzf /backup/redpanda-backup.tar.gz -C /data
```

## Troubleshooting

### Container fails to start

1. Check available memory: Redpanda requires at least 1GB
2. Verify port availability
3. Check logs: `docker compose logs redpanda`

### Cannot connect to Kafka

1. Ensure ports are properly mapped
2. Verify firewall settings
3. Check advertised listeners configuration

### Performance issues

1. Increase `REDPANDA_SMP` to use more CPU cores
2. Allocate more memory with `REDPANDA_MEMORY`
3. Monitor resource usage in Console

## References

- [Redpanda Documentation](https://docs.redpanda.com/)
- [Redpanda GitHub](https://github.com/redpanda-data/redpanda)
- [Redpanda Console](https://docs.redpanda.com/current/manage/console/)
- [rpk CLI Reference](https://docs.redpanda.com/current/reference/rpk/)

## License

Redpanda is licensed under the [Redpanda Business Source License](https://github.com/redpanda-data/redpanda/blob/dev/licenses/bsl.md).
