# n8n

[English](./README.md) | [中文](./README.zh.md)

This service deploys n8n, a fair-code workflow automation platform with native AI capabilities.

## Services

- `n8n`: The main n8n application server.
- `n8n-db`: PostgreSQL database for n8n (optional, uses SQLite by default).

## Profiles

- `default`: Runs n8n with SQLite (no external database required).
- `postgres`: Runs n8n with PostgreSQL database.

To use PostgreSQL, start with:

```bash
docker compose --profile postgres up -d
```

## Environment Variables

| Variable Name           | Description                                      | Default Value            |
| ----------------------- | ------------------------------------------------ | ------------------------ |
| N8N_VERSION             | n8n image version                                | `1.114.0`                |
| N8N_PORT                | Host port mapping for n8n web interface          | `5678`                   |
| N8N_BASIC_AUTH_ACTIVE   | Enable basic authentication                      | `true`                   |
| N8N_BASIC_AUTH_USER     | Basic auth username (required if auth is active) | `""`                     |
| N8N_BASIC_AUTH_PASSWORD | Basic auth password (required if auth is active) | `""`                     |
| N8N_HOST                | Host address                                     | `0.0.0.0`                |
| N8N_PROTOCOL            | Protocol (http or https)                         | `http`                   |
| WEBHOOK_URL             | Webhook URL for external access                  | `http://localhost:5678/` |
| GENERIC_TIMEZONE        | Timezone for n8n                                 | `UTC`                    |
| TZ                      | System timezone                                  | `UTC`                    |
| DB_TYPE                 | Database type (sqlite or postgresdb)             | `sqlite`                 |
| DB_POSTGRESDB_DATABASE  | PostgreSQL database name                         | `n8n`                    |
| DB_POSTGRESDB_HOST      | PostgreSQL host                                  | `n8n-db`                 |
| DB_POSTGRESDB_PORT      | PostgreSQL port                                  | `5432`                   |
| DB_POSTGRESDB_USER      | PostgreSQL username                              | `n8n`                    |
| DB_POSTGRESDB_PASSWORD  | PostgreSQL password                              | `n8n123`                 |
| POSTGRES_VERSION        | PostgreSQL image version                         | `17.2-alpine3.21`        |
| EXECUTIONS_MODE         | Execution mode (regular or queue)                | `regular`                |
| N8N_ENCRYPTION_KEY      | Encryption key for credentials                   | `""`                     |

Please create a `.env` file and modify it as needed for your use case.

## Volumes

- `n8n_data`: A volume for storing n8n data (workflows, credentials, etc.).
- `n8n_db_data`: A volume for storing PostgreSQL data (when using PostgreSQL profile).

## Getting Started

### SQLite (Default)

1. Create a `.env` file with authentication credentials:

   ```env
   N8N_BASIC_AUTH_USER=admin
   N8N_BASIC_AUTH_PASSWORD=your-secure-password
   ```

2. Start the service:

   ```bash
   docker compose up -d
   ```

3. Access n8n at `http://localhost:5678`

### PostgreSQL

1. Create a `.env` file with authentication and database credentials:

   ```env
   N8N_BASIC_AUTH_USER=admin
   N8N_BASIC_AUTH_PASSWORD=your-secure-password
   DB_TYPE=postgresdb
   DB_POSTGRESDB_PASSWORD=your-db-password
   ```

2. Start the service with PostgreSQL profile:

   ```bash
   docker compose --profile postgres up -d
   ```

3. Access n8n at `http://localhost:5678`

## Features

- **Visual Workflow Builder**: Create workflows with an intuitive drag-and-drop interface
- **400+ Integrations**: Connect to popular services and APIs
- **AI-Native**: Built-in LangChain support for AI workflows
- **Code When Needed**: Write JavaScript/Python or use visual nodes
- **Self-Hosted**: Full control over your data and deployments
- **Webhook Support**: Trigger workflows from external events
- **Scheduled Executions**: Run workflows on a schedule

## Documentation

For more information, visit the [official n8n documentation](https://docs.n8n.io/).

## Community Resources

- [n8n Community Forum](https://community.n8n.io/)
- [Workflow Templates](https://n8n.io/workflows)
- [Integration List](https://n8n.io/integrations)

## Security Notes

- Always set `N8N_BASIC_AUTH_USER` and `N8N_BASIC_AUTH_PASSWORD` in production
- Use HTTPS in production environments (set `N8N_PROTOCOL=https`)
- Consider setting `N8N_ENCRYPTION_KEY` for credential encryption
- Regularly backup the n8n data volume
- Keep n8n updated to the latest stable version
