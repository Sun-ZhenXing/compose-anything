# Redis

[English](./README.md) | [中文](./README.zh.md)

This service deploys Redis, a high-performance in-memory key-value store for caching, session management, and message brokering.

## Services

- `redis`: The Redis service (port 6379)

## Quick Start

```bash
docker compose up -d
```

## Environment Variables

| Variable Name              | Description                                              | Default Value      |
| -------------------------- | -------------------------------------------------------- | ------------------ |
| `GLOBAL_REGISTRY`          | Global registry prefix for all images                    | `""`               |
| `REDIS_VERSION`            | Redis image version                                      | `8.2.1-alpine3.22` |
| `REDIS_PASSWORD`           | Password for Redis authentication (empty = no auth)      | `""`               |
| `REDIS_PORT_OVERRIDE`      | Host port mapping (maps to Redis port 6379 in container) | `6379`             |
| `TZ`                       | Timezone                                                 | `UTC`              |
| `SKIP_FIX_PERMS`           | Skip permission fixing (set to 1 to skip)                | `""`               |
| `REDIS_CPU_LIMIT`          | CPU limit                                                | `0.50`             |
| `REDIS_CPU_RESERVATION`    | CPU reservation                                          | `0.25`             |
| `REDIS_MEMORY_LIMIT`       | Memory limit                                             | `256M`             |
| `REDIS_MEMORY_RESERVATION` | Memory reservation                                       | `128M`             |

Please modify the `.env` file as needed for your use case.

## Volumes

- `redis_data`: A named volume for storing Redis data files

## Custom Configuration

To use a custom `redis.conf` file, uncomment the volume mount in `docker-compose.yaml`:

```yaml
volumes:
  - ./redis.conf:/etc/redis/redis.conf
```

Then modify the `command` section to use the custom config:

```yaml
command: redis-server /etc/redis/redis.conf
```

## Security Notes

- By default, Redis runs without authentication. Set `REDIS_PASSWORD` to enable authentication.
- Redis runs as the default user in the official image.
- Consider using TLS/SSL for production deployments.

## License

Redis is open source and licensed under the [BSD 3-Clause License](https://redis.io/docs/about/license/).
