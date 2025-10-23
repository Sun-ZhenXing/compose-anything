# Paper Search MCP 服务器

Paper Search MCP 服务器通过 Model Context Protocol 提供研究论文搜索和发现功能。

## 功能特性

- 🔍 **论文搜索** - 搜索研究论文
- 📊 **高级过滤** - 按各种条件过滤论文
- 📥 **论文访问** - 访问论文信息和元数据
- 🔗 **交叉参考** - 查找相关论文

## 环境变量

| 变量                             | 默认值   | 说明                      |
| -------------------------------- | -------- | ------------------------- |
| `MCP_PAPER_SEARCH_VERSION`       | `latest` | MCP Paper Search 镜像版本 |
| `MCP_PAPER_SEARCH_PORT_OVERRIDE` | `8000`   | MCP 服务端口              |
| `TZ`                             | `UTC`    | 时区                      |

## 快速开始

```bash
docker compose up -d
```
