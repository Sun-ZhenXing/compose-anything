# Grafana MCP Server

Grafana MCP Server provides integration with Grafana monitoring and visualization platform through the Model Context Protocol.

## Features

- 📊 **Dashboard Management** - Create and manage dashboards
- 📈 **Query Datasources** - Query data sources
- 🔍 **Search Dashboards** - Search dashboards
- 🚨 **Incident Investigation** - Investigate incidents
- 📉 **Metrics Analysis** - Analyze metrics
- 🎨 **Visualization** - Data visualization

## Architecture

The service consists of two containers:

- **mcp-grafana**: MCP server providing AI interaction interface with Grafana
- **grafana**: Grafana instance

## Environment Variables

| Variable                    | Default                 | Description                              |
| --------------------------- | ----------------------- | ---------------------------------------- |
| `MCP_GRAFANA_VERSION`       | `latest`                | MCP Grafana image version                |
| `GRAFANA_VERSION`           | `latest`                | Grafana version                          |
| `MCP_GRAFANA_PORT_OVERRIDE` | `8000`                  | MCP service port                         |
| `GRAFANA_PORT_OVERRIDE`     | `3000`                  | Grafana port                             |
| `GRAFANA_URL`               | `http://grafana:3000`   | Grafana instance URL                     |
| `GRAFANA_API_KEY`           | -                       | Grafana API key (required)               |
| `GRAFANA_ADMIN_USER`        | `admin`                 | Admin username                           |
| `GRAFANA_ADMIN_PASSWORD`    | `admin`                 | Admin password (⚠️ change in production!) |
| `GRAFANA_INSTALL_PLUGINS`   | -                       | Plugins to install (comma-separated)     |
| `GRAFANA_ROOT_URL`          | `http://localhost:3000` | Grafana root URL                         |
| `TZ`                        | `UTC`                   | Timezone                                 |

## Quick Start

### 1. Configure Environment

Create a `.env` file:

```env
MCP_GRAFANA_VERSION=latest
GRAFANA_VERSION=latest
MCP_GRAFANA_PORT_OVERRIDE=8000
GRAFANA_PORT_OVERRIDE=3000
GRAFANA_ADMIN_USER=admin
GRAFANA_ADMIN_PASSWORD=your_secure_password
GRAFANA_ROOT_URL=http://localhost:3000
TZ=Asia/Shanghai
```

### 2. Start Services

```bash
docker compose up -d
```

### 3. Get API Key

1. Visit Grafana: <http://localhost:3000>
2. Login with admin credentials
3. Navigate to **Configuration** → **API Keys**
4. Create a new API key
5. Add the key to `.env` file: `GRAFANA_API_KEY=your_key_here`
6. Restart mcp-grafana service: `docker compose restart mcp-grafana`

### 4. Verify Services

```bash
# Verify MCP service
curl http://localhost:8000/health

# Verify Grafana service
curl http://localhost:3000/api/health
```

## Resource Requirements

- **MCP Service**: 128MB-512MB memory, 0.25-1.0 CPU
- **Grafana**: 256MB-1GB memory, 0.5-2.0 CPU

## Common Use Cases

1. **Dashboard Search** - Find dashboards using natural language
2. **Data Queries** - Query metric data from data sources
3. **Alert Management** - View and manage alert rules
4. **Visualization Creation** - Create new visualization panels
5. **Incident Analysis** - Investigate and analyze monitoring events

## Security Recommendations

⚠️ **Important**: In production environments:

1. Change default admin password
2. Use strong passwords and secure API keys
3. Enable HTTPS/TLS encryption
4. Restrict network access
5. Rotate API keys regularly
6. Set appropriate user permissions

## Data Persistence

- `grafana_data`: Grafana data directory
- `grafana_config`: Grafana configuration directory
- `grafana_logs`: Grafana logs directory

## References

- [Grafana Official Site](https://grafana.com/)
- [Grafana API Documentation](https://grafana.com/docs/grafana/latest/developers/http_api/)
- [MCP Documentation](https://modelcontextprotocol.io/)
- [Docker Hub - grafana/grafana](https://hub.docker.com/r/grafana/grafana)

## License

MIT License
