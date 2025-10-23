# Tavily MCP Server

Tavily MCP Server provides powerful web search and data extraction capabilities through the Model Context Protocol.

## Features

- 🔍 **Web Search** - Intelligent web search using Tavily API
- 📄 **Content Extraction** - Extract and process web page content
- 🗺️ **Web Mapping** - Discover and map website structures
- 📰 **News Search** - Search for latest news and articles
- 🌐 **Multi-source** - Aggregate search across multiple data sources

## Environment Variables

| Variable               | Default  | Description               |
| ---------------------- | -------- | ------------------------- |
| `TAVILY_API_KEY`       | -        | Tavily API key (required) |
| `TAVILY_VERSION`       | `latest` | Docker image version      |
| `TAVILY_PORT_OVERRIDE` | `8000`   | Service port              |
| `TZ`                   | `UTC`    | Timezone                  |

## Quick Start

### 1. Configure Environment

Create a `.env` file:

```env
TAVILY_API_KEY=your_tavily_api_key_here
TAVILY_VERSION=latest
TAVILY_PORT_OVERRIDE=8000
TZ=Asia/Shanghai
```

### 2. Start Service

```bash
docker compose up -d
```

### 3. Verify Service

```bash
curl http://localhost:8000/health
```

## Get API Key

Visit [Tavily](https://tavily.com/) to obtain an API key.

## References

- [Tavily Official Site](https://tavily.com/)
- [MCP Documentation](https://modelcontextprotocol.io/)
- [Docker Hub - mcp/tavily](https://hub.docker.com/r/mcp/tavily)

## License

MIT License
