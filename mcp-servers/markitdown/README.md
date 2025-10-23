# Markitdown MCP Server

Microsoft's Markitdown MCP Server provides lightweight conversion functionality to Markdown format through the Model Context Protocol.

## Features

- 📄 **Document Conversion** - Convert documents to markdown
- 🔗 **URL Conversion** - Convert web content to markdown
- 📝 **Content Processing** - Process and extract content

## Environment Variables

| Variable                       | Default  | Description                  |
| ------------------------------ | -------- | ---------------------------- |
| `MCP_MARKITDOWN_VERSION`       | `latest` | MCP Markitdown image version |
| `MCP_MARKITDOWN_PORT_OVERRIDE` | `8000`   | MCP service port             |
| `DATA_DIR`                     | `./data` | Data directory path          |
| `TZ`                           | `UTC`    | Timezone                     |

## Quick Start

```bash
docker compose up -d
```
