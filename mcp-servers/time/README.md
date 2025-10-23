# Time MCP Server

Time MCP Server provides time and timezone information capabilities through the Model Context Protocol.

## Features

- 🕐 **Current Time** - Get current time
- 🌍 **Timezone Support** - Work with multiple timezones
- 📅 **Date/Time Operations** - Various date/time operations
- ⏰ **Time Conversions** - Convert between timezones

## Environment Variables

| Variable                 | Default  | Description            |
| ------------------------ | -------- | ---------------------- |
| `MCP_TIME_VERSION`       | `latest` | MCP Time image version |
| `MCP_TIME_PORT_OVERRIDE` | `8000`   | MCP service port       |
| `TZ`                     | `UTC`    | Timezone               |

## Quick Start

```bash
docker compose up -d
```
