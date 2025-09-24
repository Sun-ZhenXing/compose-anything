# FRPC

内网穿透客户端。

以 SSH 服务穿透为例，新建 `frpc.toml` 配置文件，内容如下：

```toml
[common]
server_addr = {{ .Envs.FRP_SERVER_ADDR }}
server_port = {{ .Envs.FRP_SERVER_PORT }}
token       = {{ .Envs.FRP_SERVER_TOKEN }}

[app_22]
type = "tcp"
remote_port = 23922
local_ip    = 192.168.10.100
local_port  = 22
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
