# FRPS

内网穿透服务端。

新建 `frps.toml` 配置文件，内容如下：

```toml
[common]
bind_port = {{ .Envs.FRP_SERVER_PORT }}
token     = {{ .Envs.FRP_SERVER_TOKEN }}

dashboard_addr = 0.0.0.0
dashboard_port = {{ .Envs.FRP_ADMIN_PORT }}
dashboard_user = {{ .Envs.FRP_ADMIN_USER }}
dashboard_pwd  = {{ .Envs.FRP_ADMIN_PASS }}
```

配置密钥等信息到 `.env` 文件中：

```properties
FRP_SERVER_TOKEN=token
FRP_ADMIN_USER=admin
FRP_ADMIN_PASS=password
```

启动服务，即可代理客户端请求，注意需要将客户端的端口映射出来。可以通过 HOST 网络或共享网络的方式共享服务。

使用如下方法启用 HOST 模式：

```yaml
services:
  frps:
    # ...
    network_mode: host
```
