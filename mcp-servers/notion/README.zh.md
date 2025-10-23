# Notion MCP 服务器

官方 Notion MCP 服务器通过 Model Context Protocol 提供与 Notion 工作区的集成。

## 功能特性

- 📝 **页面管理** - 创建和管理页面
- 📋 **数据库查询** - 查询 Notion 数据库
- 🔍 **内容搜索** - 搜索工作区内容
- 📊 **数据管理** - 管理数据库记录

## 环境变量

| 变量                         | 默认值   | 说明                    |
| ---------------------------- | -------- | ----------------------- |
| `MCP_NOTION_VERSION`         | `latest` | MCP Notion 镜像版本     |
| `MCP_NOTION_PORT_OVERRIDE`   | `8000`   | MCP 服务端口            |
| `INTERNAL_INTEGRATION_TOKEN` | -        | Notion 集成令牌（必需） |
| `TZ`                         | `UTC`    | 时区                    |

## 快速开始

1. 在 <https://developers.notion.com> 创建 Notion 集成
2. 在 `.env` 文件中设置 `INTERNAL_INTEGRATION_TOKEN`
3. 运行 `docker compose up -d`
