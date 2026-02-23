# Langfuse

[English](./README.md) | [中文](./README.zh.md)

This service deploys Langfuse, an open-source LLM engineering platform for observability, metrics, evaluations, and prompt management.

## Services

- **langfuse-worker**: Background worker service for processing LLM operations
- **langfuse-web**: Main Langfuse web application server
- **postgres**: PostgreSQL database
- **clickhouse**: ClickHouse analytics database for event storage
- **minio**: S3-compatible object storage for media and exports
- **redis**: In-memory data store for caching and job queues

## Quick Start

1. Copy `.env.example` to `.env`:

   ```bash
   cp .env.example .env
   ```

2. Update critical secrets in `.env`:

   ```bash
   # Generate secure secrets
   NEXTAUTH_SECRET=$(openssl rand -base64 32)
   ENCRYPTION_KEY=$(openssl rand -hex 32)
   POSTGRES_PASSWORD=your-secure-password
   CLICKHOUSE_PASSWORD=your-secure-password
   MINIO_ROOT_PASSWORD=your-secure-password
   REDIS_AUTH=your-secure-redis-password
   ```

3. Start the services:

   ```bash
   docker compose up -d
   ```

4. Access Langfuse at `http://localhost:3000`

## Core Environment Variables

| Variable                                | Description                                     | Default                 |
| --------------------------------------- | ----------------------------------------------- | ----------------------- |
| `LANGFUSE_VERSION`                      | Langfuse container image version                | `3.143.0`               |
| `LANGFUSE_PORT`                         | Web interface port                              | `3000`                  |
| `NEXTAUTH_URL`                          | Public URL of Langfuse instance                 | `http://localhost:3000` |
| `NEXTAUTH_SECRET`                       | NextAuth.js secret (required for production)    | `mysecret`              |
| `ENCRYPTION_KEY`                        | Encryption key for sensitive data (64-char hex) | `0...0`                 |
| `SALT`                                  | Salt for password hashing                       | `mysalt`                |
| `TELEMETRY_ENABLED`                     | Enable anonymous telemetry                      | `true`                  |
| `LANGFUSE_ENABLE_EXPERIMENTAL_FEATURES` | Enable beta features                            | `true`                  |

## Database Configuration

| Variable              | Description         | Default      |
| --------------------- | ------------------- | ------------ |
| `POSTGRES_VERSION`    | PostgreSQL version  | `17`         |
| `POSTGRES_USER`       | Database user       | `postgres`   |
| `POSTGRES_PASSWORD`   | Database password   | `postgres`   |
| `POSTGRES_DB`         | Database name       | `postgres`   |
| `CLICKHOUSE_USER`     | ClickHouse user     | `clickhouse` |
| `CLICKHOUSE_PASSWORD` | ClickHouse password | `clickhouse` |

## Storage & Cache Configuration

| Variable              | Description          | Default         |
| --------------------- | -------------------- | --------------- |
| `MINIO_ROOT_USER`     | MinIO admin username | `minio`         |
| `MINIO_ROOT_PASSWORD` | MinIO admin password | `miniosecret`   |
| `REDIS_AUTH`          | Redis password       | `myredissecret` |

## S3/Media Configuration

| Variable                            | Description               | Default                 |
| ----------------------------------- | ------------------------- | ----------------------- |
| `LANGFUSE_S3_MEDIA_UPLOAD_ENDPOINT` | Media upload S3 endpoint  | `http://localhost:9090` |
| `LANGFUSE_S3_EVENT_UPLOAD_ENDPOINT` | Event upload S3 endpoint  | `http://minio:9000`     |
| `LANGFUSE_S3_BATCH_EXPORT_ENABLED`  | Enable batch export to S3 | `false`                 |

## Volumes

- `langfuse_postgres_data`: PostgreSQL data persistence
- `langfuse_clickhouse_data`: ClickHouse event data
- `langfuse_clickhouse_logs`: ClickHouse logs
- `langfuse_minio_data`: MinIO object storage data

## Resource Limits

All services have configurable CPU and memory limits:

- **langfuse-worker**: 2 CPU cores, 2GB RAM
- **langfuse-web**: 2 CPU cores, 2GB RAM
- **clickhouse**: 2 CPU cores, 4GB RAM
- **minio**: 1 CPU core, 1GB RAM
- **redis**: 1 CPU core, 512MB RAM
- **postgres**: 2 CPU cores, 2GB RAM

Adjust limits in `.env` by modifying `*_CPU_LIMIT`, `*_MEMORY_LIMIT`, `*_CPU_RESERVATION`, and `*_MEMORY_RESERVATION` variables.

## Network Access

- **langfuse-web** (port 3000): Open to all interfaces for external access
- **minio** (port 9090): Open to all interfaces for media uploads
- **All other services**: Bound to `127.0.0.1` (localhost only)

In production, restrict external access using a firewall or reverse proxy.

## Production Setup

For production deployments:

1. **Security**:
   - Generate strong secrets with `openssl rand -base64 32` and `openssl rand -hex 32`
   - Use a reverse proxy (nginx, Caddy) with SSL/TLS
   - Change all default passwords
   - Enable HTTPS by setting `NEXTAUTH_URL` to your domain

2. **Persistence**:
   - Use external volumes or cloud storage for data
   - Configure regular PostgreSQL backups
   - Monitor ClickHouse disk usage

3. **Performance**:
   - Increase resource limits based on workload
   - Consider dedicated ClickHouse cluster for large deployments
   - Configure Redis persistence if needed

## Ports

- **3000**: Langfuse web interface (external)
- **3030**: Langfuse worker API (localhost only)
- **5432**: PostgreSQL (localhost only)
- **8123**: ClickHouse HTTP (localhost only)
- **9000**: ClickHouse native (localhost only)
- **9090**: MinIO S3 API (external)
- **9091**: MinIO console (localhost only)
- **6379**: Redis (localhost only)

## Health Checks

All services include health checks with automatic restart on failure.

## Documentation

- [Langfuse Documentation](https://langfuse.com/docs)
- [Langfuse GitHub](https://github.com/langfuse/langfuse)

## Troubleshooting

### Services failing to start

- Check logs: `docker compose logs <service-name>`
- Ensure all required environment variables are set
- Verify sufficient disk space and system resources

### Database connection errors

- Verify `POSTGRES_PASSWORD` matches between services
- Check that PostgreSQL service is healthy: `docker compose ps`
- Ensure ports are not already in use

### MinIO permission issues

- Clear MinIO data and restart: `docker compose down -v`
- Regenerate MinIO credentials in `.env`
