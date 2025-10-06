# MariaDB Galera Cluster

[English](./README.md) | [中文](./README.zh.md)

This service deploys a 3-node MariaDB Galera Cluster for high availability and synchronous multi-master replication.

## Services

- `mariadb-galera-1`: First MariaDB Galera node (bootstrap node).
- `mariadb-galera-2`: Second MariaDB Galera node.
- `mariadb-galera-3`: Third MariaDB Galera node.

## Environment Variables

| Variable Name               | Description           | Default Value    |
| --------------------------- | --------------------- | ---------------- |
| MARIADB_VERSION             | MariaDB image version | `11.7.2`         |
| MARIADB_ROOT_PASSWORD       | Root user password    | `galera`         |
| MARIADB_GALERA_CLUSTER_NAME | Galera cluster name   | `galera_cluster` |
| MARIADB_PORT_1_OVERRIDE     | Node 1 port           | `3306`           |
| MARIADB_PORT_2_OVERRIDE     | Node 2 port           | `3307`           |
| MARIADB_PORT_3_OVERRIDE     | Node 3 port           | `3308`           |

Please modify the `.env` file as needed for your use case.

## Volumes

- `mariadb_galera_1_data`: Node 1 data storage.
- `mariadb_galera_2_data`: Node 2 data storage.
- `mariadb_galera_3_data`: Node 3 data storage.

## Usage

### Start the Cluster

```bash
docker-compose up -d
```

The first node (mariadb-galera-1) bootstraps the cluster with `--wsrep-new-cluster`. The other nodes join automatically.

### Connect to the Cluster

Connect to any node:

```bash
mysql -h 127.0.0.1 -P 3306 -u root -p
```

Or:

```bash
mysql -h 127.0.0.1 -P 3307 -u root -p
mysql -h 127.0.0.1 -P 3308 -u root -p
```

### Check Cluster Status

```sql
SHOW STATUS LIKE 'wsrep_cluster_size';
SHOW STATUS LIKE 'wsrep_local_state_comment';
```

The `wsrep_cluster_size` should be 3, and `wsrep_local_state_comment` should show "Synced".

## Features

- **Multi-Master Replication**: All nodes accept writes simultaneously
- **Synchronous Replication**: Data is replicated to all nodes before commit
- **Automatic Failover**: If one node fails, the cluster continues operating
- **High Availability**: No single point of failure with 3 nodes
- **Read/Write on Any Node**: Connect to any node for read and write operations

## Notes

- The first node (mariadb-galera-1) must start first as the bootstrap node
- All nodes must be able to communicate with each other
- For production, consider adding more nodes (5, 7, etc.) for better fault tolerance
- Use an odd number of nodes to avoid split-brain scenarios
- Change the default root password for production use
- The cluster uses `rsync` for State Snapshot Transfer (SST)

## Scaling

To add more nodes, add new service definitions following the pattern of nodes 2 and 3, and update the `wsrep_cluster_address` to include all nodes.

## License

MariaDB is licensed under the GPL v2.
