# Playwright MCP Server

Playwright MCP Server 是一个基于 Playwright 的模型上下文协议（MCP）服务器，提供浏览器自动化和网页抓取功能。

## 功能特性

- 🌐 **浏览器自动化** - 自动化浏览器操作
- 📸 **截图捕获** - 捕获网页截图
- 🔍 **网页抓取** - 智能提取网页内容
- 📝 **表单填写** - 自动化表单填写
- 🎭 **多浏览器支持** - 支持 Chromium、Firefox、WebKit
- 🔐 **Cookie 和会话管理** - Cookie 和会话管理

## 环境变量

| 变量                       | 默认值   | 说明            |
| -------------------------- | -------- | --------------- |
| `PLAYWRIGHT_VERSION`       | `latest` | Docker 镜像版本 |
| `PLAYWRIGHT_PORT_OVERRIDE` | `8000`   | 服务端口        |
| `TZ`                       | `UTC`    | 时区            |

## 快速开始

### 1. 配置环境

创建 `.env` 文件：

```env
PLAYWRIGHT_VERSION=latest
PLAYWRIGHT_PORT_OVERRIDE=8000
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

## 资源需求

- 最小内存：512MB
- 推荐内存：2GB
- 共享内存：2GB（已配置）

## 常见使用场景

1. **网页截图** - 自动访问并捕获截图
2. **数据抓取** - 从动态网页提取数据
3. **UI 测试** - 自动化 UI 测试场景
4. **表单自动化** - 批量填写和提交表单

## 参考链接

- [Playwright 官方网站](https://playwright.dev/)
- [MCP 文档](https://modelcontextprotocol.io/)
- [Docker Hub - mcp/playwright](https://hub.docker.com/r/mcp/playwright)

## 许可证

MIT License
