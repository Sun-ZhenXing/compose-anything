# Sub2API

[English](./README.md) | [中文](./README.zh.md)

Quick start: <https://github.com/Wei-Shaw/sub2api>.

This stack deploys Sub2API, an AI API gateway for managing subscription-backed model access, together with PostgreSQL and Redis. The Compose file enables `AUTO_SETUP=true`, so the application performs its first-run initialization automatically.

## Services

- `sub2api`: Web UI and API service.
- `postgres`: PostgreSQL database for application data.
- `redis`: Redis cache and queue backend.

## Quick Start

```bash
docker compose up -d
docker compose logs --tail=100 sub2api
```

Open `http://localhost:8080` after the containers become healthy.

If `SUB2API_ADMIN_PASSWORD` is left empty, Sub2API generates an administrator password on first start. Check the `sub2api` logs and search for `admin password`.

## Configuration

| Variable                      | Description                                                         | Default                     |
| ----------------------------- | ------------------------------------------------------------------- | --------------------------- |
| `SUB2API_VERSION`             | Sub2API image version                                               | `0.1.124`                   |
| `SUB2API_PORT_OVERRIDE`       | Host port for the web UI and API                                    | `8080`                      |
| `SUB2API_POSTGRES_PASSWORD`   | PostgreSQL password used by both the app and the database container | `sub2api`                   |
| `SUB2API_REDIS_PASSWORD`      | Optional Redis password                                             | *(empty)*                   |
| `SUB2API_ADMIN_EMAIL`         | Bootstrap administrator email                                       | `admin@sub2api.local`       |
| `SUB2API_ADMIN_PASSWORD`      | Bootstrap administrator password                                    | *(auto-generated if empty)* |
| `SUB2API_JWT_SECRET`          | Fixed JWT signing secret for persistent sessions                    | *(empty)*                   |
| `SUB2API_TOTP_ENCRYPTION_KEY` | Fixed secret for preserving TOTP data across restarts               | *(empty)*                   |
| `SUB2API_RUN_MODE`            | Application run mode (`standard` or `simple`)                       | `standard`                  |
| `TZ`                          | Container timezone                                                  | `UTC`                       |

## Ports

- `8080`: Sub2API web UI and API.

## Storage

- `sub2api_data`: Runtime data and generated configuration.
- `sub2api_postgres_data`: PostgreSQL data directory.
- `sub2api_redis_data`: Redis persistence data.

## Security Notes

- Change `SUB2API_POSTGRES_PASSWORD` before exposing the stack outside a trusted environment.
- Set fixed values for `SUB2API_JWT_SECRET` and `SUB2API_TOTP_ENCRYPTION_KEY` in production. Leaving them empty is convenient for evaluation, but it invalidates existing sessions or 2FA state after a restart.
- The stack keeps PostgreSQL and Redis on the internal Compose network only; only the Sub2API HTTP port is published to the host.
