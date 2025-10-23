# Markdownify MCP 服务器

Markdownify MCP 服务器通过 Model Context Protocol 将各种文档格式转换为 Markdown。

## 功能特性

- 📄 **格式转换** - 将文档转换为 Markdown
- 🔗 **URL 处理** - 将网页内容转换为 Markdown
- 📋 **文档解析** - 解析和转换各种文件类型

## 环境变量

| 变量                            | 默认值   | 说明                     |
| ------------------------------- | -------- | ------------------------ |
| `MCP_MARKDOWNIFY_VERSION`       | `latest` | MCP Markdownify 镜像版本 |
| `MCP_MARKDOWNIFY_PORT_OVERRIDE` | `8000`   | MCP 服务端口             |
| `TZ`                            | `UTC`    | 时区                     |

## 快速开始

```bash
docker compose up -d
```
