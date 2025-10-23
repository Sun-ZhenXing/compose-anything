# MCP YouTube Transcript Server

Model Context Protocol (MCP) server for fetching YouTube video transcripts. Enables AI assistants to retrieve and process YouTube video captions and transcripts.

## Features

- **Transcript Extraction**: Fetch transcripts from YouTube videos
- **Multiple Language Support**: Access transcripts in different languages
- **Automatic Captions**: Support for auto-generated captions
- **Timestamp Information**: Retrieve transcript with timing data
- **MCP Integration**: Standard MCP protocol for AI assistant integration

## Environment Variables

| Variable                               | Description          | Default  |
| -------------------------------------- | -------------------- | -------- |
| `MCP_YOUTUBE_TRANSCRIPT_VERSION`       | Docker image version | `latest` |
| `MCP_YOUTUBE_TRANSCRIPT_PORT_OVERRIDE` | Host port override   | `8000`   |
| `TZ`                                   | Timezone             | `UTC`    |

## Quick Start

1. Copy `.env.example` to `.env`:

   ```bash
   cp .env.example .env
   ```

2. Start the service:

   ```bash
   docker compose up -d
   ```

3. Check service status:

   ```bash
   docker compose ps
   ```

4. View logs:

   ```bash
   docker compose logs -f
   ```

## Usage

Connect your AI assistant to the MCP server at `http://localhost:8000` to enable YouTube transcript retrieval capabilities.

## License

Please check the official [MCP YouTube Transcript](https://hub.docker.com/r/mcp/youtube-transcript) documentation for license information.
