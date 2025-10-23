# ClickHouse MCP Server

ClickHouse MCP Server provides integration with ClickHouse analytics database through the Model Context Protocol.

## Features

- 📊 **Database Queries** - Execute queries against ClickHouse
- 📈 **Analytics** - Analyze data using ClickHouse capabilities
- 🔍 **Data Exploration** - Explore database structure and data
- 📉 **Performance** - Fast analytical queries on large datasets

## Environment Variables

| Variable                       | Default                 | Description                  |
| ------------------------------ | ----------------------- | ---------------------------- |
| `MCP_CLICKHOUSE_VERSION`       | `latest`                | MCP ClickHouse image version |
| `MCP_CLICKHOUSE_PORT_OVERRIDE` | `8000`                  | MCP service port             |
| `CLICKHOUSE_URL`               | `http://localhost:8123` | ClickHouse URL               |
| `CLICKHOUSE_USER`              | `default`               | Database user                |
| `CLICKHOUSE_PASSWORD`          | -                       | Database password            |
| `TZ`                           | `UTC`                   | Timezone                     |

## Quick Start

```bash
docker compose up -d
