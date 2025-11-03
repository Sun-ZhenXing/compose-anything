# Restate Multi-Node Cluster

A highly-available 3-node Restate cluster for production workloads. This configuration provides fault tolerance and automatic failover capabilities.

## Features

- **High Availability**: 3-node cluster can tolerate 1 node failure
- **Data Replication**: Configurable replication factor (default: 2 of 3 nodes)
- **Automatic Snapshots**: Periodic snapshots stored in MinIO (S3-compatible)
- **Load Distribution**: Multiple ingress endpoints for load balancing
- **Metadata Quorum**: Replicated metadata cluster for consistency

## Quick Start

1. Copy environment file:

   ```bash
   cp .env.example .env
   ```

2. Start the cluster:

   ```bash
   docker compose up -d
   ```

3. Verify cluster health:

   ```bash
   # Check node 1
   curl http://localhost:9070/health
   
   # Check node 2
   curl http://localhost:29070/health
   
   # Check node 3
   curl http://localhost:39070/health
   ```

## Architecture

The cluster consists of:

- **3 Restate Nodes**: Distributed workflow engines with replicated state
- **MinIO**: S3-compatible storage for partition snapshots
- **Replicated Bifrost Provider**: Log replication across nodes
- **Metadata Cluster**: Distributed metadata server on all nodes

## Service Endpoints

### Node 1 (Primary)

- Ingress API: `http://localhost:8080`
- Admin API: `http://localhost:9070`
- Node Communication: Port 5122

### Node 2

- Ingress API: `http://localhost:28080`
- Admin API: `http://localhost:29070`
- Node Communication: Port 25122

### Node 3

- Ingress API: `http://localhost:38080`
- Admin API: `http://localhost:39070`
- Node Communication: Port 35122

### MinIO

- API: `http://localhost:9000`
- Console: `http://localhost:9001` (admin UI)
  - Username: `minioadmin`
  - Password: `minioadmin`

## Environment Variables

### Cluster Configuration

| Variable                      | Default           | Description                 |
| ----------------------------- | ----------------- | --------------------------- |
| `RESTATE_VERSION`             | `1.5.3`           | Restate server version      |
| `RESTATE_CLUSTER_NAME`        | `restate-cluster` | Cluster name                |
| `RESTATE_DEFAULT_REPLICATION` | `2`               | Minimum replicas for writes |

### Port Configuration

Each node has three ports:

- `NODEx_INGRESS_PORT_OVERRIDE`: Ingress API port
- `NODEx_ADMIN_PORT_OVERRIDE`: Admin API port
- `NODEx_NODE_PORT_OVERRIDE`: Node-to-node communication port

### Snapshot Configuration

| Variable                                                   | Default                  | Description          |
| ---------------------------------------------------------- | ------------------------ | -------------------- |
| `RESTATE_WORKER__SNAPSHOTS__DESTINATION`                   | `s3://restate/snapshots` | S3 bucket path       |
| `RESTATE_WORKER__SNAPSHOTS__SNAPSHOT_INTERVAL_NUM_RECORDS` | `1000`                   | Records per snapshot |
| `RESTATE_WORKER__SNAPSHOTS__AWS_ENDPOINT_URL`              | `http://minio:9000`      | S3 endpoint          |

### MinIO Configuration

| Variable                      | Default      | Description          |
| ----------------------------- | ------------ | -------------------- |
| `MINIO_VERSION`               | `latest`     | MinIO version        |
| `MINIO_ROOT_USER`             | `minioadmin` | MinIO admin username |
| `MINIO_ROOT_PASSWORD`         | `minioadmin` | MinIO admin password |
| `MINIO_API_PORT_OVERRIDE`     | `9000`       | MinIO API port       |
| `MINIO_CONSOLE_PORT_OVERRIDE` | `9001`       | MinIO console port   |

## Usage Examples

### Deploy a Service (to any node)

```bash
# Deploy to node 1
curl -X POST http://localhost:9070/deployments \
  -H 'Content-Type: application/json' \
  -d '{"uri": "http://my-service:9080"}'
```

### Invoke Service with Load Balancing

Use a load balancer or DNS round-robin across ingress endpoints:

