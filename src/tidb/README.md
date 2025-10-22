# TiDB

TiDB is an open-source, cloud-native, distributed SQL database designed for modern applications. It is MySQL compatible and provides horizontal scalability, strong consistency, and high availability.

## Usage

```bash
docker compose up -d
```

## Components

This setup includes:

- **PD (Placement Driver)**: Manages and schedules TiKV
- **TiKV**: Distributed transactional key-value storage
- **TiDB**: Stateless SQL layer

## Ports

- `4000`: TiDB MySQL protocol port
- `10080`: TiDB status and metrics port
- `2379`: PD client port
- `20160`: TiKV port

## Access

### MySQL Client

TiDB is compatible with MySQL protocol:

```bash
mysql -h127.0.0.1 -P4000 -uroot
```

### Example Usage

```sql
-- Create database
CREATE DATABASE test;
USE test;

-- Create table
CREATE TABLE users (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(100)
);

-- Insert data
INSERT INTO users VALUES (1, 'Alice', 'alice@example.com');

-- Query data
SELECT * FROM users;
```

### Status and Metrics

Check TiDB status:

```bash
curl http://localhost:10080/status
```

## Features

- **MySQL Compatible**: Drop-in replacement for MySQL
- **Horizontal Scalability**: Scale out by adding more nodes
- **Strong Consistency**: ACID transactions across distributed data
- **High Availability**: Automatic failover with no data loss
- **Hybrid Transactional/Analytical Processing (HTAP)**: Both OLTP and OLAP workloads

## Notes

- This is a minimal single-node setup for development
- For production, deploy multiple PD, TiKV, and TiDB nodes
- Consider adding TiFlash for analytical workloads
- Monitor using Prometheus and Grafana for production deployments
- Data is persisted in named volumes

## Advanced Configuration

For production deployments, consider:

- Using separate machines for PD, TiKV, and TiDB
- Deploying at least 3 PD nodes for high availability
- Deploying at least 3 TiKV nodes for data replication
- Adding TiFlash for columnar storage and faster analytical queries
- Setting up monitoring with TiDB Dashboard, Prometheus, and Grafana

## References

- [TiDB Official Documentation](https://docs.pingcap.com/tidb/stable)
- [TiDB Quick Start](https://docs.pingcap.com/tidb/stable/quick-start-with-tidb)
- [TiDB Docker Images](https://hub.docker.com/u/pingcap)
