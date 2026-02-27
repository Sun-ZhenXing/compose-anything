# Opik

[English](./README.md) | [中文](./README.zh.md)

本服务部署 [Opik](https://github.com/comet-ml/opik)，一个开源的 LLM 可观测性、评估和优化平台。Opik 帮助你调试、评估和监控 LLM 应用程序、RAG 系统和智能体工作流，提供全面的追踪、自动化评估和生产级仪表板。

## 服务组件

- **frontend**：Opik Web 界面（Nginx）
- **backend**：Opik 主后端 API 服务（Java/Dropwizard）
- **python-backend**：Python 后端，用于代码执行和 AI 功能
- **mysql**：MySQL 数据库，用于状态持久化
- **clickhouse**：ClickHouse 分析数据库，用于追踪数据存储
- **redis**：Redis，用于缓存和任务队列
- **zookeeper**：ZooKeeper，用于 ClickHouse 协调
- **minio**：兼容 S3 的对象存储，用于附件

## 快速开始

1. 复制 `.env.example` 到 `.env`：

   ```bash
   cp .env.example .env
   ```

2. 更新 `.env` 中的关键密钥（本地开发可选）：

   ```bash
   # 如需生成安全密码
   MYSQL_ROOT_PASSWORD=your-secure-password
   MYSQL_PASSWORD=your-secure-password
   REDIS_PASSWORD=your-secure-password
   CLICKHOUSE_PASSWORD=your-secure-password
   MINIO_ROOT_PASSWORD=your-secure-password
   ```

3. 启动服务：

   ```bash
   docker compose up -d
   ```

4. 访问 Opik：`http://localhost:5173`

## 核心环境变量

| 变量名                          | 描述                   | 默认值    |
| ------------------------------- | ---------------------- | --------- |
| `OPIK_VERSION`                  | Opik 容器镜像版本      | `1.10.23` |
| `OPIK_PORT_OVERRIDE`            | Web UI 端口            | `5173`    |
| `OPIK_BACKEND_PORT_OVERRIDE`    | 后端 API 端口          | `3003`    |
| `OPIK_USAGE_REPORT_ENABLED`     | 启用匿名使用报告       | `true`    |
| `TOGGLE_WELCOME_WIZARD_ENABLED` | 首次运行时显示欢迎向导 | `true`    |

## 数据库配置

| 变量名                | 描述                | 默认值             |
| --------------------- | ------------------- | ------------------ |
| `MYSQL_VERSION`       | MySQL 版本          | `8.4.2`            |
| `MYSQL_ROOT_PASSWORD` | MySQL root 密码     | `opik`             |
| `MYSQL_DATABASE`      | MySQL 数据库名      | `opik`             |
| `MYSQL_USER`          | MySQL 用户名        | `opik`             |
| `MYSQL_PASSWORD`      | MySQL 密码          | `opik`             |
| `CLICKHOUSE_VERSION`  | ClickHouse 版本     | `25.3.6.56-alpine` |
| `CLICKHOUSE_DB`       | ClickHouse 数据库名 | `opik`             |
| `CLICKHOUSE_USER`     | ClickHouse 用户名   | `opik`             |
| `CLICKHOUSE_PASSWORD` | ClickHouse 密码     | `opik`             |

## 存储与缓存配置

| 变量名                        | 描述               | 默认值             |
| ----------------------------- | ------------------ | ------------------ |
| `REDIS_VERSION`               | Redis 版本         | `7.2.4-alpine3.19` |
| `REDIS_PASSWORD`              | Redis 密码         | `opik`             |
| `MINIO_ROOT_USER`             | MinIO 管理员用户名 | `opikminio`        |
| `MINIO_ROOT_PASSWORD`         | MinIO 管理员密码   | `opikminio123`     |
| `MINIO_PORT_OVERRIDE`         | MinIO API 端口     | `9000`             |
| `MINIO_CONSOLE_PORT_OVERRIDE` | MinIO 控制台端口   | `9090`             |

## AI 功能配置（可选）

| 变量名                      | 描述                | 默认值  |
| --------------------------- | ------------------- | ------- |
| `TOGGLE_OPIK_AI_ENABLED`    | 启用 Opik AI 功能   | `false` |
| `TOGGLE_GUARDRAILS_ENABLED` | 启用护栏功能        | `false` |
| `OPENAI_API_KEY`            | OpenAI API 密钥     | ``      |
| `ANTHROPIC_API_KEY`         | Anthropic API 密钥  | ``      |
| `OPENROUTER_API_KEY`        | OpenRouter API 密钥 | ``      |

## Python 后端配置

| 变量名                                      | 描述                              | 默认值    |
| ------------------------------------------- | --------------------------------- | --------- |
| `PYTHON_CODE_EXECUTOR_STRATEGY`             | 代码执行策略（process/container） | `process` |
| `PYTHON_CODE_EXECUTOR_CONTAINERS_NUM`       | 执行器容器数量                    | `5`       |
| `PYTHON_CODE_EXECUTOR_EXEC_TIMEOUT_IN_SECS` | 代码执行超时时间                  | `3`       |
| `PYTHON_CODE_EXECUTOR_ALLOW_NETWORK`        | 允许代码执行访问网络              | `false`   |
| `OPTSTUDIO_MAX_CONCURRENT_JOBS`             | 最大并发优化任务数                | `5`       |
| `OPTSTUDIO_LOG_LEVEL`                       | 优化工作室日志级别                | `INFO`    |
| `OPTSTUDIO_LLM_MAX_TOKENS`                  | LLM 调用最大令牌数                | `8192`    |

## 数据卷

- `mysql_data`：MySQL 数据库文件
- `redis_data`：Redis 持久化数据
- `zookeeper_data`：ZooKeeper 数据
- `clickhouse_data`：ClickHouse 数据文件
- `clickhouse_logs`：ClickHouse 日志
- `clickhouse_config`：ClickHouse 配置
- `minio_data`：MinIO 对象存储数据

## 资源限制

所有服务都有可配置的 CPU 和内存限制：

| 服务           | CPU 限制 | 内存限制 |
| -------------- | -------- | -------- |
| frontend       | 0.5      | 512M     |
| backend        | 2.0      | 2G       |
| python-backend | 1.0      | 1G       |
| mysql          | 1.0      | 1G       |
| clickhouse     | 2.0      | 4G       |
| redis          | 0.5      | 512M     |
| zookeeper      | 0.5      | 1G       |
| minio          | 1.0      | 1G       |

## SDK 配置

要将 Opik Python SDK 与此本地部署一起使用：

```python
import opik

# 配置为本地部署
opik.configure(use_local=True)

# 或设置环境变量
import os
os.environ["OPIK_URL_OVERRIDE"] = "http://localhost:5173/api"
os.environ["OPIK_API_KEY"] = ""  # 本地部署留空

# 开始追踪
@opik.track
def my_llm_function(user_question: str) -> str:
    # 你的 LLM 代码
    return "Hello"
```

## 文档

- [Opik 文档](https://www.comet.com/docs/opik/)
- [Python SDK 参考](https://www.comet.com/docs/opik/python-sdk-reference/)
- [GitHub 仓库](https://github.com/comet-ml/opik)

## 许可证

Opik 采用 Apache 2.0 许可证。
