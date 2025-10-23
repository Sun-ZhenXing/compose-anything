# API Gateway MCP Server

API Gateway MCP Server provides API gateway and management capabilities through the Model Context Protocol.

## Features

- 🚪 **API Gateway** - Manage API access
- 🔐 **Authentication** - Handle API authentication
- 📊 **Rate Limiting** - Implement rate limiting
- 📝 **API Documentation** - Serve API documentation

## Environment Variables

| Variable                        | Default  | Description                   |
| ------------------------------- | -------- | ----------------------------- |
| `MCP_API_GATEWAY_VERSION`       | `latest` | MCP API Gateway image version |
| `MCP_API_GATEWAY_PORT_OVERRIDE` | `8000`   | MCP service port              |
| `TZ`                            | `UTC`    | Timezone                      |

## Quick Start

```bash
docker compose up -d
```
