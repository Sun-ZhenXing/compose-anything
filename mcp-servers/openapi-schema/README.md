# OpenAPI Schema MCP Server

OpenAPI Schema MCP Server provides OpenAPI schema parsing and validation through the Model Context Protocol.

## Features

- 📋 **Schema Parsing** - Parse OpenAPI schemas
- ✅ **Validation** - Validate API schemas
- 🔍 **Schema Analysis** - Analyze schema structures
- 📊 **Schema Generation** - Generate schemas from APIs

## Environment Variables

| Variable                           | Default  | Description                      |
| ---------------------------------- | -------- | -------------------------------- |
| `MCP_OPENAPI_SCHEMA_VERSION`       | `latest` | MCP OpenAPI Schema image version |
| `MCP_OPENAPI_SCHEMA_PORT_OVERRIDE` | `8000`   | MCP service port                 |
| `TZ`                               | `UTC`    | Timezone                         |

## Quick Start

```bash
docker compose up -d
```
