# Memos

[English](./README.md) | [中文](./README.zh.md)

Memos is a privacy-first, lightweight note-taking service.

## Services

- `memos`: Memos `0.30.0`, using SQLite by default.

## Quick start

```bash
# Optional: create .env only when changing defaults.
# docker compose up -d works without this file.
cp .env.example .env
docker compose up -d
docker compose ps
```

Open <http://localhost:5230>. On first launch, create the administrator account. Configure signup restrictions and serve Memos through HTTPS before exposing it beyond localhost.

The default bind address is `127.0.0.1`. Set `MEMOS_BIND_ADDRESS=0.0.0.0` only when remote access is intentional, preferably behind an HTTPS reverse proxy.

## Configuration

| Variable | Default | Description |
| --- | --- | --- |
| `MEMOS_VERSION` | `0.30.0` | Official `neosmemo/memos` image tag. |
| `MEMOS_BIND_ADDRESS` | `127.0.0.1` | Host address to bind. |
| `MEMOS_PORT_OVERRIDE` | `5230` | Host port; Memos listens on internal port `5230`. |
| `MEMOS_DRIVER` | `sqlite` | `sqlite`, `postgres`, or `mysql`. |
| `MEMOS_DSN` | empty | External database connection string for PostgreSQL/MySQL. |
| `MEMOS_INSTANCE_URL` | empty | Canonical public URL; required for public memos, Explore, and RSS behavior. |
| `TZ` | `UTC` | Container timezone. |
| `MEMOS_CPU_LIMIT` / `MEMOS_MEMORY_LIMIT` | `1.0` / `512M` | Resource limits. |
| `MEMOS_CPU_RESERVATION` / `MEMOS_MEMORY_RESERVATION` | `0.1` / `128M` | Resource reservations. |

`MEMOS_ADDR`, `MEMOS_PORT`, and `MEMOS_DATA` are fixed container internals: `0.0.0.0`, `5230`, and `/var/opt/memos`; they are not configurable through `.env`. The obsolete `MEMOS_MODE` variable is removed and ignored.

With an empty `MEMOS_INSTANCE_URL`, private mode requires login even for PUBLIC memos, and Explore/RSS are unavailable. Set a canonical public URL to allow anonymous access only to memos whose visibility permits it; this does not make all memos public.

## Storage and updates

The named volume `memos_data` stores SQLite data and local assets at `/var/opt/memos`. When using an external database, this volume is still needed for local assets. Back up the volume and database before upgrades; never use `docker compose down -v` on real data.

Memos applies migrations automatically. Back up first; downgrades are unsupported. Before upgrading to `0.30.0`, review the [upgrade guide](https://usememos.com/docs/operations/upgrade) and [v0.30.0 notes](https://github.com/usememos/memos/releases/tag/v0.30.0): `0.28` SSO users may need to sign in by password and relink SSO, saved-filter `now()` expressions changed to `now`, timestamp CEL behavior changed, and older shared-memo API/MCP clients may need updates.

To update, change `MEMOS_VERSION`, back up data, then run:

```bash
docker compose pull
docker compose up -d
```

## Security

The official entrypoint briefly starts with the privileges needed to initialize ownership, then drops to UID/GID `10001`. The compose file keeps only the required bootstrap capabilities, uses a read-only container filesystem with `/tmp` as tmpfs, and binds to localhost by default.

## Links

- [Memos website](https://usememos.com/)
- [Memos documentation](https://usememos.com/docs)
- [Memos GitHub repository](https://github.com/usememos/memos)
- [MIT License](https://github.com/usememos/memos/blob/main/LICENSE)
