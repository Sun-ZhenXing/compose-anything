# MongoDB MCP Server

MongoDB MCP Server 提供通过模型上下文协议（MCP）与 MongoDB 数据库交互的能力，包括数据查询、插入、更新和集合管理。

## 功能特性

- 📊 **数据库操作** - 支持 CRUD 操作
- 🔍 **查询和聚合** - 复杂查询和聚合管道
- 📝 **集合管理** - 创建、删除、修改集合
- 🔐 **身份认证** - 内置认证支持
- 📈 **监控** - 健康检查和资源监控
- 🌐 **RESTful API** - 基于 MCP 协议的 API 接口

## 架构

该服务包含两个容器：

- **mcp-mongodb**：MCP 协议适配器，提供 API 接口
- **mongodb**：MongoDB 数据库实例

## 环境变量

| 变量                        | 默认值                    | 说明                             |
| --------------------------- | ------------------------- | -------------------------------- |
| `MCP_MONGODB_VERSION`       | `latest`                  | MCP MongoDB 服务版本             |
| `MONGODB_VERSION`           | `7`                       | MongoDB 版本                     |
| `MCP_MONGODB_PORT_OVERRIDE` | `8000`                    | MCP 服务端口                     |
| `MONGODB_PORT_OVERRIDE`     | `27017`                   | MongoDB 端口                     |
| `MONGODB_URI`               | `mongodb://mongodb:27017` | MongoDB 连接 URI                 |
| `MONGODB_DATABASE`          | `mcp_db`                  | 数据库名称                       |
| `MONGO_ROOT_USERNAME`       | `admin`                   | 管理员用户名                     |
| `MONGO_ROOT_PASSWORD`       | `password`                | 管理员密码（⚠️ 生产环境请修改！） |
| `TZ`                        | `UTC`                     | 时区                             |

## 快速开始

### 1. 配置环境

创建 `.env` 文件：

```env
MCP_MONGODB_VERSION=latest
MONGODB_VERSION=7
MCP_MONGODB_PORT_OVERRIDE=8000
MONGODB_PORT_OVERRIDE=27017
MONGODB_DATABASE=mcp_db
MONGO_ROOT_USERNAME=admin
MONGO_ROOT_PASSWORD=your_secure_password
TZ=Asia/Shanghai
```

### 2. 启动服务

```bash
docker compose up -d
```

### 3. 验证服务

检查 MCP 服务：

```bash
curl http://localhost:8000/health
```

连接 MongoDB：

```bash
docker compose exec mongodb mongosh -u admin -p your_secure_password
```

## 资源需求

- **MCP 服务**：128MB-512MB 内存，0.25-1.0 CPU
- **MongoDB**：512MB-2GB 内存，0.5-2.0 CPU

## 安全建议

1. **修改默认密码**：生产环境务必修改 `MONGO_ROOT_PASSWORD`
2. **网络隔离**：使用内部网络，避免 MongoDB 端口暴露到公网
3. **启用认证**：确保 MongoDB 认证已启用
4. **定期备份**：设置定期数据备份计划

## 数据持久化

- `mongodb_data`：MongoDB 数据目录
- `mongodb_config`：MongoDB 配置目录

## 常见使用场景

1. **应用后端** - 作为应用程序的数据库后端
2. **数据分析** - 存储和查询分析数据
3. **文档存储** - 存储和检索 JSON 文档
4. **会话管理** - 存储用户会话

## 参考链接

- [MongoDB 官方文档](https://docs.mongodb.com/)
- [MCP 文档](https://modelcontextprotocol.io/)
- [Docker Hub - mongo](https://hub.docker.com/_/mongo)

## 许可证

MIT License
