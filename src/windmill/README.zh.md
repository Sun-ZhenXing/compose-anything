# Windmill

Windmill 是一个开源的开发者基础设施平台,允许您从最少的 Python、TypeScript、Go、Bash、SQL 脚本快速构建生产级的多步骤自动化和内部应用。

## 功能特点

- **多语言支持**：使用 Python、TypeScript、Go、Bash、SQL 编写脚本
- **自动生成 UI**：从脚本自动生成用户界面
- **可视化工作流构建器**：通过代码执行构建复杂工作流
- **调度**：内置基于 cron 的调度
- **Webhook**：通过 HTTP webhook 触发脚本
- **版本控制**：内置 Git 同步和审计日志
- **多租户**：基于工作区的多租户

## 快速开始

1. 复制 `.env.example` 到 `.env`：

   ```bash
   copy .env.example .env
   ```

2. **重要**：编辑 `.env` 并更改：
   - `WINDMILL_SUPERADMIN_EMAIL` - 您的管理员邮箱
   - `WINDMILL_SUPERADMIN_PASSWORD` - 一个强密码
   - `POSTGRES_PASSWORD` - 一个强数据库密码

3. 启动 Windmill：

   ```bash
   docker compose up -d
   ```

4. 等待服务就绪

5. 访问 Windmill UI：`http://localhost:8000`

6. 使用配置的超级管理员凭证登录

## 默认配置

| 服务            | 端口 | 说明                       |
| --------------- | ---- | -------------------------- |
| Windmill Server | 8000 | Web UI 和 API              |
| PostgreSQL      | 5432 | 数据库（内部）             |
| Windmill LSP    | 3001 | 语言服务器（dev 配置文件） |

**默认凭证**（请更改！）：

- 邮箱：`admin@windmill.dev`
- 密码：`changeme`

## 环境变量

主要环境变量（完整列表请参阅 `.env.example`）：

| 变量                           | 说明              | 默认值                  |
| ------------------------------ | ----------------- | ----------------------- |
| `WINDMILL_VERSION`             | Windmill 镜像版本 | `main`                  |
| `WINDMILL_PORT_OVERRIDE`       | UI 的主机端口     | `8000`                  |
| `WINDMILL_BASE_URL`            | 基础 URL          | `http://localhost:8000` |
| `WINDMILL_SUPERADMIN_EMAIL`    | 超级管理员邮箱    | `admin@windmill.dev`    |
| `WINDMILL_SUPERADMIN_PASSWORD` | 超级管理员密码    | **必须更改！**          |
| `POSTGRES_PASSWORD`            | 数据库密码        | `changeme`              |
| `WINDMILL_NUM_WORKERS`         | Worker 数量       | `3`                     |
| `WINDMILL_LICENSE_KEY`         | 企业许可证        | （空）                  |
| `TZ`                           | 时区              | `UTC`                   |

## 资源需求

**最低要求**：

- CPU：1 核心
- 内存：1GB
- 磁盘：5GB

**推荐配置**：

- CPU：3+ 核心（server 1 个,worker 2+ 个）
- 内存：3GB+
- 磁盘：20GB+

## 数据卷

- `postgres_data`：PostgreSQL 数据库数据
- `windmill_server_data`：Windmill 服务器数据
- `windmill_worker_data`：Worker 执行数据

## 使用 Windmill

### 创建脚本

1. 访问 UI：`http://localhost:8000`
2. 创建工作区或使用默认工作区
3. 进入 "Scripts" 并点击 "New Script"
4. 编写您的脚本（Python 示例）：

    ```python
    def main(name: str = "world"):
        return f"Hello {name}!"
    ```

5. 保存并运行

### 创建工作流

1. 进入 "Flows" 并点击 "New Flow"
2. 使用可视化编辑器添加步骤
3. 每个步骤可以是脚本、流程或审批
4. 配置步骤之间的输入和输出
5. 部署并运行

### 使用 API

示例：列出脚本

```bash
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://localhost:8000/api/w/workspace/scripts/list
```

### 调度

1. 打开任何脚本或流程
2. 点击 "Schedule"
3. 设置 cron 表达式或间隔
4. 保存

## 配置文件

- `dev`：包含用于代码智能的 LSP 服务（端口 3001）

启用 dev 配置文件：

```bash
docker compose --profile dev up -d
```

## 安全注意事项

1. **更改默认凭证**：始终更改超级管理员凭证
2. **数据库密码**：使用强 PostgreSQL 密码
3. **Docker Socket**：挂载 Docker socket 授予容器控制权限
4. **SSL/TLS**：在生产环境中使用带 HTTPS 的反向代理
5. **许可证密钥**：如果使用企业许可证,请妥善保管密钥

## 升级

升级 Windmill：

1. 在 `.env` 中更新 `WINDMILL_VERSION`
2. 拉取并重启：

   ```bash
   docker compose pull
   docker compose up -d
   ```

3. 检查日志：

   ```bash
   docker compose logs -f windmill-server
   ```

## 故障排除

**服务无法启动：**

- 检查日志：`docker compose logs windmill-server`
- 验证数据库：`docker compose ps postgres`
- 确保 Docker socket 可访问

**无法登录：**

- 验证 `.env` 中的凭证
- 检查服务器日志中的身份验证错误
- 尝试通过 CLI 重置密码

**Worker 未处理：**

- 检查 worker 日志：`docker compose logs windmill-worker`
- 验证数据库连接
- 如需要增加 `WINDMILL_NUM_WORKERS`

## 参考资料

- 官方网站：<https://windmill.dev>
- 文档：<https://docs.windmill.dev>
- GitHub：<https://github.com/windmill-labs/windmill>
- 社区：<https://discord.gg/V7PM2YHsPB>

## 许可证

Windmill 使用 AGPLv3 许可证。详情请参阅 [LICENSE](https://github.com/windmill-labs/windmill/blob/main/LICENSE)。
