# Neo4j Cypher MCP 服务器

Neo4j Cypher MCP 服务器通过 Model Context Protocol 为 Neo4j 图数据库提供 Cypher 查询功能。

## 功能特性

- 🔍 **Cypher 查询** - 执行 Cypher 查询
- 📊 **图分析** - 分析图结构
- 🔗 **图探索** - 探索图数据

## 环境变量

| 变量                             | 默认值                  | 说明                      |
| -------------------------------- | ----------------------- | ------------------------- |
| `MCP_NEO4J_CYPHER_VERSION`       | `latest`                | MCP Neo4j Cypher 镜像版本 |
| `MCP_NEO4J_CYPHER_PORT_OVERRIDE` | `8000`                  | MCP 服务端口              |
| `NEO4J_URL`                      | `bolt://localhost:7687` | Neo4j 连接 URL            |
| `NEO4J_USER`                     | `neo4j`                 | 数据库用户                |
| `NEO4J_PASSWORD`                 | `password`              | 数据库密码                |
| `TZ`                             | `UTC`                   | 时区                      |

## 快速开始

```bash
docker compose up -d
```
