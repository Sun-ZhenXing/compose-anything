# OpenClaw

OpenClaw is a personal AI assistant that runs on your own devices. It integrates with multiple messaging platforms (WhatsApp, Telegram, Slack, Discord, Google Chat, Signal, iMessage, Microsoft Teams, WebChat) and provides AI-powered assistance across all your channels.

## Features

- **Multi-channel Support**: WhatsApp, Telegram, Slack, Discord, Google Chat, Signal, iMessage, BlueBubbles, Microsoft Teams, Matrix, Zalo, WebChat
- **Local-first Gateway**: Single control plane for sessions, channels, tools, and events
- **Multi-agent Routing**: Route inbound channels to isolated agents with per-agent sessions
- **Voice Wake + Talk Mode**: Always-on speech for macOS/iOS/Android with ElevenLabs
- **Live Canvas**: Agent-driven visual workspace with A2UI
- **First-class Tools**: Browser, canvas, nodes, cron, sessions, and channel-specific actions
- **Companion Apps**: macOS menu bar app + iOS/Android nodes
- **Skills Platform**: Bundled, managed, and workspace skills with install gating

## Quick Start

1. Copy the example environment file:

   ```bash
   cp .env.example .env
   ```

2. Generate a secure gateway token:

   ```bash
   # Using OpenSSL
   openssl rand -hex 32
   
   # Or using Python
   python3 -c "import secrets; print(secrets.token_hex(32))"
   ```

3. Edit `.env` and set at least:
   - `OPENCLAW_GATEWAY_TOKEN` - Your generated token
   - `ANTHROPIC_API_KEY` or `OPENAI_API_KEY` - If using API key auth

4. Start the gateway:

   ```bash
   docker compose up -d
   ```

5. Access the Control UI:
   - Open <http://localhost:18789> in your browser
   - Enter your gateway token when prompted

## Configuration

### Gateway Access

The gateway can be accessed in two ways:

- **Loopback** (`OPENCLAW_GATEWAY_BIND=loopback`): Only accessible from the host machine (127.0.0.1)
- **LAN** (`OPENCLAW_GATEWAY_BIND=lan`): Accessible from your local network (0.0.0.0)

For production deployments, consider:

- Using Tailscale Serve/Funnel for secure remote access
- Setting up SSH tunnels
- Implementing reverse proxy with authentication

### Model Configuration

OpenClaw supports multiple AI model providers:

- **Anthropic Claude** (Recommended): Claude Pro/Max with OAuth or API key
- **OpenAI**: ChatGPT/Codex with OAuth or API key
- **Custom Providers**: Configure via the Control UI or config file

Set API keys in `.env` or use OAuth authentication through the onboarding wizard.

### Channel Integration

To connect messaging platforms:

1. **WhatsApp**: Use the CLI to link device

   ```bash
   docker compose run --rm moltbot-cli channels login
   ```

2. **Telegram**: Set `TELEGRAM_BOT_TOKEN` in config

3. **Discord**: Set `DISCORD_BOT_TOKEN` in config

4. **Slack**: Set `SLACK_BOT_TOKEN` and `SLACK_APP_TOKEN` in config

See the [official documentation](https://docs.openclaw.bot/channels) for detailed setup instructions.

## Using the CLI

The CLI service is available via the `cli` profile:

```bash
# Run onboarding wizard
docker compose run --rm --service-ports openclaw-cli onboard

# List providers
docker compose run --rm openclaw-cli providers list

# Send a message
docker compose run --rm openclaw-cli message send --to +1234567890 --message "Hello"

# Check health
docker compose run --rm openclaw-cli health --port 18789
```

## Security Considerations

1. **Gateway Token**: Keep your gateway token secure. This is the authentication method for the Control UI and WebSocket connections.

2. **DM Access**: By default, OpenClaw uses pairing mode for direct messages from unknown senders. They receive a pairing code that you must approve.

3. **Network Exposure**: If exposing the gateway beyond localhost, use proper authentication and encryption:
   - Set up Tailscale for secure remote access
   - Use SSH tunnels
   - Implement reverse proxy with HTTPS and authentication

4. **API Keys**: Never commit API keys to version control. Use `.env` file or secrets management.

5. **Sandbox Mode**: For group/channel safety, enable sandbox mode to run non-main sessions in Docker containers.

## Advanced Configuration

### Resource Limits

Adjust CPU and memory limits in `.env`:

```env
OPENCLAW_CPU_LIMIT=2.0
OPENCLAW_MEMORY_LIMIT=2G
OPENCLAW_CPU_RESERVATION=1.0
OPENCLAW_MEMORY_RESERVATION=1G
```

### Persistent Data

Data is stored in two Docker volumes:

- `openclaw_config`: Configuration files and credentials (~/.openclaw)
- `openclaw_workspace`: Agent workspace and skills (~/openclaw-workspace)

To backup your data:

```bash
docker run --rm -v openclaw_config:/data -v $(pwd):/backup alpine tar czf /backup/openclaw-config-backup.tar.gz /data
docker run --rm -v openclaw_workspace:/data -v $(pwd):/backup alpine tar czf /backup/openclaw-workspace-backup.tar.gz /data
```

### Custom Configuration File

Create a custom config file at `~/.openclaw/openclaw.json` (inside the container):

```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "anthropic/claude-opus-4-5",
        "fallbacks": ["anthropic/claude-sonnet-4-5", "openai/gpt-4o"]
      }
    }
  }
}
```

## Troubleshooting

### Gateway Won't Start

1. Check logs: `docker compose logs openclaw-gateway`
2. Verify gateway token is set in `.env`
3. Ensure port 18789 is not already in use

### Can't Access Control UI

1. Verify gateway bind setting matches your access method
2. Check firewall rules if accessing from another machine
3. Ensure container is healthy: `docker compose ps`

### Model API Errors

1. Verify API keys are correctly set in `.env`
2. Check API key validity and quota
3. Review logs for specific error messages

### Run Doctor Command

The doctor command helps diagnose common issues:

```bash
docker compose run --rm openclaw-cli doctor
```

## Documentation

- [Official Website](https://openclaw.bot)
- [Full Documentation](https://docs.openclaw.bot)
- [Getting Started Guide](https://docs.openclaw.bot/start/getting-started)
- [Configuration Reference](https://docs.openclaw.bot/gateway/configuration)
- [Security Guide](https://docs.openclaw.bot/gateway/security)
- [Docker Installation](https://docs.openclaw.bot/install/docker)
- [GitHub Repository](https://github.com/openclaw/openclaw)

## License

OpenClaw is released under the MIT License. See the [LICENSE](https://github.com/openclaw/openclaw/blob/main/LICENSE) file for details.

## Community

- [Discord](https://discord.gg/clawd)
- [GitHub Discussions](https://github.com/openclaw/openclaw/discussions)
- [Issues](https://github.com/openclaw/openclaw/issues)
