# ClickHouse MCP 服务器

ClickHouse MCP 服务器通过 Model Context Protocol 提供与 ClickHouse 分析数据库的集成。

## 功能特性

- 📊 **数据库查询** - 对 ClickHouse 执行查询
- 📈 **数据分析** - 使用 ClickHouse 功能进行数据分析
- 🔍 **数据探索** - 探索数据库结构和数据
- 📉 **性能** - 对大型数据集进行快速分析查询

## 环境变量

| 变量                           | 默认值                  | 说明                    |
| ------------------------------ | ----------------------- | ----------------------- |
| `MCP_CLICKHOUSE_VERSION`       | `latest`                | MCP ClickHouse 镜像版本 |
| `MCP_CLICKHOUSE_PORT_OVERRIDE` | `8000`                  | MCP 服务端口            |
| `CLICKHOUSE_URL`               | `http://localhost:8123` | ClickHouse URL          |
| `CLICKHOUSE_USER`              | `default`               | 数据库用户              |
| `CLICKHOUSE_PASSWORD`          | -                       | 数据库密码              |
| `TZ`                           | `UTC`                   | 时区                    |

## 快速开始

```bash
docker compose up -d
```
