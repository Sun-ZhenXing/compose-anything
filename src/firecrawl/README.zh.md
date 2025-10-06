# Firecrawl

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署 Firecrawl，一个由 Playwright 和无头浏览器驱动的网页抓取和爬取 API。

## 服务

- `firecrawl`: Firecrawl API 主服务器。
- `redis`: 用于作业队列和缓存的 Redis。
- `playwright`: 用于浏览器自动化的 Playwright 服务。

## 环境变量

| 变量名                                | 说明                   | 默认值         |
| ------------------------------------- | ---------------------- | -------------- |
| FIRECRAWL_VERSION                     | Firecrawl 镜像版本     | `v1.16.0`      |
| REDIS_VERSION                         | Redis 镜像版本         | `7.4.2-alpine` |
| PLAYWRIGHT_VERSION                    | Playwright 服务版本    | `latest`       |
| REDIS_PASSWORD                        | Redis 密码             | `firecrawl`    |
| NUM_WORKERS_PER_QUEUE                 | 每个队列的工作进程数   | `8`            |
| SCRAPE_RATE_LIMIT_TOKEN_BUCKET_SIZE   | 速率限制的令牌桶大小   | `20`           |
| SCRAPE_RATE_LIMIT_TOKEN_BUCKET_REFILL | 每秒令牌填充速率       | `1`            |
| PROXY_SERVER                          | 代理服务器 URL（可选） | `""`           |
| PROXY_USERNAME                        | 代理用户名（可选）     | `""`           |
| PROXY_PASSWORD                        | 代理密码（可选）       | `""`           |
| BLOCK_MEDIA                           | 阻止媒体内容           | `true`         |
| FIRECRAWL_PORT_OVERRIDE               | Firecrawl API 端口     | `3002`         |

请根据实际需求修改 `.env` 文件。

## 卷

- `redis_data`: 用于作业队列和缓存的 Redis 数据存储。

## 使用方法

### 启动服务

```bash
docker-compose up -d
```

### 访问 API

Firecrawl API 可在以下地址访问:

```text
http://localhost:3002
```

### API 调用示例

**抓取单个页面:**

```bash
curl -X POST http://localhost:3002/v0/scrape \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://example.com"
  }'
```

**爬取网站:**

```bash
curl -X POST http://localhost:3002/v0/crawl \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://example.com",
    "crawlerOptions": {
      "limit": 100
    }
  }'
```

## 功能

- **网页抓取**: 从任何网页提取干净的内容
- **网站爬取**: 递归爬取整个网站
- **JavaScript 渲染**: 完全支持动态 JavaScript 渲染的页面
- **Markdown 输出**: 将网页内容清晰地转换为 markdown
- **速率限制**: 内置速率限制以防止滥用
- **代理支持**: 所有请求的可选代理配置

## 注意事项

- 该服务使用 Playwright 进行浏览器自动化,支持复杂的网页
- Redis 用于作业队列和缓存
- 速率限制可通过环境变量配置
- 对于生产环境,考虑扩展工作进程数量
- BLOCK_MEDIA 可以通过阻止图像/视频来减少内存使用

## 许可证

Firecrawl 使用 AGPL-3.0 许可证授权。
