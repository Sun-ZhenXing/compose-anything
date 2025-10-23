# ArXiv MCP Server

ArXiv MCP Server provides a comprehensive bridge between AI assistants and arXiv's research repository through the Model Context Protocol.

## Features

- 🔍 **Paper Search** - Search arXiv papers with advanced filtering
- 📥 **Paper Download** - Download and convert papers to markdown
- 📖 **Paper Reading** - Read and analyze paper content
- 🔬 **Research Analysis** - Deep research analysis capabilities
- 💾 **Local Storage** - Local paper management and storage

## Environment Variables

| Variable                  | Default        | Description             |
| ------------------------- | -------------- | ----------------------- |
| `MCP_ARXIV_VERSION`       | `latest`       | MCP ArXiv image version |
| `MCP_ARXIV_PORT_OVERRIDE` | `8000`         | MCP service port        |
| `ARXIV_STORAGE_PATH`      | `/data/papers` | Papers storage path     |
| `TZ`                      | `UTC`          | Timezone                |

## Quick Start

```bash
docker compose up -d
```
