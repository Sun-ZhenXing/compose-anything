# Inngest

[English](./README.md) | [中文](./README.zh.md)

[Inngest](https://www.inngest.com/) is an open-source durable workflow engine for building reliable applications. It provides event-driven functions with automatic retries, scheduling, fan-out, and a built-in dashboard for monitoring and debugging.

## Services

- `inngest`: Inngest server with API, Dashboard, and Connect WebSocket gateway (ports 8288, 8289)
- `postgres`: PostgreSQL database for persistence
- `redis`: Redis for queue and run state management

## Quick Start

```bash
# Copy environment file
cp .env.example .env

# Start all services
docker compose up -d
```

After startup, access the Inngest Dashboard at `http://localhost:8288`.

## Environment Variables

| Variable Name                      | Description                                          | Default Value |
| ---------------------------------- | ---------------------------------------------------- | ------------- |
| `GLOBAL_REGISTRY`                  | Global registry prefix for all images                | `""`          |
| `INNGEST_VERSION`                  | Inngest image version                                | `v1.16.3`     |
| `INNGEST_EVENT_KEY`                | Event key for authenticating event submissions (hex) | `deadbeef...` |
| `INNGEST_SIGNING_KEY`              | Signing key for server-app communication (hex)       | `01234567...` |
| `INNGEST_LOG_LEVEL`                | Log level (trace, debug, info, warn, error)          | `info`        |
| `INNGEST_PORT_OVERRIDE`            | Host port for API and Dashboard                      | `8288`        |
| `INNGEST_GATEWAY_PORT_OVERRIDE`    | Host port for Connect WebSocket gateway              | `8289`        |
| `INNGEST_PG_VERSION`               | PostgreSQL image version                             | `17.6-alpine` |
| `INNGEST_PG_USER`                  | PostgreSQL username                                  | `inngest`     |
| `INNGEST_PG_PASSWORD`              | PostgreSQL password                                  | `inngest`     |
| `INNGEST_PG_DB`                    | PostgreSQL database name                             | `inngest`     |
| `INNGEST_REDIS_VERSION`            | Redis image version                                  | `7.4-alpine`  |
| `TZ`                               | Timezone                                             | `UTC`         |
| `INNGEST_CPU_LIMIT`                | CPU limit for Inngest                                | `1.00`        |
| `INNGEST_CPU_RESERVATION`          | CPU reservation for Inngest                          | `0.50`        |
| `INNGEST_MEMORY_LIMIT`             | Memory limit for Inngest                             | `512M`        |
| `INNGEST_MEMORY_RESERVATION`       | Memory reservation for Inngest                       | `256M`        |
| `INNGEST_PG_CPU_LIMIT`             | CPU limit for PostgreSQL                             | `0.50`        |
| `INNGEST_PG_CPU_RESERVATION`       | CPU reservation for PostgreSQL                       | `0.25`        |
| `INNGEST_PG_MEMORY_LIMIT`          | Memory limit for PostgreSQL                          | `256M`        |
| `INNGEST_PG_MEMORY_RESERVATION`    | Memory reservation for PostgreSQL                    | `128M`        |
| `INNGEST_REDIS_CPU_LIMIT`          | CPU limit for Redis                                  | `0.50`        |
| `INNGEST_REDIS_CPU_RESERVATION`    | CPU reservation for Redis                            | `0.25`        |
| `INNGEST_REDIS_MEMORY_LIMIT`       | Memory limit for Redis                               | `128M`        |
| `INNGEST_REDIS_MEMORY_RESERVATION` | Memory reservation for Redis                         | `64M`         |

Please modify the `.env` file as needed for your use case.

## Volumes

- `inngest_pg_data`: Named volume for PostgreSQL data
- `inngest_redis_data`: Named volume for Redis data

## Configuring Inngest SDKs

To connect your application to a self-hosted Inngest server, set the following environment variables in your app:

```bash
INNGEST_EVENT_KEY=<your_event_key>
INNGEST_SIGNING_KEY=<your_signing_key>
INNGEST_DEV=0
INNGEST_BASE_URL=http://<inngest_host>:8288
```

For example, with a Node.js app:

```bash
INNGEST_EVENT_KEY=deadbeefcafebabe0123456789abcdef \
INNGEST_SIGNING_KEY=0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef \
INNGEST_DEV=0 \
INNGEST_BASE_URL=http://localhost:8288 \
node ./server.js
```

## Security Notes

- **Change default keys before production use.** The event key and signing key must be valid hex strings with an even number of characters. Generate secure keys with `openssl rand -hex 32`.
- **Change the default PostgreSQL password** in `.env` before production deployment.
- The Inngest image supports both `amd64` and `arm64` architectures.
- Consider using TLS/SSL termination (e.g., via a reverse proxy) for production deployments.

## References

- [Official Documentation](https://www.inngest.com/docs)
- [Self-Hosting Guide](https://www.inngest.com/docs/self-hosting)
- [GitHub Repository](https://github.com/inngest/inngest)
- [SDK Documentation](https://www.inngest.com/docs/sdk/overview)

## License

Inngest is source-available under the [Elastic License 2.0 (ELv2)](https://github.com/inngest/inngest/blob/main/LICENSE.md) with some components under [Apache-2.0](https://github.com/inngest/inngest/blob/main/LICENSE-APACHE.md).
