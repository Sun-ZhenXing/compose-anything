# Markitdown MCP 服务器

微软的 Markitdown MCP 服务器通过 Model Context Protocol 提供轻量级的 Markdown 格式转换功能。

## 功能特性

- 📄 **文档转换** - 将文档转换为 Markdown
- 🔗 **URL 转换** - 将网页内容转换为 Markdown
- 📝 **内容处理** - 处理和提取内容

## 环境变量

| 变量                           | 默认值   | 说明                    |
| ------------------------------ | -------- | ----------------------- |
| `MCP_MARKITDOWN_VERSION`       | `latest` | MCP Markitdown 镜像版本 |
| `MCP_MARKITDOWN_PORT_OVERRIDE` | `8000`   | MCP 服务端口            |
| `DATA_DIR`                     | `./data` | 数据目录路径            |
| `TZ`                           | `UTC`    | 时区                    |

## 快速开始

```bash
docker compose up -d
```
