# SigNoz MCP Server

The official SigNoz MCP Server exposes SigNoz observability data and tools to Model Context Protocol (MCP) clients over HTTP.

## Included Service

- `signoz-mcp-server`: Official stateless HTTP MCP server. Its MCP endpoint is `http://localhost:8000/mcp` by default.

## Prerequisites

- An existing SigNoz instance reachable from the container.
- A SigNoz API key created in **Settings > API Keys**.

## Quick Start

```bash
cp .env.example .env
```

Edit `.env` and set `SIGNOZ_URL` to the SigNoz base URL without an API path, plus `SIGNOZ_API_KEY`. Configuring both is recommended for a simple single-instance setup. They default to empty so HTTP clients that support per-request credentials can supply them instead.

```bash
docker compose up -d
```

Configure the MCP client to use:

```text
http://localhost:8000/mcp
```

## Key Environment Variables

| Variable                               | Default  | Description                                      |
| -------------------------------------- | -------- | ------------------------------------------------ |
| `SIGNOZ_MCP_SERVER_VERSION`            | `v0.8.0` | Official image version                           |
| `SIGNOZ_MCP_SERVER_HOST_BIND`          | `127.0.0.1` | Host address for the MCP HTTP endpoint         |
| `SIGNOZ_MCP_SERVER_PORT_OVERRIDE`      | `8000`   | Host port for the MCP HTTP endpoint              |
| `SIGNOZ_URL`                           | Empty    | SigNoz base URL without an API path              |
| `SIGNOZ_API_KEY`                       | Empty    | API key with viewer, editor, or admin access     |
| `LOG_LEVEL`                            | `info`   | Server log level                                 |
| `SIGNOZ_MCP_SERVER_CPU_LIMIT`          | `1.0`    | CPU limit                                        |
| `SIGNOZ_MCP_SERVER_MEMORY_LIMIT`       | `512M`   | Memory limit                                     |
| `SIGNOZ_MCP_SERVER_CPU_RESERVATION`    | `0.1`    | CPU reservation                                  |
| `SIGNOZ_MCP_SERVER_MEMORY_RESERVATION` | `128M`   | Memory reservation                               |
| `TZ`                                   | `UTC`    | Container timezone                               |

## Storage

The server is stateless and uses no named volume.

## Health Monitoring

The published `v0.8.0` image contains no shell or HTTP probe utility, so an in-container Docker healthcheck cannot call its probe endpoints. Monitor `http://localhost:8000/readyz` externally.

## Security

The published `v0.8.0` image defaults to root, so this stack forces UID/GID `1001:1001`. It also uses a read-only filesystem, drops all Linux capabilities, enables `no-new-privileges`, and provides only a temporary `/tmp`. The MCP endpoint is unauthenticated and therefore binds to loopback by default; expose it only through an authenticated reverse proxy. Protect the `.env` API key, use outbound HTTPS, and do not use a SigNoz ingestion key.

## Compatibility

Some tools require newer SigNoz releases. See the [upstream README](https://github.com/SigNoz/signoz-mcp-server#readme) for current compatibility and advanced OAuth or multitenancy configuration.
