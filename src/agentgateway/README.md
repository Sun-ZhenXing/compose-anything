# Agentgateway

[English](./README.md) | [中文](./README.zh.md)

Agentgateway is an open source data plane for agentic AI connectivity. This compose setup runs the official Docker image with a local configuration file.

## Services

- `agentgateway`: The Agentgateway data plane (ports 3000 and 15000)

## Quick Start

```bash
docker compose up -d
```

Agentgateway listens on port 3000. The admin UI is available on <http://localhost:15000/ui>.

## Configuration

The default configuration file is [config.yaml](./config.yaml). It is based on the official quickstart example and starts the MCP test server `@modelcontextprotocol/server-everything` via `npx`.

If you want to use a different backend, update `config.yaml` and restart the service.

## Environment Variables

| Variable Name                      | Description                                       | Default Value   |
| ---------------------------------- | ------------------------------------------------- | --------------- |
| `GLOBAL_REGISTRY`                  | Global registry prefix for all images             | `""`            |
| `AGENTGATEWAY_VERSION`             | Agentgateway image version                        | `0.11.2`        |
| `AGENTGATEWAY_PORT_OVERRIDE`       | Host port mapping for data plane (container 3000) | `3000`          |
| `AGENTGATEWAY_ADMIN_PORT_OVERRIDE` | Host port mapping for admin UI (container 15000)  | `15000`         |
| `AGENTGATEWAY_ADMIN_ADDR`          | Admin UI bind address inside container            | `0.0.0.0:15000` |
| `TZ`                               | Timezone                                          | `UTC`           |
| `AGENTGATEWAY_CPU_LIMIT`           | CPU limit                                         | `0.50`          |
| `AGENTGATEWAY_CPU_RESERVATION`     | CPU reservation                                   | `0.25`          |
| `AGENTGATEWAY_MEMORY_LIMIT`        | Memory limit                                      | `256M`          |
| `AGENTGATEWAY_MEMORY_RESERVATION`  | Memory reservation                                | `128M`          |

## Ports

- `3000`: Data plane listener
- `15000`: Admin UI

## Security Notes

- The admin UI is bound to localhost on the host by default. Change the port mapping if you need remote access.
- Review and harden CORS and backend settings before using in production.

## License

Agentgateway is open source and licensed under the Apache 2.0 License. See the upstream project for details.
