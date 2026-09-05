# AFFiNE

[中文文档](README.zh.md) | [English](README.md)

AFFiNE is a collaborative knowledge base combining documents, whiteboards, and databases.

## Services

- `affine`: AFFiNE `ghcr.io/toeverything/affine:0.27.4`, published at `http://localhost:3010`.
- `affine-migration`: Runs the release pre-deployment migration and must exit with code `0` before the app starts.
- `postgres`: PostgreSQL with pgvector, `pgvector/pgvector:0.8.1-pg16-bookworm`, private to the Compose network.
- `redis`: Redis `redis:7.4.11-alpine3.21`, private to the Compose network.

The pinned images support amd64 and ARM64. This stack has not been runtime-tested here.

## Quick start

```bash
cd apps/affine
docker compose up -d
```

The defaults are for local evaluation only. Set `.env` credentials before the first startup for production. For an optional override-based initial setup:

```bash
cp .env.example .env
# PowerShell: Copy-Item .env.example .env
docker compose up -d
```

Open <http://localhost:3010> and follow the onboarding flow.

Check the rendered configuration, migration, and logs with:

```bash
docker compose config -q
docker compose ps -a
docker compose logs affine-migration
docker compose logs -f affine
```

`affine-migration` is expected to show `Exited (0)` after a successful run.

## Configuration

Important variables are `AFFINE_VERSION`, `AFFINE_PORT_OVERRIDE`, `AFFINE_BIND_HOST`, `AFFINE_SERVER_EXTERNAL_URL`, `AFFINE_POSTGRES_USER`, `AFFINE_POSTGRES_DB`, and `AFFINE_POSTGRES_PASSWORD`. The default port is `3010`, bound to `127.0.0.1`.

The PostgreSQL credentials are also embedded in `DATABASE_URL`. Use only URI-unreserved letters, numbers, `-`, and `_` in the username, database name, and password (a random hexadecimal password is recommended), so no URL encoding mismatch occurs. The defaults are for local evaluation only; set a strong password before the first database is created. Changing `.env` alone does not change credentials already stored in PostgreSQL.

Search indexing is disabled by default with `AFFINE_INDEXER_ENABLED=false`; no external search engine is included.

## Storage and security

Named volumes store AFFiNE storage and config, PostgreSQL data, and Redis data. `docker compose down -v` deletes all of them. Back up the named volumes and database before upgrades or removal.

The default bind is local-only for initial administration. If remote access is required, change `AFFINE_BIND_HOST` and `AFFINE_SERVER_EXTERNAL_URL`, then put AFFiNE behind an HTTPS reverse proxy that supports WebSockets. PostgreSQL and Redis have no host ports; Redis's plain local connection is acceptable only on this private Compose network and it must not be shared with untrusted containers.

AFFiNE keeps its vendor image user and writable root filesystem because of the image's `/root` layout. PostgreSQL retains the stock user and required initialization capabilities; Redis runs as `redis` with a read-only root filesystem and writable data volume. These hardening choices are configuration-based and have not been runtime-verified here.

## References

- [AFFiNE source](https://github.com/toeverything/AFFiNE/tree/v0.27.4)
- [Self-host Compose reference](https://raw.githubusercontent.com/toeverything/AFFiNE/v0.27.4/.docker/selfhost/compose.yml)
- [AFFiNE documentation](https://docs.affine.pro/)
