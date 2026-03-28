# OpenFang

[English](README.md)

OpenFang 是一个开源的 Agent Operating System。这个 Compose 配置会基于上游 `v0.1.0` 源码标签构建镜像，并在启动时把最小可用的 `config.toml` 写入持久化数据卷。

## 快速开始

1. 复制环境变量示例文件：

   ```bash
   cp .env.example .env
   ```

2. 在 `.env` 中至少填写一个模型提供商的 API Key：

   - `ANTHROPIC_API_KEY`
   - `OPENAI_API_KEY`
   - `GROQ_API_KEY`

3. 启动 OpenFang：

   ```bash
   docker compose up -d
   ```

4. 打开控制台：

   - <http://localhost:4200>

5. 如需检查健康状态：

   ```bash
   curl http://localhost:4200/api/health
   ```

## 默认端口

| 服务     | 端口 | 说明              |
| -------- | ---- | ----------------- |
| OpenFang | 4200 | 控制台与 REST API |

## 关键环境变量

| 变量                     | 说明                                      | 默认值                     |
| ------------------------ | ----------------------------------------- | -------------------------- |
| `OPENFANG_VERSION`       | 用于源码构建的 Git 标签                   | `0.1.0`                    |
| `OPENFANG_PORT_OVERRIDE` | OpenFang 对外端口                         | `4200`                     |
| `OPENFANG_PROVIDER`      | 默认模型提供商                            | `anthropic`                |
| `OPENFANG_MODEL`         | 默认模型名称                              | `claude-sonnet-4-20250514` |
| `OPENFANG_API_KEY_ENV`   | OpenFang 读取提供商密钥时使用的环境变量名 | `ANTHROPIC_API_KEY`        |
| `OPENFANG_API_KEY`       | 可选的 API Bearer Token                   | -                          |
| `ANTHROPIC_API_KEY`      | Anthropic API Key                         | -                          |
| `OPENAI_API_KEY`         | OpenAI API Key                            | -                          |
| `GROQ_API_KEY`           | Groq API Key                              | -                          |
| `TZ`                     | 容器时区                                  | `UTC`                      |

## 数据卷

- `openfang_data`：持久化 `/data` 下的配置与运行数据。

## 说明

- 生成的配置会监听 `0.0.0.0:4200`，适合容器内运行。
- 如果 `OPENFANG_API_KEY` 为空，实例本身不会启用额外 API 认证，是否暴露到公网需要你自行把控。
- 该服务使用上游 Dockerfile 从源码构建，首次构建通常需要几分钟。

## 参考资料

- [OpenFang 仓库](https://github.com/RightNow-AI/openfang)
- [入门文档](https://github.com/RightNow-AI/openfang/blob/main/docs/getting-started.md)
