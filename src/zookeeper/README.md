# ZooKeeper

[Apache ZooKeeper](https://zookeeper.apache.org/) is a centralized service for maintaining configuration information, naming, providing distributed synchronization, and providing group services.

## Features

- Configuration Management: Centralized configuration management
- Naming Service: Distributed naming service
- Synchronization: Distributed synchronization primitives
- Group Services: Group membership and leader election
- High Availability: Built-in replication and failover

## Quick Start

Start ZooKeeper:

```bash
docker compose up -d
```

## Configuration

### Environment Variables

- `ZOOKEEPER_VERSION`: ZooKeeper version (default: `3.9.3`)
- `ZOOKEEPER_CLIENT_PORT_OVERRIDE`: Client port (default: `2181`)
- `ZOOKEEPER_ADMIN_PORT_OVERRIDE`: Admin server port (default: `8080`)
- `ZOO_TICK_TIME`: Tick time in milliseconds (default: `2000`)
- `ZOO_INIT_LIMIT`: Init limit (default: `10`)
- `ZOO_SYNC_LIMIT`: Sync limit (default: `5`)
- `ZOO_MAX_CLIENT_CNXNS`: Maximum client connections (default: `60`)
- `ZOO_4LW_COMMANDS_WHITELIST`: Four letter words commands whitelist (default: `srvr,mntr,ruok`)

## Access

- Client Port: `localhost:2181`
- Admin Server: <http://localhost:8080>

## Usage

### Connect to ZooKeeper

```bash
docker compose exec zookeeper zkCli.sh
```

### Check Status

```bash
echo ruok | nc localhost 2181
```

Response should be `imok` if ZooKeeper is running properly.

### Get Server Stats

```bash
echo stat | nc localhost 2181
```

## Four Letter Words Commands

ZooKeeper supports a set of commands that are exactly four letters:

- `ruok`: Tests if server is running
- `stat`: Lists server statistics and clients
- `srvr`: Lists server information
- `mntr`: Lists server metrics
- `conf`: Shows server configuration

## Data Storage

ZooKeeper data is stored in three volumes:

- `zookeeper_data`: Main data directory
- `zookeeper_datalog`: Transaction logs
- `zookeeper_logs`: Application logs

## Resources

- Resource Limits: 1 CPU, 1G RAM
- Resource Reservations: 0.25 CPU, 512M RAM

## Production Considerations

For production deployments:

1. Use an ensemble (cluster) of at least 3 nodes
2. Configure proper disk I/O for transaction logs
3. Monitor heap memory usage
4. Set up proper backup strategies
5. Configure firewall rules for all required ports
