# Playwright MCP Server

Playwright MCP Server provides browser automation and web scraping capabilities through the Model Context Protocol.

## Features

- 🌐 **Browser Automation** - Automate browser operations
- 📸 **Screenshot Capture** - Capture web page screenshots
- 🔍 **Web Scraping** - Intelligent web content extraction
- 📝 **Form Filling** - Automated form filling
- 🎭 **Multi-Browser** - Support for Chromium, Firefox, WebKit
- 🔐 **Cookie & Session** - Cookie and session management

## Environment Variables

| Variable                   | Default  | Description          |
| -------------------------- | -------- | -------------------- |
| `PLAYWRIGHT_VERSION`       | `latest` | Docker image version |
| `PLAYWRIGHT_PORT_OVERRIDE` | `8000`   | Service port         |
| `TZ`                       | `UTC`    | Timezone             |

## Quick Start

### 1. Configure Environment

Create a `.env` file:

```env
PLAYWRIGHT_VERSION=latest
PLAYWRIGHT_PORT_OVERRIDE=8000
TZ=Asia/Shanghai
```

### 2. Start Service

```bash
docker compose up -d
```

### 3. Verify Service

```bash
curl http://localhost:8000/health
```

## Resource Requirements

- Minimum memory: 512MB
- Recommended memory: 2GB
- Shared memory: 2GB (configured)

## Common Use Cases

1. **Web Screenshots** - Automatically visit and capture screenshots
2. **Data Scraping** - Extract data from dynamic web pages
3. **UI Testing** - Automated UI testing scenarios
4. **Form Automation** - Batch fill and submit forms

## References

- [Playwright Official Site](https://playwright.dev/)
- [MCP Documentation](https://modelcontextprotocol.io/)
- [Docker Hub - mcp/playwright](https://hub.docker.com/r/mcp/playwright)

## License

MIT License
