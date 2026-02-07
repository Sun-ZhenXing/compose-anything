# OpenSandbox

[English](README.md) | 中文

一个通用的 AI 应用沙箱平台，提供多语言 SDK、统一的沙箱 API 以及 Docker/Kubernetes 运行时。适用于代码智能体、GUI 智能体、智能体评估、AI 代码执行和强化学习训练等场景。

## 功能特性

- **多语言 SDK 支持**：提供 Python、JavaScript/TypeScript、Java/Kotlin 和 Go 客户端 SDK
- **统一的沙箱 API**：为沙箱生命周期、命令执行和文件操作提供一致的接口
- **多种运行时选项**：支持 Docker 和 Kubernetes 运行时
- **安全加固**：内置安全特性，包括能力限制、特权提升防护和资源限制
- **灵活的配置**：支持各种网络模式、资源约束和安全配置
- **代码解释器**：预构建的镜像，支持 Python、Node.js、Java 和 Go 内核

## 快速开始

### 前置要求

- Docker Engine（Docker 运行时必需）
- Docker Compose
- 足够的权限访问 Docker socket

> **使用 Colima 的 macOS 用户注意**：您需要在启动 OpenSandbox 之前设置 `DOCKER_HOST` 环境变量：
>
> ```bash
> export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock"
> ```

### 部署

1. **复制环境文件并根据需要配置：**

   ```bash
   cp .env.example .env
   ```

2. **编辑 `config.toml` 设置您的 API 密钥：**

   ```toml
   [server]
   api_key = "your-secret-api-key-change-this"
   ```

   **重要**：在生产环境中必须更改默认的 API 密钥！

3. **启动服务：**

   ```bash
   docker compose up -d
   ```

4. **验证服务是否运行：**

   ```bash
   curl http://localhost:8080/health
   ```

   您应该收到成功的健康检查响应。

## 配置

### 环境变量

主要环境变量（完整列表见 [.env.example](.env.example)）：

| 变量                               | 描述                       | 默认值                        |
| ---------------------------------- | -------------------------- | ----------------------------- |
| `OPENSANDBOX_SERVER_VERSION`       | OpenSandbox 服务器镜像版本 | `v1.0.5`                      |
| `OPENSANDBOX_SERVER_PORT_OVERRIDE` | 主机端口映射               | `8080`                        |
| `DOCKER_HOST`                      | Docker socket 路径         | `unix:///var/run/docker.sock` |
| `OPENSANDBOX_SERVER_CPU_LIMIT`     | CPU 核心限制               | `2.0`                         |
| `OPENSANDBOX_SERVER_MEMORY_LIMIT`  | 内存限制                   | `2G`                          |

### 服务器配置

主配置文件为 [config.toml](config.toml)。主要配置部分：

- **[server]**：HTTP 服务器设置（主机、端口、日志级别、API 密钥）
- **[runtime]**：运行时类型和 execd 镜像配置
- **[docker]**：Docker 特定设置，包括网络模式和安全选项

#### 网络模式

- **bridge**（推荐）：容器拥有隔离的网络，支持多个沙箱
- **host**：容器共享主机网络，一次只能运行一个沙箱实例

#### 安全特性

- **能力限制**：从容器中移除危险的 Linux 能力
- **特权提升防护**：阻止容器内的特权提升
- **进程限制**：控制每个沙箱的最大进程数
- **AppArmor/Seccomp 配置文件**：可选的安全配置文件（留空使用 Docker 默认值）

## 使用方法

### 基本沙箱创建（Python SDK）

```python
from opensandbox import Sandbox
from datetime import timedelta

# 创建一个代码解释器沙箱
sandbox = await Sandbox.create(
    "opensandbox/code-interpreter:v1.0.1",
    entrypoint="/opt/opensandbox/code-interpreter.sh",
    env={"PYTHON_VERSION": "3.11"},
    timeout=timedelta(minutes=10)
)

async with sandbox:
    # 执行 Python 代码
    result = await sandbox.execute(
        "python",
        "-c",
        "print('Hello from OpenSandbox!')"
    )
    print(result.stdout)
```

