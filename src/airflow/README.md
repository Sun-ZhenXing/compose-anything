# Apache Airflow

Apache Airflow is a platform to programmatically author, schedule, and monitor workflows. This stack runs Airflow 3.x with the LocalExecutor and PostgreSQL, using the new api-server + dag-processor architecture (the classic webserver component has been replaced in Airflow 3).

## Features

- **Airflow 3.x Architecture**: Webserver replaced by `api-server` + `dag-processor`
- **LocalExecutor**: Single-node execution, no Redis or Celery required
- **DAGs as Code**: Define workflows in Python
- **Rich Scheduling**: Cron-like schedules, datasets, and event triggers
- **UI and REST API**: Web UI and stable REST API on port 8080
- **Scheduler / Triggerer / Dag Processor**: All Airflow 3 components run as separate services

> Out of scope: CeleryExecutor with Redis workers. It can be added later as an optional Compose profile if needed.

## Quick Start

1. Copy `.env.example` to `.env`:

   ```bash
   cp .env.example .env
   ```

2. (Optional) Edit `.env` to customize settings such as ports and the UI password

3. Start the stack:

   ```bash
   docker compose up -d
   ```

4. Wait for initialization to finish (the `airflow-init` service runs migrations and creates the user; check with `docker compose logs -f airflow-init`)

5. Open the Airflow UI at `http://localhost:8080` and log in with `airflow` / `change-me` (change `_AIRFLOW_WWW_USER_PASSWORD` in `.env` before any real use)

## Default Configuration

| Service                | Port | Description                  |
| ---------------------- | ---- | ---------------------------- |
| airflow-apiserver      | 8080 | Web UI and REST API          |
| PostgreSQL             | 5432 | Metadata database (internal) |
| airflow-scheduler      | -    | Scheduler (no exposed port)  |
| airflow-dag-processor  | -    | DAG processor                |
| airflow-triggerer      | -    | Triggerer                    |

**Authentication**: With the default `.env`, the initial UI credentials are `airflow` / `change-me` (set by `_AIRFLOW_WWW_USER_PASSWORD`). **Change the password before any real use.**

## Environment Variables

Key environment variables (see `.env.example` for full list):

| Variable                       | Description                                | Default    |
| ------------------------------ | ------------------------------------------ | ---------- |
| `AIRFLOW_VERSION`              | Airflow image version                      | `3.3.2-python3.12` |
| `POSTGRES_VERSION`             | PostgreSQL image version                   | `16`       |
| `AIRFLOW_PORT_OVERRIDE`        | Host port for UI/API                       | `8080`     |
| `_AIRFLOW_WWW_USER_USERNAME`   | Initial UI username created by init        | `airflow`  |
| `_AIRFLOW_WWW_USER_PASSWORD`   | Initial UI password created by init        | `change-me` |
| `AIRFLOW_FERNET_KEY`           | Fernet key used to encrypt connections/variables | generated/empty |
| `AIRFLOW_UID`                  | Host UID for bind-mounted files            | `50000`    |
| `POSTGRES_DB`                  | Metadata database name                     | `airflow`  |
| `POSTGRES_USER`                | Metadata database user                     | `airflow`  |
| `POSTGRES_PASSWORD`            | Metadata database password                 | `airflow`  |
| `TZ`                           | Timezone                                   | `UTC`      |
| Resource variables             | CPU/memory limits for each service         | see `.env.example` |

## Resource Requirements

**Minimum**:

- CPU: 2 cores
- RAM: 4GB
- Disk: 10GB

Airflow runs several JVM/Python services (scheduler, dag-processor, triggerer, api-server); 4GB of RAM is a practical floor.

## Volumes

- `postgres-db` (named volume): PostgreSQL metadata database data
- `./dags`: Your DAG files (bind mount)
- `./logs`: Task and scheduler logs (bind mount)
- `./plugins`: Airflow plugins (bind mount)
- `./config`: Custom Airflow configuration (bind mount)

## Security Considerations

1. **Default Credentials**: Change `_AIRFLOW_WWW_USER_USERNAME` / `_AIRFLOW_WWW_USER_PASSWORD` before exposing the UI
2. **FERNET Key**: Set a strong `AIRFLOW_FERNET_KEY` to encrypt secrets stored in the metadata database; JWT secrets are also derived from Airflow's secret configuration
3. **Non-Root UID**: Services run with UID `50000` (`AIRFLOW_UID`); ensure bind-mounted directories are writable by this UID
4. **No `container_name`**: Services are addressed by Compose service names
5. **Network Access**: Restrict access with firewall rules; use a reverse proxy with HTTPS in production

## Troubleshooting

**Init service fails:**

- Check logs: `docker compose logs airflow-init`
- Verify PostgreSQL is healthy: `docker compose ps postgres`
- Remove the named volume and retry only if you accept losing metadata

**UI not reachable:**

- Check `airflow-apiserver` is running: `docker compose ps`
- Check logs: `docker compose logs airflow-apiserver`
- Verify port mapping with `AIRFLOW_PORT_OVERRIDE`

**DAGs are not picked up:**

- Ensure files are in `./dags` and readable by UID `50000`
- Check `docker compose logs airflow-dag-processor`
- Fix Python/import errors shown in the UI

**Permission errors on `./logs`:**

- Set `AIRFLOW_UID` to your host user's UID in `.env` and restart

## References

- Official Website: <https://airflow.apache.org/>
- GitHub: <https://github.com/apache/airflow/>
- Docker Compose docs: <https://airflow.apache.org/docs/apache-airflow/stable/howto/docker-compose/index.html>

## License

Apache Airflow is licensed under Apache-2.0. See [LICENSE](https://github.com/apache/airflow/blob/main/LICENSE) for more information.
