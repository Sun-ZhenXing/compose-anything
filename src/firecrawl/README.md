# Firecrawl

[English](./README.md) | [中文](./README.zh.md)

This service deploys Firecrawl, a web scraping and crawling API powered by Playwright and headless browsers.

## Services

- `api`: The main Firecrawl API server with integrated workers
- `redis`: Redis for job queue and caching
- `playwright-service`: Playwright service for browser automation
- `nuq-postgres`: PostgreSQL database for queue management and data storage

## Environment Variables

| Variable Name           | Description                                | Default Value |
| ----------------------- | ------------------------------------------ | ------------- |
| FIRECRAWL_VERSION       | Firecrawl image version                    | `latest`      |
| REDIS_VERSION           | Redis image version                        | `alpine`      |
| PLAYWRIGHT_VERSION      | Playwright service version                 | `latest`      |
| NUQ_POSTGRES_VERSION    | NUQ PostgreSQL image version               | `latest`      |
| POSTGRES_USER           | PostgreSQL username                        | `postgres`    |
| POSTGRES_PASSWORD       | PostgreSQL password                        | `postgres`    |
| POSTGRES_DB             | PostgreSQL database name                   | `postgres`    |
| POSTGRES_PORT_OVERRIDE  | PostgreSQL port mapping                    | `5432`        |
| INTERNAL_PORT           | Internal API port                          | `3002`        |
| FIRECRAWL_PORT_OVERRIDE | External API port mapping                  | `3002`        |
| EXTRACT_WORKER_PORT     | Extract worker port                        | `3004`        |
| WORKER_PORT             | Worker port                                | `3005`        |
| USE_DB_AUTHENTICATION   | Enable database authentication             | `false`       |
| OPENAI_API_KEY          | OpenAI API key for AI features (optional)  | `""`          |
| OPENAI_BASE_URL         | OpenAI API base URL (optional)             | `""`          |
| MODEL_NAME              | AI model name (optional)                   | `""`          |
| MODEL_EMBEDDING_NAME    | Embedding model name (optional)            | `""`          |
| OLLAMA_BASE_URL         | Ollama base URL (optional)                 | `""`          |
| BULL_AUTH_KEY           | Bull queue admin panel authentication key  | `@`           |
| TEST_API_KEY            | Test API key (optional)                    | `""`          |
| SLACK_WEBHOOK_URL       | Slack webhook for notifications (optional) | `""`          |
| POSTHOG_API_KEY         | PostHog API key (optional)                 | `""`          |
| POSTHOG_HOST            | PostHog host (optional)                    | `""`          |
| SUPABASE_ANON_TOKEN     | Supabase anonymous token (optional)        | `""`          |
| SUPABASE_URL            | Supabase URL (optional)                    | `""`          |
| SUPABASE_SERVICE_TOKEN  | Supabase service token (optional)          | `""`          |
| SELF_HOSTED_WEBHOOK_URL | Self-hosted webhook URL (optional)         | `""`          |
| SERPER_API_KEY          | Serper API key for search (optional)       | `""`          |
| SEARCHAPI_API_KEY       | SearchAPI key (optional)                   | `""`          |
| LOGGING_LEVEL           | Logging level                              | `info`        |
| PROXY_SERVER            | Proxy server URL (optional)                | `""`          |
| PROXY_USERNAME          | Proxy username (optional)                  | `""`          |
| PROXY_PASSWORD          | Proxy password (optional)                  | `""`          |
| BLOCK_MEDIA             | Block media content                        | `true`        |
| SEARXNG_ENDPOINT        | SearXNG endpoint (optional)                | `""`          |
| SEARXNG_ENGINES         | SearXNG engines (optional)                 | `""`          |
| SEARXNG_CATEGORIES      | SearXNG categories (optional)              | `""`          |

Please modify the `.env` file as needed for your use case.

## Volumes

- `redis_data`: Redis data storage for job queues and caching
- `postgres_data`: PostgreSQL data storage for queue management and metadata

## Usage

### Start the Services

```bash
docker compose up -d
```

### Access the API

The Firecrawl API will be available at:

```text
http://localhost:3002
```

### Admin Panel

Access the Bull queue admin panel at:

```text
http://localhost:3002/admin/@/queues
```

Replace `@` with your `BULL_AUTH_KEY` value if changed.

### Example API Calls

**Scrape a Single Page:**

```bash
curl -X POST http://localhost:3002/v1/scrape \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://example.com"
  }'
```

**Crawl a Website:**

```bash
curl -X POST http://localhost:3002/v1/crawl \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://example.com",
    "limit": 100
  }'
```

**Extract Structured Data:**

```bash
curl -X POST http://localhost:3002/v1/extract \
  -H "Content-Type: application/json" \
  -d '{
    "urls": ["https://example.com"],
    "schema": {
      "type": "object",
      "properties": {
        "title": {"type": "string"},
        "description": {"type": "string"}
      }
    }
  }'
```

## Features

- **Web Scraping**: Extract clean content from any webpage
- **Web Crawling**: Recursively crawl entire websites
- **JavaScript Rendering**: Full support for dynamic JavaScript-rendered pages
- **Markdown Output**: Clean markdown conversion of web content
- **Structured Data Extraction**: Extract data using JSON schemas
- **Queue Management**: Built-in job queue with Bull
- **Rate Limiting**: Configurable rate limiting
- **Proxy Support**: Optional proxy configuration for all requests
- **AI-Powered Features**: Optional OpenAI integration for advanced extraction

## Architecture

This deployment uses the official Firecrawl architecture:

- **API Server**: Handles HTTP requests and manages the job queue
- **Workers**: Built into the main container, processes scraping jobs
- **PostgreSQL**: Stores queue metadata and job information
- **Redis**: Handles job queue and caching
- **Playwright Service**: Provides browser automation capabilities

## Notes

- The service uses the official `ghcr.io/firecrawl/firecrawl` image
- PostgreSQL uses the official `ghcr.io/firecrawl/nuq-postgres` image for queue management (NUQ - Not Quite Bull)
- Redis is used for job queuing without password by default (runs on private network)
- For production use, enable `USE_DB_AUTHENTICATION` and configure Supabase
- The `BULL_AUTH_KEY` should be changed in production deployments
- AI features require an `OPENAI_API_KEY` or `OLLAMA_BASE_URL`
- All workers run within the single API container using the harness mode

## License

Firecrawl is licensed under the AGPL-3.0 License.
