# goose

[中文文档](README.zh.md)

goose is an AI-powered developer agent created by Block. It helps developers with coding tasks through natural language interaction, offering intelligent code generation, debugging assistance, and project navigation.

## Features

- **AI-Powered Development**: Leverage advanced language models for coding assistance
- **Multiple AI Providers**: Support for OpenAI, Anthropic, and Google AI
- **Interactive CLI**: Engage with goose through an intuitive command-line interface
- **Project Understanding**: Analyze and understand your codebase context
- **Code Generation**: Generate code snippets and implementations
- **Debugging Help**: Assist with troubleshooting and error resolution

## Prerequisites

- Docker and Docker Compose installed
- An API key from one of the supported AI providers:
  - OpenAI API key (for GPT models)
  - Anthropic API key (for Claude models)
  - Google API key (for Gemini models)

## Quick Start

1. Copy the example environment file:

    ```bash
    cp .env.example .env
    ```

2. Edit `.env` and configure your API credentials:

    ```bash
    # For OpenAI
    OPENAI_API_KEY=your_openai_api_key_here
    GOOSE_PROVIDER=openai
    GOOSE_MODEL=gpt-4

    # OR for Anthropic
    ANTHROPIC_API_KEY=your_anthropic_api_key_here
    GOOSE_PROVIDER=anthropic
    GOOSE_MODEL=claude-3-sonnet

    # OR for Google
    GOOGLE_API_KEY=your_google_api_key_here
    GOOSE_PROVIDER=google
    GOOSE_MODEL=gemini-pro
    ```

3. Build the Docker image:

    ```bash
    docker compose build
    ```

4. Run goose:

    ```bash
    docker compose run --rm goose
    ```

## Usage Examples

### Interactive Session

Start an interactive session with goose:

```bash
docker compose run --rm goose session start
```

### Execute a Task

Run a specific task or query:

```bash
docker compose run --rm goose run "explain the main function in app.py"
```

### Get Help

View available commands:

```bash
docker compose run --rm goose --help
```

## Configuration

### Environment Variables

| Variable             | Description                             | Default  |
| -------------------- | --------------------------------------- | -------- |
| `GOOSE_VERSION`      | goose Docker image version              | `1.18.0` |
| `TZ`                 | Container timezone                      | `UTC`    |
| `GOOSE_PROVIDER`     | AI provider (openai, anthropic, google) | `openai` |
| `GOOSE_MODEL`        | AI model to use                         | `gpt-4`  |
| `OPENAI_API_KEY`     | OpenAI API key                          | -        |
| `OPENAI_API_BASE`    | Custom OpenAI API base URL              | -        |
| `ANTHROPIC_API_KEY`  | Anthropic API key                       | -        |
| `GOOGLE_API_KEY`     | Google API key                          | -        |
| `GOOSE_CPU_LIMIT`    | CPU limit                               | `2.00`   |
| `GOOSE_MEMORY_LIMIT` | Memory limit                            | `2G`     |

### Working with Your Project

Mount your project directory to work with your code:

```bash
docker compose run --rm -v $(pwd):/workspace goose
```

Or add it to the `docker-compose.yaml` volumes section:

```yaml
volumes:
  - ./your-project:/workspace
  - goose_config:/home/goose/.config/goose
```

## Persistent Configuration

Configuration and session data are stored in named volumes:

- `goose_config`: User configuration and preferences
- `goose_workspace`: Workspace files and project data

To reset configuration:

```bash
docker compose down -v
```

## Resource Limits

Default resource allocations:

- **CPU Limit**: 2.00 cores
- **CPU Reservation**: 0.50 cores
- **Memory Limit**: 2G
- **Memory Reservation**: 512M

Adjust these in `.env` based on your system capabilities.

## Security Considerations

1. **API Keys**: Never commit your `.env` file with API keys to version control
2. **Workspace Access**: goose has access to files in the mounted workspace directory
3. **Network**: The container runs without exposed ports by default
4. **User Privileges**: Runs as non-root user (UID 1000) for enhanced security

## Supported AI Models

### OpenAI

- `gpt-4` (recommended)
- `gpt-4-turbo`
- `gpt-3.5-turbo`

### Anthropic

- `claude-3-opus`
- `claude-3-sonnet` (recommended)
- `claude-3-haiku`

### Google

- `gemini-pro`

## Troubleshooting

### API Authentication Errors

Ensure your API key is correctly set in `.env` and matches your chosen provider.

### Out of Memory

If you encounter memory issues, increase `GOOSE_MEMORY_LIMIT` in `.env`.

### Build Failures

The initial build may take 15-30 minutes as it compiles goose from source. Ensure you have a stable internet connection.

## References

- [Official GitHub Repository](https://github.com/block/goose)
- [Documentation](https://block.github.io/goose/)
- [Contributing Guide](https://github.com/block/goose/blob/main/CONTRIBUTING.md)

## License

goose is released under the Apache-2.0 License. See the [official repository](https://github.com/block/goose) for details.

This Docker Compose configuration is provided as-is for convenience and follows the project's license terms.
