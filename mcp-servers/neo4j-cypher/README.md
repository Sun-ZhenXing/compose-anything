# Neo4j Cypher MCP Server

Neo4j Cypher MCP Server provides Cypher query capabilities for Neo4j graph databases through the Model Context Protocol.

## Features

- 🔍 **Cypher Queries** - Execute Cypher queries
- 📊 **Graph Analysis** - Analyze graph structures
- 🔗 **Graph Exploration** - Explore graph data

## Environment Variables

| Variable                         | Default                 | Description                    |
| -------------------------------- | ----------------------- | ------------------------------ |
| `MCP_NEO4J_CYPHER_VERSION`       | `latest`                | MCP Neo4j Cypher image version |
| `MCP_NEO4J_CYPHER_PORT_OVERRIDE` | `8000`                  | MCP service port               |
| `NEO4J_URL`                      | `bolt://localhost:7687` | Neo4j connection URL           |
| `NEO4J_USER`                     | `neo4j`                 | Database user                  |
| `NEO4J_PASSWORD`                 | `password`              | Database password              |
| `TZ`                             | `UTC`                   | Timezone                       |

## Quick Start

```bash
docker compose up -d
```
