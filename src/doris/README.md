# Doris

Apache Doris is a modern OLAP database designed for fast analytics and real-time business intelligence. It provides SQL interface compatible with standard SQL semantics and supports both batch and real-time data processing.

## Quick Start

```bash
docker compose up -d
```

## Ports

| Service | Port | Purpose           |
| ------- | ---- | ----------------- |
| FE      | 9030 | Query Port        |
| FE      | 8030 | Web UI & HTTP API |
| BE      | 8040 | Backend HTTP Port |

## Default Credentials

- Web UI: <http://localhost:8030>
- Username: `admin`
- Password: `admin` (default, should be changed)

## Environment Variables

Key environment variables:

- `DORIS_VERSION`: Docker image version (default: 3.0.0)
- `DORIS_FE_CPU_LIMIT`: FE CPU limit (default: 1.00)
- `DORIS_FE_MEMORY_LIMIT`: FE memory limit (default: 2G)
- `DORIS_BE_CPU_LIMIT`: BE CPU limit (default: 2.00)
- `DORIS_BE_MEMORY_LIMIT`: BE memory limit (default: 4G)

See `.env.example` for all available options.

## Architecture

The deployment includes:

- **Frontend (FE)**: Handles query planning, metadata management, and user connections
- **Backend (BE)**: Executes queries and manages data storage

## Documentation

- [Apache Doris Official Docs](https://doris.apache.org/)
- [Quick Start Guide](https://doris.apache.org/docs/get-starting/)
- [SQL Reference](https://doris.apache.org/docs/sql-manual/)

## License

Apache License 2.0
