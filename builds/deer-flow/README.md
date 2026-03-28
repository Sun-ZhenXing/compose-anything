# DeerFlow

[中文文档](README.zh.md)

DeerFlow is a full-stack AI agent application from ByteDance. This Compose setup builds the frontend and backend from source, starts Gateway, LangGraph, and Nginx, and exposes the unified entrypoint on port 2026.

## Quick Start

1. Copy the example environment file:

   ```bash
   cp .env.example .env
   ```

2. Edit `.env` and set `OPENAI_API_KEY`.

3. Start the stack:

   ```bash
   docker compose up -d
   ```

4. Open DeerFlow:

   - <http://localhost:2026>

## Default Ports

| Service     | Port | Description            |
| ----------- | ---- | ---------------------- |
| Nginx       | 2026 | Unified web entrypoint |
| Gateway API | 8001 | Internal only          |
| LangGraph   | 2024 | Internal only          |
| Frontend    | 3000 | Internal only          |

## Important Environment Variables

| Variable                       | Description                                            | Default                          |
| ------------------------------ | ------------------------------------------------------ | -------------------------------- |
| `DEER_FLOW_VERSION`            | Git ref used for source builds                         | `main`                           |
| `DEER_FLOW_PORT_OVERRIDE`      | Host port for the unified entrypoint                   | `2026`                           |
| `OPENAI_API_KEY`               | OpenAI API key referenced from generated `config.yaml` | -                                |
| `DEER_FLOW_MODEL_NAME`         | Internal model identifier                              | `openai-default`                 |
| `DEER_FLOW_MODEL_DISPLAY_NAME` | Display name shown in the app                          | `OpenAI`                         |
| `DEER_FLOW_MODEL_ID`           | OpenAI model id                                        | `gpt-4.1-mini`                   |
| `DEER_FLOW_CORS_ORIGINS`       | Allowed CORS origins for the gateway                   | `http://localhost:2026`          |
| `DEER_FLOW_BETTER_AUTH_SECRET` | Frontend auth secret                                   | `deer-flow-dev-secret-change-me` |
| `TZ`                           | Container timezone                                     | `UTC`                            |

## Notes

- This setup generates a minimal `config.yaml` and `extensions_config.json` inside the backend containers, so no extra config files are required.
- The default sandbox mode is local to avoid requiring Docker socket mounts or Kubernetes provisioner setup.
- DeerFlow upstream usually expects local image builds, so the first build can take several minutes.
- Only an OpenAI-compatible model is wired by default here. If you want Anthropic, Gemini, or a more advanced config, update the generated template logic in `docker-compose.yaml`.

## References

- [DeerFlow Repository](https://github.com/bytedance/deer-flow)
- [Project README](https://github.com/bytedance/deer-flow/blob/main/README.md)
