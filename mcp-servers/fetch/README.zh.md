# Fetch MCP 服务器

Fetch MCP 服务器通过 Model Context Protocol 提供 URL 获取和内容提取功能。

## 功能特性

- 🔗 **URL 获取** - 从 URL 获取内容
- 📝 **Markdown 提取** - 从网页提取 Markdown
- 📄 **HTML 处理** - 处理 HTML 内容
- 🌐 **互联网访问** - 访问互联网资源

## 环境变量

| 变量                      | 默认值   | 说明               |
| ------------------------- | -------- | ------------------ |
| `MCP_FETCH_VERSION`       | `latest` | MCP Fetch 镜像版本 |
| `MCP_FETCH_PORT_OVERRIDE` | `8000`   | MCP 服务端口       |
| `TZ`                      | `UTC`    | 时区               |

## 快速开始

```bash
docker compose up -d
```
