# Docker MCP 服务器

Docker MCP 服务器通过 Model Context Protocol 提供 Docker 容器管理功能。

## 功能特性

- 🐳 **容器管理** - 管理 Docker 容器
- 📦 **镜像管理** - 管理 Docker 镜像
- 🔍 **容器检查** - 检查容器详情
- 📊 **容器统计** - 获取容器统计信息

## 环境变量

| 变量                       | 默认值                        | 说明                |
| -------------------------- | ----------------------------- | ------------------- |
| `MCP_DOCKER_VERSION`       | `latest`                      | MCP Docker 镜像版本 |
| `MCP_DOCKER_PORT_OVERRIDE` | `8000`                        | MCP 服务端口        |
| `DOCKER_HOST`              | `unix:///var/run/docker.sock` | Docker 套接字路径   |
| `TZ`                       | `UTC`                         | 时区                |

## 快速开始

```bash
docker compose up -d
```
