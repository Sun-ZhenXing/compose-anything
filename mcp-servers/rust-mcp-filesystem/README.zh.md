# Rust MCP Filesystem Server

Rust MCP Filesystem Server 是一个使用 Rust 构建的高性能文件系统 MCP 服务器，提供快速、安全的文件操作能力。

## 功能特性

- 🚀 **高性能** - Rust 驱动的高性能文件操作
- 🔒 **安全访问** - 可配置的访问控制
- 📁 **文件操作** - 文件读写、目录遍历
- 🔍 **文件搜索** - 快速文件搜索
- 📊 **文件信息** - 文件元数据查询
- ⚡ **异步 I/O** - 异步文件 I/O 操作

## 环境变量

| 变量                                | 默认值        | 说明                   |
| ----------------------------------- | ------------- | ---------------------- |
| `RUST_MCP_FILESYSTEM_VERSION`       | `latest`      | Docker 镜像版本        |
| `RUST_MCP_FILESYSTEM_PORT_OVERRIDE` | `8000`        | 服务端口               |
| `ALLOWED_PATHS`                     | `/projects`   | 允许访问的路径         |
| `HOST_WORKSPACE_PATH`               | `./workspace` | 要挂载的主机工作区路径 |
| `TZ`                                | `UTC`         | 时区                   |

## 快速开始

### 1. 配置环境

创建 `.env` 文件：

```env
RUST_MCP_FILESYSTEM_VERSION=latest
RUST_MCP_FILESYSTEM_PORT_OVERRIDE=8000
ALLOWED_PATHS=/projects
HOST_WORKSPACE_PATH=/path/to/your/workspace
TZ=Asia/Shanghai
```

### 2. 配置文件访问

在 `docker-compose.yaml` 中配置需要访问的目录：

```yaml
volumes:
  # 只读访问
  - /path/to/workspace:/projects/workspace:ro
  # 读写访问（移除 :ro）
  - /path/to/data:/projects/data
```

### 3. 启动服务

```bash
docker compose up -d
```

### 4. 验证服务

```bash
curl http://localhost:8000/health
```

## 安全特性

该服务实现了多层安全保护：

1. **只读文件系统**：容器文件系统设置为只读
2. **权限限制**：最小化容器权限
3. **路径限制**：只能访问配置的允许路径
4. **无特权提升**：防止权限提升
5. **Capability 限制**：只保留必要的 Linux Capabilities

## 性能特点

- ✅ **零拷贝**：利用 Rust 的零拷贝特性
- ✅ **异步 I/O**：高并发文件操作
- ✅ **内存安全**：Rust 保证的内存安全
- ✅ **低资源占用**：最小 64MB 内存

## 资源需求

- 最小内存：64MB
- 推荐内存：256MB
- CPU：0.25-1.0 核心

## 常见使用场景

1. **代码库访问** - 让 AI 访问和分析代码库
2. **文档处理** - 读取和处理文档文件
3. **日志分析** - 分析日志文件
4. **配置管理** - 读取和更新配置文件

## 安全建议

⚠️ **重要**：使用时请注意：

1. 只挂载必要的目录
2. 优先使用只读模式（`:ro`）
3. 不要挂载敏感系统目录
4. 定期审查访问日志
5. 使用防火墙限制网络访问

## 与其他实现的对比

| 特性     | Rust 实现 | Node.js 实现 |
| -------- | --------- | ------------ |
| 性能     | ⭐⭐⭐⭐⭐     | ⭐⭐⭐          |
| 内存占用 | 64MB+     | 128MB+       |
| 并发处理 | 优秀      | 良好         |
| 启动速度 | 快速      | 中等         |

## 参考链接

- [Rust 官方网站](https://www.rust-lang.org/)
- [MCP 文档](https://modelcontextprotocol.io/)
- [Docker Hub - mcp/rust-mcp-filesystem](https://hub.docker.com/r/mcp/rust-mcp-filesystem)

## 许可证

MIT License
