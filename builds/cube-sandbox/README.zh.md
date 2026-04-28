# CubeSandbox

在单个特权 Docker 容器内完整运行 [腾讯云 CubeSandbox](https://github.com/TencentCloud/CubeSandbox)——一个基于 KVM、兼容 E2B SDK 的 MicroVM 沙箱——无需修改宿主系统。

## 为什么这个栈与众不同

CubeSandbox 上游**并不是**一个容器化项目。它的核心组件（Cubelet、network-agent、cube-shim、cube-runtime、CubeAPI、CubeMaster）以宿主机二进制形式分发，官方 `install.sh` 会把它们写入 `/usr/local/services/cubetoolbox`，然后作为本机进程启动并与宿主 containerd 集成。

本栈把**整个安装器塞进一个特权容器**：

1. 容器内自起一个 `dockerd`（Docker-in-Docker），用于运行 MySQL / Redis / CubeProxy / CoreDNS 等依赖。
2. 在 `/data/cubelet` 创建一个 XFS 格式的 loop 卷（install.sh 强制要求 XFS）。
3. 首次启动时执行上游的 [`online-install.sh`](https://github.com/TencentCloud/CubeSandbox/blob/master/deploy/one-click/online-install.sh)。
4. 通过 tail 日志保持容器存活。

最终得到一个**单节点 CubeSandbox 一体化容器**，方便在不改动宿主的前提下评估 CubeSandbox。

## 特性

- 基于 Ubuntu 22.04（项目主要测试环境）
- 自包含：不安装宿主机软件包，不挂载宿主路径
- 通过 `/dev/kvm` 透传 KVM
- 三个持久化命名卷分别保存安装产物、沙箱数据和 DinD 存储
- 健康检查覆盖 CubeAPI、CubeMaster、network-agent
- 默认使用国内镜像 (`MIRROR=cn`)
- 内置冒烟测试脚本（`smoke-test.sh`）

## 环境要求

- Linux 宿主（或开启 KVM 透传的 WSL2），`/dev/kvm` 对 Docker 可见
- 已开启嵌套虚拟化（暴露 Intel VT-x / AMD-V）
- cgroup v2（现代内核——Debian 12+、Ubuntu 22.04+、kernel 5.10+）
- 推荐 ≥ 16 GiB 内存、≥ 8 vCPU（上游最低 8 GiB）
- 至少 60 GiB 空闲磁盘，用于 XFS loop 文件 + Docker 镜像层
- 可访问外网，用于下载安装包（数百 MB）和 Docker 镜像

> WSL2 用户：先确认 `/dev/kvm` 存在（`ls -l /dev/kvm`），并且当前用户在宿主发行版的 `kvm` 组中。

## 快速开始

1. 复制示例环境文件（可选，默认值即可使用）：

   ```bash
   cp .env.example .env
   ```

2. 构建并启动（首次运行会下载 CubeSandbox 安装包和若干 Docker 镜像，预计 5-20 分钟）：

   ```bash
   docker compose up -d --build
   ```

3. 观察启动日志：

   ```bash
   docker compose logs -f cube-sandbox
   ```

   等待出现 `==================== CubeSandbox is up ====================` 横幅。

4. 验证所有服务健康：

   ```bash
   curl -fsS http://127.0.0.1:3000/health        && echo  # CubeAPI
   curl -fsS http://127.0.0.1:8089/notify/health && echo  # CubeMaster
   curl -fsS http://127.0.0.1:19090/healthz      && echo  # network-agent
   ```

5. （可选）运行冒烟测试：

   ```bash
   bash smoke-test.sh                            # 仅做健康检查
   SKIP_TEMPLATE_BUILD=1 bash smoke-test.sh      # 跳过较慢的模板构建步骤
   ```

## 服务端点

由于容器使用 `network_mode: host`，CubeSandbox 的所有 HTTP 端点都直接暴露在宿主回环地址上：

| 服务          | URL                                  |
| ------------- | ------------------------------------ |
| CubeAPI       | `http://127.0.0.1:3000`              |
| CubeMaster    | `http://127.0.0.1:8089`              |
| network-agent | `http://127.0.0.1:19090`             |

CubeAPI 暴露兼容 E2B 的 REST 接口；将 [`e2b` Python SDK](https://e2b.dev) 指向 `http://127.0.0.1:3000` 即可创建沙箱。

## 配置项

主要环境变量（完整列表见 `.env.example`）：

| 变量                       | 描述                                                | 默认值          |
| -------------------------- | --------------------------------------------------- | --------------- |
| `GLOBAL_REGISTRY`          | 推送到私有仓库时使用的镜像前缀                      | _（空）_        |
| `CUBE_SANDBOX_VERSION`     | 本地构建的封装镜像 tag                              | `0.1.7`         |
| `UBUNTU_IMAGE`             | 基础 Ubuntu 版本                                    | `22.04`         |
| `TZ`                       | 容器时区                                            | `Asia/Shanghai` |
| `CUBE_MIRROR`              | 安装器镜像源——`cn`（国内 CDN）或 `gh`（GitHub）     | `cn`            |
| `CUBE_XFS_SIZE`            | `/data/cubelet` 背后 XFS loop 文件大小              | `50G`           |
| `CUBE_FORCE_REINSTALL`     | 设为 `1` 时下次启动会重跑 `install.sh`              | `0`             |
| `CUBE_CPU_LIMIT`           | CPU 上限                                            | `8`             |
| `CUBE_MEMORY_LIMIT`        | 内存上限                                            | `16G`           |
| `CUBE_CPU_RESERVATION`     | CPU 预留                                            | `2`             |
| `CUBE_MEMORY_RESERVATION`  | 内存预留                                            | `8G`            |

## 存储

三个命名卷保存所有持久化状态——`docker compose down && up` 不会丢失安装：

| 卷               | 容器内路径                          | 用途                                                |
| ---------------- | ----------------------------------- | --------------------------------------------------- |
| `cube_dind_data` | `/var/lib/docker`                   | DinD 守护进程的镜像 / 容器 / 卷                     |
| `cube_data`      | `/data`                             | XFS loop 文件、`/data/cubelet`、沙箱磁盘、日志       |
| `cube_toolbox`   | `/usr/local/services/cubetoolbox`   | 已安装的 CubeSandbox 二进制和脚本                   |

完全清空并从头重装：

```bash
docker compose down -v
docker compose up -d --build
```

## 安全说明

⚠️ 本栈**按设计是高特权的**，仅在受信环境中使用。

- `privileged: true`——挂载 XFS loop 卷、管理 TAP 接口、运行 KVM 所必需
- `network_mode: host`——Cubelet 注册节点 IP、管理宿主 TAP 接口所必需
- `cgroup: host`——容器内的 `dockerd` 共享宿主 cgroup v2 层级所必需
- 透传 `/dev/kvm` 和 `/dev/net/tun`

这些权限等同于直接在宿主上运行 `online-install.sh` 所需的权限。容器封装的好处在于：所有安装副作用都被限制在上述三个命名卷内，删除本栈不会在宿主上留下任何残留。

## 故障排查

- **`/dev/kvm not found`**：宿主未对 Docker 暴露 KVM。WSL2 用户请确认嵌套虚拟化已启用且内核暴露 `/dev/kvm`；裸金属用户请在 BIOS 中启用 VT-x / AMD-V。
- **首次启动卡在 "Running CubeSandbox one-click installer"**：安装器正在下载安装包（数百 MB）并拉取若干 Docker 镜像。用 `docker compose logs -f cube-sandbox` 查看进度。
- **`quickcheck.sh reported issues`**：进入容器查看日志：

  ```bash
  docker compose exec cube-sandbox bash
  ls /data/log/
  tail -f /data/log/CubeAPI/*.log
  ```

- **干净重跑安装**：在 `.env` 中设置 `CUBE_FORCE_REINSTALL=1`，然后 `docker compose up -d --force-recreate`。

## 项目信息

- 上游项目：https://github.com/TencentCloud/CubeSandbox
- 许可证：上游项目采用 Apache-2.0；本配置以 as-is 形式提供给 Compose Anything 项目使用。
