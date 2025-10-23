# SearXNG

[English](./README.md) | [中文](./README.zh.md)

This service deploys SearXNG, a privacy-respecting metasearch engine that aggregates results from multiple search engines without tracking users.

## Services

- `searxng`: The SearXNG metasearch engine
- `redis`: Valkey (Redis-compatible) for caching search results
- `caddy`: Reverse proxy and HTTPS termination (uses host network mode)

## Environment Variables

| Variable Name         | Description                                                                    | Default Value         |
| --------------------- | ------------------------------------------------------------------------------ | --------------------- |
| SEARXNG_VERSION       | SearXNG image version                                                          | `2025.1.20-1ce14ef99` |
| SEARXNG_PORT_OVERRIDE | Host port mapping for SearXNG (maps to port 8080 in container)                 | 8080                  |
| SEARXNG_HOSTNAME      | Hostname for Caddy reverse proxy                                               | `http://localhost`    |
| LETSENCRYPT_EMAIL     | Email for Let's Encrypt HTTPS certificates (set to "internal" for self-signed) | `internal`            |
| SEARXNG_UWSGI_WORKERS | Number of uWSGI worker processes                                               | 4                     |
| SEARXNG_UWSGI_THREADS | Number of uWSGI threads per worker                                             | 4                     |
| VALKEY_VERSION        | Valkey (Redis) image version                                                   | `8-alpine`            |
| CADDY_VERSION         | Caddy reverse proxy version                                                    | `2-alpine`            |
| TZ                    | Timezone setting                                                               | `UTC`                 |

Please modify the `.env` file as needed for your use case.

## Volumes

- `caddy-data`: Caddy data storage (certificates, etc.)
- `caddy-config`: Caddy configuration
- `valkey-data`: Valkey data persistence
- `./searxng`: SearXNG configuration directory (mounted to `/etc/searxng`)

## Ports

- `8080`: SearXNG Web UI (via Caddy reverse proxy when using host network mode)

## Configuration

### SearXNG Settings

Edit configuration files in the `./searxng` directory to customize:

- Search engines to use
- UI theme and appearance
- Privacy settings
- Result filtering

### HTTPS with Let's Encrypt

To enable HTTPS with Let's Encrypt certificates:

1. Set `LETSENCRYPT_EMAIL` to your email address in `.env`
2. Set `SEARXNG_HOSTNAME` to your domain name (e.g., `https://search.example.com`)
3. Ensure ports 80 and 443 are accessible from the internet
4. Create or update the `Caddyfile` with your domain configuration

### Self-Signed Certificates

By default (`LETSENCRYPT_EMAIL=internal`), Caddy will use self-signed certificates for HTTPS.

## First-Time Setup

1. Start the services
2. Access SearXNG at `http://localhost:8080` (or your configured hostname)
3. Configure your browser to use SearXNG as the default search engine (optional)
4. Customize settings through the web interface

## Additional Information

- Official Documentation: <https://docs.searxng.org/>
- GitHub Repository: <https://github.com/searxng/searxng>
- Original Project: <https://github.com/searxng/searxng-docker>
