# MCP ElevenLabs 服务器

Model Context Protocol（MCP）服务器,用于 ElevenLabs 文本转语音 API 集成。使 AI 助手能够从文本生成高质量的语音音频。

## 功能特性

- **文本转语音**:将文本转换为自然流畅的语音
- **多种声音**:访问各种语音模型
- **语音克隆**:创建自定义语音配置文件
- **多语言支持**:支持多种语言
- **音频控制**:调整速度、音高和稳定性
- **MCP 集成**:标准 MCP 协议,用于 AI 助手集成

## 环境变量

| 变量                           | 描述                        | 默认值   |
| ------------------------------ | --------------------------- | -------- |
| `MCP_ELEVENLABS_VERSION`       | Docker 镜像版本             | `latest` |
| `MCP_ELEVENLABS_PORT_OVERRIDE` | 主机端口覆盖                | `8000`   |
| `ELEVENLABS_API_KEY`           | ElevenLabs API 密钥（必需） | -        |
| `TZ`                           | 时区                        | `UTC`    |

## 快速开始

1. 复制 `.env.example` 到 `.env`:

   ```bash
   cp .env.example .env
   ```

2. 编辑 `.env` 并设置您的 `ELEVENLABS_API_KEY`（从 <https://elevenlabs.io> 获取）

3. 启动服务:

   ```bash
   docker compose up -d
   ```

4. 检查服务状态:

   ```bash
   docker compose ps
   ```

5. 查看日志:

   ```bash
   docker compose logs -f
   ```

## 使用说明

将您的 AI 助手连接到 MCP 服务器 `http://localhost:8000`,即可启用 ElevenLabs 的文本转语音功能。

## 许可证

请查看官方 [MCP ElevenLabs](https://hub.docker.com/r/mcp/elevenlabs) 文档以获取许可证信息。
