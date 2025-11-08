# Neo4j

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署 Neo4j，领先的图数据库管理系统。

## 服务

- `neo4j`：Neo4j 社区版数据库

## 快速开始

```bash
docker compose up -d
```

## 环境变量

| 变量名                           | 说明                         | 默认值             |
| -------------------------------- | ---------------------------- | ------------------ |
| `GLOBAL_REGISTRY`                | 全局镜像仓库前缀             | `""`               |
| `NEO4J_VERSION`                  | Neo4j 镜像版本               | `5.27.4-community` |
| `NEO4J_HTTP_PORT_OVERRIDE`       | HTTP 主机端口（映射到 7474） | `7474`             |
| `NEO4J_BOLT_PORT_OVERRIDE`       | Bolt 主机端口（映射到 7687） | `7687`             |
| `NEO4J_AUTH`                     | 身份验证（格式：user/pass）  | `neo4j/password`   |
| `NEO4J_ACCEPT_LICENSE_AGREEMENT` | 接受许可协议                 | `yes`              |
| `NEO4J_PAGECACHE_SIZE`           | 页缓存内存大小               | `512M`             |
| `NEO4J_HEAP_INIT_SIZE`           | 初始堆大小                   | `512M`             |
| `NEO4J_HEAP_MAX_SIZE`            | 最大堆大小                   | `1G`               |
| `TZ`                             | 时区                         | `UTC`              |

请根据实际需求修改 `.env` 文件。

## 卷

- `neo4j_data`：Neo4j 数据库数据
- `neo4j_logs`：Neo4j 日志文件
- `neo4j_import`：批量数据导入目录
- `neo4j_plugins`：Neo4j 插件目录

## 端口

- `7474`：HTTP（Neo4j 浏览器）
- `7687`：Bolt 协议

## 访问点

- Neo4j 浏览器：<http://localhost:7474>
- Bolt URI：`bolt://localhost:7687`
- 默认凭据：`neo4j` / `password`（通过 `NEO4J_AUTH` 修改）

## 基本使用

### 使用 Neo4j 浏览器

1. 打开 <http://localhost:7474>
2. 使用 `NEO4J_AUTH` 中的凭据登录
3. 运行 Cypher 查询

### 创建节点和关系

```cypher
// 创建节点
CREATE (alice:Person {name: 'Alice', age: 30})
CREATE (bob:Person {name: 'Bob', age: 25})

// 创建关系
MATCH (a:Person {name: 'Alice'}), (b:Person {name: 'Bob'})
CREATE (a)-[:KNOWS]->(b)

// 查询
MATCH (p:Person)-[:KNOWS]->(friend)
RETURN p.name, friend.name
```

## 内存配置

生产环境中，根据工作负载调整内存设置：

- `NEO4J_PAGECACHE_SIZE`：应足够大以缓存图数据（建议使用 RAM 的 50%）
- `NEO4J_HEAP_INIT_SIZE` / `NEO4J_HEAP_MAX_SIZE`：用于查询处理的 JVM 堆

## 导入数据

将 CSV 或其他数据文件放在挂载的导入目录中，然后使用 `LOAD CSV` 或 `neo4j-admin import`。

## 安全提示

- 首次登录后立即更改默认密码
- 生产环境中使用强密码
- 生产环境中启用 SSL/TLS
- 限制对 Neo4j 端口的网络访问
- 定期备份图数据库
- 保持 Neo4j 更新以获取安全补丁

## 许可证

Neo4j 社区版采用 GPLv3 许可。商业使用请考虑 Neo4j 企业版。详情请参见 [Neo4j Licensing](https://neo4j.com/licensing/)。
