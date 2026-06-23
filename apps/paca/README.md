# Paca

Self-hosted project management platform designed for human + AI collaboration as Scrum team members.

## Services

- `paca-postgres`: PostgreSQL 16 database for persistent storage.
- `paca-valkey`: Valkey 8 cache and pub-sub event bus.
- `paca-minio`: MinIO S3-compatible object store for file uploads.
- `paca-api`: Go REST API backend (port 8080 internal).
- `paca-web`: React SPA frontend served via internal nginx (port 3000 internal).
- `paca-realtime`: Node.js Socket.IO real-time event hub (port 3001 internal).
- `paca-gateway`: Nginx reverse proxy that routes all traffic to the correct service.

## Quick Start

1. Create a `.env` file from the example and set your secrets:

```bash
cp .env.example .env
# Edit .env to set PACA_JWT_SECRET, PACA_ENCRYPTION_KEY, PACA_ADMIN_PASSWORD, etc.
```

1. Start the stack:

```bash
docker compose up -d
```

1. Open `http://localhost` in your browser and log in with the configured admin credentials.

## Key Environment Variables

| Variable                         | Description                       | Default            |
| -------------------------------- | --------------------------------- | ------------------ |
| `PACA_PORT_OVERRIDE`             | Host port for the gateway         | `80`               |
| `PACA_VERSION`                   | Application image tag             | `latest`           |
| `PACA_POSTGRES_PASSWORD`         | PostgreSQL password               | `changeme`         |
| `PACA_ADMIN_USERNAME`            | Initial admin username            | `admin`            |
| `PACA_ADMIN_PASSWORD`            | Initial admin password            | `changeme`         |
| `PACA_JWT_SECRET`                | JWT signing secret (min 32 chars) | (placeholder)      |
| `PACA_ENCRYPTION_KEY`            | AES-256 key for plugin secrets    | (empty)            |
| `PACA_PUBLIC_URL`                | Public base URL                   | `http://localhost` |
| `PACA_STORAGE_PROVIDER`          | Object storage provider           | `minio`            |
| `PACA_STORAGE_ACCESS_KEY_ID`     | Storage access key                | `minioadmin`       |
| `PACA_STORAGE_SECRET_ACCESS_KEY` | Storage secret key                | `minioadmin`       |

## Storage

| Volume                  | Purpose                       |
| ----------------------- | ----------------------------- |
| `paca_postgres_data`    | PostgreSQL database files     |
| `paca_valkey_data`      | Valkey append-only file       |
| `paca_minio_data`       | MinIO object store data       |
| `paca_backend_plugins`  | WASM backend plugin binaries  |
| `paca_frontend_plugins` | Frontend plugin static assets |
| `paca_mcp_plugins`      | MCP plugin bundles            |

## Using External Services

- **External PostgreSQL**: Set `PACA_DATABASE_URL` and run with `--scale paca-postgres=0`.
- **AWS S3 instead of MinIO**: Set `PACA_STORAGE_PROVIDER=s3` and run with `--scale paca-minio=0`.
- **External Valkey/Redis**: Set `PACA_REDIS_URL` and run with `--scale paca-valkey=0`.

## Security Notes

- Generate strong secrets with `openssl rand -hex 32`.
- Change all default passwords before using in production.
- Set `PACA_COOKIE_SECURE=true` when serving over HTTPS.
- The gateway binds to port 80 by default; use a reverse proxy with TLS for production.
- This stack runs multiple services as root (nginx, postgres); consider hardening for production.

## Scaling

You can selectively disable optional services:

```bash
# Without MinIO (use S3 instead)
docker compose up -d --scale paca-minio=0

# Without the web frontend (serve SPA from CDN)
docker compose up -d --scale paca-web=0
```
