# MicroSandbox

[English Documentation](README.md)

MicroSandbox 是由 Zerocore AI 开发的基于 KVM 的安全沙箱环境。它使用硬件级虚拟化技术提供隔离的轻量级虚拟机，用于安全地运行不受信任的代码。

## 特性

- **基于 KVM 的虚拟化**：利用硬件虚拟化实现强隔离
- **轻量级**：相比传统虚拟机开销更小
- **安全**：硬件级隔离保护宿主系统
- **快速启动**：虚拟机初始化快速，便于快速测试
- **多架构支持**：支持 x86_64（amd64）和 ARM64（aarch64）平台

## 前置要求

- 已安装 Docker 和 Docker Compose
- 硬件虚拟化支持（KVM）：
  - 在 BIOS 中启用 Intel VT-x 或 AMD-V
  - 宿主机上可用 `/dev/kvm` 设备
- Linux 宿主系统（KVM 是 Linux 特有的）
- 特权容器访问权限（KVM 需要）

### 检查 KVM 支持

在运行 MicroSandbox 之前，请验证您的系统支持 KVM：

```bash
# 检查 KVM 设备是否存在
ls -l /dev/kvm

# 检查 CPU 虚拟化支持
grep -E 'vmx|svm' /proc/cpuinfo
```

如果 `/dev/kvm` 不存在，请确保在 BIOS 中启用了虚拟化，并加载了 KVM 内核模块：

```bash
# 加载 KVM 模块（Intel）
sudo modprobe kvm_intel

# 或者 AMD
sudo modprobe kvm_amd
```

## 快速开始

1. 复制示例环境文件：

    ```bash
    cp .env.example .env
    ```

2. （可选）编辑 `.env` 以自定义资源限制：

    ```bash
    # 根据需要调整 CPU 和内存
    MICROSANDBOX_CPU_LIMIT=4.00
    MICROSANDBOX_MEMORY_LIMIT=4G
    ```

3. 构建 Docker 镜像：

    ```bash
    docker compose build
    ```

4. 运行 MicroSandbox：

    ```bash
    docker compose run --rm microsandbox
    ```

## 使用示例

### 交互式会话

启动 MicroSandbox 交互式会话：

```bash
docker compose run --rm microsandbox
```

### 在沙箱中运行命令

在沙箱内执行特定命令：

```bash
docker compose run --rm microsandbox run "echo Hello from sandbox"
```

### 获取帮助

查看可用命令和选项：

```bash
docker compose run --rm microsandbox --help
```

## 配置

### 环境变量

| 变量                              | 描述                          | 默认值      |
| --------------------------------- | ----------------------------- | ----------- |
| `MICROSANDBOX_VERSION`            | MicroSandbox 版本             | `latest`    |
| `DEBIAN_VERSION`                  | Debian 基础镜像版本           | `13.2-slim` |
| `MICROSANDBOX_AUTO_PULL_IMAGES`   | 构建时自动拉取基础镜像        | `true`      |
| `MICROSANDBOX_DEV_MODE`           | 启用开发模式（无需 API 密钥） | `true`      |
| `MICROSANDBOX_PORT`               | 容器内部端口                  | `5555`      |
| `MICROSANDBOX_PORT_OVERRIDE`      | 外部主机端口映射              | `5555`      |
| `TZ`                              | 容器时区                      | `UTC`       |
| `MICROSANDBOX_CPU_LIMIT`          | CPU 核心数上限                | `4`         |
| `MICROSANDBOX_CPU_RESERVATION`    | CPU 核心数预留                | `1`         |
| `MICROSANDBOX_MEMORY_LIMIT`       | 最大内存分配                  | `4G`        |
| `MICROSANDBOX_MEMORY_RESERVATION` | 内存预留                      | `1G`        |

### 卷挂载

- `microsandbox_namespaces`：MicroSandbox 命名空间配置和虚拟机状态
- `microsandbox_workspace`：沙箱操作的工作目录

## 安全注意事项

### 特权模式

MicroSandbox 需要 `privileged: true` 以访问 KVM 设备。这对于硬件虚拟化是必需的，但会授予容器提升的权限。请考虑以下事项:

- 仅在受信任的系统上运行 MicroSandbox
- 审查您计划在沙箱中执行的代码
- 保持 MicroSandbox 镜像更新以获取安全补丁
- 如果运行不受信任的代码，请使用网络隔离
- 在生产环境中，通过设置 `MICROSANDBOX_DEV_MODE=false` 禁用开发模式

**为什么需要特权模式？**

MicroSandbox 使用 KVM（基于内核的虚拟机）来提供硬件级隔离。与共享主机内核的 Docker 容器不同，MicroSandbox 创建具有自己内核的真实虚拟机。这提供了更强的安全边界，即使 Docker 容器本身以特权模式运行。

特权容器只是协调器——实际的不受信任代码在具有硬件强制边界的隔离虚拟机内运行。此架构专门设计用于安全地运行不受信任的代码。

### KVM 设备访问

容器需要访问 `/dev/kvm` 以进行硬件虚拟化。映射方式如下：

```yaml
devices:
  - /dev/kvm:/dev/kvm
```

确保宿主系统的 KVM 设备具有适当的权限。

## 架构支持

MicroSandbox 支持两种主要架构：

- **amd64**（x86_64）：Intel 和 AMD 处理器
- **arm64**（aarch64）：基于 ARM 的处理器（例如 AWS Graviton、通过 Linux VM 的 Apple Silicon）

在构建过程中会根据目标平台自动选择正确的二进制文件。

## 故障排除

### KVM 不可用

如果您看到关于 KVM 不可用的错误：

1. 验证在 BIOS 中启用了硬件虚拟化
2. 检查是否加载了 KVM 内核模块：`lsmod | grep kvm`
3. 确保 `/dev/kvm` 存在并具有正确的权限
4. 确认您在 Linux 宿主机上运行（而不是 WSL2 或 macOS）

### /dev/kvm 权限被拒绝

```bash
# 将您的用户添加到 kvm 组
sudo usermod -aG kvm $USER

# 或使用 sudo 运行
sudo docker compose run --rm microsandbox
```

### 性能问题

如果您遇到性能缓慢的问题：

- 在 `.env` 中增加 CPU 和内存限制
- 验证 KVM 加速是否正常工作：`dmesg | grep kvm`
- 检查宿主系统资源可用性

## 参考资料

- [MicroSandbox GitHub 仓库](https://github.com/zerocore-ai/microsandbox)
- [Zerocore AI](https://zerocore.ai/)
- [KVM 文档](https://www.linux-kvm.org/)

## 许可证

MicroSandbox 是 Zerocore AI 的开源项目。有关许可证信息，请参阅[上游仓库](https://github.com/zerocore-ai/microsandbox)。
