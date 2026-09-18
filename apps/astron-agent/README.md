# astron-agent

[English](./README.md) | [中文](./README.zh.md)

This service deploys [astron-agent](https://github.com/iflytek/astron-agent), iFLYTEK's open-source agentic workflow platform for building, publishing, and running AI agents and workflows. The stack bundles PostgreSQL, MySQL, Redis, and MinIO as private middleware plus the full set of core microservices behind an nginx entry point. Internal credentials are generated automatically on first startup, so no manual secret setup is required.

## Services

- **nginx**: Reverse proxy and web UI entry point.
- **console-frontend / console-hub**: Console web UI and backend API.
- **core-tenant, core-database, core-rpa, core-link, core-aitools, core-agent, core-knowledge, core-workflow**: astron-agent microservices.
- **postgres, mysql, redis, minio**: Private middleware used by the core services.
- **internal-credentials-init / minio-credentials-check**: One-shot init and validation jobs.
- **casdoor + casdoor-mysql**: Optional login stack behind the `auth` profile.

## Quick Start

1. Copy the environment template:

   ```bash
   cp .env.example .env
   ```

2. Start the stack:

   ```bash
   docker compose up -d
   ```

3. Open `http://localhost` (the first start pulls roughly ten images and takes several minutes).

## Optional Casdoor Login (auth profile)

By default console-hub starts without a login provider. To enable the bundled Casdoor SSO:

```bash
docker compose --profile auth up -d
```

Then set these values in `.env` so console-hub validates JWTs against Casdoor:

```ini
OAUTH2_ISSUER_URI=http://localhost:8000
```

- Casdoor admin UI: `http://localhost:8000`, default credentials `admin` / `123` — change the password immediately.
- The Casdoor redirect URI is derived from `CONSOLE_DOMAIN` at container startup (`${CONSOLE_DOMAIN}/callback`). If you serve the console on any address other than `http://localhost`, update `CONSOLE_DOMAIN`/`HOST_BASE_ADDRESS` in `.env` before the first Casdoor start.

## Core Environment Variables

| Variable                       | Description                                                            | Default                        |
| ------------------------------ | ---------------------------------------------------------------------- | ------------------------------ |
| `ASTRON_AGENT_VERSION`         | astron-agent image tag                                                 | `1.1.2`                        |
| `ASTRON_PORT_OVERRIDE`         | Host port of the web UI (nginx)                                        | `80`                           |
| `TZ`                           | Timezone for middleware containers                                     | `UTC`                          |
| `MINIO_PORT_OVERRIDE`          | Host port for MinIO API (loopback only)                                | `18998`                        |
| `MINIO_CONSOLE_PORT_OVERRIDE`  | Host port for MinIO console (loopback only)                            | `18999`                        |
| `CASDOOR_PORT_OVERRIDE`        | Host port for the Casdoor admin UI (`auth` profile only)               | `8000`                         |
| `POSTGRES_USER` / `POSTGRES_PASSWORD` | Bundled PostgreSQL credentials                                  | `spark` / `spark123`           |
| `MYSQL_ROOT_PASSWORD`          | Root password of the bundled MySQL server                              | `root123`                      |
| `REDIS_PASSWORD`               | Password of the bundled Redis server                                   | `123`                          |
| `MINIO_ROOT_USER` / `MINIO_ROOT_PASSWORD` | Bundled MinIO credentials                                   | `minioadmin` / `minioadmin123` |
| `WORKFLOW_INTERNAL_API_KEY`    | Optional override; auto-generated when left empty                      | *(empty)*                      |
| `TENANT_KEY` / `TENANT_SECRET` | Optional override; auto-generated when left empty                      | *(empty)*                      |
| `CONSOLE_DOMAIN`               | Console origin; drives Casdoor redirect URIs                           | `http://localhost:80`          |
| `RPA_URL`                      | External RPA service endpoint (RPA runtime is not bundled)             | `https://newapi.iflyrpa.com`   |

See `.env.example` for the full list, including observability (OTLP/Langfuse), skill-sandbox tokens, and resource limits.

## Volumes

- `postgres_data`, `mysql_data`, `redis_data`, `minio_data`: Middleware data.
- `nginx_logs`: Nginx access/error logs.
- `workflow_internal_secrets`, `tenant_bootstrap_secrets`, `artifact_upload_secrets`, `sandbox_runtime_credential_secrets`: Auto-generated internal credentials shared read-only with consumers.
- `casdoor-logs`, `casdoor-mysql-data`: Only used by the `auth` profile.

## Ports

- **80**: Web UI via nginx (override with `ASTRON_PORT_OVERRIDE`).
- **18998 / 18999**: MinIO API/console, bound to `127.0.0.1` only.
- **8000**: Casdoor admin UI (`auth` profile only).

All service-to-service traffic stays on the private `astron-agent-network`; no other ports are published.

## Resource Requirements

| Service group                      | CPU limit | Memory limit |
| ---------------------------------- | --------- | ------------ |
| Each core-* business service (x8)  | 2.0       | 2-4 GB       |
| console-hub                        | 2.0       | 2 GB         |
| mysql (+ casdoor-mysql)            | 1.5       | 2 GB         |
| postgres / minio / casdoor         | 1.0       | 1 GB         |
| nginx / console-frontend / redis   | 0.5-1.0   | 512 MB       |

This stack runs about 17 containers. Plan for **8 GB+ RAM** and several GB of free disk. All limits are tunable via `*_CPU_LIMIT` / `*_MEMORY_LIMIT` variables in `.env`.

## Notes

- Internal credentials (`TENANT_KEY`, `TENANT_SECRET`, `WORKFLOW_INTERNAL_API_KEY`, skill-sandbox tokens) are generated once on first boot and persisted in named volumes. Leave them empty unless you have a reason to override.
- The RPA execution stack is not bundled; point `RPA_URL` at your own deployment or the public cloud. See [astron-rpa](https://github.com/iflytek/astron-rpa).
- MinIO maintenance ports are bound to `127.0.0.1` on purpose. If you expose the console beyond localhost, put it behind an authenticated reverse proxy with TLS and align `CONSOLE_DOMAIN` / `OSS_REMOTE_ENDPOINT`.
- The services write logs into host-bound folders under `./config/<service>/logs/`; Docker creates these directories automatically on first start.
- First startup pulls ~10 images and can take several minutes before every service reports healthy.

## Documentation

- [astron-agent GitHub](https://github.com/iflytek/astron-agent)
- [Deployment guide (with auth)](https://github.com/iflytek/astron-agent/blob/main/docs/DEPLOYMENT_GUIDE_WITH_AUTH.md)
- [Configuration reference](https://github.com/iflytek/astron-agent/blob/main/docs/CONFIGURATION.md)
