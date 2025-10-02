# Apache Kafka

[English](./README.md) | [中文](./README.zh.md)

This service deploys Apache Kafka, a distributed streaming platform, along with Zookeeper and optional Kafka UI.

## Services

- `zookeeper`: Zookeeper service for Kafka coordination.
- `kafka`: The Kafka broker service.
- `kafka-ui`: Optional web UI for Kafka management (profile: `ui`).

## Environment Variables

| Variable Name                    | Description                                          | Default Value   |
| -------------------------------- | ---------------------------------------------------- | --------------- |
| KAFKA_VERSION                    | Kafka image version                                  | `7.8.0`         |
| KAFKA_UI_VERSION                 | Kafka UI image version                               | `latest`        |
| ZOOKEEPER_CLIENT_PORT_OVERRIDE   | Host port mapping for Zookeeper (maps to port 2181)  | 2181            |
| KAFKA_BROKER_PORT_OVERRIDE       | Host port mapping for Kafka (maps to port 9092)      | 9092            |
| KAFKA_JMX_PORT_OVERRIDE          | Host port mapping for JMX (maps to port 9999)        | 9999            |
| KAFKA_UI_PORT_OVERRIDE           | Host port mapping for Kafka UI (maps to port 8080)   | 8080            |
| KAFKA_NUM_PARTITIONS             | Default number of partitions for auto-created topics | 3               |
| KAFKA_DEFAULT_REPLICATION_FACTOR | Default replication factor                           | 1               |
| KAFKA_AUTO_CREATE_TOPICS_ENABLE  | Enable automatic topic creation                      | `true`          |
| KAFKA_DELETE_TOPIC_ENABLE        | Enable topic deletion                                | `true`          |
| KAFKA_LOG_RETENTION_HOURS        | Log retention time in hours                          | 168             |
| KAFKA_LOG_SEGMENT_BYTES          | Log segment size in bytes                            | 1073741824      |
| KAFKA_HEAP_OPTS                  | JVM heap options for Kafka                           | `-Xmx1G -Xms1G` |
| KAFKA_UI_READONLY                | Set Kafka UI to readonly mode                        | `false`         |

Please modify the `.env` file as needed for your use case.

## Volumes

- `zookeeper_data`: Zookeeper data directory.
- `zookeeper_log`: Zookeeper log directory.
- `kafka_data`: Kafka data directory.

## Usage

1. Start Kafka with Zookeeper:

   ```bash
   docker compose up -d
   ```

2. Start with Kafka UI (optional):

   ```bash
   docker compose --profile ui up -d
   ```

3. Access Kafka UI at `http://localhost:8080` (if enabled).

## Testing Kafka

1. Create a topic:

   ```bash
   docker exec kafka kafka-topics --create --topic test-topic --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
   ```

2. List topics:

   ```bash
   docker exec kafka kafka-topics --list --bootstrap-server localhost:9092
   ```

3. Produce messages:

   ```bash
   docker exec -it kafka kafka-console-producer --topic test-topic --bootstrap-server localhost:9092
   ```

4. Consume messages:

   ```bash
   docker exec -it kafka kafka-console-consumer --topic test-topic --from-beginning --bootstrap-server localhost:9092
   ```

## Configuration

- Kafka is configured for single-node deployment by default
- For production, consider adjusting replication factor and other settings
- Custom Kafka configuration can be added via environment variables

## Security Notes

- This configuration is for development/testing purposes
- For production, enable SSL/SASL authentication
- Secure Zookeeper communication
- Regularly update Kafka version for security patches
