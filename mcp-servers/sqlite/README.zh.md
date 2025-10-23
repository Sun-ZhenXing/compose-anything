# SQLite MCP 服务器

SQLite MCP 服务器通过 Model Context Protocol 提供数据库交互和商业智能功能。

## 功能特性

- 💾 **数据库访问** - 访问 SQLite 数据库
- 🔍 **查询执行** - 执行 SQL 查询
- 📊 **数据分析** - 分析数据
- 📈 **商业智能** - BI 功能

## 环境变量

| 变量                       | 默认值   | 说明                |
| -------------------------- | -------- | ------------------- |
| `MCP_SQLITE_VERSION`       | `latest` | MCP SQLite 镜像版本 |
| `MCP_SQLITE_PORT_OVERRIDE` | `8000`   | MCP 服务端口        |
| `DATA_DIR`                 | `./data` | 数据目录路径        |
| `TZ`                       | `UTC`    | 时区                |

## 快速开始

```bash
docker compose up -d
```
