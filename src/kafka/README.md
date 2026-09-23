# Apache Kafka

[English](./README.md) | [中文](./README.zh.md)

This service deploys Apache Kafka, a distributed streaming platform, in single-node KRaft mode, along with an optional Kafka UI.

## Services

- `kafka`: The Kafka broker service (single-node KRaft, combined broker and controller).
- `kafka-ui`: Optional web UI for Kafka management (profile: `ui`).

## Environment Variables

| Variable Name                    | Description                                           | Default Value             |
| -------------------------------- | ----------------------------------------------------- | ------------------------- |
| KAFKA_VERSION                    | Kafka image version                                   | `8.3.2`                   |
| KAFKA_UI_VERSION                 | Kafka UI image version                                | `v0.7.2`                  |
| KAFKA_CLUSTER_ID                 | KRaft cluster ID (base64 UUID)                        | `MkU3OEVBNTcwNTJENDM2Qk`  |
| KAFKA_BROKER_PORT_OVERRIDE       | Host port mapping for Kafka (maps to port 9092)       | 9092                      |
| KAFKA_JMX_PORT_OVERRIDE          | Host port mapping for JMX (maps to port 9999)         | 9999                      |
| KAFKA_UI_PORT_OVERRIDE           | Host port mapping for Kafka UI (maps to port 8080)    | 8080                      |
| KAFKA_NUM_PARTITIONS             | Default number of partitions for auto-created topics  | 3                         |
| KAFKA_DEFAULT_REPLICATION_FACTOR | Default replication factor                            | 1                         |
| KAFKA_AUTO_CREATE_TOPICS_ENABLE  | Enable automatic topic creation                       | `true`                    |
| KAFKA_DELETE_TOPIC_ENABLE        | Enable topic deletion                                 | `true`                    |
| KAFKA_LOG_RETENTION_HOURS        | Log retention time in hours                           | 168                       |
| KAFKA_LOG_SEGMENT_BYTES          | Log segment size in bytes                             | 1073741824                |
| KAFKA_HEAP_OPTS                  | JVM heap options for Kafka                            | `-Xmx1G -Xms1G`           |
| KAFKA_UI_READONLY                | Set Kafka UI to readonly mode                         | `false`                   |

> Note: `KAFKA_CLUSTER_ID` must stay stable for the lifetime of the `kafka_data` volume.

Please modify the `.env` file as needed for your use case.

## Volumes

- `kafka_data`: Kafka data directory.

## Usage

1. Start Kafka:

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
   docker compose exec kafka kafka-topics --create --topic test-topic --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
   ```

2. List topics:

   ```bash
   docker compose exec kafka kafka-topics --list --bootstrap-server localhost:9092
   ```

3. Produce messages:

   ```bash
   docker compose exec -it kafka kafka-console-producer --topic test-topic --bootstrap-server localhost:9092
   ```

4. Consume messages:

   ```bash
   docker compose exec -it kafka kafka-console-consumer --topic test-topic --from-beginning --bootstrap-server localhost:9092
   ```

## Configuration

- Kafka is configured for single-node deployment by default
- The broker runs in single-node KRaft mode (combined broker + controller). Combined mode is intended for local development; for production, separate the controller and broker roles or run a multi-node quorum.
- For production, consider adjusting replication factor and other settings
- Custom Kafka configuration can be added via environment variables

## Migrating from ZooKeeper

- Confluent Platform 8.0 and Apache Kafka 4.0 removed ZooKeeper support; `confluentinc/cp-zookeeper` is no longer published for 8.x.
- Because the broker now formats its log directory for KRaft, an existing `kafka_data` volume from the ZooKeeper-based setup cannot be reused — it must be removed (`docker compose down -v`) and the cluster recreated. Existing topic data is lost; migrate topics with MirrorMaker or by producing/consuming, not by keeping the volume.

## Security Notes

- This configuration is for development/testing purposes
- For production, enable SSL/SASL authentication
- The KRaft controller listener is internal to the Compose network and is not published to the host.
- Regularly update Kafka version for security patches
