# OpenCode

[English](./README.md) | [中文](./README.zh.md)

[OpenCode](https://github.com/anomalyco/opencode) 是一个为终端和 Web 构建的开源 AI 编程助手。它允许你使用多种大语言模型（LLM）提供商来自动执行本地或远程项目中的编码任务。

## 使用方法

1. 将 `.env.example` 复制为 `.env`。
2. 在 `.env` 中设置你偏好的 LLM 提供商 API 密钥（例如 `ANTHROPIC_API_KEY`）。
3. 将 `OPENCODE_PROJECT_DIR` 设置为你希望助手工作的项目路径。
4. 启动服务：

    ```bash
    docker compose up -d
    ```

5. 在浏览器中访问 `http://localhost:4096` 进入 Web 界面。

## 配置项

- `OPENCODE_VERSION`：OpenCode 镜像版本（默认为 `1.1.27`）。
- `OPENCODE_PORT_OVERRIDE`：映射到宿主机的 Web 端口（默认为 `4096`）。
- `OPENCODE_PROJECT_DIR`：助手有权访问的项目代码库路径。
- `ANTHROPIC_API_KEY`：Anthropic Claude 模型的 API 密钥。
- `OPENAI_API_KEY`：OpenAI 模型的 API 密钥。
- `GEMINI_API_KEY`：Google Gemini 模型的 API 密钥。
- `DEEPSEEK_API_KEY`：DeepSeek 模型的 API 密钥。

## 数据卷

- `opencode_data`：用于存储配置、会话数据和缓存。
- 将目标项目目录挂载到容器内的 `/app` 路径。

## 资源限制

默认限制：

- CPU：1.0
- 内存：2G

你可以通过 `.env` 文件中的 `OPENCODE_CPU_LIMIT` 和 `OPENCODE_MEMORY_LIMIT` 来覆盖这些默认值。
