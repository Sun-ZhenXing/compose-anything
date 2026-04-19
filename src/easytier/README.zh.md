# EasyTier

[English](./README.md) | [中文](./README.zh.md)

[EasyTier](https://github.com/EasyTier/EasyTier) 是一款网状 VPN 组网工具，可在 NAT 或防火墙后面的主机之间构建私有加密覆盖网络。本配置将 EasyTier 部署为**公共中继服务器**——作为稳定的入口节点，供各客户端节点在无法直连时进行发现和流量中转。

## 服务

- `easytier`：以中继模式（`--no-tun`）运行的 EasyTier 核心节点，不创建本地 TUN 网络接口。

## 端口

| 端口    | 协议 | 说明                                              |
| ------- | ---- | ------------------------------------------------- |
| `11010` | TCP  | 节点连接监听端口——需公网可达                      |
| `11010` | UDP  | 节点连接监听端口——需公网可达                      |
| `15888` | TCP  | 管理 RPC 端口（默认仅绑定 `127.0.0.1`）           |

## 环境变量

| 变量名                       | 描述                              | 默认值         |
| ---------------------------- | --------------------------------- | -------------- |
| `EASYTIER_VERSION`           | EasyTier 镜像版本                 | `v2.6.0`       |
| `TZ`                         | 时区                              | `UTC`          |
| `EASYTIER_NETWORK_NAME`      | 所有节点共享的虚拟网络名称        | `easytier`     |
| `EASYTIER_NETWORK_SECRET`    | 网络密钥（密码），**必须设置**    | `""`           |
| `EASYTIER_IPV4`              | 本服务器节点在虚拟网络中的 IPv4  | `10.144.144.1` |
| `EASYTIER_TCP_PORT_OVERRIDE` | 节点 TCP 监听端口（宿主机映射）   | `11010`        |
| `EASYTIER_UDP_PORT_OVERRIDE` | 节点 UDP 监听端口（宿主机映射）   | `11010`        |
| `EASYTIER_RPC_PORT_OVERRIDE` | 管理 RPC 端口（仅本机可访问）     | `15888`        |
| `EASYTIER_CPU_LIMIT`         | CPU 上限                          | `0.50`         |
| `EASYTIER_MEMORY_LIMIT`      | 内存上限                          | `128M`         |

## 快速开始

1. 复制 `.env.example` 并设置强网络密钥：

   ```bash
   cp .env.example .env
   ```

   编辑 `.env`：

   ```env
   EASYTIER_NETWORK_NAME=myvpn
   EASYTIER_NETWORK_SECRET=<你的强密钥>
   ```

   生成随机密钥：`openssl rand -hex 16`

2. 启动服务：

   ```bash
   docker compose up -d
   ```

3. 验证节点状态：

   ```bash
   docker compose exec easytier easytier-cli -p 127.0.0.1:15888 node info
   ```

4. 在各客户端机器上连接到此服务器：

   ```bash
   easytier-core \
     --network-name myvpn \
     --network-secret <你的强密钥> \
     --peers tcp://<服务器公网 IP>:11010 \
     --ipv4 10.144.144.2
   ```

## 数据卷

本配置不使用持久化卷，所有配置均通过环境变量转换为命令行参数传入。

## 安全说明

- **`EASYTIER_NETWORK_SECRET` 为必填项。** 若密钥为空，任何知道网络名称的节点均可接入，请务必在公网暴露前设置强密钥。
- 管理 RPC 端口（`15888`）默认仅绑定 `127.0.0.1`，请勿在无额外认证保护的情况下对外暴露。
- 防火墙及云安全组需放行 `11010/tcp` 和 `11010/udp`，客户端节点才能连接到本服务器。
- 本配置以 `--no-tun` 中继模式运行，无需创建 TUN 设备，因此无需提升内核权限（`NET_ADMIN`），已应用 `cap_drop: ALL`。
- 如需服务器节点同时作为 VPN 网络中的普通成员（拥有本地虚拟网卡），请移除 `command` 中的 `--no-tun` 参数，并在服务中添加 `cap_add: [NET_ADMIN]`。

## 文档

- [EasyTier GitHub](https://github.com/EasyTier/EasyTier)
- [EasyTier 官方文档](https://www.easytier.top/guide/introduction.html)
