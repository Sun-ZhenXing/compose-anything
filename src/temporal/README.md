# Temporal

Temporal is a scalable and reliable runtime for Reentrant Processes called Temporal Workflow Executions. It enables developers to write simple, resilient code without worrying about failures, retries, or state management.

## Features

- **Durable Execution**: Workflows survive failures, restarts, and even code deployments
- **Built-in Reliability**: Automatic retries, timeouts, and error handling
- **Long-Running Workflows**: Support workflows that run for days, months, or years
- **Multi-Language SDKs**: Official support for Go, Java, TypeScript, Python, PHP, .NET
- **Advanced Visibility**: Search and filter workflow executions
- **Event-Driven**: Signals, queries, and updates for workflow interaction

## Quick Start

1. Copy `.env.example` to `.env`:

   ```bash
   cp .env.example .env
   ```

2. (Optional) Edit `.env` to customize database passwords and settings

3. Start Temporal:

   ```bash
   docker compose up -d
   ```

4. Wait for services to be ready (check with `docker compose logs -f temporal`)

5. Access Temporal Web UI at `http://localhost:8233`

6. Frontend service is available at `localhost:7233` (gRPC)

## Default Configuration

| Service           | Port | Description            |
| ----------------- | ---- | ---------------------- |
| Temporal Frontend | 7233 | gRPC endpoint for SDKs |
| Temporal Web UI   | 8233 | Web interface          |
| PostgreSQL        | 5432 | Database (internal)    |

**Authentication**: No authentication by default. Configure mTLS and authorization for production use.

## Environment Variables

Key environment variables (see `.env.example` for full list):

| Variable                          | Description             | Default    |
| --------------------------------- | ----------------------- | ---------- |
| `TEMPORAL_VERSION`                | Temporal server version | `1.24.2`   |
| `TEMPORAL_UI_VERSION`             | Temporal UI version     | `2.28.0`   |
| `TEMPORAL_FRONTEND_PORT_OVERRIDE` | Frontend gRPC port      | `7233`     |
| `TEMPORAL_UI_PORT_OVERRIDE`       | Web UI port             | `8233`     |
| `POSTGRES_DB`                     | Database name           | `temporal` |
| `POSTGRES_USER`                   | Database user           | `temporal` |
| `POSTGRES_PASSWORD`               | Database password       | `temporal` |
| `TEMPORAL_LOG_LEVEL`              | Log level               | `info`     |
| `TZ`                              | Timezone                | `UTC`      |

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
- `temporal_data`: Temporal configuration and state

## Using Temporal

### Install SDK

Choose your language:

**Go:**

```bash
go get go.temporal.io/sdk
```

**TypeScript:**

```bash
npm install @temporalio/client @temporalio/worker
```

**Python:**

```bash
pip install temporalio
```

### Write a Workflow (Python Example)

```python
from temporalio import workflow, activity
from datetime import timedelta

@activity.defn
async def say_hello(name: str) -> str:
    return f"Hello, {name}!"

@workflow.defn
class HelloWorkflow:
    @workflow.run
    async def run(self, name: str) -> str:
        return await workflow.execute_activity(
            say_hello,
            name,
            start_to_close_timeout=timedelta(seconds=10),
        )
```

### Run a Worker

```python
from temporalio.client import Client
from temporalio.worker import Worker

async def main():
    client = await Client.connect("localhost:7233")

    worker = Worker(
        client,
        task_queue="hello-queue",
        workflows=[HelloWorkflow],
        activities=[say_hello],
    )

    await worker.run()
```

### Execute a Workflow

```python
from temporalio.client import Client

async def main():
    client = await Client.connect("localhost:7233")

    result = await client.execute_workflow(
        HelloWorkflow.run,
        "World",
        id="hello-workflow",
        task_queue="hello-queue",
    )

    print(result)
```

### Using tctl CLI

The admin-tools container (dev profile) includes tctl:

```bash
docker compose --profile dev run temporal-admin-tools
tctl namespace list
tctl workflow list
```

## Profiles

- `dev`: Include admin-tools container for CLI access

To enable dev profile:

```bash
docker compose --profile dev up -d
```

## Security Considerations

1. **Authentication**: Configure mTLS for production deployments
2. **Authorization**: Set up authorization rules for namespaces and workflows
3. **Database Passwords**: Use strong PostgreSQL passwords
4. **Network Security**: Restrict access to Temporal ports
5. **Encryption**: Enable encryption at rest for sensitive data

## Upgrading

To upgrade Temporal:

1. Update versions in `.env`
2. Pull and restart:

   ```bash
   docker compose pull
   docker compose up -d
   ```

3. Check logs for migration messages:

   ```bash
   docker compose logs -f temporal
   ```

## Troubleshooting

**Service won't start:**

- Check logs: `docker compose logs temporal`
- Verify database: `docker compose ps postgres`
- Ensure sufficient resources allocated

**Cannot connect from SDK:**

- Verify port 7233 is accessible
- Check firewall rules
- Ensure SDK version compatibility

**Web UI not loading:**

- Check UI logs: `docker compose logs temporal-ui`
- Verify frontend is healthy: `docker compose ps temporal`
- Clear browser cache

## References

- Official Website: <https://temporal.io>
- Documentation: <https://docs.temporal.io>
- GitHub: <https://github.com/temporalio/temporal>
- Community: <https://community.temporal.io>
- SDK Documentation: <https://docs.temporal.io/dev-guide>

## License

Temporal is licensed under MIT. See [LICENSE](https://github.com/temporalio/temporal/blob/master/LICENSE) for more information.
