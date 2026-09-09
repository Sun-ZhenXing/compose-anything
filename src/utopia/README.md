# Utopia

[English](./README.md) | [中文](./README.zh.md)

Utopia is an enterprise-grade World Model / knowledge engineering platform (bitemporal knowledge graph + hybrid retrieval + agent RAG), licensed under Apache-2.0. This stack runs the Utopia server with a pgvector-backed PostgreSQL database.

> Pre-release warning: upstream only publishes `0.1.0-rc5` (2026-09-05, pre-release, no stable tag). Schema migrations only move forward with no rollback, so back up the database and data volumes before any upgrade. Do not use `latest`.

## Services

- `app`: Utopia server with bundled web UI (port 1516)
- `db`: PostgreSQL 16 with pgvector extension (port 5432 in container, 1517 on host by default)

## Quick Start

```bash
cp .env.example .env
docker compose up -d
```

Then open <http://localhost:1516> and register the first user, which becomes the system administrator. After logging in, go to Administration -> Models to configure chat and embedding models (LLM/embedding providers are external OpenAI-compatible endpoints; no local models or GPU are required).

## Environment Variables

| Variable Name                  | Description                                                    | Default Value                        |
| ------------------------------ | -------------------------------------------------------------- | ------------------------------------ |
| `TZ`                           | Timezone                                                       | `UTC`                                |
| `UTOPIA_VERSION`               | Utopia app image version                                       | `0.1.0-rc5`                          |
| `UTOPIA_DB_VERSION`            | Database image version                                         | `pg16`                               |
| `UTOPIA_IMAGE`                 | Full app image reference                                       | `ghcr.io/deeplethe/utopia:0.1.0-rc5` |
| `UTOPIA_DB_IMAGE`              | Full database image reference                                  | `pgvector/pgvector:pg16`             |
| `UTOPIA_PORT_OVERRIDE`         | Host port mapping (maps to app port 1516 in container)         | `1516`                               |
| `UTOPIA_DB_PORT_OVERRIDE`      | Host port mapping (maps to PostgreSQL port 5432 in container)  | `1517`                               |
| `UTOPIA_DB_PASSWORD`           | Password for the `utopia` PostgreSQL user (first init only)    | `utopia`                             |
| `UTOPIA_JWT_SECRET`            | JWT signing secret (empty = auto-generated into the database)  | `""`                                 |
| `UTOPIA_SECRET_KEY`            | App secret key (empty = generated as `secret.key` in data vol) | `""`                                 |
| `UTOPIA_OPEN_REGISTRATION`     | Allow open user registration                                   | `true`                               |
| `UTOPIA_DB_MAX_CONNECTIONS`    | Max database connections for the app pool                      | `32`                                 |
| `UTOPIA_CPU_LIMIT`             | App CPU limit                                                  | `2`                                  |
| `UTOPIA_CPU_RESERVATION`       | App CPU reservation                                            | `0.1`                                |
| `UTOPIA_MEMORY_LIMIT`          | App memory limit                                               | `2G`                                 |
| `UTOPIA_MEMORY_RESERVATION`    | App memory reservation                                         | `256M`                               |
| `UTOPIA_DB_CPU_LIMIT`          | Database CPU limit                                             | `2`                                  |
| `UTOPIA_DB_CPU_RESERVATION`    | Database CPU reservation                                       | `0.1`                                |
| `UTOPIA_DB_MEMORY_LIMIT`       | Database memory limit                                          | `2G`                                 |
| `UTOPIA_DB_MEMORY_RESERVATION` | Database memory reservation                                    | `512M`                               |

The stack works out of the box with defaults. For evaluation you can keep everything as-is; only setting a stronger `UTOPIA_DB_PASSWORD` is recommended for shared use.

## Volumes

- `utopia_data`: app data (`/app/data`): uploaded files, Tantivy search index, and `secret.key`. Losing it breaks references stored in the database, so always back it up together with the DB.
- `utopia_db_data`: PostgreSQL data (`/var/lib/postgresql/data`).

Back up the database:

```bash
docker compose exec db pg_dump -U utopia utopia > utopia-backup.sql
```

Back up the volumes (example):

```bash
docker run --rm -v utopia_utopia_data:/data -v "%cd%:/backup" alpine tar czf /backup/utopia-data.tgz -C /data .
docker run --rm -v utopia_utopia_db_data:/data -v "%cd%:/backup" alpine tar czf /backup/utopia-db-data.tgz -C /data .
```

Adjust the volume names with `docker volume ls` if your project directory prefix differs.

## Health Checks

- `db`: `pg_isready -U utopia -d utopia`.
- `app`: TCP probe on port 1516 (the slim image has no guaranteed curl/wget). The application-level health endpoint is `GET /api/v1/health`, which returns `{"status":"ok",...}`.

## Security Notes

- There is no default account. The first registered user becomes the system administrator; set `UTOPIA_OPEN_REGISTRATION=false` after initial setup to block further self-registration.
- `UTOPIA_JWT_SECRET` (stored in the database) and `UTOPIA_SECRET_KEY` (`secret.key` in the data volume) are auto-generated on first start if left empty. Set explicit values and back them up for production use.
- `UTOPIA_DB_PASSWORD` only applies on first volume initialization. Changing it afterwards requires updating the database role as well, or recreating the volume with `docker compose down -v` (which deletes all data).
- `cap_drop: ["ALL"]` is applied to `app` only. It is intentionally not applied to `db` because PostgreSQL relies on setuid/setgid and file-ownership capabilities during startup and can fail to start with all capabilities dropped.
- No GPU is required; all LLM/embedding calls go to external OpenAI-compatible endpoints.
- This is a pre-release (`0.1.0-rc5`): expect breaking changes and always back up before upgrading (migrations have no rollback).

## License

Utopia is open source under the [Apache-2.0 License](https://github.com/deeplethe/utopia).
