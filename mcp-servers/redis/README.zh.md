# Redis MCP 服务器

[English](./README.md) | [中文](./README.zh.md)

此服务部署一个用于 Redis 的 MCP（模型上下文协议）服务器，提供与 Redis 数据库交互的标准化接口。

## 服务

- `mcp`：MCP Redis 服务器
- `redis`：Redis 数据库服务

## 环境变量

| 变量名              | 说明                                            | 默认值     |
| ------------------- | ----------------------------------------------- | ---------- |
| MCP_REDIS_VERSION   | MCP Redis 镜像版本                              | `latest`   |
| MCP_PORT_OVERRIDE   | MCP 服务器主机端口映射（映射到容器内端口 8000） | 8000       |
| REDIS_VERSION       | Redis 镜像版本                                  | `7-alpine` |
| REDIS_PORT_OVERRIDE | Redis 主机端口映射（映射到容器内端口 6379）     | 6379       |
| TZ                  | 时区设置                                        | `UTC`      |

请根据实际需求修改 `.env` 文件。

## 卷

- `redis_data`：Redis 数据持久化

## 端口

- `8000`：MCP 服务器 API
- `6379`：Redis 数据库

## 使用方法

MCP 服务器提供了与 Redis 交互的标准化接口。访问 MCP API：`http://localhost:8000`。

## 附加信息

- 模型上下文协议：<https://modelcontextprotocol.io/>
- Redis 文档：<https://redis.io/documentation>
