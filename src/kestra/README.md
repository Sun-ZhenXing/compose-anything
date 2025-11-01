# Kestra

Kestra is an infinitely scalable orchestration and scheduling platform that allows you to declare, run, schedule, and monitor millions of workflows declaratively in code.

## Features

- **Declarative YAML**: Define workflows in simple YAML syntax
- **Event-Driven**: Trigger workflows based on events, schedules, or APIs
- **Multi-Language Support**: Execute Python, Node.js, Shell, SQL, and more
- **Real-Time Monitoring**: Live logs and execution tracking
- **Plugin Ecosystem**: Extensive library of integrations
- **Version Control**: Git integration for workflow versioning
- **Scalable**: Handle millions of workflow executions

## Quick Start

1. Copy `.env.example` to `.env`:

   ```bash
   cp .env.example .env
   ```

2. (Optional) Edit `.env` to customize settings, especially if enabling basic auth

3. Start Kestra:

   ```bash
   docker compose up -d
   ```

4. Wait for services to be ready (check with `docker compose logs -f kestra`)

5. Access Kestra UI at `http://localhost:8080`

## Default Configuration

| Service           | Port | Description          |
| ----------------- | ---- | -------------------- |
| Kestra            | 8080 | Web UI and API       |
| Kestra Management | 8081 | Management endpoints |
| PostgreSQL        | 5432 | Database (internal)  |

**Authentication**: No authentication by default. Set `KESTRA_BASIC_AUTH_ENABLED=true` in `.env` to enable basic authentication.

## Environment Variables

Key environment variables (see `.env.example` for full list):

| Variable                     | Description          | Default       |
| ---------------------------- | -------------------- | ------------- |
| `KESTRA_VERSION`             | Kestra image version | `latest-full` |
| `KESTRA_PORT_OVERRIDE`       | Host port for UI/API | `8080`        |
| `KESTRA_MANAGEMENT_PORT`     | Management port      | `8081`        |
| `POSTGRES_DB`                | Database name        | `kestra`      |
| `POSTGRES_USER`              | Database user        | `kestra`      |
| `POSTGRES_PASSWORD`          | Database password    | `k3str4`      |
| `KESTRA_BASIC_AUTH_ENABLED`  | Enable basic auth    | `false`       |
| `KESTRA_BASIC_AUTH_USERNAME` | Auth username        | `admin`       |
| `KESTRA_BASIC_AUTH_PASSWORD` | Auth password        | `admin`       |
| `TZ`                         | Timezone             | `UTC`         |

## Resource Requirements

**Minimum**:

- CPU: 1 core
- RAM: 1GB
- Disk: 5GB

**Recommended**:

- CPU: 2+ cores
- RAM: 2GB+
- Disk: 20GB+

## Volumes

- `postgres_data`: PostgreSQL database data
- `kestra_data`: Kestra storage (workflow outputs, files)
- `kestra_logs`: Kestra application logs

## Using Kestra

### Creating a Workflow

1. Access the UI at `http://localhost:8080`
2. Go to "Flows" and click "Create"
3. Define your workflow in YAML:

    ```yaml
    id: hello-world
    namespace: company.team

    tasks:
      - id: hello
        type: io.kestra.plugin.core.log.Log
        message: Hello, World!
    ```

4. Save and execute

### Using the API

Example: List flows

```bash
curl http://localhost:8080/api/v1/flows/search
```

Example: Trigger execution

```bash
curl -X POST http://localhost:8080/api/v1/executions/company.team/hello-world
```

### CLI

Install Kestra CLI:

```bash
curl -o kestra https://github.com/kestra-io/kestra/releases/latest/download/kestra
chmod +x kestra
```

### Docker Task Runner

Kestra can execute tasks in Docker containers. The compose file mounts `/var/run/docker.sock` to enable this feature. Use the `io.kestra.plugin.scripts.runner.docker.Docker` task type.

## Security Considerations

1. **Authentication**: Enable basic auth or configure SSO (OIDC) for production
2. **Database Passwords**: Use strong passwords for PostgreSQL
3. **Docker Socket**: Mounting Docker socket grants container control; ensure proper security
4. **Network Access**: Restrict access with firewall rules
5. **SSL/TLS**: Use reverse proxy with HTTPS in production

## Upgrading

To upgrade Kestra:

1. Update `KESTRA_VERSION` in `.env`
2. Pull and restart:

   ```bash
   docker compose pull
   docker compose up -d
   ```

3. Check logs:

   ```bash
   docker compose logs -f kestra
   ```

## Troubleshooting

**Service won't start:**

- Check logs: `docker compose logs kestra`
- Verify database: `docker compose ps postgres`
- Ensure Docker socket is accessible

**Cannot execute Docker tasks:**

- Verify `/var/run/docker.sock` is mounted
- Check Docker daemon is running
- Review task logs in Kestra UI

**Performance issues:**

- Increase resource limits in `.env`
- Check database performance
- Monitor Java heap usage (adjust `KESTRA_JAVA_OPTS`)

## References

- Official Website: <https://kestra.io>
- Documentation: <https://kestra.io/docs>
- GitHub: <https://github.com/kestra-io/kestra>
- Community: <https://kestra.io/slack>
- Plugin Hub: <https://kestra.io/plugins>

## License

Kestra is licensed under Apache-2.0. See [LICENSE](https://github.com/kestra-io/kestra/blob/develop/LICENSE) for more information.