```bash
# Node 1
curl -X POST http://localhost:8080/MyService/myMethod \
  -H 'Content-Type: application/json' \
  -d '{"key": "value"}'

# Node 2
curl -X POST http://localhost:28080/MyService/myMethod \
  -H 'Content-Type: application/json' \
  -d '{"key": "value"}'
```

### Check Cluster Status

```bash
# From any admin API
curl http://localhost:9070/cluster
```

## Fault Tolerance

The cluster is configured with:

- **Replication Factor**: 2 (data written to 2 out of 3 nodes)
- **Quorum**: Requires majority (2/3 nodes) for metadata operations
- **Tolerance**: Can survive 1 node failure without downtime

### Testing Failover

Stop one node:

```bash
docker compose stop restate-2
```

The cluster continues to operate. Services remain available on nodes 1 and 3.

## Snapshots and Backups

Partition snapshots are automatically saved to MinIO every 1000 records. This enables:

- Fast recovery after failures
- Backup and restore capabilities
- Reduced replay time on node restart

### Viewing Snapshots

Access MinIO console at `http://localhost:9001`:

1. Login with `minioadmin` / `minioadmin`
2. Navigate to `restate` bucket
3. Browse `snapshots/` directory

### Backup Strategy

To backup cluster data:

1. Stop the cluster:

   ```bash
   docker compose down
   ```

2. Backup volumes:

   ```bash
   docker run --rm -v restate-cluster_restate_data:/data -v $(pwd)/backup:/backup alpine tar czf /backup/restate-data.tar.gz -C /data .
   docker run --rm -v restate-cluster_minio_data:/data -v $(pwd)/backup:/backup alpine tar czf /backup/minio-data.tar.gz -C /data .
   ```

## Resource Limits

### Per Restate Node

- CPU: 0.5-2.0 cores
- Memory: 512MB-2GB

### MinIO Instance

- CPU: 0.25-1.0 cores
- Memory: 128MB-512MB

Adjust based on workload in `docker-compose.yaml`.

## Scaling

To add more nodes:

1. Add new service in `docker-compose.yaml`
2. Set unique `RESTATE_NODE_NAME` and `RESTATE_FORCE_NODE_ID`
3. Add node address to `RESTATE_METADATA_CLIENT__ADDRESSES`
4. Expose unique ports
5. Set `RESTATE_AUTO_PROVISION=false`

## Production Considerations

- **Storage**: Use durable storage for volumes (EBS, persistent disks)
- **Network**: Ensure low latency between nodes (<10ms)
- **Monitoring**: Set up Prometheus scraping on port 9070
- **Security**: Change MinIO credentials in production
- **Replication**: Adjust `RESTATE_DEFAULT_REPLICATION` based on cluster size
- **Snapshots**: Consider external S3 for snapshot storage

## Monitoring

Each node exposes metrics:

```bash
curl http://localhost:9070/metrics   # Node 1
curl http://localhost:29070/metrics  # Node 2
curl http://localhost:39070/metrics  # Node 3
```

## Troubleshooting

### Node Won't Start

Check logs:

```bash
docker compose logs restate-1
```

Ensure all nodes can reach each other on port 5122.

### Split Brain Prevention

The cluster uses raft consensus with majority quorum. If nodes become partitioned, only the partition with majority (2+ nodes) remains active.

### Data Recovery

If data is corrupted:

1. Stop cluster
2. Restore from volume backups
3. Restart cluster

## Documentation

- [Official Documentation](https://docs.restate.dev/)
- [Cluster Deployment Guide](https://docs.restate.dev/server/clusters)
- [Snapshots Documentation](https://docs.restate.dev/server/snapshots)
- [Configuration Reference](https://docs.restate.dev/references/server-config)

## License

This configuration is provided under the project's license. Restate is licensed under the [Business Source License 1.1](https://github.com/restatedev/restate/blob/main/LICENSE).

## Notes

- For single-node deployments, see [restate](../restate/)
- MinIO is used for demo purposes; use AWS S3/compatible storage in production
- The cluster automatically provisions on first start
- Node IDs are pinned to ensure consistent identity across restarts
