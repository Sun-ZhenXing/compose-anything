# OpenViking

[中文文档](README.zh.md)

OpenViking is an agent-native context database from Volcengine. This Compose setup runs the official container image and bootstraps a minimal ov.conf from environment variables so the service can start with a single command.

## Quick Start

1. Copy the example environment file:

   ```bash
   cp .env.example .env
   ```

2. Edit `.env` and set at least:

   - `OPENVIKING_ROOT_API_KEY`
   - `OPENVIKING_EMBEDDING_API_KEY`
   - `OPENVIKING_VLM_API_KEY`

3. Start the service:

   ```bash
   docker compose up -d
   ```

4. Verify health:

   ```bash
   curl http://localhost:1933/health
   ```

## Default Ports

| Service    | Port | Description                  |
| ---------- | ---- | ---------------------------- |
| OpenViking | 1933 | HTTP API and health endpoint |

## Important Environment Variables

| Variable                       | Description                                     | Default                   |
| ------------------------------ | ----------------------------------------------- | ------------------------- |
| `OPENVIKING_VERSION`           | OpenViking image tag                            | `main`                    |
| `OPENVIKING_PORT_OVERRIDE`     | Host port for the HTTP API                      | `1933`                    |
| `OPENVIKING_ROOT_API_KEY`      | Root API key required when binding to `0.0.0.0` | `openviking-dev-root-key` |
| `OPENVIKING_EMBEDDING_API_KEY` | API key for the embedding model                 | -                         |
| `OPENVIKING_EMBEDDING_MODEL`   | Embedding model name                            | `text-embedding-3-small`  |
| `OPENVIKING_VLM_API_KEY`       | API key for the VLM / multimodal model          | -                         |
| `OPENVIKING_VLM_MODEL`         | VLM model name                                  | `gpt-4o-mini`             |
| `TZ`                           | Container timezone                              | `UTC`                     |

## Volumes

- `openviking_data`: Persistent workspace and local storage data.

## Notes

- This setup generates `ov.conf` at container start from `.env`, so no extra config file is required.
- The service can start without model API keys, but indexing and multimodal features will not work until valid credentials are provided.
- `/health` is unauthenticated and is used by the healthcheck.

## References

- [OpenViking Repository](https://github.com/volcengine/OpenViking)
- [Deployment Guide](https://github.com/volcengine/OpenViking/blob/main/docs/en/guides/03-deployment.md)
