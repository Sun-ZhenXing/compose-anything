# Gitea

[English](./README.md) | [中文](./README.zh.md)

This stack runs Gitea 1.27.0 with the rootless image and PostgreSQL 17.6.

## Services

- `gitea`: Gitea web and SSH service.
- `db`: PostgreSQL database service.

## Quick Start

Copying the example environment file is optional. Before the first startup, strongly consider changing `POSTGRES_PASSWORD`; the default is only suitable for local evaluation.

```bash
cp .env.example .env
# Edit POSTGRES_PASSWORD in .env.
docker compose up -d
```

Open <http://localhost:3000> after the services become healthy.

## Initial Setup

Use these database settings on the Gitea installation page:

- Database type: `PostgreSQL`
- Host: `db:5432`
- User: `gitea`, or the value of `POSTGRES_USER`
- Database name: `gitea`, or the value of `POSTGRES_DB`
- Password: the value of `POSTGRES_PASSWORD`

The first registered user becomes an administrator.

## Configuration

| Variable | Default | Description |
| --- | --- | --- |
| `GITEA_VERSION` | `1.27.0-rootless` | Gitea image tag. |
| `GITEA_DB_TYPE` | `postgres` | Gitea database type. |
| `GITEA_POSTGRES_HOST` | `db:5432` | PostgreSQL address inside the Compose network. |
| `POSTGRES_VERSION` | `17.6` | PostgreSQL image version. |
| `POSTGRES_USER` | `gitea` | Database user. |
| `POSTGRES_PASSWORD` | `gitea` | Database password; change it for production. |
| `POSTGRES_DB` | `gitea` | Database name. |
| `GITEA_HTTP_PORT` | `3000` | Published Gitea HTTP port. |
| `GITEA_SSH_PORT` | `2222` | Published Gitea SSH port. |

### Default Ports

| Service | Host port | Container port |
| --- | --- | --- |
| Gitea HTTP | `3000` | `3000` |
| Gitea SSH | `2222` | `2222` |
| PostgreSQL | Not published | `5432` |

## Storage

- `gitea_data`: Gitea repositories and application data.
- `gitea_config`: Gitea configuration.
- `postgres`: PostgreSQL database files.

## Upgrading

Before upgrading from an older release, back up the `postgres`, `gitea_data`, and `gitea_config` volumes. Gitea automatically runs database migrations during startup; do not downgrade directly after a migration. Restore a compatible backup instead.

## Security

The Gitea application uses the rootless image. The default database password is only for local evaluation and must be changed in production. Publish the HTTP and SSH ports only when needed, and restrict their network exposure with host firewall or proxy rules.
