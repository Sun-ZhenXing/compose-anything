# InfluxDB

InfluxDB is a high-performance, open-source time series database designed for handling high write and query loads. It is ideal for storing and analyzing metrics, events, and real-time analytics data.

## Features

- **Time Series Optimized**: Purpose-built for time-stamped data
- **High Performance**: Fast writes and queries for time series data
- **SQL-like Query Language**: Flux and InfluxQL for flexible data querying
- **Built-in UI**: Web-based interface for data exploration and visualization
- **Retention Policies**: Automatic data expiration and downsampling
- **Multi-tenancy**: Organizations and buckets for data isolation

## Quick Start

1. Copy the environment file and customize it:

   ```bash
   cp .env.example .env
   ```

2. Edit `.env` to configure your InfluxDB instance:
   - `INFLUXDB_ADMIN_USERNAME`: Admin username (default: admin)
   - `INFLUXDB_ADMIN_PASSWORD`: Admin password (default: changeme123456)
   - `INFLUXDB_ORG`: Organization name (default: myorg)
   - `INFLUXDB_BUCKET`: Default bucket name (default: mybucket)
   - `INFLUXDB_ADMIN_TOKEN`: API access token (default: mytoken123456)

3. Start InfluxDB:

   ```bash
   docker compose up -d
   ```

4. Access the InfluxDB UI at `http://localhost:8086`

## Configuration

### Environment Variables

| Variable                  | Description                         | Default          |
| ------------------------- | ----------------------------------- | ---------------- |
| `INFLUXDB_VERSION`        | InfluxDB version                    | `2.8.0`          |
| `TZ`                      | Timezone                            | `UTC`            |
| `INFLUXDB_INIT_MODE`      | Initialization mode (setup/upgrade) | `setup`          |
| `INFLUXDB_ADMIN_USERNAME` | Admin username                      | `admin`          |
| `INFLUXDB_ADMIN_PASSWORD` | Admin password                      | `changeme123456` |
| `INFLUXDB_ORG`            | Organization name                   | `myorg`          |
| `INFLUXDB_BUCKET`         | Default bucket name                 | `mybucket`       |
| `INFLUXDB_RETENTION`      | Retention period (0 for infinite)   | `0`              |
| `INFLUXDB_ADMIN_TOKEN`    | Admin API token                     | `mytoken123456`  |
| `INFLUXDB_PORT_OVERRIDE`  | Host port binding                   | `8086`           |

### Volumes

- `influxdb_data`: Stores time series data
- `influxdb_config`: Stores configuration files

## Usage

### Accessing the Web UI

Open your browser and navigate to:

```text
http://localhost:8086
```

Login with the credentials configured in your `.env` file.

### Using the CLI

Execute commands inside the container:

```bash
docker compose exec influxdb influx
```

### Writing Data

Using the Flux query language:

```bash
docker compose exec influxdb influx write \
  --bucket mybucket \
  --org myorg \
  'measurement,tag=value field=42'
```

### Querying Data

Query data using the CLI:

```bash
docker compose exec influxdb influx query \
  --org myorg \
  'from(bucket: "mybucket") |> range(start: -1h)'
```

## API Access

InfluxDB provides a RESTful API for programmatic access:

```bash
curl -X POST "http://localhost:8086/api/v2/query?org=myorg" \
  -H "Authorization: Token mytoken123456" \
  -H "Content-Type: application/json" \
  -d '{"query": "from(bucket: \"mybucket\") |> range(start: -1h)"}'
```

## Backup and Restore

### Backup

```bash
docker compose exec influxdb influx backup /var/lib/influxdb2/backup
docker compose cp influxdb:/var/lib/influxdb2/backup ./backup
```

### Restore

```bash
docker compose cp ./backup influxdb:/var/lib/influxdb2/backup
docker compose exec influxdb influx restore /var/lib/influxdb2/backup
```

## Security Considerations

1. **Change Default Credentials**: Always change the default admin password and token in production
2. **Use Strong Tokens**: Generate cryptographically secure tokens for API access
3. **Network Security**: Consider using a reverse proxy with HTTPS in production
4. **Access Control**: Use InfluxDB's built-in authorization system to limit access

## Troubleshooting

### Container won't start

Check the logs:

```bash
docker compose logs influxdb
```

### Cannot access web UI

Ensure port 8086 is not in use:

```bash
netstat -an | grep 8086
```

### Data persistence

Verify volumes are properly mounted:

```bash
docker compose exec influxdb ls -la /var/lib/influxdb2
```

## References

- [Official Documentation](https://docs.influxdata.com/influxdb/v2/)
- [Flux Query Language](https://docs.influxdata.com/flux/v0/)
- [Docker Hub](https://hub.docker.com/_/influxdb)
- [GitHub Repository](https://github.com/influxdata/influxdb)

## License

InfluxDB is available under the MIT License. See the [LICENSE](https://github.com/influxdata/influxdb/blob/master/LICENSE) file for more information.
