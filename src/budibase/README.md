# Budibase

Budibase is an all-in-one low-code platform for building modern internal tools and dashboards. Build CRUD apps, admin panels, approval workflows, and more in minutes.

## Features

- **Visual App Builder**: Drag-and-drop interface for building apps quickly
- **Built-in Database**: Spreadsheet-like database or connect to external data sources
- **Multi-tenant Support**: User management and role-based access control
- **Automation**: Build workflows and automations without code
- **Custom Plugins**: Extend functionality with custom components
- **API & Webhooks**: REST API, GraphQL, and webhook support
- **Self-hosted**: Full control over your data

## Quick Start

1. Copy `.env.example` to `.env`:

   ```bash
   cp .env.example .env
   ```

2. **IMPORTANT**: Edit `.env` and change the following security settings:
   - `BUDIBASE_INTERNAL_API_KEY` - Generate a random 32+ character string
   - `BUDIBASE_JWT_SECRET` - Generate a random 32+ character string
   - `BUDIBASE_ADMIN_EMAIL` - Your admin email
   - `BUDIBASE_ADMIN_PASSWORD` - A strong password
   - `BUDIBASE_MINIO_ACCESS_KEY` and `BUDIBASE_MINIO_SECRET_KEY` - MinIO credentials

3. Start Budibase:

   ```bash
   docker compose up -d
   ```

4. Access Budibase at `http://localhost:10000`

5. Log in with your configured admin credentials

## Default Configuration

| Service  | Port  | Description    |
| -------- | ----- | -------------- |
| Budibase | 10000 | Web UI and API |

**Default Admin Credentials** (Change these!):

- Email: `admin@budibase.com`
- Password: `changeme`

## Environment Variables

Key environment variables (see `.env.example` for full list):

| Variable                    | Description                  | Default              |
| --------------------------- | ---------------------------- | -------------------- |
| `BUDIBASE_VERSION`          | Budibase image version       | `3.23.0`             |
| `BUDIBASE_PORT_OVERRIDE`    | Host port for UI             | `10000`              |
| `BUDIBASE_INTERNAL_API_KEY` | Internal API key (32+ chars) | **Must change!**     |
| `BUDIBASE_JWT_SECRET`       | JWT secret (32+ chars)       | **Must change!**     |
| `BUDIBASE_ADMIN_EMAIL`      | Admin user email             | `admin@budibase.com` |
| `BUDIBASE_ADMIN_PASSWORD`   | Admin user password          | `changeme`           |
| `BUDIBASE_ENVIRONMENT`      | Environment mode             | `PRODUCTION`         |
| `TZ`                        | Timezone                     | `UTC`                |

## Resource Requirements

**Minimum**:

- CPU: 0.5 cores
- RAM: 512MB
- Disk: 2GB

**Recommended**:

- CPU: 2 cores
- RAM: 2GB
- Disk: 10GB

## Volumes

- `budibase_data`: Budibase application data (database, files, configs)
- `redis_data`: Redis cache data

## Security Considerations

1. **Change Default Credentials**: Always change the default admin credentials
2. **Strong Secrets**: Use strong random strings for API keys and JWT secrets
3. **Environment Variables**: Store sensitive values in `.env` file, never commit to version control
4. **SSL/TLS**: Use reverse proxy (nginx, Traefik) with SSL in production
5. **Firewall**: Restrict access to port 10000 in production environments
6. **Backups**: Regularly backup the `budibase_data` volume

## Upgrading

1. Pull the latest image:

   ```bash
   docker compose pull
   ```

2. Restart the services:

   ```bash
   docker compose up -d
   ```

3. Check logs:

   ```bash
   docker compose logs -f
   ```

## Troubleshooting

**Service won't start:**

- Check logs: `docker compose logs budibase`
- Ensure ports are not in use: `netstat -an | findstr 10000`
- Verify environment variables are set correctly

**Cannot login:**

- Verify admin credentials in `.env` file
- Reset admin password by recreating the container with new credentials

**Performance issues:**

- Increase resource limits in `.env` file
- Check Redis memory usage: `docker compose exec redis redis-cli INFO memory`

## References

- Official Website: <https://budibase.com>
- Documentation: <https://docs.budibase.com>
- GitHub: <https://github.com/Budibase/budibase>
- Community: <https://github.com/Budibase/budibase/discussions>
- Docker Hub: <https://hub.docker.com/r/budibase/budibase>

## License

Budibase is licensed under GPL-3.0. See [LICENSE](https://github.com/Budibase/budibase/blob/master/LICENSE) for more information.
