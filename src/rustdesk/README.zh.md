# RustDesk Server OSS

[English](./README.md) | [中文](./README.zh.md)

自托管开源 RustDesk ID／会合服务器（`hbbs`）和中继服务器（`hbbr`）。本配置使用官方固定版本的 s6 镜像，由同一容器监督两个守护进程，以保持部署精简。这是 OSS 服务器，不包含 Pro Web 控制台或账户／API 服务。

## 服务

| Compose 服务 | 守护进程 | 用途 |
| --- | --- | --- |
| `rustdesk` | `hbbs` 和 `hbbr` | ID／会合服务与中继服务，由同一容器监督 |

## 快速开始

```sh
cd src/rustdesk
docker compose up -d
docker compose ps
```

默认公告的中继地址（`127.0.0.1:21117`）仅适用于与 Docker 主机同机的客户端。远程使用前，请从 `.env.example` 创建 `.env`，并将 `RUSTDESK_RELAY_SERVER` 设置为客户端可访问的地址，例如 `rustdesk.example.com:21117`，然后启动服务。该值必须是一个不含空白字符的 `host:port`。

获取客户端配置所需的公钥：

```sh
docker compose exec rustdesk cat /data/id_ed25519.pub
```

在 RustDesk 客户端中，将 **ID Server** 设置为可访问的服务器地址（默认端口 `21116`），将 **Relay Server** 设置为 `RUSTDESK_RELAY_SERVER` 中相同的地址，并将 **Key** 设置为上述公钥。**API Server** 留空。

同机验证时，**ID Server** 使用 `127.0.0.1:21116`，**Relay Server** 使用 `127.0.0.1:21117`。

## 端口

| 宿主机端口 | 协议 | 用途 |
| --- | --- | --- |
| `21115` | TCP | NAT 测试 |
| `21116` | TCP 和 UDP | ID／会合服务 |
| `21117` | TCP | 中继服务 |

默认不发布 `21114`（Pro API）和 `21118`／`21119`（可选 Web 客户端／WebSocket 服务）。标准桌面客户端无需这些端口。如需启用可选 Web 访问，请添加明确的端口映射，并将服务置于可信任的反向代理之后。

## 环境变量

| 变量 | 描述 | 默认值 |
| --- | --- | --- |
| `RUSTDESK_VERSION` | 官方服务器镜像版本 | `1.1.16` |
| `TZ` | 容器时区 | `UTC` |
| `RUSTDESK_RELAY_SERVER` | 向客户端公告的中继地址（`host:port`） | `127.0.0.1:21117` |
| `RUSTDESK_NAT_PORT_OVERRIDE` | 发布的 NAT 测试 TCP 端口 | `21115` |
| `RUSTDESK_ID_PORT_OVERRIDE` | 发布的 ID／会合 TCP 和 UDP 端口 | `21116` |
| `RUSTDESK_RELAY_PORT_OVERRIDE` | 发布的中继 TCP 端口 | `21117` |
| `RUSTDESK_CPU_LIMIT`／`RUSTDESK_MEMORY_LIMIT` | 容器资源上限 | `1`／`256M` |
| `RUSTDESK_CPU_RESERVATION`／`RUSTDESK_MEMORY_RESERVATION` | 资源预留 | `0.1`／`64M` |

更改 ID 端口时，NAT 测试端口必须设置为 ID 端口减一；ID 端口的 TCP 和 UDP 映射必须相同。更改中继端口时，也要更新 `RUSTDESK_RELAY_SERVER` 和客户端配置。

## 存储

命名卷 `rustdesk_data` 持久化保存 `/data`，包括 `id_ed25519`、`id_ed25519.pub` 和 `db_v2.sqlite3`。请备份此卷；执行 `docker compose down -v` 删除卷会永久移除服务器身份和状态。

## 安全与网络

- 仅分发 `id_ed25519.pub`；妥善保管私钥 `id_ed25519`，并保护卷备份。
- 根据网络环境，在主机防火墙／路由器中开放并转发 TCP `21115`–`21117` 和 UDP `21116`。远程客户端必须能够实际访问服务器；默认的 localhost 中继地址无法从远程访问。
- 桥接网络具备较好的可移植性，但与 Linux 主机网络模式相比，可能影响点对点直连。中继在可访问时仍可使用；此配置不保证所有 NAT／防火墙环境下的客户端网络均可正常工作。
- `ENCRYPTED_ONLY=1` 向两个守护进程传入 `-k _`，启用服务器密钥匹配校验。客户端必须填写匹配的公钥，否则连接会被拒绝。
- 官方 s6 镜像以 root 初始化密钥文件所有权，并需要可写的运行时目录。本配置保留上游用户、权限和文件系统设置，不强制使用未经兼容性验证的非 root 或只读设置。服务启用 `no-new-privileges`，不需要特权模式或挂载宿主机套接字。
- 健康检查确认两个受监督的守护进程均报告运行中，但不验证公网可达性或点对点连接是否成功。

## 参考资料

- [RustDesk 服务器 Docker 文档](https://rustdesk.com/docs/en/self-host/rustdesk-server-oss/docker/)
- [RustDesk 客户端配置](https://rustdesk.com/docs/en/self-host/client-configuration/)
- [官方 s6 镜像 Dockerfile](https://github.com/rustdesk/rustdesk-server/blob/1.1.16/docker/Dockerfile)
