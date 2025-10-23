# Wolfram Alpha MCP 服务器

Wolfram Alpha MCP 服务器通过 Model Context Protocol 提供计算知识引擎功能。

## 功能特性

- 🔢 **计算查询** - 执行计算查询
- 📊 **数据分析** - 分析复杂数据
- 🧮 **数学操作** - 数学计算
- 🌍 **知识库** - 访问 Wolfram Alpha 知识库

## 环境变量

| 变量                              | 默认值   | 说明                           |
| --------------------------------- | -------- | ------------------------------ |
| `MCP_WOLFRAM_ALPHA_VERSION`       | `latest` | MCP Wolfram Alpha 镜像版本     |
| `MCP_WOLFRAM_ALPHA_PORT_OVERRIDE` | `8000`   | MCP 服务端口                   |
| `WOLFRAM_ALPHA_APPID`             | -        | Wolfram Alpha API 密钥（必需） |
| `TZ`                              | `UTC`    | 时区                           |

## 快速开始

1. 从 [Wolfram Alpha](https://products.wolframalpha.com/api/) 获取 API 密钥
2. 在 `.env` 文件中设置 `WOLFRAM_ALPHA_APPID`
3. 运行 `docker compose up -d`
