# Redis MCP Server

[English](./README.md) | [中文](./README.zh.md)

This service deploys an MCP (Model Context Protocol) server for Redis, providing a standardized interface to interact with Redis databases.

## Services

- `mcp`: The MCP Redis server
- `redis`: Redis database service

## Environment Variables

| Variable Name       | Description                                                       | Default Value |
| ------------------- | ----------------------------------------------------------------- | ------------- |
| MCP_REDIS_VERSION   | MCP Redis image version                                           | `latest`      |
| MCP_PORT_OVERRIDE   | Host port mapping for MCP server (maps to port 8000 in container) | 8000          |
| REDIS_VERSION       | Redis image version                                               | `7-alpine`    |
| REDIS_PORT_OVERRIDE | Host port mapping for Redis (maps to port 6379 in container)      | 6379          |
| TZ                  | Timezone setting                                                  | `UTC`         |

Please modify the `.env` file as needed for your use case.

## Volumes

- `redis_data`: Redis data persistence

## Ports

- `8000`: MCP server API
- `6379`: Redis database

## Usage

The MCP server provides a standardized interface to interact with Redis. Access the MCP API at `http://localhost:8000`.

## Additional Information

- Model Context Protocol: <https://modelcontextprotocol.io/>
- Redis Documentation: <https://redis.io/documentation>
