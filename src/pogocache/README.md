# Pogocache

[Pogocache](https://github.com/tidwall/pogocache) is fast caching software built from scratch with a focus on low latency and cpu efficiency. It is a high-performance, multi-protocol Redis alternative.

## Features

- **Fast**: Faster than Memcached, Valkey, Redis, Dragonfly, and Garnet.
- **Multi-protocol**: Supports Redis RESP, Memcached, PostgreSQL wire protocol, and HTTP.
- **Persistence**: Supports AOF-style persistence.
- **Resource Efficient**: Low CPU and memory overhead.

## Deployment

```bash
docker compose up -d
```

## Configuration

| Variable                  | Default | Description                                   |
| ------------------------- | ------- | --------------------------------------------- |
| `POGOCACHE_VERSION`       | `1.3.1` | Pogocache image version                       |
| `POGOCACHE_PORT_OVERRIDE` | `9401`  | Host port for Pogocache                       |
| `POGOCACHE_EXTRA_ARGS`    |         | Additional CLI arguments (e.g. `--auth pass`) |

## Accessing Pogocache

- **Redis**: `redis-cli -p 9401`
- **Postgres**: `psql -h localhost -p 9401`
- **HTTP**: `curl http://localhost:9401/key`
- **Memcached**: `telnet localhost 9401`

## Persistence

By default, the data is persisted to a named volume `pogocache_data` at `/data/pogocache.db`.
