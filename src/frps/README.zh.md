# FRPS（FRP 服务端）

[English](./README.md) | [中文](./README.zh.md)

FRPS 是一个快速反向代理服务器，可以帮助将 NAT 和防火墙后面的本地服务器暴露到互联网。这是 FRP（Fast Reverse Proxy）工具的服务端组件。

## 快速开始

1. 从 `.env.example` 创建 `.env` 文件：

    ```bash
    cp .env.example .env
    ```

2. 编辑 `.env` 文件并配置认证凭据：

    ```properties
    FRP_SERVER_TOKEN=your_secure_token_here
    FRP_ADMIN_USER=your_admin_username
    FRP_ADMIN_PASSWORD=your_secure_password
    ```

3. 创建 `frps.toml` 配置文件或使用提供的模板。

4. 启动服务：

    ```bash
    docker compose up -d
    ```

服务将在以下位置可访问：

- FRP 服务端口：`7000`（默认）
- 管理面板：`http://localhost:7500`（默认）

## 配置文件

示例 `frps.toml`：

```toml
bindPort = {{ .Envs.FRP_SERVER_PORT }}

auth.method = "{{ .Envs.FRP_AUTH_METHOD }}"
auth.token = "{{ .Envs.FRP_SERVER_TOKEN }}"

webServer.addr = "{{ .Envs.FRP_ADMIN_ADDR }}"
webServer.port = {{ .Envs.FRP_ADMIN_PORT }}
webServer.user = "{{ .Envs.FRP_ADMIN_USER }}"
webServer.password = "{{ .Envs.FRP_ADMIN_PASSWORD }}"
```

## 网络模式

### 标准模式（默认）

使用 `docker-compose.yaml` 中配置的端口映射。

### Host 网络模式

为了获得更好的性能和访问所有端口，可以使用 host 网络模式：

```yaml
services:
  frps:
    # ...
    network_mode: host
```

**注意**：使用 host 网络模式时，`ports` 部分将被忽略，服务直接使用主机端口。

## 环境变量

### 镜像配置

- `GLOBAL_REGISTRY`：可选的全局镜像仓库前缀
- `FRPS_VERSION`：FRPS 镜像版本（默认：`0.65.0`）
- `TZ`：时区设置（默认：`UTC`）

### 服务器配置

- `FRP_AUTH_METHOD`：认证方法（默认：`token`）
- `FRP_SERVER_TOKEN`：客户端认证令牌（**请修改以确保安全**）
- `FRP_SERVER_PORT`：FRP 服务端口（默认：`7000`）

### 管理面板

- `FRP_ADMIN_ADDR`：管理面板绑定地址（默认：`0.0.0.0`）
- `FRP_ADMIN_PORT`：管理面板端口（默认：`7500`）
- `FRP_ADMIN_USER`：管理面板用户名（默认：`admin`）
- `FRP_ADMIN_PASSWORD`：管理面板密码（**请修改以确保安全**）

### 端口覆盖

- `FRP_PORT_OVERRIDE_SERVER`：映射到 FRP 服务端口的主机端口（默认：`7000`）
- `FRP_PORT_OVERRIDE_ADMIN`：映射到管理面板的主机端口（默认：`7500`）

### 资源限制

- `FRPS_CPU_LIMIT`：CPU 限制（默认：`0.5`）
- `FRPS_MEMORY_LIMIT`：内存限制（默认：`128M`）
- `FRPS_CPU_RESERVATION`：CPU 预留（默认：`0.1`）
- `FRPS_MEMORY_RESERVATION`：内存预留（默认：`64M`）

## 卷

- `./frps.toml:/etc/frp/frps.toml`：FRPS 配置文件

## 安全注意事项

1. **修改默认凭据**：务必修改 `FRP_SERVER_TOKEN`、`FRP_ADMIN_USER` 和 `FRP_ADMIN_PASSWORD` 的默认值
2. **使用强密码**：使用复杂的随机生成的密码和令牌
3. **防火墙规则**：考虑将管理面板的访问限制在受信任的 IP 地址
4. **TLS/SSL**：在生产环境中，考虑在 FRP 配置中设置 TLS 加密

## 健康检查

服务包含一个健康检查，用于验证管理面板是否可访问。健康检查：

- 每 30 秒运行一次
- 超时时间为 10 秒
- 最多重试 3 次
- 启动后等待 10 秒再进行第一次检查

## 许可证

FRP 采用 Apache License 2.0 许可证。详情请参阅 [FRP GitHub 仓库](https://github.com/fatedier/frp)。
