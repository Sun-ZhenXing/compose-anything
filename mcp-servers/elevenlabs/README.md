# MCP ElevenLabs Server

Model Context Protocol (MCP) server for ElevenLabs text-to-speech API integration. Enables AI assistants to generate high-quality voice audio from text.

## Features

- **Text-to-Speech**: Convert text to natural-sounding speech
- **Multiple Voices**: Access to various voice models
- **Voice Cloning**: Create custom voice profiles
- **Multi-language Support**: Support for multiple languages
- **Audio Controls**: Adjust speed, pitch, and stability
- **MCP Integration**: Standard MCP protocol for AI assistant integration

## Environment Variables

| Variable                       | Description                   | Default  |
| ------------------------------ | ----------------------------- | -------- |
| `MCP_ELEVENLABS_VERSION`       | Docker image version          | `latest` |
| `MCP_ELEVENLABS_PORT_OVERRIDE` | Host port override            | `8000`   |
| `ELEVENLABS_API_KEY`           | ElevenLabs API key (required) | -        |
| `TZ`                           | Timezone                      | `UTC`    |

## Quick Start

1. Copy `.env.example` to `.env`:

   ```bash
   cp .env.example .env
   ```

2. Edit `.env` and set your `ELEVENLABS_API_KEY` (get from <https://elevenlabs.io>)

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

Connect your AI assistant to the MCP server at `http://localhost:8000` to enable text-to-speech capabilities with ElevenLabs.

## License

Please check the official [MCP ElevenLabs](https://hub.docker.com/r/mcp/elevenlabs) documentation for license information.
