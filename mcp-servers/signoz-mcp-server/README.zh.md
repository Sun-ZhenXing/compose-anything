# SigNoz MCP Server

官方 SigNoz MCP Server 通过 HTTP 向模型上下文协议（MCP）客户端提供 SigNoz 可观测性数据和工具。

## 包含的服务

- `signoz-mcp-server`：官方无状态 HTTP MCP 服务器。默认 MCP 端点为 `http://localhost:8000/mcp`。

## 前置条件

- 一个容器可访问的现有 SigNoz 实例。
- 在 **Settings > API Keys** 中创建的 SigNoz API 密钥。

## 快速开始

```bash
cp .env.example .env
```

编辑 `.env`，将 `SIGNOZ_URL` 设置为不含 API 路径的 SigNoz 基础 URL，并设置 `SIGNOZ_API_KEY`。对于简单的单实例部署，建议同时配置这两项。它们默认为空，因此支持逐请求凭据的 HTTP 客户端也可以自行提供凭据。

```bash
docker compose up -d
```

将 MCP 客户端配置为使用：

```text
http://localhost:8000/mcp
```

## 主要环境变量

| 变量                                   | 默认值   | 说明                              |
| -------------------------------------- | -------- | --------------------------------- |
| `SIGNOZ_MCP_SERVER_VERSION`            | `v0.8.0` | 官方镜像版本                      |
| `SIGNOZ_MCP_SERVER_HOST_BIND`          | `127.0.0.1` | MCP HTTP 端点的主机监听地址     |
| `SIGNOZ_MCP_SERVER_PORT_OVERRIDE`      | `8000`   | MCP HTTP 端点的主机端口           |
| `SIGNOZ_URL`                           | 空       | 不含 API 路径的 SigNoz 基础 URL   |
| `SIGNOZ_API_KEY`                       | 空       | 具有查看者、编辑者或管理员权限的 API 密钥 |
| `LOG_LEVEL`                            | `info`   | 服务器日志级别                    |
| `SIGNOZ_MCP_SERVER_CPU_LIMIT`          | `1.0`    | CPU 上限                          |
| `SIGNOZ_MCP_SERVER_MEMORY_LIMIT`       | `512M`   | 内存上限                          |
| `SIGNOZ_MCP_SERVER_CPU_RESERVATION`    | `0.1`    | CPU 预留量                        |
| `SIGNOZ_MCP_SERVER_MEMORY_RESERVATION` | `128M`   | 内存预留量                        |
| `TZ`                                   | `UTC`    | 容器时区                          |

## 存储

该服务器是无状态服务，不使用命名卷。

## 健康监控

发布的 `v0.8.0` 镜像不包含 shell 或 HTTP 探测工具，因此容器内 Docker 健康检查无法调用其探测端点。请从外部监控 `http://localhost:8000/readyz`。

## 安全

发布的 `v0.8.0` 镜像默认以 root 用户运行，因此此栈强制使用 UID/GID `1001:1001`。此栈还采用只读文件系统、移除全部 Linux capabilities、启用 `no-new-privileges`，并仅提供临时 `/tmp`。MCP 端点未启用身份验证，因此默认只监听回环地址；仅应通过经过身份验证的反向代理公开。请保护 `.env` 中的 API 密钥、使用出站 HTTPS，并且不要使用 SigNoz ingestion key。

## 兼容性

部分工具需要较新的 SigNoz 版本。当前兼容性以及高级 OAuth 或多租户配置请参阅[上游 README](https://github.com/SigNoz/signoz-mcp-server#readme)。
