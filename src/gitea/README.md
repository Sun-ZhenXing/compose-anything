# Gitea

[English](./README.md) | [中文](./README.zh.md)

This stack runs Gitea 1.27.3 with the rootless image and PostgreSQL 17.11.

## Services

- `gitea`: Gitea web and SSH service.
- `db`: PostgreSQL database service.
- `gitea_mcp`: Gitea MCP server serving a streamable HTTP endpoint. Optional; it only starts with the `mcp` profile.

## Quick Start

Copying the example environment file is optional. Before the first startup, strongly consider changing `POSTGRES_PASSWORD`; the default is only suitable for local evaluation.

```bash
cp .env.example .env
# Edit POSTGRES_PASSWORD in .env.
docker compose up -d
```

Open <http://localhost:3000> after the services become healthy.

The MCP server is optional and stays off by default. Start it together with the stack:

```bash
docker compose --profile mcp up -d
```

## Initial Setup

Use these database settings on the Gitea installation page:

- Database type: `PostgreSQL`
- Host: `db:5432`
- User: `gitea`, or the value of `POSTGRES_USER`
- Database name: `gitea`, or the value of `POSTGRES_DB`
- Password: the value of `POSTGRES_PASSWORD`

The first registered user becomes an administrator.

## Gitea MCP Server (Optional)

The `gitea_mcp` service runs the official Gitea MCP server over streamable HTTP. It is gated behind the `mcp` profile, so a plain `docker compose up -d` never starts it.

```bash
docker compose --profile mcp up -d
```

The MCP endpoint is then available at <http://localhost:3001/mcp> (`POST` only) and its health endpoint at <http://localhost:3001/healthz>.

Authentication can be supplied in two ways:

- Set `GITEA_MCP_ACCESS_TOKEN` in `.env` with a personal access token created in Gitea under **Settings > Applications**. Every request then uses that token.
- Leave the token empty and let each MCP client send its own `Authorization: Bearer <token>` header.

The service is stateless and stores no data. Its log file lives inside the container and is discarded when the container is recreated; use `docker compose logs gitea_mcp` to read it.

## Configuration

| Variable | Default | Description |
| --- | --- | --- |
| `GITEA_VERSION` | `1.27.3-rootless` | Gitea image tag. |
| `GITEA_DB_TYPE` | `postgres` | Gitea database type. |
| `GITEA_POSTGRES_HOST` | `db:5432` | PostgreSQL address inside the Compose network. |
| `POSTGRES_VERSION` | `17.11` | PostgreSQL image version. |
| `POSTGRES_USER` | `gitea` | Database user. |
| `POSTGRES_PASSWORD` | `gitea` | Database password; change it for production. |
| `POSTGRES_DB` | `gitea` | Database name. |
| `GITEA_HTTP_PORT` | `3000` | Published Gitea HTTP port. |
| `GITEA_SSH_PORT` | `2222` | Published Gitea SSH port. |
| `GITEA_MCP_VERSION` | `1.7.0` | Gitea MCP server image tag. |
| `GITEA_MCP_PORT_OVERRIDE` | `3001` | Host port for the MCP HTTP endpoint. |
| `GITEA_MCP_HOST` | `http://gitea:3000` | Gitea URL as seen from inside the Compose network. |
| `GITEA_MCP_ACCESS_TOKEN` | empty | Gitea personal access token used for every request. |
| `GITEA_MCP_INSECURE` | `false` | Skip TLS verification when `GITEA_MCP_HOST` uses HTTPS. |
| `GITEA_MCP_READONLY` | `false` | Hide MCP tools that modify Gitea data. |

### Default Ports

| Service | Host port | Container port |
| --- | --- | --- |
| Gitea HTTP | `3000` | `3000` |
| Gitea SSH | `2222` | `2222` |
| Gitea MCP | `3001` | `8080` |
| PostgreSQL | Not published | `5432` |

## Storage

- `gitea_data`: Gitea repositories and application data.
- `gitea_config`: Gitea configuration.
- `postgres`: PostgreSQL database files.
- `gitea_mcp` uses no volume; the MCP server keeps no state.

## Upgrading

Before upgrading from an older release, back up the `postgres`, `gitea_data`, and `gitea_config` volumes. Gitea automatically runs database migrations during startup; do not downgrade directly after a migration. Restore a compatible backup instead.

## Security

The Gitea application uses the rootless image. The default database password is only for local evaluation and must be changed in production. Publish the HTTP and SSH ports only when needed, and restrict their network exposure with host firewall or proxy rules.
