# OpenAPI MCP Server

OpenAPI MCP Server provides OpenAPI specification support through the Model Context Protocol.

## Features

- 📋 **API Documentation** - Parse and analyze OpenAPI specs
- 🔌 **API Integration** - Connect to OpenAPI services
- 📐 **Schema Validation** - Validate API schemas

## Environment Variables

| Variable                    | Default  | Description               |
| --------------------------- | -------- | ------------------------- |
| `MCP_OPENAPI_VERSION`       | `latest` | MCP OpenAPI image version |
| `MCP_OPENAPI_PORT_OVERRIDE` | `8000`   | MCP service port          |
| `TZ`                        | `UTC`    | Timezone                  |

## Quick Start

```bash
docker compose up -d
```
