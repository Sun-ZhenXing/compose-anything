# Filesystem MCP Server

Filesystem MCP Server provides local filesystem access with configurable allowed paths through the Model Context Protocol.

## Features

- 📁 **File Access** - Read and write files
- 📂 **Directory Management** - Create and manage directories
- 🔍 **File Search** - Search for files
- 📄 **File Operations** - Various file operations

## Environment Variables

| Variable                       | Default  | Description                  |
| ------------------------------ | -------- | ---------------------------- |
| `MCP_FILESYSTEM_VERSION`       | `latest` | MCP Filesystem image version |
| `MCP_FILESYSTEM_PORT_OVERRIDE` | `8000`   | MCP service port             |
| `DATA_DIR`                     | `./data` | Data directory path          |
| `TZ`                           | `UTC`    | Timezone                     |

## Quick Start

```bash
docker compose up -d
```
