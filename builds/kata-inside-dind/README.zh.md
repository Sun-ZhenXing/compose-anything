# Kata 容器在 Docker-in-Docker 中运行

[English Documentation](README.md)

一个基于虚拟机的容器运行时（Kata Containers 与 Firecracker VMM）在 Docker-in-Docker（DinD）容器内运行。此设置提供轻量级虚拟机，具有强安全隔离的同时保持容器的性能和简洁性。Kata Containers 支持多种虚拟机管理器（QEMU、Firecracker、Cloud Hypervisor），此镜像默认包含 Firecracker 以获得最佳性能。

## 特性

- ✅ 使用官方安装脚本的完整 Kata Containers 运行时
- ✅ Firecracker VMM 提供轻量级 VM 隔离
- ✅ QEMU 回退支持
- ✅ Docker-in-Docker 支持容器管理
- ✅ 基于 VM 的容器隔离和硬件安全性
- ✅ 资源限制防止系统资源耗尽
- ✅ 运行时就绪性的健康检查
- ✅ Kata 和 Docker 数据的持久化存储
- ✅ 可配置的日志级别
- ✅ 通过 RuntimeClass 与 Kubernetes 兼容

## 前置条件

**关键要求：**

- Docker Engine 20.10+
- Docker Compose 2.0+
- **宿主机必须支持嵌套虚拟化（KVM）**
- 宿主机上 `/dev/kvm` 设备可用
- 宿主机上 `/lib/modules` 可用（用于内核模块验证）
- 至少 2 个 CPU 核心和 4GB RAM
- 需要特权容器支持

### 验证宿主机前置条件

```bash
# 检查 KVM 是否可用
ls -l /dev/kvm

# 对于 Intel CPU，验证嵌套虚拟化是否启用
cat /sys/module/kvm_intel/parameters/nested
# 应该输出 'Y' 或 '1'。如果不是：
# sudo modprobe -r kvm_intel
# sudo modprobe kvm_intel nested=1
```

## 快速开始

1. 复制环境文件：

   ```bash
   cp .env.example .env
   ```

2. （可选）在 `.env` 中自定义配置

3. 构建并启动服务：

   ```bash
   docker compose up -d --build
   ```

4. 等待 Kata 运行时就绪：

   ```bash
   docker compose logs -f kata-dind
   ```

5. 访问容器内的 Docker 守护进程：

   ```bash
   # 获取容器 ID
   docker compose ps

   # 在容器内执行命令
   docker compose exec kata-dind docker ps

   # 使用 Firecracker 运行时运行容器
   docker compose exec kata-dind docker run --rm --runtime=kata-fc debian:bookworm uname -a

   # 或使用 QEMU（回退方案）
   docker compose exec kata-dind docker run --rm --runtime=kata debian:bookworm uname -a
   ```

## 配置

### 环境变量

| 变量                           | 默认值      | 说明                                      |
| ------------------------------ | ----------- | ----------------------------------------- |
| `DEBIAN_VERSION`               | `13.2-slim` | 基础 Debian 版本                          |
| `KATA_VERSION`                 | `3.24.0`    | Kata Containers 版本                      |
| `FIRECRACKER_VERSION`          | `1.10.1`    | 要安装的 Firecracker VMM 版本             |
| `KATA_DIND_VERSION`            | `0.2.0`     | 构建的镜像版本标签                        |
| `TZ`                           | `UTC`       | 容器的时区                                |
| `KATA_LOGGING_LEVEL`           | `info`      | Kata 日志级别（debug、info、warn、error） |
| `KATA_DIND_CPU_LIMIT`          | `2.00`      | CPU 限制（核心数）                        |
| `KATA_DIND_MEMORY_LIMIT`       | `4G`        | 内存限制                                  |
| `KATA_DIND_CPU_RESERVATION`    | `0.50`      | CPU 预留（核心数）                        |
| `KATA_DIND_MEMORY_RESERVATION` | `1G`        | 内存预留                                  |

## 使用示例

### 运行安全容器

```bash
docker compose exec kata-dind docker run -it --rm --runtime=kata-fc alpine sh
```

### 检查运行时信息

```bash
docker compose exec kata-dind docker info | grep -i runtime
```
