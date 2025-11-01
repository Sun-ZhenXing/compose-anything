# Kestra

Kestra 是一个无限可扩展的编排和调度平台,允许您以声明方式在代码中定义、运行、调度和监控数百万个工作流。

## 功能特点

- **声明式 YAML**：使用简单的 YAML 语法定义工作流
- **事件驱动**：基于事件、计划或 API 触发工作流
- **多语言支持**：执行 Python、Node.js、Shell、SQL 等
- **实时监控**：实时日志和执行跟踪
- **插件生态系统**：丰富的集成库
- **版本控制**：Git 集成用于工作流版本管理
- **可扩展**：处理数百万个工作流执行

## 快速开始

1. 复制 `.env.example` 到 `.env`：

   ```bash
   copy .env.example .env
   ```

2. （可选）编辑 `.env` 自定义设置,特别是启用基本身份验证

3. 启动 Kestra：

   ```bash
   docker compose up -d
   ```

4. 等待服务就绪（使用 `docker compose logs -f kestra` 检查）

5. 访问 Kestra UI：`http://localhost:8080`

## 默认配置

| 服务              | 端口 | 说明           |
| ----------------- | ---- | -------------- |
| Kestra            | 8080 | Web UI 和 API  |
| Kestra Management | 8081 | 管理端点       |
| PostgreSQL        | 5432 | 数据库（内部） |

**身份验证**：默认无身份验证。在 `.env` 中设置 `KESTRA_BASIC_AUTH_ENABLED=true` 以启用基本身份验证。

## 环境变量

主要环境变量（完整列表请参阅 `.env.example`）：

| 变量                         | 说明              | 默认值        |
| ---------------------------- | ----------------- | ------------- |
| `KESTRA_VERSION`             | Kestra 镜像版本   | `latest-full` |
| `KESTRA_PORT_OVERRIDE`       | UI/API 的主机端口 | `8080`        |
| `KESTRA_MANAGEMENT_PORT`     | 管理端口          | `8081`        |
| `POSTGRES_DB`                | 数据库名称        | `kestra`      |
| `POSTGRES_USER`              | 数据库用户        | `kestra`      |
| `POSTGRES_PASSWORD`          | 数据库密码        | `k3str4`      |
| `KESTRA_BASIC_AUTH_ENABLED`  | 启用基本身份验证  | `false`       |
| `KESTRA_BASIC_AUTH_USERNAME` | 验证用户名        | `admin`       |
| `KESTRA_BASIC_AUTH_PASSWORD` | 验证密码          | `admin`       |
| `TZ`                         | 时区              | `UTC`         |

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
- `kestra_data`：Kestra 存储（工作流输出、文件）
- `kestra_logs`：Kestra 应用日志

## 使用 Kestra

### 创建工作流

1. 访问 UI：`http://localhost:8080`
2. 进入 "Flows" 并点击 "Create"
3. 用 YAML 定义您的工作流：

    ```yaml
    id: hello-world
    namespace: company.team

    tasks:
      - id: hello
        type: io.kestra.plugin.core.log.Log
        message: Hello, World!
    ```

4. 保存并执行

### 使用 API

示例：列出流

```bash
curl http://localhost:8080/api/v1/flows/search
```

示例：触发执行

```bash
curl -X POST http://localhost:8080/api/v1/executions/company.team/hello-world
```

### CLI

安装 Kestra CLI：

```bash
curl -o kestra https://github.com/kestra-io/kestra/releases/latest/download/kestra
chmod +x kestra
```

### Docker 任务运行器

Kestra 可以在 Docker 容器中执行任务。compose 文件挂载了 `/var/run/docker.sock` 以启用此功能。使用 `io.kestra.plugin.scripts.runner.docker.Docker` 任务类型。

## 安全注意事项

1. **身份验证**：生产环境中启用基本身份验证或配置 SSO（OIDC）
2. **数据库密码**：为 PostgreSQL 使用强密码
3. **Docker Socket**：挂载 Docker socket 授予容器控制权限,确保适当的安全性
4. **网络访问**：使用防火墙规则限制访问
5. **SSL/TLS**：在生产环境中使用带 HTTPS 的反向代理

## 升级

升级 Kestra：

1. 在 `.env` 中更新 `KESTRA_VERSION`
2. 拉取并重启：

   ```bash
   docker compose pull
   docker compose up -d
   ```

3. 检查日志：

   ```bash
   docker compose logs -f kestra
   ```

## 故障排除

**服务无法启动：**

- 检查日志：`docker compose logs kestra`
- 验证数据库：`docker compose ps postgres`
- 确保 Docker socket 可访问

**无法执行 Docker 任务：**

- 验证 `/var/run/docker.sock` 已挂载
- 检查 Docker 守护进程是否运行
- 在 Kestra UI 中查看任务日志

**性能问题：**

- 在 `.env` 中增加资源限制
- 检查数据库性能
- 监控 Java 堆使用（调整 `KESTRA_JAVA_OPTS`）

## 参考资料

- 官方网站：<https://kestra.io>
- 文档：<https://kestra.io/docs>
- GitHub：<https://github.com/kestra-io/kestra>
- 社区：<https://kestra.io/slack>
- 插件中心：<https://kestra.io/plugins>

## 许可证

Kestra 使用 Apache-2.0 许可证。详情请参阅 [LICENSE](https://github.com/kestra-io/kestra/blob/develop/LICENSE)。
