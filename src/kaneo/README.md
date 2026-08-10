# Kaneo

[English](./README.md) | [中文](./README.zh.md)

This service deploys [Kaneo](https://kaneo.app), an open-source kanban and project management platform. Kaneo offers workspaces, projects, customizable workflows, labels, and time tracking, plus integrations with GitHub, Gitea, Slack, Discord, and Telegram. It supports SSO (OIDC) and ships a built-in MCP server at `/api/mcp`.

## Services

- `kaneo`: The Kaneo application server (web UI + API).
- `postgres`: PostgreSQL database storing all Kaneo data.

## Quick Start

1. Create a `.env` file from the example:

   ```bash
   cp .env.example .env
   ```

2. Edit `.env` and set the required values:

   ```env
   AUTH_SECRET=your-32-char-minimum-random-secret
   POSTGRES_PASSWORD=your-secure-db-password
   ```

   Generate a secret with `openssl rand -hex 32`. See [Security Notes](#security-notes) for why `AUTH_SECRET` matters.

3. Start the services:

   ```bash
   docker compose up -d
   ```

4. Open `http://localhost:5173` in your browser.

5. The first user to register becomes the workspace owner. Registration is open by default; once you have your account, lock it down by adding `DISABLE_REGISTRATION=true` to the `kaneo` service environment (or set the equivalent app setting).

## Environment Variables

| Variable Name        | Description                          | Default Value          |
| -------------------- | ------------------------------------ | ---------------------- |
| KANEO_VERSION        | Kaneo image version                  | `2.16.2`               |
| POSTGRES_VERSION     | PostgreSQL image version             | `16.14-alpine`         |
| KANEO_PORT_OVERRIDE  | Host port for the Kaneo web interface | `5173`                 |
| KANEO_CLIENT_URL     | Public URL clients use to reach Kaneo | `http://localhost:5173` |
| AUTH_SECRET          | Session signing secret (required, min 32 chars) | *(none)*    |
| POSTGRES_DB          | PostgreSQL database name             | `kaneo`                |
| POSTGRES_USER        | PostgreSQL user                      | `kaneo`                |
| POSTGRES_PASSWORD    | PostgreSQL password                  | `kaneo123`             |
| KANEO_CPU_LIMIT      | Kaneo CPU limit                      | `1.0`                  |
| KANEO_MEMORY_LIMIT   | Kaneo memory limit                   | `1G`                   |
| POSTGRES_CPU_LIMIT   | PostgreSQL CPU limit                 | `1.0`                  |
| POSTGRES_MEMORY_LIMIT| PostgreSQL memory limit              | `1G`                   |

## Storage

All application data is stored in the `postgres_data` named volume, managed by the `postgres` service.

Uploads attached to descriptions and comments are kept inside the container's ephemeral filesystem by default. For persistent uploads, configure S3-compatible object storage (e.g., MinIO) in the Kaneo settings — the app runs fine without it, but uploads will be lost on container recreation.

## Security Notes

- **Open registration**: registration is enabled by default, so anyone who can reach the app can create an account. Register your account first, then disable registration (e.g., `DISABLE_REGISTRATION=true`).
- **AUTH_SECRET**: required and must be at least 32 characters. If it is unset or changes, all user sessions are invalidated on restart. Generate with `openssl rand -hex 32`.
- **POSTGRES_PASSWORD**: change the default (`kaneo123`) before exposing the service beyond localhost.
- **Image source**: the image is pulled from GitHub Container Registry (`ghcr.io/usekaneo/kaneo`) and pinned to version `2.16.2`. The health check probes `http://127.0.0.1:5173/api/health`.
