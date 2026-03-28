# OpenFang

[中文文档](README.zh.md)

OpenFang is an open-source agent operating system. This Compose setup builds the upstream Docker image from the `v0.1.0` source tag and writes a minimal `config.toml` into the persistent data volume on startup.

## Quick Start

1. Copy the example environment file:

   ```bash
   cp .env.example .env
   ```

2. Set at least one provider API key in `.env`:

   - `ANTHROPIC_API_KEY`
   - `OPENAI_API_KEY`
   - `GROQ_API_KEY`

3. Start OpenFang:

   ```bash
   docker compose up -d
   ```

4. Open the dashboard:

   - <http://localhost:4200>

5. Verify health if needed:

   ```bash
   curl http://localhost:4200/api/health
   ```

## Default Ports

| Service  | Port | Description            |
| -------- | ---- | ---------------------- |
| OpenFang | 4200 | Dashboard and REST API |

## Important Environment Variables

| Variable                 | Description                                                        | Default                    |
| ------------------------ | ------------------------------------------------------------------ | -------------------------- |
| `OPENFANG_VERSION`       | Git tag used for the source build                                  | `0.1.0`                    |
| `OPENFANG_PORT_OVERRIDE` | Host port for OpenFang                                             | `4200`                     |
| `OPENFANG_PROVIDER`      | Default model provider                                             | `anthropic`                |
| `OPENFANG_MODEL`         | Default model name                                                 | `claude-sonnet-4-20250514` |
| `OPENFANG_API_KEY_ENV`   | Environment variable name that OpenFang reads for the provider key | `ANTHROPIC_API_KEY`        |
| `OPENFANG_API_KEY`       | Optional Bearer token to protect the API                           | -                          |
| `ANTHROPIC_API_KEY`      | Anthropic API key                                                  | -                          |
| `OPENAI_API_KEY`         | OpenAI API key                                                     | -                          |
| `GROQ_API_KEY`           | Groq API key                                                       | -                          |
| `TZ`                     | Container timezone                                                 | `UTC`                      |

## Volumes

- `openfang_data`: Persistent configuration and runtime data under `/data`.

## Notes

- The generated config binds to `0.0.0.0:4200` for container use.
- If `OPENFANG_API_KEY` is empty, the instance runs without API authentication except for whatever protections you place in front of it.
- This setup uses the upstream Dockerfile, so the first build can take several minutes.

## References

- [OpenFang Repository](https://github.com/RightNow-AI/openfang)
- [Getting Started Guide](https://github.com/RightNow-AI/openfang/blob/main/docs/getting-started.md)
