# FalkorDB

[FalkorDB](https://falkordb.com/) is a low-latency property graph database that leverages sparse matrices and linear algebra for high-performance graph queries. It is a community-driven fork of RedisGraph, optimized for large-scale knowledge graphs and AI-powered applications.

## Getting Started

1. Copy `.env.example` to `.env` and adjust the configuration as needed.
2. Start the service:

   ```bash
   docker compose up -d
   ```

3. Access the FalkorDB Browser at `http://localhost:3000`.
4. Connect to the database using `redis-cli` or any Redis-compatible client on port `6379`.

## Environment Variables

| Variable                         | Description                  | Default    |
| -------------------------------- | ---------------------------- | ---------- |
| `FALKORDB_VERSION`               | Version of FalkorDB image    | `v4.14.11` |
| `FALKORDB_PORT_OVERRIDE`         | Host port for Redis protocol | `6379`     |
| `FALKORDB_BROWSER_PORT_OVERRIDE` | Host port for Browser UI     | `3000`     |
| `FALKORDB_CPU_LIMIT`             | Maximum CPU cycles           | `1.00`     |
| `FALKORDB_MEMORY_LIMIT`          | Maximum memory               | `2G`       |

## Resources

- [Official Documentation](https://docs.falkordb.com/)
- [GitHub Repository](https://github.com/FalkorDB/FalkorDB)
- [Docker Hub](https://hub.docker.com/r/falkordb/falkordb)
