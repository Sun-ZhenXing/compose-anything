# Archon

[English](./README.md) | [中文](./README.zh.md)

Quick start: <https://archon.diy/docs/deployment/docker>.

This service deploys Archon, an open-source workflow engine for AI coding agents. The stack uses the official pre-built web UI + API image, persists Archon's working state in Docker volumes, defaults to SQLite for zero-config startup, and offers an optional `with-db` profile for local PostgreSQL.

## Services

- **archon**: Archon web UI and API server.
- **postgres**: Optional PostgreSQL 17 backend for shared or heavier workflow usage.

## Quick Start

1. Copy `.env.example` to `.env`:

   ```bash
   cp .env.example .env
   ```

2. Set at least one AI credential in `.env`.

   For Docker deployments, prefer `CLAUDE_CODE_OAUTH_TOKEN` or `CLAUDE_API_KEY`. If you use GitHub repositories or webhooks, set both `GH_TOKEN` and `GITHUB_TOKEN` to the same personal access token.

3. Start Archon:

   ```bash
   docker compose up -d
   ```

4. Open `http://localhost:3000`.

## Optional Local PostgreSQL

If you want a local PostgreSQL backend instead of SQLite, set this in `.env`:

```ini
DATABASE_URL=postgresql://postgres:postgres@postgres:5432/remote_coding_agent
```

Then start the optional profile:

```bash
docker compose --profile with-db up -d
```

## Core Environment Variables

| Variable                  | Description                                                                 | Default               |
| ------------------------- | --------------------------------------------------------------------------- | --------------------- |
| `ARCHON_VERSION`          | Archon image tag                                                            | `latest`              |
| `ARCHON_PORT_OVERRIDE`    | Host port for the Archon web UI and API                                     | `3000`                |
| `CLAUDE_CODE_OAUTH_TOKEN` | Claude Code OAuth token for Docker deployments                              | placeholder           |
| `CLAUDE_API_KEY`          | Anthropic API key as an alternative to OAuth                                | *(empty)*             |
| `DEFAULT_AI_ASSISTANT`    | Default assistant for new conversations                                     | `claude`              |
| `DATABASE_URL`            | PostgreSQL connection string; leave empty to use SQLite                     | *(empty)*             |
| `GH_TOKEN`                | GitHub personal access token for cloning private repos and GitHub CLI usage | *(empty)*             |
| `GITHUB_TOKEN`            | Same GitHub token reused by the GitHub adapter                              | *(empty)*             |
| `ARCHON_DATA`             | Optional host path for `/.archon`; leave empty for a named volume           | Docker-managed volume |
| `ARCHON_USER_HOME`        | Optional host path for `/home/appuser`; leave empty for a named volume      | Docker-managed volume |
| `POSTGRES_PASSWORD`       | Password for the optional local PostgreSQL container                        | `postgres`            |

## Volumes

- `archon_data`: SQLite database, registered codebases, workspaces, worktrees, and other Archon-managed data under `/.archon`.
- `archon_user_home`: Persisted `/home/appuser` state, including Claude/Codex auth, `~/.gitconfig`, shell history, and user-installed Archon assets.
- `archon_postgres_data`: PostgreSQL data when the `with-db` profile is enabled.

## Ports

- **3000**: Archon web UI and API
- **5432**: Optional local PostgreSQL, bound to `127.0.0.1` only when the `with-db` profile is enabled

## Resource Requirements

| Service  | CPU Limit | Memory Limit |
| -------- | --------- | ------------ |
| archon   | 2         | 4 GB         |
| postgres | 1         | 1 GB         |

The Archon image includes Chromium and Git tooling. Plan for **4+ GB RAM** and **2+ CPU cores**, and allocate more if you run concurrent workflows or browser-driven validation.

## Notes

- Default startup stores data in SQLite at `/.archon/archon.db`; use `DATABASE_URL` only when you need PostgreSQL.
- The bundled PostgreSQL bootstrap mounts the current `000_combined.sql` schema for fresh installs. If a future upstream release adds incremental PostgreSQL migrations, apply the newer SQL files from the Archon repository before upgrading an existing PostgreSQL data volume.
- If you expose Archon beyond localhost, put it behind an authenticated reverse proxy.

## Documentation

- [Archon Docker Guide](https://archon.diy/docs/deployment/docker)
- [Archon Database Reference](https://archon.diy/docs/reference/database)
- [GitHub](https://github.com/coleam00/Archon)
