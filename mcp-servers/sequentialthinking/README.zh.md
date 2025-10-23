# Sequential Thinking MCP 服务器

Sequential Thinking MCP 服务器通过 Model Context Protocol 提供结构化推理和逐步思考功能。

## 功能特性

- 🧠 **顺序推理** - 执行逐步推理
- 💭 **思考跟踪** - 跟踪和管理思考
- 📝 **结构化分析** - 结构化问题分析
- 🔄 **迭代精化** - 迭代精化解决方案

## 环境变量

| 变量                                   | 默认值   | 说明                             |
| -------------------------------------- | -------- | -------------------------------- |
| `MCP_SEQUENTIALTHINKING_VERSION`       | `latest` | MCP Sequential Thinking 镜像版本 |
| `MCP_SEQUENTIALTHINKING_PORT_OVERRIDE` | `8000`   | MCP 服务端口                     |
| `TZ`                                   | `UTC`    | 时区                             |

## 快速开始

```bash
docker compose up -d
```
