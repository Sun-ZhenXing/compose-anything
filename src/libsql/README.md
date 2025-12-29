# libSQL Server

[中文说明](README.zh.md)

## Introduction

libSQL is an open-source fork of SQLite optimized for edge deployments and serverless architectures. It offers SQLite compatibility with additional features like primary-replica replication, built-in HTTP/WebSocket API (Hrana protocol), and is designed for distributed database scenarios.

**Key Features:**

- 100% SQLite compatible
- Primary-replica replication support
- Built-in HTTP and WebSocket APIs
- Edge-optimized for low latency
- Open-source and extensible

**Official Resources:**

- GitHub: <https://github.com/tursodatabase/libsql>
- Documentation: <https://github.com/tursodatabase/libsql/tree/main/docs>
- Docker Hub: <https://github.com/tursodatabase/libsql/pkgs/container/libsql-server>

## Quick Start

### 1. Basic Usage (Primary Instance)

```bash
cd src/libsql
docker compose up -d
```

The database will be available at:

- HTTP/Hrana API: <http://localhost:8080>
- gRPC (for replication): localhost:5001

### 2. With Replica Instance

To enable replication, start with the `replica` profile:

```bash
docker compose --profile replica up -d
```

This will start:

- Primary instance on ports 8080 (HTTP) and 5001 (gRPC)
- Replica instance on ports 8081 (HTTP) and 5002 (gRPC)

### 3. Accessing the Database

You can connect to libSQL using:

**Via HTTP API:**

```bash
# Create a table
curl -X POST http://localhost:8080 \
  -H "Content-Type: application/json" \
  -d '{"statements": ["CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT)"]}'

# Insert data
curl -X POST http://localhost:8080 \
  -H "Content-Type: application/json" \
  -d '{"statements": ["INSERT INTO users (name) VALUES ('\''Alice'\'')"]}'

# Query data
curl -X POST http://localhost:8080 \
  -H "Content-Type: application/json" \
  -d '{"statements": ["SELECT * FROM users"]}'
```

**Via libSQL CLI (if installed):**

```bash
libsql client http://localhost:8080
```

## Configuration

### Environment Variables

Key environment variables (see `.env.example` for full list):

| Variable                    | Default              | Description                                      |
| --------------------------- | -------------------- | ------------------------------------------------ |
| `LIBSQL_VERSION`            | `latest`             | libSQL server version                            |
| `LIBSQL_HTTP_PORT_OVERRIDE` | `8080`               | HTTP API port                                    |
| `LIBSQL_GRPC_PORT_OVERRIDE` | `5001`               | gRPC port for replication                        |
| `LIBSQL_NODE`               | `primary`            | Node type: `primary`, `replica`, or `standalone` |
| `LIBSQL_DB_PATH`            | `iku.db`             | Database file name                               |
| `LIBSQL_PRIMARY_URL`        | `http://libsql:5001` | Primary URL for replica nodes                    |
| `TZ`                        | `UTC`                | Timezone                                         |

### Authentication (Optional)

To enable authentication, uncomment and configure these variables:

**HTTP Basic Auth:**

```bash
# Generate base64 encoded credentials
echo -n "username:password" | base64
# Result: dXNlcm5hbWU6cGFzc3dvcmQ=

# Set in .env
LIBSQL_HTTP_AUTH=basic:dXNlcm5hbWU6cGFzc3dvcmQ=
```

**JWT Authentication:**

```bash
# Option 1: Using key file
LIBSQL_AUTH_JWT_KEY_FILE=/path/to/jwt-key.pem

# Option 2: Using key directly
LIBSQL_AUTH_JWT_KEY=your-jwt-key-here
```

### Platform Support

- **x86-64:** Use `LIBSQL_PLATFORM=linux/amd64` (default)
- **ARM64 (Apple Silicon):**
  - Use `LIBSQL_VERSION=latest-arm` for native ARM images
  - Or use `LIBSQL_PLATFORM=linux/amd64` to run via Rosetta

## Data Persistence

Database files are stored in a Docker named volume:

- Volume: `libsql_data`
- Container path: `/var/lib/sqld`

To backup your database:

```bash
# Copy database file from container
docker compose cp libsql:/var/lib/sqld/iku.db ./backup.db
```

## Resource Limits

Default resource allocations per instance:

- CPU: 0.5-1.0 cores
- Memory: 256M-512M

Adjust in `.env` file:

```bash
LIBSQL_CPU_LIMIT=2.0
LIBSQL_MEMORY_LIMIT=1G
```

## Replication Architecture

libSQL supports primary-replica replication:

1. **Primary Instance:** Accepts reads and writes
2. **Replica Instance(s):** Read-only, replicates from primary via gRPC

To add a replica:

```bash
# Start with replica profile
docker compose --profile replica up -d
```

Replicas connect to the primary using `LIBSQL_PRIMARY_URL` and stay synchronized automatically.

## Common Operations

### Check Server Health

```bash
curl http://localhost:8080/health
```

### View Logs

```bash
docker compose logs -f libsql
```

### Restart Service

```bash
docker compose restart libsql
```

### Stop and Remove

```bash
docker compose down
# To remove volumes as well
docker compose down -v
```

## Troubleshooting

### Connection Refused

- Verify the service is running: `docker compose ps`
- Check logs: `docker compose logs libsql`
- Ensure ports are not in use: `netstat -an | grep 8080`

### Replica Not Syncing

- Verify `LIBSQL_PRIMARY_URL` is correct
- Check primary instance is healthy and accessible
- Review replica logs for connection errors

### Performance Issues

- Increase resource limits in `.env`
- Consider using SSD for volume storage
- Enable query logging for optimization

## Security Notes

- **Default Setup:** No authentication enabled - suitable for development only
- **Production:** Always enable authentication (HTTP Basic or JWT)
- **Network:** Consider using Docker networks or reverse proxy for external access
- **Secrets:** Never commit `.env` with credentials to version control

## License

libSQL is licensed under the MIT License. See the [official repository](https://github.com/tursodatabase/libsql) for details.
