# OpenCode

[English](./README.md) | [中文](./README.zh.md)

[OpenCode](https://github.com/anomalyco/opencode) is the open source AI coding agent built for the terminal and web. It allows you to use various LLM providers to automate coding tasks in your local or remote projects.

## Usage

1. Copy `.env.example` to `.env`.
2. Set your preferred LLM provider API key in `.env` (e.g., `ANTHROPIC_API_KEY`).
3. Set `OPENCODE_PROJECT_DIR` to the path of the project you want the agent to work on.
4. Run the service:

    ```bash
    docker compose up -d
    ```

5. Access the web interface at `http://localhost:4096`.

## Configuration

- `OPENCODE_VERSION`: The version of the OpenCode image (default: `1.1.27`).
- `OPENCODE_PORT_OVERRIDE`: The host port to expose the web interface (default: `4096`).
- `OPENCODE_PROJECT_DIR`: Path to the project codebase you want the agent to have access to.
- `ANTHROPIC_API_KEY`: API key for Anthropic Claude models.
- `OPENAI_API_KEY`: API key for OpenAI models.
- `GEMINI_API_KEY`: API key for Google Gemini models.
- `DEEPSEEK_API_KEY`: API key for DeepSeek models.

## Volumes

- `opencode_data`: Stores configuration, session data, and cache.
- Mounts the target project directory to `/app`.

## Resources

Default limits:

- CPU: 1.0
- Memory: 2G

You can override these in your `.env` file using `OPENCODE_CPU_LIMIT` and `OPENCODE_MEMORY_LIMIT`.
