# DeerFlow

[English](README.md)

DeerFlow 是字节跳动开源的全栈 AI Agent 应用。这个 Compose 配置会从源码构建前后端镜像，启动 Gateway、LangGraph 和 Nginx，并通过 2026 端口暴露统一入口。

## 快速开始

1. 复制环境变量示例文件：

   ```bash
   cp .env.example .env
   ```

2. 编辑 `.env`，至少填写 `OPENAI_API_KEY`。

3. 启动整个栈：

   ```bash
   docker compose up -d
   ```

4. 打开 DeerFlow：

   - <http://localhost:2026>

## 默认端口

| 服务        | 端口 | 说明          |
| ----------- | ---- | ------------- |
| Nginx       | 2026 | 统一 Web 入口 |
| Gateway API | 8001 | 仅内部访问    |
| LangGraph   | 2024 | 仅内部访问    |
| Frontend    | 3000 | 仅内部访问    |

## 关键环境变量

| 变量                           | 说明                                         | 默认值                           |
| ------------------------------ | -------------------------------------------- | -------------------------------- |
| `DEER_FLOW_VERSION`            | 用于源码构建的 Git 引用                      | `main`                           |
| `DEER_FLOW_PORT_OVERRIDE`      | 统一入口对外端口                             | `2026`                           |
| `OPENAI_API_KEY`               | 生成的 `config.yaml` 中引用的 OpenAI API Key | -                                |
| `DEER_FLOW_MODEL_NAME`         | 模型内部标识                                 | `openai-default`                 |
| `DEER_FLOW_MODEL_DISPLAY_NAME` | 界面展示名称                                 | `OpenAI`                         |
| `DEER_FLOW_MODEL_ID`           | OpenAI 模型 ID                               | `gpt-4.1-mini`                   |
| `DEER_FLOW_CORS_ORIGINS`       | Gateway 允许的跨域来源                       | `http://localhost:2026`          |
| `DEER_FLOW_BETTER_AUTH_SECRET` | 前端鉴权密钥                                 | `deer-flow-dev-secret-change-me` |
| `TZ`                           | 容器时区                                     | `UTC`                            |

## 说明

- 这个配置会在后端容器内部生成最小可用的 `config.yaml` 和 `extensions_config.json`，因此不需要额外手工准备配置文件。
- 默认使用本地 sandbox 模式，这样不需要挂载 Docker Socket，也不依赖 Kubernetes provisioner。
- DeerFlow 上游通常要求本地构建镜像，因此首次构建耗时可能较长。
- 当前默认只接入了 OpenAI 兼容模型。如果你要改成 Anthropic、Gemini 或更复杂的配置，需要调整 `docker-compose.yaml` 中生成配置文件的模板。

## 参考资料

- [DeerFlow 仓库](https://github.com/bytedance/deer-flow)
- [项目 README](https://github.com/bytedance/deer-flow/blob/main/README_zh.md)
