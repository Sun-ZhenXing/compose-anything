# Text to GraphQL MCP 服务器

Text to GraphQL MCP 服务器通过 Model Context Protocol 将自然语言文本描述转换为 GraphQL 查询。

## 功能特性

- 📝 **文本解析** - 解析文本描述
- 🔄 **查询生成** - 从文本生成 GraphQL 查询
- 🔗 **API 集成** - 与 GraphQL API 集成
- 🎯 **查询优化** - 优化生成的查询

## 环境变量

| 变量                                | 默认值   | 说明                         |
| ----------------------------------- | -------- | ---------------------------- |
| `MCP_TEXT_TO_GRAPHQL_VERSION`       | `latest` | MCP Text to GraphQL 镜像版本 |
| `MCP_TEXT_TO_GRAPHQL_PORT_OVERRIDE` | `8000`   | MCP 服务端口                 |
| `TZ`                                | `UTC`    | 时区                         |

## 快速开始

```bash
docker compose up -d
```
