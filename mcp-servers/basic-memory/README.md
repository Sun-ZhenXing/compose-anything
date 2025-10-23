# Basic Memory MCP Server

Basic Memory MCP Server provides basic memory management and persistence capabilities through the Model Context Protocol.

## Features

- 💾 **Memory Storage** - Store and retrieve data
- 📝 **Notes** - Create and manage notes
- 🔄 **Persistence** - Persistent data storage
- 🔍 **Memory Search** - Search stored memories

## Environment Variables

| Variable                         | Default  | Description                    |
| -------------------------------- | -------- | ------------------------------ |
| `MCP_BASIC_MEMORY_VERSION`       | `latest` | MCP Basic Memory image version |
| `MCP_BASIC_MEMORY_PORT_OVERRIDE` | `8000`   | MCP service port               |
| `TZ`                             | `UTC`    | Timezone                       |

## Quick Start

```bash
docker compose up -d
```
