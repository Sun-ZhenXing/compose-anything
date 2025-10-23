# E2B MCP Server

E2B MCP Server provides cloud-based code execution and development environment capabilities through the Model Context Protocol.

## Features

- 💻 **Code Execution** - Execute code safely in cloud
- 📁 **File Management** - Manage files and directories
- 🖥️ **Terminal Access** - Access terminal environment
- 🔧 **Development Tools** - Various development tools

## Environment Variables

| Variable                | Default  | Description            |
| ----------------------- | -------- | ---------------------- |
| `MCP_E2B_VERSION`       | `latest` | MCP E2B image version  |
| `MCP_E2B_PORT_OVERRIDE` | `8000`   | MCP service port       |
| `E2B_API_KEY`           | -        | E2B API key (required) |
| `TZ`                    | `UTC`    | Timezone               |

## Quick Start

```bash
docker compose up -d
```
