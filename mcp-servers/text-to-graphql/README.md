# Text to GraphQL MCP Server

Text to GraphQL MCP Server converts natural language text descriptions into GraphQL queries through the Model Context Protocol.

## Features

- 📝 **Text Parsing** - Parse text descriptions
- 🔄 **Query Generation** - Generate GraphQL queries from text
- 🔗 **API Integration** - Integrate with GraphQL APIs
- 🎯 **Query Optimization** - Optimize generated queries

## Environment Variables

| Variable                            | Default  | Description                       |
| ----------------------------------- | -------- | --------------------------------- |
| `MCP_TEXT_TO_GRAPHQL_VERSION`       | `latest` | MCP Text to GraphQL image version |
| `MCP_TEXT_TO_GRAPHQL_PORT_OVERRIDE` | `8000`   | MCP service port                  |
| `TZ`                                | `UTC`    | Timezone                          |

## Quick Start

```bash
docker compose up -d
```
