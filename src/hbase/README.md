# HBase

HBase is a distributed, scalable, big data store built on top of Hadoop. It provides random, real-time read/write access to your Big Data.

## Usage

```bash
docker compose up -d
```

## Configuration

This setup runs HBase in standalone mode with embedded ZooKeeper.

## Ports

- `16000`: HBase Master port
- `16010`: HBase Master Web UI
- `16020`: HBase RegionServer port
- `16030`: HBase RegionServer Web UI
- `2181`: ZooKeeper client port

## Access

### HBase Shell

Access HBase shell:

```bash
docker compose exec hbase hbase shell
```

### Web UI

- HBase Master UI: <http://localhost:16010>
- HBase RegionServer UI: <http://localhost:16030>

### Example Commands

```bash
# List tables
echo "list" | docker compose exec -T hbase hbase shell -n

# Create a table
echo "create 'test', 'cf'" | docker compose exec -T hbase hbase shell -n

# Put data
echo "put 'test', 'row1', 'cf:a', 'value1'" | docker compose exec -T hbase hbase shell -n

# Scan table
echo "scan 'test'" | docker compose exec -T hbase hbase shell -n
```

## Notes

- This is a standalone setup suitable for development and testing
- For production, consider using a distributed HBase cluster with external ZooKeeper and HDFS
- Data is persisted in named volumes

## References

- [HBase Official Documentation](https://hbase.apache.org/book.html)
- [HBase Docker Image](https://hub.docker.com/r/harisekhon/hbase)
