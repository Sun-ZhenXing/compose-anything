# OpenAPI MCP 服务器

OpenAPI MCP 服务器通过 Model Context Protocol 提供 OpenAPI 规范支持。

## 功能特性

- 📋 **API 文档** - 解析和分析 OpenAPI 规范
- 🔌 **API 集成** - 连接到 OpenAPI 服务
- 📐 **模式验证** - 验证 API 模式

## 环境变量

| 变量                        | 默认值   | 说明                 |
| --------------------------- | -------- | -------------------- |
| `MCP_OPENAPI_VERSION`       | `latest` | MCP OpenAPI 镜像版本 |
| `MCP_OPENAPI_PORT_OVERRIDE` | `8000`   | MCP 服务端口         |
| `TZ`                        | `UTC`    | 时区                 |

## 快速开始

```bash
docker compose up -d
```
