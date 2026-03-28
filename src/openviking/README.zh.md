# OpenViking

[English](README.md)

OpenViking 是火山引擎开源的 Agent 原生上下文数据库。这个 Compose 配置直接使用官方容器镜像，并在容器启动时根据环境变量生成最小可用的 ov.conf，因此可以用一条命令启动。

## 快速开始

1. 复制环境变量示例文件：

   ```bash
   cp .env.example .env
   ```

2. 编辑 `.env`，至少设置以下变量：

   - `OPENVIKING_ROOT_API_KEY`
   - `OPENVIKING_EMBEDDING_API_KEY`
   - `OPENVIKING_VLM_API_KEY`

3. 启动服务：

   ```bash
   docker compose up -d
   ```

4. 检查健康状态：

   ```bash
   curl http://localhost:1933/health
   ```

## 默认端口

| 服务       | 端口 | 说明                    |
| ---------- | ---- | ----------------------- |
| OpenViking | 1933 | HTTP API 与健康检查接口 |

## 关键环境变量

| 变量                           | 说明                                     | 默认值                    |
| ------------------------------ | ---------------------------------------- | ------------------------- |
| `OPENVIKING_VERSION`           | OpenViking 镜像标签                      | `main`                    |
| `OPENVIKING_PORT_OVERRIDE`     | HTTP API 对外端口                        | `1933`                    |
| `OPENVIKING_ROOT_API_KEY`      | 服务监听 `0.0.0.0` 时需要的 Root API Key | `openviking-dev-root-key` |
| `OPENVIKING_EMBEDDING_API_KEY` | Embedding 模型的 API Key                 | -                         |
| `OPENVIKING_EMBEDDING_MODEL`   | Embedding 模型名称                       | `text-embedding-3-small`  |
| `OPENVIKING_VLM_API_KEY`       | 多模态模型 API Key                       | -                         |
| `OPENVIKING_VLM_MODEL`         | 多模态模型名称                           | `gpt-4o-mini`             |
| `TZ`                           | 容器时区                                 | `UTC`                     |

## 数据卷

- `openviking_data`：持久化工作区与本地存储数据。

## 说明

- 这个配置会在容器启动时根据 `.env` 生成 `ov.conf`，因此不需要额外准备配置文件。
- 即使没有填写模型 API Key，服务通常也可以启动，但索引与多模态能力无法正常使用。
- `/health` 端点不需要认证，Compose 健康检查会依赖它。

## 参考资料

- [OpenViking 仓库](https://github.com/volcengine/OpenViking)
- [部署文档](https://github.com/volcengine/OpenViking/blob/main/docs/zh/guides/03-deployment.md)
