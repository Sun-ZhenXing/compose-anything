# Windmill

Windmill is an open-source developer infrastructure platform that allows you to quickly build production-grade multi-step automations and internal apps from minimal Python, TypeScript, Go, Bash, SQL scripts.

## Features

- **Multi-Language Support**: Write scripts in Python, TypeScript, Go, Bash, SQL
- **Auto-Generated UIs**: Automatic UI generation from scripts
- **Visual Workflow Builder**: Build complex workflows with code execution
- **Scheduling**: Built-in cron-based scheduling
- **Webhooks**: Trigger scripts via HTTP webhooks
- **Version Control**: Built-in Git sync and audit logs
- **Multi-Tenant**: Workspace-based multi-tenancy

## Quick Start

1. Copy `.env.example` to `.env`:

   ```bash
   cp .env.example .env
   ```

2. **IMPORTANT**: Edit `.env` and change:
   - `WINDMILL_SUPERADMIN_EMAIL` - Your admin email
   - `WINDMILL_SUPERADMIN_PASSWORD` - A strong password
   - `POSTGRES_PASSWORD` - A strong database password

3. Start Windmill:

   ```bash
   docker compose up -d
   ```

4. Wait for services to be ready

5. Access Windmill UI at `http://localhost:8000`

6. Log in with your configured superadmin credentials

## Default Configuration

| Service         | Port | Description                   |
| --------------- | ---- | ----------------------------- |
| Windmill Server | 8000 | Web UI and API                |
| PostgreSQL      | 5432 | Database (internal)           |
| Windmill LSP    | 3001 | Language Server (dev profile) |

**Default Credentials** (Change these!):

- Email: `admin@windmill.dev`
- Password: `changeme`

## Environment Variables

Key environment variables (see `.env.example` for full list):

| Variable                       | Description            | Default                 |
| ------------------------------ | ---------------------- | ----------------------- |
| `WINDMILL_VERSION`             | Windmill image version | `main`                  |
| `WINDMILL_PORT_OVERRIDE`       | Host port for UI       | `8000`                  |
| `WINDMILL_BASE_URL`            | Base URL               | `http://localhost:8000` |
| `WINDMILL_SUPERADMIN_EMAIL`    | Superadmin email       | `admin@windmill.dev`    |
| `WINDMILL_SUPERADMIN_PASSWORD` | Superadmin password    | **Must change!**        |
| `POSTGRES_PASSWORD`            | Database password      | `changeme`              |
| `WINDMILL_NUM_WORKERS`         | Number of workers      | `3`                     |
| `WINDMILL_LICENSE_KEY`         | Enterprise license     | (empty)                 |
| `TZ`                           | Timezone               | `UTC`                   |

## Resource Requirements

**Minimum**:

- CPU: 1 core
- RAM: 1GB
- Disk: 5GB

**Recommended**:

- CPU: 3+ cores (1 for server, 2+ for workers)
- RAM: 3GB+
- Disk: 20GB+

## Volumes

- `postgres_data`: PostgreSQL database data
- `windmill_server_data`: Windmill server data
- `windmill_worker_data`: Worker execution data

## Using Windmill

### Creating a Script

1. Access the UI at `http://localhost:8000`
2. Create a workspace or use default
3. Go to "Scripts" and click "New Script"
4. Write your script (Python example):

    ```python
    def main(name: str = "world"):
        return f"Hello {name}!"
    ```

5. Save and run

### Creating a Workflow

1. Go to "Flows" and click "New Flow"
2. Use the visual editor to add steps
3. Each step can be a script, flow, or approval
4. Configure inputs and outputs between steps
5. Deploy and run

### Using the API

Example: List scripts

```bash
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://localhost:8000/api/w/workspace/scripts/list
```

### Scheduling

1. Open any script or flow
2. Click "Schedule"
3. Set cron expression or interval
4. Save

## Profiles

- `dev`: Include LSP service for code intelligence (port 3001)

To enable dev profile:

```bash
docker compose --profile dev up -d
```

## Security Considerations

1. **Change Default Credentials**: Always change superadmin credentials
2. **Database Password**: Use a strong PostgreSQL password
3. **Docker Socket**: Mounting Docker socket grants container control
4. **SSL/TLS**: Use reverse proxy with HTTPS in production
5. **License Key**: Keep enterprise license key secure if using

## Upgrading

To upgrade Windmill:

1. Update `WINDMILL_VERSION` in `.env`
2. Pull and restart:

   ```bash
   docker compose pull
   docker compose up -d
   ```

3. Check logs:

   ```bash
   docker compose logs -f windmill-server
   ```

## Troubleshooting

**Service won't start:**

- Check logs: `docker compose logs windmill-server`
- Verify database: `docker compose ps postgres`
- Ensure Docker socket is accessible

**Cannot login:**

- Verify credentials in `.env`
- Check server logs for authentication errors
- Try resetting password via CLI

**Workers not processing:**

- Check worker logs: `docker compose logs windmill-worker`
- Verify database connection
- Increase `WINDMILL_NUM_WORKERS` if needed

## References

- Official Website: <https://windmill.dev>
- Documentation: <https://docs.windmill.dev>
- GitHub: <https://github.com/windmill-labs/windmill>
- Community: <https://discord.gg/V7PM2YHsPB>

## License

Windmill is licensed under AGPLv3. See [LICENSE](https://github.com/windmill-labs/windmill/blob/main/LICENSE) for more information.
