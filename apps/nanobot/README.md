# Nanobot

[中文说明](README.zh.md) | [English](README.md)

Nanobot is a lightweight, production-ready personal AI assistant with multi-channel support (Telegram, Discord, WhatsApp, Feishu), local model integration, and powerful tool capabilities.

## Features

- 🤖 **Multi-Provider LLM Support**: OpenRouter, Anthropic, OpenAI, DeepSeek, Groq, Gemini, and more
- 🖥️ **Local Models**: Run your own models with vLLM or any OpenAI-compatible server
- 💬 **Multi-Channel**: Telegram, Discord, WhatsApp, and Feishu (飞书) integration
- 🛠️ **Powerful Tools**: File operations, shell execution, web search, and custom skills
- 📅 **Scheduled Tasks**: Cron-like job scheduling with natural language
- 🎯 **Memory & Skills**: Persistent memory and extensible skill system
- 🔒 **Security**: Sandbox mode, access control, and safe command execution

## Quick Start

### Prerequisites

- Docker and Docker Compose installed
- At least one LLM provider API key (recommended: [OpenRouter](https://openrouter.ai/keys))

### Setup

1. **Copy the example environment file:**

    ```bash
    cp .env.example .env
    ```

2. **Edit `.env` and configure at least one LLM provider:**

    ```bash
    # For OpenRouter (recommended for global access)
    OPENROUTER_API_KEY=sk-or-v1-xxxxx

    # Or use any other provider
    ANTHROPIC_API_KEY=sk-ant-xxxxx
    OPENAI_API_KEY=sk-xxxxx
    ```

3. **Start the service:**

    ```bash
    docker compose up -d
    ```

4. **Initialize configuration (first time only):**

    ```bash
    docker compose exec nanobot nanobot onboard
    ```

5. **Check status:**

    ```bash
    docker compose exec nanobot nanobot status
    ```

## Usage

### CLI Mode

Chat directly with nanobot:

```bash
docker compose exec nanobot nanobot agent -m "What is 2+2?"
```

Interactive mode:

```bash
docker compose exec nanobot nanobot agent
```

### Gateway Mode (Default)

The default `docker compose up` starts the gateway server which enables:

- Telegram bot integration
- Discord bot integration
- WhatsApp messaging (requires additional setup)
- Feishu/Lark integration
- HTTP API access (port 18790)

### Channel Setup

#### Telegram

1. Create a bot via [@BotFather](https://t.me/BotFather) on Telegram
2. Get your user ID from [@userinfobot](https://t.me/userinfobot)
3. Configure in `.env`:

    ```bash
    TELEGRAM_ENABLED=true
    TELEGRAM_TOKEN=your_bot_token
    ```

4. Restart the service

#### Discord

1. Create a bot at [Discord Developer Portal](https://discord.com/developers/applications)
2. Enable **MESSAGE CONTENT INTENT** in bot settings
3. Configure in `.env`:

    ```bash
    DISCORD_ENABLED=true
    DISCORD_TOKEN=your_bot_token
    ```

4. Restart the service

#### WhatsApp

Requires Node.js and additional setup. See [official documentation](https://github.com/HKUDS/nanobot#-chat-apps) for details.

#### Feishu (飞书)

1. Create an app at [Feishu Open Platform](https://open.feishu.cn/app)
2. Enable Bot capability and add `im:message` permission
3. Configure in `.env`:

    ```bash
    FEISHU_ENABLED=true
    FEISHU_APP_ID=your_app_id
    FEISHU_APP_SECRET=your_app_secret
    ```

4. Restart the service

## Configuration

### Environment Variables

See [.env.example](.env.example) for all available configuration options.

Key settings:

| Variable                | Description                                | Default                     |
| ----------------------- | ------------------------------------------ | --------------------------- |
| `NANOBOT_MODEL`         | LLM model to use                           | `anthropic/claude-opus-4-5` |
| `NANOBOT_COMMAND`       | Command to run (gateway, agent, status)    | `gateway`                   |
| `RESTRICT_TO_WORKSPACE` | Sandbox mode - restrict tools to workspace | `false`                     |
| `BRAVE_API_KEY`         | API key for web search tool                | (empty)                     |
| `TELEGRAM_ENABLED`      | Enable Telegram channel                    | `false`                     |
| `DISCORD_ENABLED`       | Enable Discord channel                     | `false`                     |

### LLM Provider Priority

When multiple providers are configured, nanobot will:

1. Match provider based on model name (e.g., `gpt-4` → OpenAI)
2. Fall back to first available API key

### Security

For production deployments:

- Set `RESTRICT_TO_WORKSPACE=true` to sandbox all file and shell operations
- Configure `allowFrom` lists in the config file for channel access control
- Use dedicated user accounts for channel integrations
- Monitor API usage and set spending limits
- Keep credentials in environment variables, never in code

## Scheduled Tasks

Run tasks on a schedule:

```bash
# Add a daily reminder
docker compose exec nanobot nanobot cron add \
  --name "morning" \
  --message "Good morning! What's on the agenda?" \
  --cron "0 9 * * *"

# List scheduled jobs
docker compose exec nanobot nanobot cron list

# Remove a job
docker compose exec nanobot nanobot cron remove <job_id>
```

## Local Models (vLLM)

Run nanobot with your own local models:

1. **Start a vLLM server:**

    ```bash
    vllm serve meta-llama/Llama-3.1-8B-Instruct --port 8000
    ```

2. **Configure in `.env`:**

    ```bash
    VLLM_API_KEY=dummy
    VLLM_API_BASE=http://host.docker.internal:8000/v1
    NANOBOT_MODEL=meta-llama/Llama-3.1-8B-Instruct
    ```

3. **Restart the service**

## Volumes

- `nanobot_config`: Configuration files and credentials
- `nanobot_workspace`: Agent workspace and files

## Ports

- `18790`: Gateway HTTP API (configurable via `NANOBOT_PORT_OVERRIDE`)

## Resource Limits

Default resource limits:

- CPU: 1.0 cores (limit), 0.5 cores (reservation)
- Memory: 1GB (limit), 512MB (reservation)

Adjust via environment variables: `NANOBOT_CPU_LIMIT`, `NANOBOT_MEMORY_LIMIT`, etc.

## Troubleshooting

### Check logs

```bash
docker compose logs -f nanobot
```

### Verify configuration

```bash
docker compose exec nanobot nanobot status
```

### Test LLM connection

```bash
docker compose exec nanobot nanobot agent -m "Hello!"
```

### Common issues

**No API key configured:**

- Ensure at least one provider API key is set in `.env`
- Restart the service after updating environment variables

**Channel not responding:**

- Check that the channel is enabled in `.env`
- Verify bot tokens are correct
- Check logs for connection errors

**File permission errors:**

- Ensure volumes have proper permissions
- Try running with `RESTRICT_TO_WORKSPACE=false` for debugging

## License

Nanobot is an open-source project. See the [official repository](https://github.com/HKUDS/nanobot) for license details.

## Links

- Official Repository: <https://github.com/HKUDS/nanobot>
- Documentation: <https://github.com/HKUDS/nanobot#readme>
- Issues: <https://github.com/HKUDS/nanobot/issues>
