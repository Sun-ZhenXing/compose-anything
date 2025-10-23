# OpenWeather MCP 服务器

OpenWeather MCP 服务器通过 Model Context Protocol 提供气象数据和气象信息。

## 功能特性

- 🌤️ **当前天气** - 获取当前天气数据
- 📋 **天气预报** - 获取天气预报
- 🌡️ **温度数据** - 访问温度信息
- 🌍 **基于位置** - 按位置查询天气

## 环境变量

| 变量                            | 默认值   | 说明                         |
| ------------------------------- | -------- | ---------------------------- |
| `MCP_OPENWEATHER_VERSION`       | `latest` | MCP OpenWeather 镜像版本     |
| `MCP_OPENWEATHER_PORT_OVERRIDE` | `8000`   | MCP 服务端口                 |
| `OPENWEATHER_API_KEY`           | -        | OpenWeather API 密钥（必需） |
| `TZ`                            | `UTC`    | 时区                         |

## 快速开始

1. 在 [OpenWeatherMap](https://openweathermap.org/api) 注册获取 API 密钥
2. 在 `.env` 文件中设置 `OPENWEATHER_API_KEY`
3. 运行 `docker compose up -d`
