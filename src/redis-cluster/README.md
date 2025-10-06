# Redis Cluster

[English](./README.md) | [中文](./README.zh.md)

This service deploys a Redis Cluster with 6 nodes (3 masters + 3 replicas).

## Services

- `redis-1` to `redis-6`: Redis cluster nodes
- `redis-cluster-init`: Initialization container (one-time setup)

## Environment Variables

| Variable Name | Description         | Default Value  |
| ------------- | ------------------- | -------------- |
| REDIS_VERSION | Redis image version | `8.2.1-alpine` |

Please modify the `.env` file as needed for your use case.

## Volumes

- `redis_1_data` to `redis_6_data`: Data persistence for each Redis node

## Usage

### Start Redis Cluster

```bash
# Start all Redis nodes
docker compose up -d

# Initialize the cluster (first time only)
docker compose --profile init up redis-cluster-init

# Verify cluster status
docker exec redis-1 redis-cli --cluster check redis-1:6379
```

### Connect to Cluster

```bash
# Connect using redis-cli
docker exec -it redis-1 redis-cli -c

# Test cluster
127.0.0.1:6379> CLUSTER INFO
127.0.0.1:6379> SET mykey "Hello"
127.0.0.1:6379> GET mykey
```

### Access from Application

Use cluster mode connection from your application:

```python
# Python example
from redis.cluster import RedisCluster

startup_nodes = [
    {"host": "localhost", "port": "7000"},
    {"host": "localhost", "port": "7001"},
    {"host": "localhost", "port": "7002"},
]
rc = RedisCluster(startup_nodes=startup_nodes, decode_responses=True)
rc.set("foo", "bar")
print(rc.get("foo"))
```

## Ports

- 7000-7005: Mapped to each Redis node's 6379 port

## Cluster Information

- **Masters**: 3 nodes (redis-1, redis-2, redis-3)
- **Replicas**: 3 nodes (redis-4, redis-5, redis-6)
- **Total slots**: 16384 (distributed across masters)

## Adding New Nodes

To add more nodes to the cluster:

1. Add new service in `docker-compose.yaml`
2. Start the new node
3. Add to cluster:

```bash
docker exec redis-1 redis-cli --cluster add-node new-node-ip:6379 redis-1:6379
docker exec redis-1 redis-cli --cluster reshard redis-1:6379
```

## Removing Nodes

```bash
# Remove a node
docker exec redis-1 redis-cli --cluster del-node redis-1:6379 <node-id>
```

## Notes

- Cluster initialization only needs to be done once
- Each node stores a subset of the data
- Automatic failover is handled by Redis Cluster
- Minimum 3 master nodes required for production
- Data is automatically replicated to replica nodes

## Security

- Add password authentication for production:

```bash
command: redis-server --requirepass yourpassword --cluster-enabled yes ...
```

- Use firewall rules to restrict access
- Consider using TLS for inter-node communication in production

## License

Redis is available under the Redis Source Available License 2.0 (RSALv2). See [Redis GitHub](https://github.com/redis/redis) for more information.
