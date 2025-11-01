# Conductor

Netflix Conductor is a workflow orchestration engine that runs in the cloud. It allows you to orchestrate microservices and workflows with a visual workflow designer.

## Features

- **Visual Workflow Designer**: Drag-and-drop interface for building complex workflows
- **Microservice Orchestration**: Coordinate multiple services with decision logic
- **Task Management**: Built-in retry mechanisms and error handling
- **Scalable Architecture**: Designed for high-throughput scenarios
- **REST API**: Full REST API with SDKs for Java, Python, Go, C#
- **Monitoring**: Real-time monitoring and metrics via Prometheus

## Quick Start

1. Copy `.env.example` to `.env`:

   ```bash
   cp .env.example .env
   ```

2. (Optional) Edit `.env` to customize database passwords and other settings

3. Start Conductor (note: first run will build the image, may take several minutes):

   ```bash
   docker compose up -d
   ```

4. Wait for services to be healthy (check with `docker compose ps`)

5. Access Conductor UI at `http://localhost:5000`

6. API is available at `http://localhost:8080`

## Default Configuration

| Service          | Port | Description                  |
| ---------------- | ---- | ---------------------------- |
| Conductor Server | 8080 | REST API                     |
| Conductor UI     | 5000 | Web UI                       |
| PostgreSQL       | 5432 | Database (internal)          |
| Elasticsearch    | 9200 | Search & indexing (internal) |

**Authentication**: No authentication is configured by default. Add an authentication layer (reverse proxy with OAuth2, LDAP, etc.) in production.

## Environment Variables

Key environment variables (see `.env.example` for full list):

| Variable                         | Description           | Default     |
| -------------------------------- | --------------------- | ----------- |
| `CONDUCTOR_SERVER_PORT_OVERRIDE` | Host port for API     | `8080`      |
| `CONDUCTOR_UI_PORT_OVERRIDE`     | Host port for UI      | `5000`      |
| `POSTGRES_DB`                    | Database name         | `conductor` |
| `POSTGRES_USER`                  | Database user         | `conductor` |
| `POSTGRES_PASSWORD`              | Database password     | `conductor` |
| `ELASTICSEARCH_VERSION`          | Elasticsearch version | `8.11.0`    |
| `CONDUCTOR_LOG_LEVEL`            | Log level             | `INFO`      |
| `TZ`                             | Timezone              | `UTC`       |

## Resource Requirements

**Minimum**:

- CPU: 1 core
- RAM: 1.5GB
- Disk: 5GB

**Recommended**:

- CPU: 4+ cores
- RAM: 4GB+
- Disk: 20GB+

## Volumes

- `postgres_data`: PostgreSQL database data
- `elasticsearch_data`: Elasticsearch indices
- `conductor_logs`: Conductor server logs

## Using Conductor

### Creating a Workflow

1. Access the UI at `http://localhost:5000`
2. Go to "Definitions" > "Workflow Defs"
3. Click "Define Workflow" and use the visual editor
4. Define tasks and their execution logic
5. Save and execute your workflow

### Using the API

Example: Get server information

```bash
curl http://localhost:8080/api/
```

Example: List workflows

```bash
curl http://localhost:8080/api/metadata/workflow
```

### SDKs

Conductor provides official SDKs:

- Java: <https://github.com/conductor-oss/conductor/tree/main/java-sdk>
- Python: <https://github.com/conductor-oss/conductor/tree/main/python-sdk>
- Go: <https://github.com/conductor-oss/conductor/tree/main/go-sdk>
- C#: <https://github.com/conductor-oss/conductor/tree/main/csharp-sdk>

## Security Considerations

1. **Authentication**: Configure authentication for production use
2. **Database Passwords**: Use strong passwords for PostgreSQL
3. **Network Security**: Use firewall rules to restrict access
4. **SSL/TLS**: Enable HTTPS with a reverse proxy
5. **Elasticsearch**: Consider enabling X-Pack security for production

## Upgrading

To upgrade Conductor:

1. Update version in `.env` file (if using versioned tags)
2. Pull latest image and restart:

   ```bash
   docker compose pull
   docker compose up -d
   ```

3. Check logs for any migration messages:

   ```bash
   docker compose logs -f conductor-server
   ```

## Troubleshooting

**Service won't start:**

- Check logs: `docker compose logs conductor-server`
- Ensure database is healthy: `docker compose ps postgres`
- Verify Elasticsearch: `docker compose ps elasticsearch`

**UI not accessible:**

- Check if port 5000 is available: `netstat -an | findstr 5000`
- Verify service is running: `docker compose ps conductor-server`

**Performance issues:**

- Increase resource limits in `.env`
- Monitor Elasticsearch heap size
- Check database connection pool settings

## References

- Official Website: <https://conductor-oss.org>
- Documentation: <https://docs.conductor-oss.org>
- GitHub: <https://github.com/conductor-oss/conductor>
- Community: <https://github.com/conductor-oss/conductor/discussions>

## License

Conductor is licensed under Apache-2.0. See [LICENSE](https://github.com/conductor-oss/conductor/blob/main/LICENSE) for more information.
