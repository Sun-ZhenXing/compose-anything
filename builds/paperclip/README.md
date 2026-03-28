# Paperclip

[中文文档](README.zh.md)

Paperclip is an open-source orchestration platform for running AI-native teams. This Compose setup builds the upstream Docker image from source, persists the full Paperclip home directory, and exposes the web UI on port 3100.

## Quick Start

1. Copy the example environment file:

   ```bash
   cp .env.example .env
   ```

2. Optionally edit `.env`:

   - Set `PAPERCLIP_PUBLIC_URL` if you are not using `http://localhost:3100`
   - Add `OPENAI_API_KEY` and or `ANTHROPIC_API_KEY` for local adapters
   - Set `DATABASE_URL` if you want to use an external PostgreSQL instance instead of the embedded database

3. Start the service:

   ```bash
   docker compose up -d
   ```

4. Open the UI:

   - <http://localhost:3100>

5. Follow the Paperclip onboarding flow in the browser.

## Default Ports

| Service   | Port | Description    |
| --------- | ---- | -------------- |
| Paperclip | 3100 | Web UI and API |

## Important Environment Variables

| Variable                        | Description                              | Default                 |
| ------------------------------- | ---------------------------------------- | ----------------------- |
| `PAPERCLIP_GIT_REF`             | Git ref used for the source build        | `main`                  |
| `PAPERCLIP_PORT_OVERRIDE`       | Host port for Paperclip                  | `3100`                  |
| `PAPERCLIP_PUBLIC_URL`          | Public URL for auth and invite flows     | `http://localhost:3100` |
| `PAPERCLIP_ALLOWED_HOSTNAMES`   | Extra allowed hostnames                  | `localhost`             |
| `PAPERCLIP_DEPLOYMENT_MODE`     | Deployment mode                          | `authenticated`         |
| `PAPERCLIP_DEPLOYMENT_EXPOSURE` | Exposure mode                            | `private`               |
| `DATABASE_URL`                  | Optional external PostgreSQL URL         | -                       |
| `OPENAI_API_KEY`                | OpenAI key for bundled local adapters    | -                       |
| `ANTHROPIC_API_KEY`             | Anthropic key for bundled local adapters | -                       |
| `TZ`                            | Container timezone                       | `UTC`                   |

## Volumes

- `paperclip_data`: Stores embedded PostgreSQL data, uploaded files, secrets, and runtime state.

## Notes

- If `DATABASE_URL` is not provided, Paperclip automatically uses embedded PostgreSQL.
- The upstream Docker image includes the UI and server in one container.
- The first source build can take several minutes.

## References

- [Paperclip Repository](https://github.com/paperclipai/paperclip)
- [Docker Deployment Guide](https://github.com/paperclipai/paperclip/blob/main/docs/deploy/docker.md)
