# Trigger.dev

[English](./README.md) | [中文](./README.zh.md)

Trigger.dev is an open-source platform for building AI workflows and background jobs in TypeScript. It provides long-running tasks with retries, queues, observability, and elastic scaling.

## Services

### Core Services (Webapp Stack)

| Service                 | Description                                         |
| ----------------------- | --------------------------------------------------- |
| `webapp`                | Main Trigger.dev application with dashboard and API |
| `trigger-postgres`      | PostgreSQL database with logical replication        |
| `trigger-redis`         | Redis for cache and job queue                       |
| `trigger-clickhouse`    | ClickHouse for analytics database                   |
| `trigger-minio`         | S3-compatible object storage                        |
| `trigger-minio-init`    | MinIO bucket initialization                         |
| `electric`              | ElectricSQL for real-time sync                      |
| `trigger-registry`      | Private Docker registry for deployed code           |
| `trigger-registry-init` | Registry htpasswd initialization                    |

### Worker Services (Supervisor Stack)

| Service               | Description                               |
| --------------------- | ----------------------------------------- |
| `supervisor`          | Worker orchestrator that executes tasks   |
| `docker-socket-proxy` | Secure Docker socket proxy for supervisor |

## Prerequisites

- Docker 20.10.0+
- Docker Compose 2.20.0+
- Minimum 6 vCPU and 12 GB RAM for the complete stack

## Quick Start

1. Create a `.env` file with required secrets:

   ```bash
   cp .env.example .env
   ```

2. Generate required secrets:

   ```bash
   # Generate secrets
   echo "SESSION_SECRET=$(openssl rand -hex 16)" >> .env
   echo "MAGIC_LINK_SECRET=$(openssl rand -hex 16)" >> .env
   echo "ENCRYPTION_KEY=$(openssl rand -hex 16)" >> .env
   echo "POSTGRES_PASSWORD=$(openssl rand -hex 16)" >> .env
   ```

3. Start all services:

   ```bash
   docker compose up -d
   ```

4. Wait for services to be healthy:

   ```bash
   docker compose ps
   ```

5. Access the webapp at `http://localhost:8030`

6. Get the magic link from webapp logs for first login:

   ```bash
   docker compose logs -f webapp
   ```

## Environment Variables

### Required Secrets

| Variable            | Description                                                |
| ------------------- | ---------------------------------------------------------- |
| `SESSION_SECRET`    | Session encryption secret (run: `openssl rand -hex 16`)    |
| `MAGIC_LINK_SECRET` | Magic link encryption secret (run: `openssl rand -hex 16`) |
| `ENCRYPTION_KEY`    | Secret store encryption key (run: `openssl rand -hex 16`)  |
| `POSTGRES_PASSWORD` | PostgreSQL password                                        |

### Domain Configuration

| Variable       | Default                 | Description                            |
| -------------- | ----------------------- | -------------------------------------- |
| `APP_ORIGIN`   | `http://localhost:8030` | Public webapp URL                      |
| `LOGIN_ORIGIN` | `http://localhost:8030` | Login URL (usually same as APP_ORIGIN) |
| `API_ORIGIN`   | `http://localhost:8030` | API URL                                |

### Image Versions

| Variable             | Default                        | Description                               |
| -------------------- | ------------------------------ | ----------------------------------------- |
| `TRIGGER_IMAGE_TAG`  | `v4.2.0`                       | Trigger.dev webapp and supervisor version |
| `POSTGRES_VERSION`   | `17.2-alpine3.21`              | PostgreSQL version                        |
| `REDIS_VERSION`      | `7.4.3-alpine3.21`             | Redis version                             |
| `CLICKHOUSE_VERSION` | `25.3`                         | ClickHouse version                        |
| `MINIO_VERSION`      | `RELEASE.2025-04-22T22-12-26Z` | MinIO version                             |

### Port Configuration

| Variable             | Default | Description          |
| -------------------- | ------- | -------------------- |
| `TRIGGER_PORT`       | `8030`  | Webapp port          |
| `MINIO_API_PORT`     | `9000`  | MinIO API port       |
| `MINIO_CONSOLE_PORT` | `9001`  | MinIO console port   |
| `REGISTRY_PORT`      | `5000`  | Docker registry port |

### Authentication

