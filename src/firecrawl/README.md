# Firecrawl

[English](./README.md) | [中文](./README.zh.md)

This service deploys Firecrawl, a web scraping and crawling API powered by Playwright and headless browsers.

## Services

- `firecrawl`: The main Firecrawl API server.
- `redis`: Redis for job queue and caching.
- `playwright`: Playwright service for browser automation.

## Environment Variables

| Variable Name                         | Description                         | Default Value  |
| ------------------------------------- | ----------------------------------- | -------------- |
| FIRECRAWL_VERSION                     | Firecrawl image version             | `v1.16.0`      |
| REDIS_VERSION                         | Redis image version                 | `7.4.2-alpine` |
| PLAYWRIGHT_VERSION                    | Playwright service version          | `latest`       |
| REDIS_PASSWORD                        | Redis password                      | `firecrawl`    |
| NUM_WORKERS_PER_QUEUE                 | Number of workers per queue         | `8`            |
| SCRAPE_RATE_LIMIT_TOKEN_BUCKET_SIZE   | Token bucket size for rate limiting | `20`           |
| SCRAPE_RATE_LIMIT_TOKEN_BUCKET_REFILL | Token refill rate per second        | `1`            |
| PROXY_SERVER                          | Proxy server URL (optional)         | `""`           |
| PROXY_USERNAME                        | Proxy username (optional)           | `""`           |
| PROXY_PASSWORD                        | Proxy password (optional)           | `""`           |
| BLOCK_MEDIA                           | Block media content                 | `true`         |
| FIRECRAWL_PORT_OVERRIDE               | Firecrawl API port                  | `3002`         |

Please modify the `.env` file as needed for your use case.

## Volumes

- `redis_data`: Redis data storage for job queues and caching.

## Usage

### Start the Services

```bash
docker-compose up -d
```

### Access the API

The Firecrawl API will be available at:

```text
http://localhost:3002
```

### Example API Calls

**Scrape a Single Page:**

```bash
curl -X POST http://localhost:3002/v0/scrape \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://example.com"
  }'
```

**Crawl a Website:**

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

## Features

- **Web Scraping**: Extract clean content from any webpage
- **Web Crawling**: Recursively crawl entire websites
- **JavaScript Rendering**: Full support for dynamic JavaScript-rendered pages
- **Markdown Output**: Clean markdown conversion of web content
- **Rate Limiting**: Built-in rate limiting to prevent abuse
- **Proxy Support**: Optional proxy configuration for all requests

## Notes

- The service uses Playwright for browser automation, supporting complex web pages
- Redis is used for job queuing and caching
- Rate limiting is configurable via environment variables
- For production use, consider scaling the number of workers
- BLOCK_MEDIA can reduce memory usage by blocking images/videos

## License

Firecrawl is licensed under the AGPL-3.0 License.
