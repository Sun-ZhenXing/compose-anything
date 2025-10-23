# Markdownify MCP Server

Markdownify MCP Server converts various document formats to Markdown through the Model Context Protocol.

## Features

- 📄 **Format Conversion** - Convert documents to Markdown
- 🔗 **URL Processing** - Convert web content to Markdown
- 📋 **Document Parsing** - Parse and convert various file types

## Environment Variables

| Variable                        | Default  | Description                   |
| ------------------------------- | -------- | ----------------------------- |
| `MCP_MARKDOWNIFY_VERSION`       | `latest` | MCP Markdownify image version |
| `MCP_MARKDOWNIFY_PORT_OVERRIDE` | `8000`   | MCP service port              |
| `TZ`                            | `UTC`    | Timezone                      |

## Quick Start

```bash
docker compose up -d
```
