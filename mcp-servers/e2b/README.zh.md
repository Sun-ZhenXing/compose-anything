# E2B MCP 服务器

E2B MCP 服务器通过 Model Context Protocol 提供云端代码执行和开发环境功能。

## 功能特性

- 💻 **代码执行** - 在云端安全执行代码
- 📁 **文件管理** - 管理文件和目录
- 🖥️ **终端访问** - 访问终端环境
- 🔧 **开发工具** - 各种开发工具

## 环境变量

| 变量                    | 默认值   | 说明                 |
| ----------------------- | -------- | -------------------- |
| `MCP_E2B_VERSION`       | `latest` | MCP E2B 镜像版本     |
| `MCP_E2B_PORT_OVERRIDE` | `8000`   | MCP 服务端口         |
| `E2B_API_KEY`           | -        | E2B API 密钥（必需） |
| `TZ`                    | `UTC`    | 时区                 |

## 快速开始

```bash
docker compose up -d
```
