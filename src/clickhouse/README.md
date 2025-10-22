# ClickHouse

ClickHouse is a fast open-source column-oriented database management system that allows generating analytical data reports in real-time.

## Usage

```bash
docker compose up -d
```

## Configuration

Key environment variables:

- `CLICKHOUSE_DB`: Default database name (default: `default`)
- `CLICKHOUSE_USER`: Default user name (default: `default`)
- `CLICKHOUSE_PASSWORD`: Default user password (default: `clickhouse`)
- `CLICKHOUSE_DEFAULT_ACCESS_MANAGEMENT`: Enable SQL-driven access control (default: `1`)

## Ports

- `8123`: HTTP interface
- `9000`: Native TCP protocol
- `9004`: MySQL protocol emulation
- `9005`: PostgreSQL protocol emulation

## Access

### HTTP Interface

```bash
curl 'http://localhost:8123/?user=default&password=clickhouse' -d 'SELECT 1'
```

### ClickHouse Client

```bash
docker compose exec clickhouse clickhouse-client --user default --password clickhouse
```

### MySQL Protocol

```bash
mysql -h127.0.0.1 -P9004 -udefault -pclickhouse
```

### PostgreSQL Protocol

```bash
psql -h127.0.0.1 -p9005 -Udefault
```

## Example Queries

```sql
-- Create a table
CREATE TABLE events (
    event_date Date,
    event_type String,
    user_id UInt32
) ENGINE = MergeTree()
ORDER BY (event_date, event_type);

-- Insert data
INSERT INTO events VALUES ('2024-01-01', 'click', 1), ('2024-01-01', 'view', 2);

-- Query data
SELECT * FROM events;
```

## Notes

- ClickHouse is optimized for OLAP (Online Analytical Processing) workloads
- It excels at aggregating large amounts of data quickly
- For production, consider using a cluster setup with replication
- Custom configurations can be mounted in `/etc/clickhouse-server/config.d/` and `/etc/clickhouse-server/users.d/`

## References

- [ClickHouse Official Documentation](https://clickhouse.com/docs)
- [ClickHouse Docker Hub](https://hub.docker.com/r/clickhouse/clickhouse-server)
