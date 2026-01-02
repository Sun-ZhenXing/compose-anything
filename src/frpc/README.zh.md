# FRPC（FRP 客户端）

[English](./README.md) | [中文](./README.zh.md)

FRPC 是一个快速反向代理客户端，连接到 FRP 服务器以将本地服务暴露到互联网。这是 FRP（Fast Reverse Proxy）工具的客户端组件。

## 快速开始

1. 从 `.env.example` 创建 `.env` 文件：

    ```bash
    cp .env.example .env
    ```

2. 编辑 `.env` 文件并配置 FRP 服务器连接：

    ```properties
    FRP_SERVER_ADDR=your.frp.server.com
    FRP_SERVER_PORT=7000
    FRP_SERVER_TOKEN=your_server_token
    ```

3. 创建包含代理规则的 `frpc.toml` 配置文件（参见下面的示例）。

4. 启动服务：

    ```bash
    docker compose up -d
    ```

## 配置文件

客户端需要一个 `frpc.toml` 文件来定义代理规则。以下是一些常见示例：

### 示例 1：SSH 服务代理

将本地 SSH 服务暴露到互联网：

```toml
serverAddr = "{{ .Envs.FRP_SERVER_ADDR }}"
serverPort = {{ .Envs.FRP_SERVER_PORT }}
auth.token = "{{ .Envs.FRP_SERVER_TOKEN }}"

[[proxies]]
name = "ssh"
type = "tcp"
remotePort = 6000
localIP = "{{ .Envs.FRP_APP_HOST }}"
localPort = 22
```

此配置将：

- 连接到 `FRP_SERVER_ADDR:FRP_SERVER_PORT` 的 FRP 服务器
- 通过服务器的 6000 端口暴露本地 SSH（22 端口）
- 通过 `FRP_SERVER_ADDR:6000` 访问服务

### 示例 2：Web 服务代理

暴露本地 Web 应用程序：

```toml
serverAddr = "{{ .Envs.FRP_SERVER_ADDR }}"
serverPort = {{ .Envs.FRP_SERVER_PORT }}
auth.token = "{{ .Envs.FRP_SERVER_TOKEN }}"

[[proxies]]
name = "web"
type = "http"
customDomains = ["your-domain.com"]
localIP = "{{ .Envs.FRP_APP_HOST }}"
localPort = 8080
```

### 示例 3：多个服务

同时代理多个服务：

```toml
serverAddr = "{{ .Envs.FRP_SERVER_ADDR }}"
serverPort = {{ .Envs.FRP_SERVER_PORT }}
auth.token = "{{ .Envs.FRP_SERVER_TOKEN }}"

[[proxies]]
name = "ssh"
type = "tcp"
remotePort = 6000
localIP = "192.168.1.100"
localPort = 22

[[proxies]]
name = "web"
type = "tcp"
remotePort = 8080
localIP = "192.168.1.101"
localPort = 80
```

### 示例 4：管理面板

启用管理面板以监控客户端：

```toml
serverAddr = "{{ .Envs.FRP_SERVER_ADDR }}"
serverPort = {{ .Envs.FRP_SERVER_PORT }}
auth.token = "{{ .Envs.FRP_SERVER_TOKEN }}"

webServer.addr = "{{ .Envs.FRP_ADMIN_ADDR }}"
webServer.port = {{ .Envs.FRP_ADMIN_PORT }}
webServer.user = "{{ .Envs.FRP_ADMIN_USER }}"
webServer.password = "{{ .Envs.FRP_ADMIN_PASSWORD }}"

[[proxies]]
name = "app"
type = "tcp"
remotePort = 9000
localIP = "{{ .Envs.FRP_APP_HOST }}"
localPort = 3000
```

在 `http://localhost:7400`（默认）访问管理面板。

## 环境变量

### 镜像配置

- `GLOBAL_REGISTRY`：可选的全局镜像仓库前缀
- `FRPC_VERSION`：FRPC 镜像版本（默认：`0.65.0`）
- `TZ`：时区设置（默认：`UTC`）

### 服务器连接

- `FRP_SERVER_ADDR`：FRP 服务器地址（**必需**，例如 `frp.example.com` 或 `192.168.1.1`）
- `FRP_SERVER_PORT`：FRP 服务器端口（默认：`7000`）
- `FRP_SERVER_TOKEN`：连接到服务器的认证令牌（**必须与服务器令牌匹配**）

### 本地应用

- `FRP_APP_HOST`：本地应用主机地址（默认：`127.0.0.1`）
  - 使用 `host.docker.internal` 访问运行在主机上的服务
  - 使用特定 IP 地址访问本地网络上的服务

### 管理面板（可选）

- `FRP_ADMIN_ADDR`：管理面板绑定地址（默认：`0.0.0.0`）
- `FRP_ADMIN_PORT`：管理面板端口（默认：`7400`）
- `FRP_ADMIN_USER`：管理面板用户名（默认：`admin`）
- `FRP_ADMIN_PASSWORD`：管理面板密码（默认：`password`）

### 资源限制

- `FRPC_CPU_LIMIT`：CPU 限制（默认：`0.5`）
- `FRPC_MEMORY_LIMIT`：内存限制（默认：`128M`）
- `FRPC_CPU_RESERVATION`：CPU 预留（默认：`0.1`）
- `FRPC_MEMORY_RESERVATION`：内存预留（默认：`64M`）

## 卷

- `./frpc.toml:/etc/frp/frpc.toml`：FRPC 配置文件

## 访问主机服务

要从容器内访问运行在主机上的服务，请使用 `host.docker.internal`：

```properties
FRP_APP_HOST=host.docker.internal
```

然后在 `frpc.toml` 中：

```toml
[[proxies]]
name = "local-service"
type = "tcp"
remotePort = 8080
localIP = "{{ .Envs.FRP_APP_HOST }}"
localPort = 3000
```

这将通过 FRP 服务器的 8080 端口暴露主机的 3000 端口。

## 安全注意事项

1. **保护令牌安全**：保持 `FRP_SERVER_TOKEN` 机密并使用强随机值
2. **限制暴露**：只暴露实际需要的服务
3. **使用加密**：对于敏感服务考虑使用 HTTPS/TLS
4. **监控访问**：启用管理面板以监控活动连接

## 故障排除

### 无法连接到 FRP 服务器

- 验证 `FRP_SERVER_ADDR` 和 `FRP_SERVER_PORT` 是否正确
- 确保 FRP 服务器正在运行且可访问
- 检查 `FRP_SERVER_TOKEN` 是否与服务器配置匹配

### 无法访问本地服务

- 验证 `FRP_APP_HOST` 是否正确
- 对于主机服务，确保使用 `host.docker.internal`
- 对于网络服务，确保 IP 地址和端口正确
- 检查客户端和服务器端的防火墙规则

## 许可证

FRP 采用 Apache License 2.0 许可证。详情请参阅 [FRP GitHub 仓库](https://github.com/fatedier/frp)。
