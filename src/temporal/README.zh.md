# Temporal

Temporal 是一个可扩展且可靠的持久化执行运行时,用于运行称为 Temporal 工作流执行的可重入流程。它使开发人员能够编写简单、有弹性的代码,而无需担心故障、重试或状态管理。

## 功能特点

- **持久化执行**：工作流可以在故障、重启甚至代码部署后继续运行
- **内置可靠性**：自动重试、超时和错误处理
- **长期运行的工作流**：支持运行数天、数月或数年的工作流
- **多语言 SDK**：官方支持 Go、Java、TypeScript、Python、PHP、.NET
- **高级可见性**：搜索和过滤工作流执行
- **事件驱动**：通过信号、查询和更新与工作流交互

## 快速开始

1. 复制 `.env.example` 到 `.env`：

   ```bash
   copy .env.example .env
   ```

2. （可选）编辑 `.env` 自定义数据库密码和设置

3. 启动 Temporal：

   ```bash
   docker compose up -d
   ```

4. 等待服务就绪（使用 `docker compose logs -f temporal` 检查）

5. 访问 Temporal Web UI：`http://localhost:8233`

6. Frontend 服务地址：`localhost:7233`（gRPC）

## 默认配置

| 服务              | 端口 | 说明             |
| ----------------- | ---- | ---------------- |
| Temporal Frontend | 7233 | SDK 的 gRPC 端点 |
| Temporal Web UI   | 8233 | Web 界面         |
| PostgreSQL        | 5432 | 数据库（内部）   |

**身份验证**：默认无身份验证。生产环境中请配置 mTLS 和授权。

## 环境变量

主要环境变量（完整列表请参阅 `.env.example`）：

| 变量                              | 说明                | 默认值     |
| --------------------------------- | ------------------- | ---------- |
| `TEMPORAL_VERSION`                | Temporal 服务器版本 | `1.24.2`   |
| `TEMPORAL_UI_VERSION`             | Temporal UI 版本    | `2.28.0`   |
| `TEMPORAL_FRONTEND_PORT_OVERRIDE` | Frontend gRPC 端口  | `7233`     |
| `TEMPORAL_UI_PORT_OVERRIDE`       | Web UI 端口         | `8233`     |
| `POSTGRES_DB`                     | 数据库名称          | `temporal` |
| `POSTGRES_USER`                   | 数据库用户          | `temporal` |
| `POSTGRES_PASSWORD`               | 数据库密码          | `temporal` |
| `TEMPORAL_LOG_LEVEL`              | 日志级别            | `info`     |
| `TZ`                              | 时区                | `UTC`      |

## 资源需求

**最低要求**：

- CPU：1 核心
- 内存：1GB
- 磁盘：5GB

**推荐配置**：

- CPU：2+ 核心
- 内存：2GB+
- 磁盘：20GB+

## 数据卷

- `postgres_data`：PostgreSQL 数据库数据
- `temporal_data`：Temporal 配置和状态

## 使用 Temporal

### 安装 SDK

选择您的语言：

**Go：**

```bash
go get go.temporal.io/sdk
```

**TypeScript：**

```bash
npm install @temporalio/client @temporalio/worker
```

**Python：**

```bash
pip install temporalio
```

### 编写工作流（Python 示例）

```python
from temporalio import workflow, activity
from datetime import timedelta

@activity.defn
async def say_hello(name: str) -> str:
    return f"Hello, {name}!"

@workflow.defn
class HelloWorkflow:
    @workflow.run
    async def run(self, name: str) -> str:
        return await workflow.execute_activity(
            say_hello,
            name,
            start_to_close_timeout=timedelta(seconds=10),
        )
```

### 运行 Worker

```python
from temporalio.client import Client
from temporalio.worker import Worker

async def main():
    client = await Client.connect("localhost:7233")

    worker = Worker(
        client,
        task_queue="hello-queue",
        workflows=[HelloWorkflow],
        activities=[say_hello],
    )

    await worker.run()
```

### 执行工作流

```python
from temporalio.client import Client

async def main():
    client = await Client.connect("localhost:7233")

    result = await client.execute_workflow(
        HelloWorkflow.run,
        "World",
        id="hello-workflow",
        task_queue="hello-queue",
    )

    print(result)
```

### 使用 tctl CLI

admin-tools 容器（dev 配置文件）包含 tctl：

```bash
docker compose --profile dev run temporal-admin-tools
tctl namespace list
tctl workflow list
```

## 配置文件

- `dev`：包含用于 CLI 访问的 admin-tools 容器

启用 dev 配置文件：

```bash
docker compose --profile dev up -d
```

## 安全注意事项

1. **身份验证**：为生产部署配置 mTLS
2. **授权**：为命名空间和工作流设置授权规则
3. **数据库密码**：使用强 PostgreSQL 密码
4. **网络安全**：限制对 Temporal 端口的访问
5. **加密**：为敏感数据启用静态加密

## 升级

升级 Temporal：

1. 在 `.env` 中更新版本
2. 拉取并重启：

   ```bash
   docker compose pull
   docker compose up -d
   ```

3. 检查日志查看迁移消息：

   ```bash
   docker compose logs -f temporal
   ```

## 故障排除

**服务无法启动：**

- 检查日志：`docker compose logs temporal`
- 验证数据库：`docker compose ps postgres`
- 确保分配了足够的资源

**SDK 无法连接：**

- 验证端口 7233 可访问
- 检查防火墙规则
- 确保 SDK 版本兼容性

**Web UI 无法加载：**

- 检查 UI 日志：`docker compose logs temporal-ui`
- 验证 frontend 健康：`docker compose ps temporal`
- 清除浏览器缓存

## 参考资料

- 官方网站：<https://temporal.io>
- 文档：<https://docs.temporal.io>
- GitHub：<https://github.com/temporalio/temporal>
- 社区：<https://community.temporal.io>
- SDK 文档：<https://docs.temporal.io/dev-guide>

## 许可证

Temporal 使用 MIT 许可证。详情请参阅 [LICENSE](https://github.com/temporalio/temporal/blob/master/LICENSE)。
