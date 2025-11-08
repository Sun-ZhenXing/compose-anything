# Neo4j

[English](./README.md) | [中文](./README.zh.md)

This service deploys Neo4j, a leading graph database management system.

## Services

- `neo4j`: Neo4j Community Edition database

## Quick Start

```bash
docker compose up -d
```

## Environment Variables

| Variable Name                    | Description                           | Default Value      |
| -------------------------------- | ------------------------------------- | ------------------ |
| `GLOBAL_REGISTRY`                | Global registry prefix for all images | `""`               |
| `NEO4J_VERSION`                  | Neo4j image version                   | `5.27.4-community` |
| `NEO4J_HTTP_PORT_OVERRIDE`       | Host port for HTTP (maps to 7474)     | `7474`             |
| `NEO4J_BOLT_PORT_OVERRIDE`       | Host port for Bolt (maps to 7687)     | `7687`             |
| `NEO4J_AUTH`                     | Authentication (format: user/pass)    | `neo4j/password`   |
| `NEO4J_ACCEPT_LICENSE_AGREEMENT` | Accept license agreement              | `yes`              |
| `NEO4J_PAGECACHE_SIZE`           | Page cache memory size                | `512M`             |
| `NEO4J_HEAP_INIT_SIZE`           | Initial heap size                     | `512M`             |
| `NEO4J_HEAP_MAX_SIZE`            | Maximum heap size                     | `1G`               |
| `TZ`                             | Timezone                              | `UTC`              |

Please modify the `.env` file as needed for your use case.

## Volumes

- `neo4j_data`: Neo4j database data
- `neo4j_logs`: Neo4j log files
- `neo4j_import`: Import directory for bulk data
- `neo4j_plugins`: Neo4j plugins directory

## Ports

- `7474`: HTTP (Neo4j Browser)
- `7687`: Bolt protocol

## Access Points

- Neo4j Browser: <http://localhost:7474>
- Bolt URI: `bolt://localhost:7687`
- Default credentials: `neo4j` / `password` (change via `NEO4J_AUTH`)

## Basic Usage

### Using Neo4j Browser

1. Open <http://localhost:7474>
2. Log in with credentials from `NEO4J_AUTH`
3. Run Cypher queries

### Create Nodes and Relationships

```cypher
// Create nodes
CREATE (alice:Person {name: 'Alice', age: 30})
CREATE (bob:Person {name: 'Bob', age: 25})

// Create relationship
MATCH (a:Person {name: 'Alice'}), (b:Person {name: 'Bob'})
CREATE (a)-[:KNOWS]->(b)

// Query
MATCH (p:Person)-[:KNOWS]->(friend)
RETURN p.name, friend.name
```

## Memory Configuration

For production environments, adjust memory settings based on your workload:

- `NEO4J_PAGECACHE_SIZE`: Should be large enough to cache graph data (recommend 50% of RAM)
- `NEO4J_HEAP_INIT_SIZE` / `NEO4J_HEAP_MAX_SIZE`: JVM heap for query processing

## Importing Data

Place CSV or other data files in the mounted import directory, then use `LOAD CSV` or `neo4j-admin import`.

## Security Notes

- Change default password immediately after first login
- Use strong passwords in production
- Enable SSL/TLS for production deployments
- Restrict network access to Neo4j ports
- Regularly backup your graph database
- Keep Neo4j updated for security patches

## License

Neo4j Community Edition is licensed under GPLv3. For commercial use, consider Neo4j Enterprise Edition. See [Neo4j Licensing](https://neo4j.com/licensing/) for details.
