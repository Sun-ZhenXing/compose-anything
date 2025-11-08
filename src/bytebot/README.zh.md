# Bytebot

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署 Bytebot，一个开源的 AI 桌面代理，可自动化执行计算机任务。

## 服务

- `bytebot-desktop`：容器化的 Linux 桌面环境
- `bytebot-agent`：用于任务处理的 AI 代理
- `bytebot-ui`：任务管理的 Web 界面
- `bytebot-db`：PostgreSQL 数据库

## 环境变量

| 变量名                          | 说明                         | 默认值        |
| ------------------------------- | ---------------------------- | ------------- |
| `BYTEBOT_VERSION`               | Bytebot 镜像版本             | `edge`        |
| `POSTGRES_VERSION`              | PostgreSQL 版本              | `17-alpine`   |
| `POSTGRES_USER`                 | PostgreSQL 用户名            | `bytebot`     |
| `POSTGRES_PASSWORD`             | PostgreSQL 密码              | `bytebotpass` |
| `POSTGRES_DB`                   | PostgreSQL 数据库名称        | `bytebot`     |
| `ANTHROPIC_API_KEY`             | Anthropic API 密钥（Claude） | `""`          |
| `OPENAI_API_KEY`                | OpenAI API 密钥（GPT）       | `""`          |
| `GEMINI_API_KEY`                | Google Gemini API 密钥       | `""`          |
| `BYTEBOT_DESKTOP_PORT_OVERRIDE` | 桌面端口覆盖                 | `9990`        |
| `BYTEBOT_AGENT_PORT_OVERRIDE`   | 代理端口覆盖                 | `9991`        |
| `BYTEBOT_UI_PORT_OVERRIDE`      | UI 端口覆盖                  | `9992`        |

至少需要一个 AI API 密钥。

## 卷

- `bytebot_db_data`：PostgreSQL 数据

## 使用方法

### 启动 Bytebot

```bash
docker compose up -d
```

### 访问

- Web UI：<http://localhost:9992>
- Agent API：<http://localhost:9991>
- 桌面 VNC：<http://localhost:9990/vnc>

### 创建任务

1. 打开 <http://localhost:9992>
2. 使用自然语言描述创建新任务
3. 在桌面环境中观察代理工作

## 功能特性

- 自然语言任务自动化
- 带 VNC 的可视化桌面环境
- 支持多种 AI 模型（Claude、GPT、Gemini）
- 基于 Web 的任务管理界面

## 注意事项

- 需要至少一个 AI API 密钥才能正常工作
- 桌面环境使用共享内存（2GB）
- 首次启动可能需要几分钟
- 适合开发和测试使用

## 安全性

- 生产环境中请更改默认数据库密码
- 妥善保管 AI API 密钥
- 考虑使用环境文件而不是命令行参数传递敏感信息

## 许可证

Bytebot 采用 Apache License 2.0 许可。详情请参见 [Bytebot GitHub](https://github.com/bytebot-ai/bytebot)。
