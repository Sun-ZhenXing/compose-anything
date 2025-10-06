# Dockge

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署 Dockge，一个精美、易用且响应式的自托管 Docker Compose 堆栈管理器。

## 服务

- `dockge`: Dockge Web 界面，用于管理 Docker Compose 堆栈。

## 环境变量

| 变量名            | 说明                 | 默认值        |
| ----------------- | -------------------- | ------------- |
| DOCKGE_VERSION    | Dockge 镜像版本      | `1`           |
| PORT_OVERRIDE     | 主机端口映射         | `5001`        |
| STACKS_DIR        | 主机上存储堆栈的目录 | `./stacks`    |
| DOCKGE_STACKS_DIR | 容器内堆栈目录       | `/opt/stacks` |
| PUID              | 运行服务的用户 ID    | `1000`        |
| PGID              | 运行服务的组 ID      | `1000`        |

请根据实际需求修改 `.env` 文件。

## 卷

- `dockge_data`: 用于存储 Dockge 应用程序数据的卷。
- Docker socket: 挂载以允许 Dockge 管理 Docker 容器。
- Stacks 目录: 存储 docker-compose.yaml 文件的位置。

## 功能

- 🧑‍💼 管理你的 `compose.yaml` 文件
- ⌨️ `compose.yaml` 交互式编辑器
- 🦦 交互式 Web 终端
- 🏪 将 `docker run ...` 命令转换为 `compose.yaml`
- 📙 基于文件的结构 - 不会劫持你的 compose 文件
- 🚄 响应式 - 一切都是实时响应的

## 安全说明

- Dockge 需要访问 Docker socket，这将授予它对 Docker 的完全控制权。
- 仅在受信任的网络上运行 Dockge。
- 如果暴露到互联网，请考虑使用身份验证。
- 默认设置将数据存储在命名卷中以保持持久性。

## 首次运行

首次运行时，系统会提示你创建管理员帐户。请确保使用强密码。

## 许可证

Dockge 使用 MIT 许可证授权。
