# Neo4j Memory MCP Server

Neo4j Memory MCP Server provides memory management capabilities using Neo4j knowledge graphs through the Model Context Protocol.

## Features

- 🧠 **Knowledge Graph** - Build and manage knowledge graphs
- 📊 **Entity Management** - Create and manage entities
- 🔗 **Relationships** - Create and track relationships
- 💾 **Persistent Memory** - Store and retrieve memories

## Environment Variables

| Variable                         | Default                 | Description                    |
| -------------------------------- | ----------------------- | ------------------------------ |
| `MCP_NEO4J_MEMORY_VERSION`       | `latest`                | MCP Neo4j Memory image version |
| `MCP_NEO4J_MEMORY_PORT_OVERRIDE` | `8000`                  | MCP service port               |
| `NEO4J_URL`                      | `bolt://localhost:7687` | Neo4j connection URL           |
| `NEO4J_USER`                     | `neo4j`                 | Database user                  |
| `NEO4J_PASSWORD`                 | `password`              | Database password              |
| `TZ`                             | `UTC`                   | Timezone                       |

## Quick Start

```bash
docker compose up -d
```
