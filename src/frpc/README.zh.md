# FRPC (内网穿透客户端)

[English](./README.md) | [中文](./README.zh.md)

这是一个 FRPC（内网穿透客户端）服务。

## 示例

以 SSH 服务穿透为例，新建 `frpc.toml` 配置文件，内容如下：

```toml
serverAddr = "{{ .Envs.FRP_SERVER_ADDR }}"
serverPort = {{ .Envs.FRP_SERVER_PORT }}
auth.token = "{{ .Envs.FRP_SERVER_TOKEN }}"

[[proxies]]
name = "app_22"
type = "tcp"
remotePort = 23922
localIP = "192.168.10.100"
localPort = 22
```

配置远程 FRPS 服务地址到 `.env` 文件中：

```properties
FRP_SERVER_ADDR=frps.example.com
FRP_SERVER_PORT=9870
FRP_SERVER_TOKEN=password
```

启动服务，即可代理 `192.168.10.100:22` 到 `FRP_SERVER_ADDR:23922`。

```bash
docker compose up -d
```

## 服务

- `frpc`: FRPC 客户端服务。

## 配置

- `FRPC_VERSION`: FRPC 镜像的版本，默认为 `0.64.0`。
- `FRP_SERVER_ADDR`: 远程 FRPS 服务器地址。
- `FRP_SERVER_PORT`: 远程 FRPS 服务器端口。
- `FRP_SERVER_TOKEN`: 用于连接 FRPS 的令牌。

## 卷

- `frpc.toml`: FRPC 的配置文件。
