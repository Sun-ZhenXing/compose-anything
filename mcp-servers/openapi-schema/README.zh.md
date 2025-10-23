# OpenAPI Schema MCP 服务器

OpenAPI Schema MCP 服务器通过 Model Context Protocol 提供 OpenAPI 模式解析和验证。

## 功能特性

- 📋 **模式解析** - 解析 OpenAPI 模式
- ✅ **验证** - 验证 API 模式
- 🔍 **模式分析** - 分析模式结构
- 📊 **模式生成** - 从 API 生成模式

## 环境变量

| 变量                               | 默认值   | 说明                        |
| ---------------------------------- | -------- | --------------------------- |
| `MCP_OPENAPI_SCHEMA_VERSION`       | `latest` | MCP OpenAPI Schema 镜像版本 |
| `MCP_OPENAPI_SCHEMA_PORT_OVERRIDE` | `8000`   | MCP 服务端口                |
| `TZ`                               | `UTC`    | 时区                        |

## 快速开始

```bash
docker compose up -d
```
