# Time MCP 服务器

Time MCP 服务器通过 Model Context Protocol 提供时间和时区信息功能。

## 功能特性

- 🕐 **当前时间** - 获取当前时间
- 🌍 **时区支持** - 使用多个时区
- 📅 **日期/时间操作** - 各种日期/时间操作
- ⏰ **时间转换** - 在时区之间转换

## 环境变量

| 变量                     | 默认值   | 说明              |
| ------------------------ | -------- | ----------------- |
| `MCP_TIME_VERSION`       | `latest` | MCP Time 镜像版本 |
| `MCP_TIME_PORT_OVERRIDE` | `8000`   | MCP 服务端口      |
| `TZ`                     | `UTC`    | 时区              |

## 快速开始

```bash
docker compose up -d
```
