# Agentgateway

[English](./README.md) | [中文](./README.zh.md)

Agentgateway 是一个面向智能体 AI 连接的开源数据平面。本 Compose 配置运行官方 Docker 镜像，并使用本地配置文件。

## 服务

- `agentgateway`：Agentgateway 数据平面（端口 3000 与 15000）

## 快速开始

```bash
docker compose up -d
```

Agentgateway 监听端口 3000。管理界面可通过 <http://localhost:15000/ui> 访问。

## 配置说明

默认配置文件为 [config.yaml](./config.yaml)。该文件基于官方 Quickstart 示例，并通过 `npx` 启动 MCP 测试服务器 `@modelcontextprotocol/server-everything`。

如需使用其他后端，请修改 `config.yaml` 并重启服务。

## 环境变量

| 变量名                             | 说明                           | 默认值          |
| ---------------------------------- | ------------------------------ | --------------- |
| `GLOBAL_REGISTRY`                  | 全局镜像仓库前缀               | `""`            |
| `AGENTGATEWAY_VERSION`             | Agentgateway 镜像版本          | `0.11.2`        |
| `AGENTGATEWAY_PORT_OVERRIDE`       | 数据平面端口映射（容器 3000）  | `3000`          |
| `AGENTGATEWAY_ADMIN_PORT_OVERRIDE` | 管理界面端口映射（容器 15000） | `15000`         |
| `AGENTGATEWAY_ADMIN_ADDR`          | 容器内管理界面绑定地址         | `0.0.0.0:15000` |
| `TZ`                               | 时区                           | `UTC`           |
| `AGENTGATEWAY_CPU_LIMIT`           | CPU 限制                       | `0.50`          |
| `AGENTGATEWAY_CPU_RESERVATION`     | CPU 预留                       | `0.25`          |
| `AGENTGATEWAY_MEMORY_LIMIT`        | 内存限制                       | `256M`          |
| `AGENTGATEWAY_MEMORY_RESERVATION`  | 内存预留                       | `128M`          |

## 端口

- `3000`：数据平面监听
- `15000`：管理界面

## 安全说明

- 默认仅在宿主机本地暴露管理界面。如需远程访问，请调整端口映射。
- 在生产环境中，请根据实际需求收紧 CORS 与后端配置。

## 许可证

Agentgateway 采用 Apache 2.0 许可证，详情请参考上游项目。
