# Wolfram Alpha MCP Server

Wolfram Alpha MCP Server provides computational knowledge engine capabilities through the Model Context Protocol.

## Features

- 🔢 **Computational Queries** - Perform computational queries
- 📊 **Data Analysis** - Analyze complex data
- 🧮 **Mathematical Operations** - Mathematical computations
- 🌍 **Knowledge Base** - Access Wolfram Alpha knowledge base

## Environment Variables

| Variable                          | Default  | Description                      |
| --------------------------------- | -------- | -------------------------------- |
| `MCP_WOLFRAM_ALPHA_VERSION`       | `latest` | MCP Wolfram Alpha image version  |
| `MCP_WOLFRAM_ALPHA_PORT_OVERRIDE` | `8000`   | MCP service port                 |
| `WOLFRAM_ALPHA_APPID`             | -        | Wolfram Alpha API key (required) |
| `TZ`                              | `UTC`    | Timezone                         |

## Getting Started

1. Get your API key from [Wolfram Alpha](https://products.wolframalpha.com/api/)
2. Set the `WOLFRAM_ALPHA_APPID` in your `.env` file
3. Run `docker compose up -d`
