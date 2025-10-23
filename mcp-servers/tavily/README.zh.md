# Tavily MCP 服务器

Tavily MCP 服务器通过模型上下文协议提供强大的网络搜索和数据提取功能。

## 功能特性

- 🔍 **网络搜索** - 使用 Tavily API 进行智能网络搜索
- 📄 **内容提取** - 提取和处理网页内容
- 🗺️ **网站映射** - 发现和映射网站结构
- 📰 **新闻搜索** - 搜索最新新闻和文章
- 🌐 **多源聚合** - 跨多个数据源的聚合搜索

## 环境变量

| 变量                   | 默认值   | 说明                    |
| ---------------------- | -------- | ----------------------- |
| `TAVILY_API_KEY`       | -        | Tavily API 密钥（必需） |
| `TAVILY_VERSION`       | `latest` | Docker 镜像版本         |
| `TAVILY_PORT_OVERRIDE` | `8000`   | 服务端口                |
| `TZ`                   | `UTC`    | 时区                    |

## 快速开始

### 1. 配置环境

创建 `.env` 文件：

```env
TAVILY_API_KEY=your_tavily_api_key_here
TAVILY_VERSION=latest
TAVILY_PORT_OVERRIDE=8000
TZ=Asia/Shanghai
```

### 2. 启动服务

```bash
docker compose up -d
```

### 3. 验证服务

```bash
curl http://localhost:8000/health
```

## 获取 API 密钥

访问 [Tavily](https://tavily.com/) 获取 API 密钥。

## 参考链接

- [Tavily 官网](https://tavily.com/)
- [MCP 官方文档](https://modelcontextprotocol.io/)
- [Docker Hub - mcp/tavily](https://hub.docker.com/r/mcp/tavily)

## 许可证

MIT License
