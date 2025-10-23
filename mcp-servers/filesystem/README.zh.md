# Filesystem MCP 服务器

Filesystem MCP 服务器通过 Model Context Protocol 提供具有可配置允许路径的本地文件系统访问。

## 功能特性

- 📁 **文件访问** - 读写文件
- 📂 **目录管理** - 创建和管理目录
- 🔍 **文件搜索** - 搜索文件
- 📄 **文件操作** - 各种文件操作

## 环境变量

| 变量                           | 默认值   | 说明                    |
| ------------------------------ | -------- | ----------------------- |
| `MCP_FILESYSTEM_VERSION`       | `latest` | MCP Filesystem 镜像版本 |
| `MCP_FILESYSTEM_PORT_OVERRIDE` | `8000`   | MCP 服务端口            |
| `DATA_DIR`                     | `./data` | 数据目录路径            |
| `TZ`                           | `UTC`    | 时区                    |

## 快速开始

```bash
docker compose up -d
```
