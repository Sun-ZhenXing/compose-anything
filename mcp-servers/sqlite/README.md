# SQLite MCP Server

SQLite MCP Server provides database interaction and business intelligence capabilities through the Model Context Protocol.

## Features

- 💾 **Database Access** - Access SQLite databases
- 🔍 **Query Execution** - Execute SQL queries
- 📊 **Data Analysis** - Analyze data
- 📈 **Business Intelligence** - BI capabilities

## Environment Variables

| Variable                   | Default  | Description              |
| -------------------------- | -------- | ------------------------ |
| `MCP_SQLITE_VERSION`       | `latest` | MCP SQLite image version |
| `MCP_SQLITE_PORT_OVERRIDE` | `8000`   | MCP service port         |
| `DATA_DIR`                 | `./data` | Data directory path      |
| `TZ`                       | `UTC`    | Timezone                 |

## Quick Start

```bash
docker compose up -d
```
