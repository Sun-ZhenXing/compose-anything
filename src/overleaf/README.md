# Overleaf

Overleaf is a web-based collaborative LaTeX editor that makes the writing of technical documents as easy as pie. Write, compile, and download LaTeX documents online with automatic cloud backup.

## Quick Start

```bash
docker compose up -d
```

## Ports

| Service  | Port | Purpose       |
| -------- | ---- | ------------- |
| Overleaf | 8080 | Web Interface |

## Default Access

- Web UI: <http://localhost:8080>
- Create a new account or log in

## Environment Variables

Key environment variables:

- `OVERLEAF_VERSION`: Docker image version (default: 5.2.1)
- `OVERLEAF_PORT_OVERRIDE`: Override default HTTP port (default: 8080)
- `SHARELATEX_APP_NAME`: Application name (default: Overleaf)
- `SHARELATEX_ADMIN_EMAILS`: Admin email addresses
- `ENABLE_SUBSCRIPTIONS`: Enable subscription features (default: false)

See `.env.example` for all available options.

## Services Included

- **Overleaf**: Main application
- **MongoDB**: Project and user data storage
- **Redis**: Session and cache management

## Features

- Real-time collaborative editing
- Rich text and code editors
- Instant preview of compiled documents
- Version control and history
- Templates library
- Git integration (Pro)

## Documentation

- [Overleaf Official Docs](https://www.overleaf.com/learn)
- [Community Server Setup](https://www.overleaf.com/help/207-how-does-overleaf-help-with-group-collaboration)

## License

AGPL License (Community Edition)
