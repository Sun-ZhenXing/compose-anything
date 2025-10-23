# Docker Hub MCP Server

Docker Hub MCP Server provides integration with Docker Hub through the Model Context Protocol, enabling image search, query, and management capabilities.

## Features

- 🔍 **Image Search** - Search for images on Docker Hub
- 📊 **Image Info** - Get detailed image information
- 🏷️ **Tag Management** - View image tags
- 📈 **Statistics** - View download counts and stars
- 👤 **User Management** - Manage Docker Hub account
- 📝 **Repository Info** - Repository information queries

## Environment Variables

| Variable                      | Default  | Description                                    |
| ----------------------------- | -------- | ---------------------------------------------- |
| `DOCKERHUB_MCP_VERSION`       | `latest` | Docker image version                           |
| `DOCKERHUB_MCP_PORT_OVERRIDE` | `8000`   | Service port                                   |
| `DOCKERHUB_USERNAME`          | -        | Docker Hub username (optional, for auth)       |
| `DOCKERHUB_PASSWORD`          | -        | Docker Hub password (optional, for auth)       |
| `DOCKERHUB_TOKEN`             | -        | Docker Hub access token (recommended for auth) |
| `TZ`                          | `UTC`    | Timezone                                       |

## Authentication Methods

The service supports three authentication methods:

### 1. No Authentication (Public Access)

Only public images and information can be accessed.

### 2. Username & Password Authentication

```env
DOCKERHUB_USERNAME=your_username
DOCKERHUB_PASSWORD=your_password
```

### 3. Access Token Authentication (Recommended)

```env
DOCKERHUB_TOKEN=your_access_token
```

## Quick Start

### 1. Configure Environment

Create a `.env` file:

#### No Authentication Mode (Public Access Only)

```env
DOCKERHUB_MCP_VERSION=latest
DOCKERHUB_MCP_PORT_OVERRIDE=8000
TZ=Asia/Shanghai
```

#### Token Authentication Mode (Recommended)

```env
DOCKERHUB_MCP_VERSION=latest
DOCKERHUB_MCP_PORT_OVERRIDE=8000
DOCKERHUB_TOKEN=dckr_pat_your_token_here
TZ=Asia/Shanghai
```

### 2. Get Docker Hub Access Token

1. Login to [Docker Hub](https://hub.docker.com/)
2. Click avatar → **Account Settings**
3. Navigate to **Security** → **Access Tokens**
4. Click **New Access Token**
5. Set permissions (read-only recommended)
6. Generate and copy the token

### 3. Start Service

```bash
docker compose up -d
```

### 4. Verify Service

```bash
curl http://localhost:8000/health
```

## Resource Requirements

- Minimum memory: 128MB
- Recommended memory: 512MB
- CPU: 0.25-1.0 cores

## Common Use Cases

1. **Image Search** - Search for Docker images suitable for projects
2. **Version Query** - View all available tags for an image
3. **Dependency Analysis** - Analyze base images and dependencies
4. **Security Check** - View image security scan reports
5. **Download Statistics** - Check image popularity

## API Features

The MCP server provides the following main features:

- ✅ Search public and private images
- ✅ Get image tag lists
- ✅ View detailed image information
- ✅ Query repository statistics
- ✅ Check for image updates
- ✅ View Dockerfiles

## Permission Types

### Read-Only Token Permissions

Recommended for most query operations:

- ✅ Search images
- ✅ View image information
- ✅ Get tag lists
- ❌ Push images
- ❌ Delete images

### Read-Write Token Permissions

For management operations:

- ✅ All read-only operations
- ✅ Push images
- ✅ Delete images
- ✅ Update repository settings

## Security Recommendations

⚠️ **Important**:

1. **Prefer Access Tokens**: More secure than passwords
2. **Least Privilege**: Only grant necessary permissions
3. **Regular Rotation**: Update access tokens regularly
4. **Protect Environment Variables**: Don't commit `.env` to version control
5. **Monitor Access**: Regularly check token usage
6. **Use Read-Only Tokens**: Unless write access is needed

## Rate Limits

Docker Hub has API rate limits:

- **Unauthenticated**: 100 requests/6 hours
- **Free Account**: 200 requests/6 hours
- **Paid Account**: Higher rate limits

Authentication is recommended for higher rate limits.

## References

- [Docker Hub Official Site](https://hub.docker.com/)
- [Docker Hub API Documentation](https://docs.docker.com/docker-hub/api/latest/)
- [MCP Documentation](https://modelcontextprotocol.io/)

## License

MIT License

通过 AI 可以进行以下查询:

1. "搜索 nginx 相关的镜像"
2. "查看 python:3.11 镜像的所有标签"
3. "获取 redis:alpine 镜像的详细信息"
4. "查找最流行的 PostgreSQL 镜像"
5. "比较不同 Node.js 镜像的大小"

## 参考链接

- [Docker Hub](https://hub.docker.com/)
- [Docker Hub API 文档](https://docs.docker.com/docker-hub/api/latest/)
- [Docker Hub 访问令牌](https://docs.docker.com/docker-hub/access-tokens/)
- [MCP 官方文档](https://modelcontextprotocol.io/)
- [Docker Hub - mcp/dockerhub](https://hub.docker.com/r/mcp/dockerhub)

## 许可证

MIT License
