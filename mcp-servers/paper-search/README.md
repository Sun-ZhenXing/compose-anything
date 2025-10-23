# Paper Search MCP Server

Paper Search MCP Server provides research paper search and discovery capabilities through the Model Context Protocol.

## Features

- 🔍 **Paper Search** - Search research papers
- 📊 **Advanced Filtering** - Filter papers by various criteria
- 📥 **Paper Access** - Access paper information and metadata
- 🔗 **Cross-reference** - Find related papers

## Environment Variables

| Variable                         | Default  | Description                    |
| -------------------------------- | -------- | ------------------------------ |
| `MCP_PAPER_SEARCH_VERSION`       | `latest` | MCP Paper Search image version |
| `MCP_PAPER_SEARCH_PORT_OVERRIDE` | `8000`   | MCP service port               |
| `TZ`                             | `UTC`    | Timezone                       |

## Quick Start

```bash
docker compose up -d
```