### API 认证

所有 API 请求都需要在 `X-API-Key` 头中包含 `config.toml` 中配置的密钥：

```bash
curl -H "X-API-Key: your-secret-api-key-change-this" \
     http://localhost:8080/sandboxes
```

## 预构建镜像

OpenSandbox 提供了几个预构建的沙箱镜像：

- **opensandbox/code-interpreter**：多语言代码解释器（Python、Node.js、Java、Go）
- **opensandbox/vscode**：VS Code Server 环境
- **opensandbox/desktop**：支持 VNC 的完整桌面环境
- **opensandbox/playwright**：使用 Playwright 进行浏览器自动化
- **opensandbox/chrome**：Chromium 浏览器环境

## 端口

| 端口 | 服务               | 描述            |
| ---- | ------------------ | --------------- |
| 8080 | OpenSandbox Server | HTTP API 服务器 |

## 数据持久化

- **opensandbox_data**：服务器数据和状态

## 健康检查

该服务在 `/health` 端点提供内置的健康检查：

```bash
curl http://localhost:8080/health
```

## 安全注意事项

### Docker Socket 访问

此服务需要访问 Docker socket（`/var/run/docker.sock`）以创建和管理沙箱容器。这是一个高权限操作。

**安全影响：**

- 具有 Docker socket 访问权限的容器可能会控制主机系统
- 仅在受信任的环境中部署
- 在生产环境中考虑使用 Docker-in-Docker 或 rootless Docker 以获得额外的隔离

**替代方案：**

- 使用 Kubernetes 运行时而不是 Docker 运行时（需要 Kubernetes 集群）
- 使用受限用户权限和资源配额进行部署

### API 密钥安全

- **切勿在生产环境中使用默认 API 密钥**
- 安全存储 API 密钥（例如，使用 Docker secrets、密钥管理器的环境变量）
- 定期轮换 API 密钥
- 限制网络暴露（使用防火墙规则、反向代理）

### 资源限制

始终配置适当的 CPU 和内存限制以防止资源耗尽：

```yaml
deploy:
  resources:
    limits:
      cpus: '2.0'
      memory: 2G
```

## 故障排除

### Docker Socket 连接问题

**错误**：Failed to initialize Docker service

**解决方案**：

- 确保 Docker Desktop/Engine 正在运行
- 在使用 Colima 的 macOS 上：设置 `DOCKER_HOST=unix://${HOME}/.colima/default/docker.sock`
- 检查 Docker socket 权限：`ls -l /var/run/docker.sock`

### 健康检查失败

**错误**：Health check timeout

**解决方案**：

- 检查容器日志：`docker compose logs opensandbox-server`
- 验证服务是否成功启动：`docker compose ps`
- 如果服务需要更多时间初始化，增加 docker-compose.yaml 中的 `start_period`

### 沙箱创建失败

**错误**：Failed to create sandbox

**解决方案**：

- 确保 execd 镜像可访问：`docker pull opensandbox/execd:v1.0.5`
- 检查可用的系统资源（CPU、内存、磁盘空间）
- 查看服务器日志以获取详细的错误消息

## 许可证

此项目是 OpenSandbox 套件的一部分。详情请参阅主 [LICENSE](https://github.com/alibaba/OpenSandbox/blob/main/LICENSE) 文件。

## 参考资料

- [OpenSandbox GitHub 仓库](https://github.com/alibaba/OpenSandbox)
- [OpenSandbox 文档](https://github.com/alibaba/OpenSandbox/tree/main/docs)
- [Docker 安全](https://docs.docker.com/engine/security/)

## 支持

如有问题和疑问：

- [GitHub Issues](https://github.com/alibaba/OpenSandbox/issues)
- [官方文档](https://github.com/alibaba/OpenSandbox)
