# MCP YouTube Transcript 服务器

Model Context Protocol（MCP）服务器，用于获取 YouTube 视频字幕。使 AI 助手能够检索和处理 YouTube 视频字幕和转录内容。

## 功能特性

- **字幕提取**：从 YouTube 视频中获取字幕
- **多语言支持**：访问不同语言的字幕
- **自动字幕**：支持自动生成的字幕
- **时间戳信息**：检索带有时间数据的字幕
- **MCP 集成**：标准 MCP 协议，用于 AI 助手集成

## 环境变量

| 变量                                   | 描述            | 默认值   |
| -------------------------------------- | --------------- | -------- |
| `MCP_YOUTUBE_TRANSCRIPT_VERSION`       | Docker 镜像版本 | `latest` |
| `MCP_YOUTUBE_TRANSCRIPT_PORT_OVERRIDE` | 主机端口覆盖    | `8000`   |
| `TZ`                                   | 时区            | `UTC`    |

## 快速开始

1. 复制 `.env.example` 到 `.env`：

   ```bash
   cp .env.example .env
   ```

2. 启动服务：

   ```bash
   docker compose up -d
   ```

3. 检查服务状态：

   ```bash
   docker compose ps
   ```

4. 查看日志：

   ```bash
   docker compose logs -f
   ```

## 使用说明

将您的 AI 助手连接到 MCP 服务器 `http://localhost:8000`，即可启用 YouTube 字幕检索功能。

## 许可证

请查看官方 [MCP YouTube Transcript](https://hub.docker.com/r/mcp/youtube-transcript) 文档以获取许可证信息。
