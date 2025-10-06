# Langfuse

[English](./README.md) | [中文](./README.zh.md)

This service deploys Langfuse, an open-source LLM engineering platform for observability, metrics, evaluations, and prompt management.

## Services

- `langfuse-server`: The main Langfuse application server.
- `langfuse-db`: PostgreSQL database for Langfuse.

## Environment Variables

| Variable Name                         | Description                                     | Default Value           |
| ------------------------------------- | ----------------------------------------------- | ----------------------- |
| LANGFUSE_VERSION                      | Langfuse image version                          | `3.115.0`               |
| LANGFUSE_PORT                         | Host port mapping for Langfuse web interface    | `3000`                  |
| POSTGRES_VERSION                      | PostgreSQL image version                        | `17.2-alpine3.21`       |
| POSTGRES_USER                         | PostgreSQL username                             | `postgres`              |
| POSTGRES_PASSWORD                     | PostgreSQL password                             | `postgres`              |
| POSTGRES_DB                           | PostgreSQL database name                        | `langfuse`              |
| NEXTAUTH_URL                          | Public URL of your Langfuse instance            | `http://localhost:3000` |
| NEXTAUTH_SECRET                       | Secret for NextAuth.js (required, generate one) | `""`                    |
| SALT                                  | Salt for encryption (required, generate one)    | `""`                    |
| TELEMETRY_ENABLED                     | Enable telemetry                                | `true`                  |
| LANGFUSE_ENABLE_EXPERIMENTAL_FEATURES | Enable experimental features                    | `false`                 |

**Important**: You must set `NEXTAUTH_SECRET` and `SALT` for production use. Generate them using:

```bash
# For NEXTAUTH_SECRET
openssl rand -base64 32

# For SALT
openssl rand -base64 32
```

Please create a `.env` file and modify it as needed for your use case.

## Volumes

- `langfuse_db_data`: A volume for storing PostgreSQL data.

## Getting Started

1. Create a `.env` file with required secrets:

   ```env
   NEXTAUTH_SECRET=your-generated-secret-here
   SALT=your-generated-salt-here
   POSTGRES_PASSWORD=your-secure-password
   ```

2. Start the services:

   ```bash
   docker compose up -d
   ```

3. Access Langfuse at `http://localhost:3000`

4. Create your first account on the setup page

## Documentation

For more information, visit the [official Langfuse documentation](https://langfuse.com/docs).

## Security Notes

- Change default passwords in production
- Use strong, randomly generated values for `NEXTAUTH_SECRET` and `SALT`
- Consider using a reverse proxy with SSL/TLS in production
- Regularly backup the PostgreSQL database
