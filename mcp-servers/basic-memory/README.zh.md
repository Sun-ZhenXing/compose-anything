# Basic Memory MCP 服务器

Basic Memory MCP 服务器通过 Model Context Protocol 提供基本内存管理和持久化功能。

## 功能特性

- 💾 **内存存储** - 存储和检索数据
- 📝 **笔记** - 创建和管理笔记
- 🔄 **持久化** - 持久化数据存储
- 🔍 **内存搜索** - 搜索存储的记忆

## 环境变量

| 变量                             | 默认值   | 说明                      |
| -------------------------------- | -------- | ------------------------- |
| `MCP_BASIC_MEMORY_VERSION`       | `latest` | MCP Basic Memory 镜像版本 |
| `MCP_BASIC_MEMORY_PORT_OVERRIDE` | `8000`   | MCP 服务端口              |
| `TZ`                             | `UTC`    | 时区                      |

## 快速开始

```bash
docker compose up -d
```