| Variable                    | Description                                                   |
| --------------------------- | ------------------------------------------------------------- |
| `WHITELISTED_EMAILS`        | Regex pattern to restrict login (e.g., `^user@example\.com$`) |
| `AUTH_GITHUB_CLIENT_ID`     | GitHub OAuth client ID                                        |
| `AUTH_GITHUB_CLIENT_SECRET` | GitHub OAuth client secret                                    |

### Email Configuration

| Variable          | Default | Description                                    |
| ----------------- | ------- | ---------------------------------------------- |
| `EMAIL_TRANSPORT` | —       | Transport type: `resend`, `smtp`, or `aws-ses` |
| `FROM_EMAIL`      | —       | From email address                             |
| `RESEND_API_KEY`  | —       | Resend API key (if using Resend)               |
| `SMTP_HOST`       | —       | SMTP server host                               |
| `SMTP_PORT`       | `587`   | SMTP server port                               |

## Volumes

| Volume                    | Description                      |
| ------------------------- | -------------------------------- |
| `trigger_shared`          | Shared volume for worker token   |
| `trigger_postgres_data`   | PostgreSQL data                  |
| `trigger_redis_data`      | Redis data                       |
| `trigger_clickhouse_data` | ClickHouse data                  |
| `trigger_clickhouse_logs` | ClickHouse logs                  |
| `trigger_minio_data`      | MinIO object storage             |
| `trigger_registry_data`   | Docker registry data             |
| `trigger_registry_auth`   | Registry htpasswd authentication |

## Worker Token

On first startup, the webapp generates a worker token and saves it to the shared volume. If you need to run workers on separate machines:

1. Check webapp logs for the token:

   ```bash
   docker compose logs webapp | grep -A15 "Worker Token"
   ```

2. Set the token in the remote worker's `.env`:

   ```bash
   TRIGGER_WORKER_TOKEN=tr_wgt_xxxxx
   ```

## Registry Setup

The built-in registry uses htpasswd authentication. The htpasswd file is **automatically generated** on first startup using the credentials from environment variables.

Default credentials:

- Username: `registry-user` (set via `REGISTRY_USER`)
- Password: `very-secure-indeed` (set via `REGISTRY_PASSWORD`)

To use custom credentials, set them in your `.env` file before first run:

```bash
REGISTRY_USER=my-user
REGISTRY_PASSWORD=my-secure-password
```

Before deploying tasks, login to the registry:

```bash
docker login -u registry-user localhost:5000
```

## CLI Usage

To initialize a project with self-hosted Trigger.dev:

```bash
npx trigger.dev@latest login -a http://localhost:8030
npx trigger.dev@latest init -p <project-ref> -a http://localhost:8030
```

To deploy tasks:

```bash
npx trigger.dev@latest deploy --self-hosted
```

## GitHub OAuth Setup

1. Create a GitHub OAuth App at `https://github.com/settings/developers`
2. Set callback URL: `http://localhost:8030/auth/github/callback`
3. Configure environment variables:

   ```env
   AUTH_GITHUB_CLIENT_ID=your_client_id
   AUTH_GITHUB_CLIENT_SECRET=your_client_secret
   ```

## Production Considerations

- Use strong, unique passwords for all secrets
- Set up proper TLS/SSL with a reverse proxy
- Configure email transport for magic links
- Use external managed databases for high availability
- Set appropriate resource limits based on your workload
- Enable `WHITELISTED_EMAILS` to restrict access
- Consider disabling telemetry: `TRIGGER_TELEMETRY_DISABLED=1`

## Scaling Workers

To add more worker capacity:

1. Set up additional supervisor instances on different machines
2. Configure each with the same `TRIGGER_WORKER_TOKEN`
3. Use unique `TRIGGER_WORKER_INSTANCE_NAME` for each

## Troubleshooting

### Magic links not arriving

- Check webapp logs: `docker compose logs -f webapp`
- Magic links are logged if no email transport is configured
- Set up email transport for production use

### Deployment fails at push step

- Ensure you're logged into the registry: `docker login localhost:5000`
- Check registry is healthy: `docker compose ps trigger-registry`

### Services not starting

- Ensure all required secrets are set in `.env`
- Check logs: `docker compose logs -f`

## References

- [Trigger.dev Documentation](https://trigger.dev/docs)
- [Self-hosting Guide](https://trigger.dev/docs/self-hosting/docker)
- [GitHub Repository](https://github.com/triggerdotdev/trigger.dev)
