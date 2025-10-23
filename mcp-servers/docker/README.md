# Docker MCP Server

Docker MCP Server provides Docker container management capabilities through the Model Context Protocol.

## Features

- 🐳 **Container Management** - Manage Docker containers
- 📦 **Image Management** - Manage Docker images
- 🔍 **Container Inspection** - Inspect container details
- 📊 **Container Statistics** - Get container statistics

## Environment Variables

| Variable                   | Default                       | Description              |
| -------------------------- | ----------------------------- | ------------------------ |
| `MCP_DOCKER_VERSION`       | `latest`                      | MCP Docker image version |
| `MCP_DOCKER_PORT_OVERRIDE` | `8000`                        | MCP service port         |
| `DOCKER_HOST`              | `unix:///var/run/docker.sock` | Docker socket path       |
| `TZ`                       | `UTC`                         | Timezone                 |

## Quick Start

```bash
docker compose up -d
```
