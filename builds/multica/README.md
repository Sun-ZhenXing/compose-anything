# Multica

[English](./README.md) | [中文](./README.zh.md)

Multica is an open-source managed agents platform that turns coding agents into real teammates. Assign tasks, track progress, and compound reusable skills — works with Claude Code, Codex, OpenClaw, and OpenCode. This Compose setup builds the Go backend and Next.js frontend from source, starts PostgreSQL with pgvector, and exposes both services.

## Services

- **multica-backend**: Go backend (Chi router, sqlc, gorilla/websocket) with auto-migration on startup
- **multica-frontend**: Next.js 16 web application (App Router, standalone output)
- **multica-postgres**: PostgreSQL 17 with pgvector extension

## Quick Start

1. Copy the example environment file:

   ```bash
   cp .env.example .env
   ```

2. Edit `.env` and change `MULTICA_JWT_SECRET` to a secure random value:

   ```bash
   MULTICA_JWT_SECRET=$(openssl rand -base64 32)
   ```

3. Start the stack (first run builds images from source — this takes several minutes):

   ```bash
   docker compose up -d
   ```

4. Open Multica:

   - Frontend: <http://localhost:3000>
   - Backend API: <http://localhost:8080>

## Default Ports

| Service  | Port | Description            |
| -------- | ---- | ---------------------- |
| Frontend | 3000 | Web UI                 |
| Backend  | 8080 | REST API and WebSocket |
| Postgres | 5432 | Internal only          |

## Important Environment Variables

| Variable                         | Description                                | Default                   |
| -------------------------------- | ------------------------------------------ | ------------------------- |
| `MULTICA_VERSION`                | Git ref used for source builds             | `v0.1.32`                 |
| `MULTICA_BACKEND_PORT_OVERRIDE`  | Host port for the backend API              | `8080`                    |
| `MULTICA_FRONTEND_PORT_OVERRIDE` | Host port for the web UI                   | `3000`                    |
| `MULTICA_JWT_SECRET`             | JWT signing secret (change for production) | `change-me-in-production` |
| `MULTICA_POSTGRES_PASSWORD`      | PostgreSQL password                        | `multica`                 |
| `MULTICA_FRONTEND_ORIGIN`        | Frontend URL for CORS and cookies          | `http://localhost:3000`   |
| `MULTICA_GOOGLE_CLIENT_ID`       | Google OAuth client ID (optional)          | -                         |
| `MULTICA_GOOGLE_CLIENT_SECRET`   | Google OAuth client secret (optional)      | -                         |
| `MULTICA_RESEND_API_KEY`         | Resend API key for email (optional)        | -                         |
| `TZ`                             | Container timezone                         | `UTC`                     |

## Storage

| Volume           | Description     |
| ---------------- | --------------- |
| `multica_pgdata` | PostgreSQL data |

## Security Notes

- Always change `MULTICA_JWT_SECRET` before exposing the service.
- Change `MULTICA_POSTGRES_PASSWORD` for production deployments.
- Google OAuth and email (Resend) are optional; the platform works without them.
- The first build downloads the full Multica repository from GitHub and builds Docker images, so it requires internet access and may take several minutes.

## References

- [Multica Repository](https://github.com/multica-ai/multica)
- [Self-Hosting Guide](https://github.com/multica-ai/multica/blob/main/SELF_HOSTING.md)
