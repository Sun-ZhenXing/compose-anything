# Neo4j Memory MCP 服务器

Neo4j Memory MCP 服务器通过 Model Context Protocol 使用 Neo4j 知识图谱提供内存管理功能。

## 功能特性

- 🧠 **知识图谱** - 构建和管理知识图谱
- 📊 **实体管理** - 创建和管理实体
- 🔗 **关系管理** - 创建和跟踪关系
- 💾 **持久化内存** - 存储和检索内存

## 环境变量

| 变量                             | 默认值                  | 说明                      |
| -------------------------------- | ----------------------- | ------------------------- |
| `MCP_NEO4J_MEMORY_VERSION`       | `latest`                | MCP Neo4j Memory 镜像版本 |
| `MCP_NEO4J_MEMORY_PORT_OVERRIDE` | `8000`                  | MCP 服务端口              |
| `NEO4J_URL`                      | `bolt://localhost:7687` | Neo4j 连接 URL            |
| `NEO4J_USER`                     | `neo4j`                 | 数据库用户                |
| `NEO4J_PASSWORD`                 | `password`              | 数据库密码                |
| `TZ`                             | `UTC`                   | 时区                      |

## 快速开始

```bash
docker compose up -d
```
