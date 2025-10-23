# Memory MCP 服务器

Memory MCP 服务器通过 Model Context Protocol 提供高级基于知识图谱的持久化内存系统。

## 功能特性

- 🧠 **知识图谱** - 构建和管理知识图谱
- 📊 **实体管理** - 创建和管理实体
- 🔗 **关系管理** - 创建和跟踪关系
- 💾 **持久化内存** - 高级内存存储
- 🔍 **图查询** - 查询知识图谱

## 环境变量

| 变量                       | 默认值   | 说明                |
| -------------------------- | -------- | ------------------- |
| `MCP_MEMORY_VERSION`       | `latest` | MCP Memory 镜像版本 |
| `MCP_MEMORY_PORT_OVERRIDE` | `8000`   | MCP 服务端口        |
| `TZ`                       | `UTC`    | 时区                |

## 快速开始

```bash
docker compose up -d
```
