# MCP Firecrawl Server

Model Context Protocol (MCP) server for Firecrawl web scraping and crawling capabilities. Enables AI assistants to extract structured data from websites.

## Features

- **Web Scraping**: Extract content from web pages
- **Site Crawling**: Crawl entire websites systematically
- **Structured Data**: Convert web content to structured formats
- **JavaScript Rendering**: Support for dynamic content
- **Rate Limiting**: Built-in rate limiting for respectful scraping
- **MCP Integration**: Standard MCP protocol for AI assistant integration

## Environment Variables

| Variable                      | Description                  | Default  |
| ----------------------------- | ---------------------------- | -------- |
| `MCP_FIRECRAWL_VERSION`       | Docker image version         | `latest` |
| `MCP_FIRECRAWL_PORT_OVERRIDE` | Host port override           | `8000`   |
| `FIRECRAWL_API_KEY`           | Firecrawl API key (required) | -        |
| `TZ`                          | Timezone                     | `UTC`    |

## Quick Start

1. Copy `.env.example` to `.env`:

   ```bash
   cp .env.example .env
   ```

2. Edit `.env` and set your `FIRECRAWL_API_KEY` (get from <https://firecrawl.dev>)

3. Start the service:

   ```bash
   docker compose up -d
   ```

4. Check service status:

   ```bash
   docker compose ps
   ```

5. View logs:

   ```bash
   docker compose logs -f
   ```

## Usage

Connect your AI assistant to the MCP server at `http://localhost:8000` to enable web scraping and crawling capabilities.

## License

Please check the official [MCP Firecrawl](https://hub.docker.com/r/mcp/firecrawl) documentation for license information.
