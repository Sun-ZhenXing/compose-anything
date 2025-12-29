# libSQL Server

[English Documentation](README.md)

## 简介

libSQL 是 SQLite 的开源分支，针对边缘部署和无服务器架构进行了优化。它提供与 SQLite 的完全兼容性，同时增加了主从复制、内置 HTTP/WebSocket API（Hrana 协议）等功能，专为分布式数据库场景设计。

**核心特性：**

- 100% SQLite 兼容
- 支持主从复制
- 内置 HTTP 和 WebSocket API
- 边缘优化，低延迟
- 开源可扩展

**官方资源：**

- GitHub：<https://github.com/tursodatabase/libsql>
- 文档：<https://github.com/tursodatabase/libsql/tree/main/docs>
- Docker Hub：<https://github.com/tursodatabase/libsql/pkgs/container/libsql-server>

## 快速开始

### 1. 基本用法（主实例）

```bash
cd src/libsql
docker compose up -d
```

数据库将在以下端口可用：

- HTTP/Hrana API：<http://localhost:8080>
- gRPC（用于复制）：localhost:5001

### 2. 启用副本实例

要启用复制，使用 `replica` profile 启动：

```bash
docker compose --profile replica up -d
```

这将启动：

- 主实例，端口 8080（HTTP）和 5001（gRPC）
- 副本实例，端口 8081（HTTP）和 5002（gRPC）

### 3. 访问数据库

可以通过以下方式连接到 libSQL：

**通过 HTTP API：**

```bash
# 创建表
curl -X POST http://localhost:8080 \
  -H "Content-Type: application/json" \
  -d '{"statements": ["CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT)"]}'

# 插入数据
curl -X POST http://localhost:8080 \
  -H "Content-Type: application/json" \
  -d '{"statements": ["INSERT INTO users (name) VALUES ('\''Alice'\'')"]}'

# 查询数据
curl -X POST http://localhost:8080 \
  -H "Content-Type: application/json" \
  -d '{"statements": ["SELECT * FROM users"]}'
```

**通过 libSQL CLI（如已安装）：**

```bash
libsql client http://localhost:8080
```

## 配置说明

### 环境变量

主要环境变量（完整列表请参见 `.env.example`）：

| 变量名                      | 默认值               | 说明                                           |
| --------------------------- | -------------------- | ---------------------------------------------- |
| `LIBSQL_VERSION`            | `latest`             | libSQL 服务器版本                              |
| `LIBSQL_HTTP_PORT_OVERRIDE` | `8080`               | HTTP API 端口                                  |
| `LIBSQL_GRPC_PORT_OVERRIDE` | `5001`               | gRPC 复制端口                                  |
| `LIBSQL_NODE`               | `primary`            | 节点类型：`primary`、`replica` 或 `standalone` |
| `LIBSQL_DB_PATH`            | `iku.db`             | 数据库文件名                                   |
| `LIBSQL_PRIMARY_URL`        | `http://libsql:5001` | 副本节点的主节点 URL                           |
| `TZ`                        | `UTC`                | 时区                                           |

### 身份验证（可选）

要启用身份验证，请取消注释并配置以下变量：

**HTTP 基本认证：**

```bash
# 生成 base64 编码的凭据
echo -n "username:password" | base64
# 结果：dXNlcm5hbWU6cGFzc3dvcmQ=

# 在 .env 中设置
LIBSQL_HTTP_AUTH=basic:dXNlcm5hbWU6cGFzc3dvcmQ=
```

**JWT 认证：**

```bash
# 方式 1：使用密钥文件
LIBSQL_AUTH_JWT_KEY_FILE=/path/to/jwt-key.pem

# 方式 2：直接使用密钥
LIBSQL_AUTH_JWT_KEY=your-jwt-key-here
```

### 平台支持

- **x86-64：** 使用 `LIBSQL_PLATFORM=linux/amd64`（默认）
- **ARM64（Apple Silicon）：**
  - 使用 `LIBSQL_VERSION=latest-arm` 获取原生 ARM 镜像
  - 或使用 `LIBSQL_PLATFORM=linux/amd64` 通过 Rosetta 运行

## 数据持久化

数据库文件存储在 Docker 命名卷中：

- 卷名：`libsql_data`
- 容器路径：`/var/lib/sqld`

备份数据库：

```bash
# 从容器复制数据库文件
docker compose cp libsql:/var/lib/sqld/iku.db ./backup.db
```

## 资源限制

每个实例的默认资源分配：

- CPU：0.5-1.0 核心
- 内存：256M-512M

在 `.env` 文件中调整：

```bash
LIBSQL_CPU_LIMIT=2.0
LIBSQL_MEMORY_LIMIT=1G
```

## 复制架构

libSQL 支持主从复制：

1. **主实例：** 接受读写操作
2. **副本实例：** 只读，通过 gRPC 从主实例复制

添加副本：

```bash
# 使用 replica profile 启动
docker compose --profile replica up -d
```

副本使用 `LIBSQL_PRIMARY_URL` 连接到主实例，并自动保持同步。

## 常用操作

### 检查服务器健康状态

```bash
curl http://localhost:8080/health
```

### 查看日志

```bash
docker compose logs -f libsql
```

### 重启服务

```bash
docker compose restart libsql
```

### 停止并删除

```bash
docker compose down
# 同时删除卷
docker compose down -v
```

## 故障排查

### 连接被拒绝

- 验证服务正在运行：`docker compose ps`
- 检查日志：`docker compose logs libsql`
- 确保端口未被占用：`netstat -an | grep 8080`

### 副本未同步

- 验证 `LIBSQL_PRIMARY_URL` 是否正确
- 检查主实例是否健康且可访问
- 查看副本日志以查找连接错误

### 性能问题

- 在 `.env` 中增加资源限制
- 考虑为卷存储使用 SSD
- 启用查询日志以进行优化

## 安全注意事项

- **默认设置：** 未启用身份验证 - 仅适用于开发环境
- **生产环境：** 始终启用身份验证（HTTP Basic 或 JWT）
- **网络：** 考虑使用 Docker 网络或反向代理进行外部访问
- **密钥：** 切勿将包含凭据的 `.env` 提交到版本控制

## 许可证

libSQL 采用 MIT 许可证。详情请参见[官方仓库](https://github.com/tursodatabase/libsql)。
