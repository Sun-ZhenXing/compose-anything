# Apache Airflow

Apache Airflow 是一个以编程方式编写、调度和监控工作流的平台。本技术栈使用 LocalExecutor 和 PostgreSQL 运行 Airflow 3.x，并采用全新的 api-server ＋ dag-processor 架构（Airflow 3 已用其取代经典的 webserver 组件）。

## 功能特点

- **Airflow 3.x 架构**：webserver 已被 `api-server` ＋ `dag-processor` 取代
- **LocalExecutor**：单机执行，无需 Redis 或 Celery
- **DAG 即代码**：使用 Python 定义工作流
- **丰富的调度能力**：类 Cron 调度、数据集（datasets）与事件触发
- **UI 与 REST API**：Web UI 和稳定的 REST API，端口为 8080
- **完整的组件拆分**：scheduler、triggerer、dag-processor 作为独立服务运行

> 超出范围：基于 Redis 的 CeleryExecutor。如有需要，后续可通过可选的 Compose profile 添加。

## 快速开始

1. 复制 `.env.example` 到 `.env`：

   ```bash
   cp .env.example .env
   ```

2. （可选）编辑 `.env` 自定义设置，例如端口和 UI 密码

3. 启动技术栈：

   ```bash
   docker compose up -d
   ```

4. 等待初始化完成（`airflow-init` 服务会执行数据库迁移并创建用户；使用 `docker compose logs -f airflow-init` 检查）

5. 打开 Airflow UI：`http://localhost:8080`，使用 `airflow` / `change-me` 登录（请先在 `.env` 中修改 `_AIRFLOW_WWW_USER_PASSWORD`）

## 默认配置

| 服务                   | 端口 | 说明                 |
| ---------------------- | ---- | -------------------- |
| airflow-apiserver      | 8080 | Web UI 与 REST API   |
| PostgreSQL             | 5432 | 元数据库（内部）     |
| airflow-scheduler      | -    | 调度器（无暴露端口） |
| airflow-dag-processor  | -    | DAG 处理器           |
| airflow-triggerer      | -    | 触发器               |

**身份验证**：使用默认 `.env` 时，初始 UI 凭据为 `airflow` / `change-me`（由 `_AIRFLOW_WWW_USER_PASSWORD` 设置）。**在实际使用前请务必修改密码。**

## 环境变量

主要环境变量（完整列表请参阅 `.env.example`）：

| 变量                           | 说明                                  | 默认值          |
| ------------------------------ | ------------------------------------- | --------------- |
| `AIRFLOW_VERSION`              | Airflow 镜像版本                      | `3.3.2-python3.12` |
| `POSTGRES_VERSION`             | PostgreSQL 镜像版本                   | `16`            |
| `AIRFLOW_PORT_OVERRIDE`        | UI/API 的主机端口                     | `8080`          |
| `_AIRFLOW_WWW_USER_USERNAME`   | 初始化时创建的 UI 用户名              | `airflow`       |
| `_AIRFLOW_WWW_USER_PASSWORD`   | 初始化时创建的 UI 密码                | `change-me`     |
| `AIRFLOW_FERNET_KEY`           | 用于加密连接与变量的 Fernet 密钥      | 生成/空         |
| `AIRFLOW_UID`                  | 用于 bind 挂载文件的主机 UID          | `50000`         |
| `POSTGRES_DB`                  | 元数据库名称                          | `airflow`       |
| `POSTGRES_USER`                | 元数据库用户                          | `airflow`       |
| `POSTGRES_PASSWORD`            | 元数据库密码                          | `airflow`       |
| `TZ`                           | 时区                                  | `UTC`           |
| 资源相关变量                   | 各服务的 CPU/内存限制                 | 见 `.env.example` |

## 资源需求

**最低要求**：

- CPU：2 核心
- 内存：4GB
- 磁盘：10GB

Airflow 会运行多个 Python 服务（scheduler、dag-processor、triggerer、api-server），4GB 内存是比较实际的底线。

## 数据卷

- `postgres-db`（命名卷）：PostgreSQL 元数据库数据
- `./dags`：DAG 文件（bind 挂载）
- `./logs`：任务与调度日志（bind 挂载）
- `./plugins`：Airflow 插件（bind 挂载）
- `./config`：自定义 Airflow 配置（bind 挂载）

## 安全注意事项

1. **默认凭据**：在对外暴露 UI 之前，修改 `_AIRFLOW_WWW_USER_USERNAME` / `_AIRFLOW_WWW_USER_PASSWORD`
2. **FERNET 密钥**：设置强 `AIRFLOW_FERNET_KEY`，用于加密存储在元数据库中的敏感信息；JWT 密钥同样来自 Airflow 的密钥配置
3. **非 root UID**：服务以 UID `50000`（`AIRFLOW_UID`）运行，请确保 bind 挂载目录对该 UID 可写
4. **不使用 `container_name`**：服务通过 Compose 服务名互相访问
5. **网络访问**：使用防火墙规则限制访问；生产环境中使用带 HTTPS 的反向代理

## 故障排除

**初始化服务失败：**

- 检查日志：`docker compose logs airflow-init`
- 验证 PostgreSQL 是否健康：`docker compose ps postgres`
- 仅在接受丢失元数据的前提下，删除命名卷后重试

**UI 无法访问：**

- 检查 `airflow-apiserver` 是否运行：`docker compose ps`
- 查看日志：`docker compose logs airflow-apiserver`
- 使用 `AIRFLOW_PORT_OVERRIDE` 检查端口映射

**DAG 未被识别：**

- 确认文件位于 `./dags` 且 UID `50000` 可读
- 查看日志：`docker compose logs airflow-dag-processor`
- 在 UI 中查看并修复 Python/导入错误

**`./logs` 权限错误：**

- 在 `.env` 中将 `AIRFLOW_UID` 设置为主机用户的 UID 后重启

## 参考资料

- 官方网站：<https://airflow.apache.org/>
- GitHub：<https://github.com/apache/airflow/>
- Docker Compose 文档：<https://airflow.apache.org/docs/apache-airflow/stable/howto/docker-compose/index.html>

## 许可证

Apache Airflow 使用 Apache-2.0 许可证。详情请参阅 [LICENSE](https://github.com/apache/airflow/blob/main/LICENSE)。
