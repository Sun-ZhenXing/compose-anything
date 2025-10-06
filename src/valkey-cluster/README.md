# Valkey Cluster

[English](./README.md) | [中文](./README.zh.md)

This service deploys a Valkey cluster with 6 nodes (3 masters and 3 replicas).

## Services

- `valkey-node-1` to `valkey-node-6`: Six Valkey cluster nodes.
- `valkey-cluster-init`: Initialization service that creates the cluster.

## Environment Variables

| Variable Name       | Description                 | Default Value |
| ------------------- | --------------------------- | ------------- |
| VALKEY_VERSION      | Valkey image version        | `8.0-alpine`  |
| VALKEY_PASSWORD     | Password for authentication | `passw0rd`    |
| VALKEY_PORT_1-6     | Host ports for nodes        | 7001-7006     |
| VALKEY_BUS_PORT_1-6 | Host ports for cluster bus  | 17001-17006   |

Please modify the `.env` file as needed for your use case.

## Volumes

- `valkey_data_1` to `valkey_data_6`: Volumes for storing Valkey data for each node.

## Cluster Configuration

The cluster is configured with:

- **6 nodes**: 3 masters and 3 replicas
- **Replication factor**: 1 (each master has 1 replica)
- **Hash slots**: Automatically distributed across masters
- **Automatic failover**: Enabled

## Connection

Connect to the cluster using any Valkey/Redis client with cluster mode enabled:

```bash
# Using valkey-cli
valkey-cli -c -h localhost -p 7001 -a passw0rd

# Using redis-cli (compatible)
redis-cli -c -h localhost -p 7001 -a passw0rd
```

## Notes

- The `valkey-cluster-init` service runs once to create the cluster and then stops.
- If you need to recreate the cluster, remove all volumes and restart.
- For production, consider using at least 6 nodes on different machines.
- The cluster requires all nodes to be reachable from each other.

## Scaling

To add more nodes to the cluster:

1. Add new node services to `docker-compose.yaml`
2. Start the new nodes
3. Use `valkey-cli --cluster add-node` to add them to the cluster
4. Rebalance the hash slots if needed

## License

Valkey is licensed under the BSD 3-Clause License.
