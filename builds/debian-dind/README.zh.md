# Debian DinD

基于 Debian 的 Docker-in-Docker（DinD）服务，允许你在 Docker 容器内运行 Docker。适用于 CI/CD 流水线、开发环境和容器化构建系统。

## 特性

- 基于最新稳定版 Debian（13.2-slim）
- 开箱即用的 Docker 守护进程
- 可选的 NVIDIA Container Toolkit，支持 GPU
- 配置了资源限制
- 包含健康检查
- 通过环境变量自定义配置

## 快速开始

1. 复制示例环境文件：

   ```bash
   cp .env.example .env
   ```

2. 启动服务：

   ```bash
   docker compose up -d
   ```

3. 验证 Docker 是否在容器内运行：

   ```bash
   docker compose exec dind docker info
   docker compose exec dind docker run hello-world
   ```

## 配置说明

主要环境变量（查看 `.env.example` 了解所有选项）：

| 变量                      | 说明                      | 默认值           |
| ------------------------- | ------------------------- | ---------------- |
| `GLOBAL_REGISTRY`         | 全局镜像仓库前缀（可选）  | -                |
| `DEBIAN_DIND_VERSION`     | 主 DinD 镜像版本          | `0.1.1`          |
| `DEBIAN_DIND_GPU_VERSION` | GPU 版本 DinD 镜像版本    | `0.1.1-gpu`      |
| `DEBIAN_VERSION`          | Debian 基础镜像版本       | `13.2-slim`      |
| `DIND_PORT_OVERRIDE`      | Docker 守护进程的主机端口 | `2375`           |
| `INSTALL_NVIDIA_TOOLKIT`  | 构建时安装 NVIDIA 工具包  | `false`          |
| `TZ`                      | 时区                      | `UTC`            |
| `DIND_CPU_LIMIT`          | CPU 限制                  | `2.0`            |
| `DIND_MEMORY_LIMIT`       | 内存限制                  | `4G`             |
| `DIND_CPU_RESERVATION`    | CPU 预留                  | `1.0`            |
| `DIND_MEMORY_RESERVATION` | 内存预留                  | `2G`             |
| `DOCKER_TLS_CERTDIR`      | TLS 证书目录              | 空（TLS 已禁用） |

## GPU 支持

使用 GPU 支持的 DinD：

1. 在 `.env` 中设置 `INSTALL_NVIDIA_TOOLKIT=true`
2. 使用 `gpu` profile：

   ```bash
   docker compose --profile gpu up -d
   ```

或使用专用的 GPU 服务：

```bash
docker compose up -d dind-gpu
```

## 安全注意事项

⚠️ **重要**：此服务以特权模式运行，这会授予容器对主机系统的广泛访问权限。仅在可信环境中使用。

- DinD 运行需要特权模式
- Docker 守护进程在端口 2375 上暴露，未启用 TLS（仅用于开发）
- 生产环境请通过设置 `DOCKER_TLS_CERTDIR=/certs` 启用 TLS

## 数据卷

- `dind-data`：存储 Docker 守护进程数据（镜像、容器、卷）
- `dind-gpu-data`：GPU 服务的独立数据卷

## 资源限制

默认资源限制：

- CPU：2.0 核心（限制），1.0 核心（预留）
- 内存：4GB（限制），2GB（预留）

根据你的工作负载在 `.env` 中调整这些值。

## 高级用法

### 从主机连接

你可以从主机连接到 Docker 守护进程：

```bash
export DOCKER_HOST=tcp://localhost:2375
docker info
```

### 在 CI/CD 中使用

GitLab CI 配置示例：

```yaml
services:
  - name: your-registry/debian-dind:latest
    alias: docker

variables:
  DOCKER_HOST: tcp://docker:2375
```

## 构建参数

手动构建镜像时：

- `DEBIAN_VERSION`：Debian 基础版本（默认：`13.2-slim`）
- `INSTALL_NVIDIA_TOOLKIT`：安装 NVIDIA 工具包（默认：`false`）

示例：

```bash
docker build --build-arg DEBIAN_VERSION=13.2-slim --build-arg INSTALL_NVIDIA_TOOLKIT=true -t debian-dind-gpu .
```

## 许可证

此配置按原样提供，用于 Compose Anything 项目。
