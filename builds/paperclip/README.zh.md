# Paperclip

[English](README.md)

Paperclip 是一个面向 AI 团队编排的开源平台。这个 Compose 配置会从上游源码构建 Docker 镜像，持久化整个 Paperclip Home 目录，并通过 3100 端口暴露 Web 界面。

## 快速开始

1. 复制环境变量示例文件：

   ```bash
   cp .env.example .env
   ```

2. 按需编辑 `.env`：

   - 如果你不通过 `http://localhost:3100` 访问，请修改 `PAPERCLIP_PUBLIC_URL`
   - 如果要启用本地适配器，填写 `OPENAI_API_KEY` 和或 `ANTHROPIC_API_KEY`
   - 如果要接入外部 PostgreSQL，而不是内置数据库，请设置 `DATABASE_URL`

3. 启动服务：

   ```bash
   docker compose up -d
   ```

4. 打开界面：

   - <http://localhost:3100>

5. 在浏览器中完成 Paperclip 的初始化流程。

## 默认端口

| 服务      | 端口 | 说明           |
| --------- | ---- | -------------- |
| Paperclip | 3100 | Web 界面与 API |

## 关键环境变量

| 变量                            | 说明                         | 默认值                  |
| ------------------------------- | ---------------------------- | ----------------------- |
| `PAPERCLIP_GIT_REF`             | 用于源码构建的 Git 引用      | `main`                  |
| `PAPERCLIP_PORT_OVERRIDE`       | Paperclip 对外端口           | `3100`                  |
| `PAPERCLIP_PUBLIC_URL`          | 认证与邀请流程使用的公开 URL | `http://localhost:3100` |
| `PAPERCLIP_ALLOWED_HOSTNAMES`   | 额外允许的主机名             | `localhost`             |
| `PAPERCLIP_DEPLOYMENT_MODE`     | 部署模式                     | `authenticated`         |
| `PAPERCLIP_DEPLOYMENT_EXPOSURE` | 暴露模式                     | `private`               |
| `DATABASE_URL`                  | 可选的外部 PostgreSQL 连接串 | -                       |
| `OPENAI_API_KEY`                | OpenAI Key                   | -                       |
| `ANTHROPIC_API_KEY`             | Anthropic Key                | -                       |
| `TZ`                            | 容器时区                     | `UTC`                   |

## 数据卷

- `paperclip_data`：保存内置 PostgreSQL、上传文件、密钥和运行状态。

## 说明

- 如果没有设置 `DATABASE_URL`，Paperclip 会自动启用内置 PostgreSQL。
- 上游 Docker 镜像已经包含前端和服务端，不需要再拆分多个容器。
- 首次源码构建通常需要几分钟。

## 参考资料

- [Paperclip 仓库](https://github.com/paperclipai/paperclip)
- [Docker 部署文档](https://github.com/paperclipai/paperclip/blob/main/docs/deploy/docker.md)
