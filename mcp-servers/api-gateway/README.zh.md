# API Gateway MCP 服务器

API Gateway MCP 服务器通过 Model Context Protocol 提供 API 网关和管理功能。

## 功能特性

- 🚪 **API 网关** - 管理 API 访问
- 🔐 **身份验证** - 处理 API 身份验证
- 📊 **速率限制** - 实施速率限制
- 📝 **API 文档** - 提供 API 文档

## 环境变量

| 变量                            | 默认值   | 说明                     |
| ------------------------------- | -------- | ------------------------ |
| `MCP_API_GATEWAY_VERSION`       | `latest` | MCP API Gateway 镜像版本 |
| `MCP_API_GATEWAY_PORT_OVERRIDE` | `8000`   | MCP 服务端口             |
| `TZ`                            | `UTC`    | 时区                     |

## 快速开始

```bash
docker compose up -d
```
