# K3s inside Docker-in-Docker

[English Documentation](README.md)

在 Docker-in-Docker（DinD）容器中运行的轻量级 Kubernetes 发行版（K3s）。此配置允许你在单个 Docker 容器内运行完整的 Kubernetes 集群，非常适合开发、测试和 CI/CD 流水线。

## 功能特性

- ✅ 在单个容器中运行完整的 K3s 集群
- ✅ 支持 Docker-in-Docker，可运行容器化工作负载
- ✅ 在 6443 端口暴露 Kubernetes API 服务器
- ✅ 支持多架构（x86-64、ARM64）
- ✅ 资源限制防止系统资源耗尽
- ✅ 健康检查确保集群就绪
- ✅ 持久化存储 K3s 和 Docker 数据
- ✅ 预装常用镜像支持离线使用

## 前置要求

- Docker Engine 20.10+
- Docker Compose 2.0+
- 至少 2 个 CPU 核心和 4GB 内存
- 支持特权容器

## 快速开始

1. 复制环境变量文件：

   ```bash
   cp .env.example .env
   ```

2. （可选）在 `.env` 中自定义配置

3. 构建并启动服务：

   ```bash
   docker compose up -d --build
   ```

4. 等待 K3s 就绪（检查健康状态）：

   ```bash
   docker compose ps
   ```

5. 访问 Kubernetes 集群：

   ```bash
   # 从容器中复制 kubeconfig
   docker compose exec k3s cat /etc/rancher/k3s/k3s.yaml > kubeconfig.yaml

   # 使用 kubectl 连接集群
   export KUBECONFIG=$(pwd)/kubeconfig.yaml
   kubectl get nodes
   ```

## 配置说明

### 环境变量

| 变量                          | 默认值         | 说明                      |
| ----------------------------- | -------------- | ------------------------- |
| `K3S_VERSION`                 | `v1.28.2+k3s1` | 要安装的 K3s 版本         |
| `K3S_DIND_VERSION`            | `0.2.0`        | 构建的镜像版本标签        |
| `PRELOAD_IMAGES`              | `true`         | 构建时预下载镜像          |
| `TZ`                          | `UTC`          | 容器时区                  |
| `K3S_API_PORT_OVERRIDE`       | `6443`         | Kubernetes API 服务器端口 |
| `DOCKER_TLS_PORT_OVERRIDE`    | `2376`         | Docker 守护进程 TLS 端口  |
| `K3S_TOKEN`                   | （空）         | 集群加入的共享密钥        |
| `K3S_DISABLE_SERVICES`        | `traefik`      | 要禁用的服务（逗号分隔）  |
| `K3S_DIND_CPU_LIMIT`          | `2.00`         | CPU 限制（核心数）        |
| `K3S_DIND_MEMORY_LIMIT`       | `4G`           | 内存限制                  |
| `K3S_DIND_CPU_RESERVATION`    | `0.50`         | CPU 预留（核心数）        |
| `K3S_DIND_MEMORY_RESERVATION` | `1G`           | 内存预留                  |

### 数据卷

- `k3s_data`：K3s 集群数据和状态
- `docker_data`：Docker 守护进程数据

## 使用示例

### 部署示例应用

```bash
# 创建部署
docker compose exec k3s k3s kubectl create deployment nginx --image=nginx

# 暴露为服务
docker compose exec k3s k3s kubectl expose deployment nginx --port=80 --type=NodePort

# 查看服务
docker compose exec k3s k3s kubectl get svc nginx
```

### 在 K3s 中运行 Docker 命令

```bash
# 进入容器
docker compose exec k3s sh

# 在容器内可以同时使用 docker 和 kubectl
docker ps
kubectl get pods -A
```

### 构建和部署自定义镜像

```bash
# 进入容器
docker compose exec k3s sh

# 在容器内构建镜像
docker build -t myapp:latest .

# 部署到 K3s（使用本地镜像）
kubectl create deployment myapp --image=myapp:latest
kubectl set image deployment/myapp myapp=myapp:latest --local -o yaml | kubectl apply -f -
```

## 安全注意事项

⚠️ **重要安全提示：**

- 此容器以**特权模式**运行，拥有广泛的系统访问权限
- 仅适用于开发和测试环境
- **请勿**在未经适当安全加固的情况下用于生产环境
- 容器内的 Docker 守护进程默认无需身份验证即可访问
- 所有容器共享主机的内核

### 生产环境建议

对于生产工作负载，请考虑：

- 在主机或虚拟机上原生运行 K3s
- 使用托管的 Kubernetes 服务（EKS、GKE、AKS）
- 实施适当的网络隔离
- 启用 RBAC 和 Pod 安全标准
- 使用加密通信通道

## 故障排除

### 容器启动失败

检查系统是否支持特权容器：

```bash
docker run --rm --privileged alpine sh -c "echo 'Privileged mode works'"
```

### K3s 服务器未就绪

等待更长时间让集群初始化（通常需要 60-90 秒）：

```bash
docker compose logs -f k3s
```

### kubectl 连接被拒绝

确保 kubeconfig 中的服务器地址指向 `localhost` 或正确的 IP：

```bash
kubectl cluster-info
```

## 高级配置

### 自定义 K3s 服务器参数

修改 `entrypoint.sh` 或传递环境变量来自定义 K3s 行为。

### 启用额外的 K3s 服务

默认情况下 Traefik 已禁用。要启用它：

```bash
# 在 .env 文件中
K3S_DISABLE_SERVICES=
```

### 更改 K3s 版本

在 `.env` 中更新 `K3S_VERSION` 并重新构建：

```bash
docker compose up -d --build
```

### 离线/隔离网络环境

默认情况下，在构建过程中会预先下载常用的容器镜像：

- K3s 系统镜像（pause、coredns、local-path-provisioner、metrics-server）
- 常用基础镜像（nginx、busybox、alpine）

这些镜像存储在 Docker 数据卷中，因此启动容器时无需访问互联网。

如需禁用预加载（如果网络良好可加快构建速度）：

```bash
# 在 .env 文件中
PRELOAD_IMAGES=false
```

如需添加更多预加载镜像，编辑 Dockerfile 并在预加载部分添加 `docker pull` 命令。

## 清理

删除集群和所有数据：

```bash
docker compose down -v
```

## 许可证

此配置按原样提供，遵循 Compose Anything 项目的相同许可证。

## 参考资料

- [K3s 文档](https://docs.k3s.io/)
- [Docker-in-Docker](https://hub.docker.com/_/docker)
- [Kubernetes 文档](https://kubernetes.io/docs/)
