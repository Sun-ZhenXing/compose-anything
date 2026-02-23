# Apache Cassandra

[English](./README.md) | [中文](./README.zh.md)

This service deploys Apache Cassandra, a highly scalable NoSQL distributed database.

## Services

- `cassandra`: The Cassandra database service.

## Environment Variables

| Variable Name                  | Description                                      | Default Value                 |
| ------------------------------ | ------------------------------------------------ | ----------------------------- |
| CASSANDRA_VERSION              | Cassandra image version                          | `5.0.2`                       |
| CASSANDRA_CQL_PORT_OVERRIDE    | Host port mapping for CQL (maps to port 9042)    | 9042                          |
| CASSANDRA_THRIFT_PORT_OVERRIDE | Host port mapping for Thrift (maps to port 9160) | 9160                          |
| CASSANDRA_CLUSTER_NAME         | Name of the Cassandra cluster                    | `Test Cluster`                |
| CASSANDRA_DC                   | Datacenter name                                  | `datacenter1`                 |
| CASSANDRA_RACK                 | Rack name                                        | `rack1`                       |
| CASSANDRA_ENDPOINT_SNITCH      | Endpoint snitch configuration                    | `GossipingPropertyFileSnitch` |
| CASSANDRA_NUM_TOKENS           | Number of tokens per node                        | 256                           |
| CASSANDRA_SEEDS                | Seed nodes for cluster discovery                 | `cassandra`                   |
| CASSANDRA_START_RPC            | Enable Thrift RPC interface                      | `false`                       |
| MAX_HEAP_SIZE                  | Maximum JVM heap size                            | `1G`                          |
| HEAP_NEWSIZE                   | JVM new generation heap size                     | `100M`                        |

Please modify the `.env` file as needed for your use case.

## Volumes

- `cassandra_data`: Cassandra data directory.
- `cassandra_logs`: Cassandra log directory.
- `./cassandra.yaml`: Optional custom Cassandra configuration file.

## Usage

1. Start the service:

   ```bash
   docker compose up -d
   ```

2. Wait for Cassandra to be ready (check logs):

   ```bash
   docker compose logs -f cassandra
   ```

3. Connect using cqlsh:

   ```bash
   docker exec -it cassandra cqlsh
   ```

## Basic CQL Commands

```sql
-- Create a keyspace
CREATE KEYSPACE test_keyspace
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

-- Use the keyspace
USE test_keyspace;

-- Create a table
CREATE TABLE users (
    id UUID PRIMARY KEY,
    name TEXT,
    email TEXT
);

-- Insert data
INSERT INTO users (id, name, email)
VALUES (uuid(), 'John Doe', 'john@example.com');

-- Query data
SELECT * FROM users;
```

## Health Check

The service includes a health check that verifies Cassandra is responding to CQL queries.

## Security Notes

- This configuration is for development/testing purposes
- For production, enable authentication and SSL/TLS
- Configure proper network security and firewall rules
- Regularly backup your data and update Cassandra version
