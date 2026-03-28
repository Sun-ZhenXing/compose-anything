# Mattermost

[中文文档](README.zh.md)

Mattermost is an open-source team collaboration platform that provides chat, file sharing, channels, and integrations. This Compose stack includes Mattermost plus PostgreSQL and is designed to start with a single `docker compose up -d`.

## Quick Start

1. Copy the example environment file:

   ```bash
   cp .env.example .env
   ```

2. Edit `.env` if you want to change the port, site URL, or database password.

3. Start the stack:

   ```bash
   docker compose up -d
   ```

4. Open Mattermost:

   - <http://localhost:8065>

5. Complete the first-run wizard to create the initial system admin account.

## Default Ports

| Service    | Port | Description            |
| ---------- | ---- | ---------------------- |
| Mattermost | 8065 | Web UI and API         |
| PostgreSQL | 5432 | Internal database only |

## Important Environment Variables

| Variable                       | Description                                    | Default                 |
| ------------------------------ | ---------------------------------------------- | ----------------------- |
| `MATTERMOST_VERSION`           | Mattermost Team Edition image tag              | `11.3`                  |
| `MATTERMOST_PORT_OVERRIDE`     | Host port for Mattermost                       | `8065`                  |
| `MATTERMOST_SITE_URL`          | Public URL used by Mattermost                  | `http://localhost:8065` |
| `POSTGRES_DB`                  | PostgreSQL database name                       | `mattermost`            |
| `POSTGRES_USER`                | PostgreSQL user                                | `mmuser`                |
| `POSTGRES_PASSWORD`            | PostgreSQL password                            | `mmchangeit`            |
| `MATTERMOST_ENABLE_LOCAL_MODE` | Enables local mode for administrative commands | `false`                 |
| `TZ`                           | Container timezone                             | `UTC`                   |

## Volumes

- `mattermost_postgres_data`: PostgreSQL data.
- `mattermost_config`: Mattermost config directory.
- `mattermost_data`: Uploaded files and application data.
- `mattermost_logs`: Application logs.
- `mattermost_plugins`: Server-side plugins.
- `mattermost_client_plugins`: Webapp plugins.
- `mattermost_bleve_indexes`: Search indexes.

## Notes

- The application depends on PostgreSQL and waits until the database is healthy before booting.
- The default setup uses Team Edition.
- If you expose Mattermost behind a reverse proxy or different hostname, update `MATTERMOST_SITE_URL`.

## References

- [Mattermost Repository](https://github.com/mattermost/mattermost)
- [Mattermost Team Edition Image](https://hub.docker.com/r/mattermost/mattermost-team-edition)
