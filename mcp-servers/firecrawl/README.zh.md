# MCP Firecrawl 服务器

Model Context Protocol（MCP）服务器，用于 Firecrawl 网页抓取和爬虫功能。使 AI 助手能够从网站中提取结构化数据。

## 功能特性

- **网页抓取**:从网页中提取内容
- **网站爬虫**:系统地爬取整个网站
- **结构化数据**:将网页内容转换为结构化格式
- **JavaScript 渲染**:支持动态内容
- **速率限制**:内置速率限制,实现礼貌的抓取
- **MCP 集成**:标准 MCP 协议,用于 AI 助手集成

## 环境变量

| 变量                          | 描述                       | 默认值   |
| ----------------------------- | -------------------------- | -------- |
| `MCP_FIRECRAWL_VERSION`       | Docker 镜像版本            | `latest` |
| `MCP_FIRECRAWL_PORT_OVERRIDE` | 主机端口覆盖               | `8000`   |
| `FIRECRAWL_API_KEY`           | Firecrawl API 密钥（必需） | -        |
| `TZ`                          | 时区                       | `UTC`    |

## 快速开始

1. 复制 `.env.example` 到 `.env`:

   ```bash
   cp .env.example .env
   ```

2. 编辑 `.env` 并设置您的 `FIRECRAWL_API_KEY`（从 <https://firecrawl.dev> 获取）

3. 启动服务:

   ```bash
   docker compose up -d
   ```

4. 检查服务状态:

   ```bash
   docker compose ps
   ```

5. 查看日志:

   ```bash
   docker compose logs -f
   ```

## 使用说明

将您的 AI 助手连接到 MCP 服务器 `http://localhost:8000`,即可启用网页抓取和爬虫功能。

## 许可证

请查看官方 [MCP Firecrawl](https://hub.docker.com/r/mcp/firecrawl) 文档以获取许可证信息。
