# LibreChat

[English](./README.md) | [中文](./README.zh.md)

Quick start: <https://docs.librechat.ai>.

This service deploys LibreChat, an open-source AI chat platform that supports OpenAI, Anthropic, Google, Ollama, and many other providers in a single unified interface with conversation history, file uploads, code execution, and multi-user support.

## Services

- **librechat**: The LibreChat web application (Node.js).
- **mongodb**: MongoDB database for conversation and user data.
- **meilisearch**: Full-text search engine for message indexing.

## Quick Start

1. Copy `.env.example` to `.env`:

   ```bash
   cp .env.example .env
   ```

2. Update the secrets in `.env` (generate with `openssl rand -hex 32`):

   ```
   JWT_SECRET, JWT_REFRESH_SECRET, MEILI_MASTER_KEY, CREDS_KEY, CREDS_IV
   ```

3. Start the services:

   ```bash
   docker compose up -d
   ```

4. Open `http://localhost:3080` and register the first user account.

## Core Environment Variables

| Variable              | Description                                              | Default                      |
| --------------------- | -------------------------------------------------------- | ---------------------------- |
| `LIBRECHAT_VERSION`   | Image version                                            | `v0.8.4`                     |
| `LIBRECHAT_PORT_OVERRIDE` | Host port for the web UI                            | `3080`                       |
| `JWT_SECRET`          | JWT signing secret (min 32 chars) — **CHANGEME**         | placeholder                  |
| `JWT_REFRESH_SECRET`  | JWT refresh signing secret — **CHANGEME**                | placeholder                  |
| `MEILI_MASTER_KEY`    | Meilisearch master key — **CHANGEME**                    | placeholder                  |
| `CREDS_KEY`           | Encryption key for stored credentials (exactly 32 chars) | placeholder                  |
| `CREDS_IV`            | Encryption IV (exactly 16 chars)                         | placeholder                  |
| `ALLOW_REGISTRATION`  | Allow new user registration                              | `true`                       |
| `OPENAI_API_KEY`      | OpenAI API key (optional; can also configure in UI)      | *(empty)*                    |
| `ANTHROPIC_API_KEY`   | Anthropic API key (optional)                             | *(empty)*                    |

## Volumes

- `librechat_images`: User-uploaded images served by the web UI.
- `librechat_logs`: Application log files.
- `librechat_mongo_data`: MongoDB data persistence.
- `librechat_meilisearch_data`: Meilisearch index data.

## Ports

- **3080**: LibreChat web UI

## Security Notes

- Generate all secrets before any external exposure: `openssl rand -hex 32`
- `CREDS_KEY` and `CREDS_IV` encrypt stored API keys — losing them makes stored credentials unrecoverable.
- Set `ALLOW_REGISTRATION=false` after creating admin accounts to lock down signups.

## Resource Requirements

| Service      | CPU Limit | Memory Limit |
| ------------ | --------- | ------------ |
| librechat    | 2         | 2 GB         |
| mongodb      | 1         | 1 GB         |
| meilisearch  | 0.5       | 512 MB       |

Total recommended: **4+ GB RAM**.

## Documentation

- [LibreChat Docs](https://docs.librechat.ai)
- [GitHub](https://github.com/danny-avila/LibreChat)
