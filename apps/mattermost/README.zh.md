# Mattermost

[English](README.md)

Mattermost 是一个开源团队协作平台，提供聊天、频道、文件共享和集成能力。这个 Compose 配置包含 Mattermost 和 PostgreSQL，目标是用一条 `docker compose up -d` 完成启动。

## 快速开始

1. 复制环境变量示例文件：

   ```bash
   cp .env.example .env
   ```

2. 按需修改 `.env`，例如端口、站点 URL 或数据库密码。

3. 启动整个栈：

   ```bash
   docker compose up -d
   ```

4. 打开 Mattermost：

   - <http://localhost:8065>

5. 按照首次启动向导创建初始系统管理员账号。

## 默认端口

| 服务       | 端口 | 说明                 |
| ---------- | ---- | -------------------- |
| Mattermost | 8065 | Web 界面与 API       |
| PostgreSQL | 5432 | 仅供内部使用的数据库 |

## 关键环境变量

| 变量                           | 说明                             | 默认值                  |
| ------------------------------ | -------------------------------- | ----------------------- |
| `MATTERMOST_VERSION`           | Mattermost Team Edition 镜像标签 | `11.3`                  |
| `MATTERMOST_PORT_OVERRIDE`     | Mattermost 对外端口              | `8065`                  |
| `MATTERMOST_SITE_URL`          | Mattermost 对外访问 URL          | `http://localhost:8065` |
| `POSTGRES_DB`                  | PostgreSQL 数据库名              | `mattermost`            |
| `POSTGRES_USER`                | PostgreSQL 用户名                | `mmuser`                |
| `POSTGRES_PASSWORD`            | PostgreSQL 密码                  | `mmchangeit`            |
| `MATTERMOST_ENABLE_LOCAL_MODE` | 是否启用本地管理模式             | `false`                 |
| `TZ`                           | 容器时区                         | `UTC`                   |

## 数据卷

- `mattermost_postgres_data`：PostgreSQL 数据。
- `mattermost_config`：Mattermost 配置目录。
- `mattermost_data`：上传文件和业务数据。
- `mattermost_logs`：应用日志。
- `mattermost_plugins`：服务端插件。
- `mattermost_client_plugins`：前端插件。
- `mattermost_bleve_indexes`：搜索索引。

## 说明

- Mattermost 依赖 PostgreSQL，只有数据库健康后才会继续启动。
- 这里默认使用 Team Edition。
- 如果你通过反向代理或自定义域名访问 Mattermost，请同步修改 `MATTERMOST_SITE_URL`。

## 参考资料

- [Mattermost 仓库](https://github.com/mattermost/mattermost)
- [Mattermost Team Edition 镜像](https://hub.docker.com/r/mattermost/mattermost-team-edition)
