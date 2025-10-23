# Docker Hub MCP Server

Docker Hub MCP Server 提供通过模型上下文协议（MCP）与 Docker Hub 集成的能力，实现镜像搜索、查询和管理功能。

## 功能特性

- 🔍 **镜像搜索** - 在 Docker Hub 上搜索镜像
- 📊 **镜像信息** - 获取详细的镜像信息
- 🏷️ **标签管理** - 查看镜像标签
- 📈 **统计信息** - 查看下载量和星标数
- 👤 **用户管理** - 管理 Docker Hub 账户
- 📝 **仓库信息** - 仓库信息查询

## 环境变量

| 变量                          | 默认值   | 说明                                |
| ----------------------------- | -------- | ----------------------------------- |
| `DOCKERHUB_MCP_VERSION`       | `latest` | Docker 镜像版本                     |
| `DOCKERHUB_MCP_PORT_OVERRIDE` | `8000`   | 服务端口                            |
| `DOCKERHUB_USERNAME`          | -        | Docker Hub 用户名（可选，用于认证） |
| `DOCKERHUB_PASSWORD`          | -        | Docker Hub 密码（可选，用于认证）   |
| `DOCKERHUB_TOKEN`             | -        | Docker Hub 访问令牌（推荐用于认证） |
| `TZ`                          | `UTC`    | 时区                                |

## 认证方式

该服务支持三种认证方式：

### 1. 无认证（公开访问）

仅能访问公开镜像和信息。

### 2. 用户名和密码认证

```env
DOCKERHUB_USERNAME=your_username
DOCKERHUB_PASSWORD=your_password
```

### 3. 访问令牌认证（推荐）

```env
DOCKERHUB_TOKEN=your_access_token
```

## 快速开始

### 1. 配置环境

创建 `.env` 文件：

#### 无认证模式（仅公开访问）

```env
DOCKERHUB_MCP_VERSION=latest
DOCKERHUB_MCP_PORT_OVERRIDE=8000
TZ=Asia/Shanghai
```

#### 令牌认证模式（推荐）

```env
DOCKERHUB_MCP_VERSION=latest
DOCKERHUB_MCP_PORT_OVERRIDE=8000
DOCKERHUB_TOKEN=dckr_pat_your_token_here
TZ=Asia/Shanghai
```

### 2. 获取 Docker Hub 访问令牌

1. 登录 [Docker Hub](https://hub.docker.com/)
2. 点击头像 → **Account Settings**
3. 导航到 **Security** → **Access Tokens**
4. 点击 **New Access Token**
5. 设置权限（推荐只读权限）
6. 生成并复制令牌

### 3. 启动服务

```bash
docker compose up -d
```

### 4. 验证服务

```bash
curl http://localhost:8000/health
```

## 资源需求

- 最小内存：128MB
- 推荐内存：512MB
- CPU：0.25-1.0 核心

## 常见使用场景

1. **镜像搜索** - 搜索适合项目的 Docker 镜像
2. **版本查询** - 查看镜像的所有可用标签
3. **依赖分析** - 分析镜像的基础镜像和依赖
4. **安全检查** - 查看镜像的安全扫描报告
5. **下载统计** - 查看镜像的受欢迎程度

## API 功能

该 MCP 服务器提供以下主要功能：

- ✅ 搜索公开和私有镜像
- ✅ 获取镜像标签列表
- ✅ 查看镜像详细信息
- ✅ 查询仓库统计信息
- ✅ 检查镜像更新
- ✅ 查看 Dockerfiles

## 权限类型

### 只读令牌权限

推荐用于大多数查询操作：

- ✅ 搜索镜像
- ✅ 查看镜像信息
- ✅ 获取标签列表
- ❌ 推送镜像
- ❌ 删除镜像

### 读写令牌权限

用于管理操作：

- ✅ 所有只读操作
- ✅ 推送镜像
- ✅ 删除镜像
- ✅ 更新仓库设置

## 安全建议

⚠️ **重要**：

1. **优先使用访问令牌**：比密码更安全
2. **最小权限原则**：只授予必要的权限
3. **定期轮换**：定期更新访问令牌
4. **保护环境变量**：不要将 `.env` 提交到版本控制
5. **监控访问**：定期检查令牌使用情况
6. **使用只读令牌**：除非需要写权限

## 速率限制

Docker Hub 有 API 速率限制：

- **未认证**：100 次请求 / 6 小时
- **免费账户**：200 次请求 / 6 小时
- **付费账户**：更高的速率限制

建议使用认证以获得更高的速率限制。

## 参考链接

- [Docker Hub 官方网站](https://hub.docker.com/)
- [Docker Hub API 文档](https://docs.docker.com/docker-hub/api/latest/)
- [MCP 文档](https://modelcontextprotocol.io/)

## 许可证

MIT License
