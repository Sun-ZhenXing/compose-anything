# Pingora Proxy Manager

A high-performance, zero-downtime reverse proxy manager built on Cloudflare's [Pingora](https://github.com/cloudflare/pingora). Simple, Modern, and Fast.

## Features

- **⚡️ High Performance**: Built on Rust & Pingora, capable of handling high traffic with low latency
- **🔄 Zero-Downtime Configuration**: Dynamic reconfiguration without restarting the process
- **🔒 SSL/TLS Automation**:
  - HTTP-01 challenge for single domains
  - DNS-01 challenge for wildcard certificates (`*.example.com`) via Cloudflare, AWS Route53, etc.
- **🌐 Proxy Hosts**: Easy management of virtual hosts, locations, and path rewriting
- **📡 Streams (L4)**: TCP and UDP forwarding for databases, game servers, etc.
- **🛡️ Access Control**: IP whitelisting/blacklisting and Basic Authentication support
- **🎨 Modern Dashboard**: Clean and responsive UI built with React, Tailwind CSS, and shadcn/ui
- **🐳 Docker Ready**: Single container deployment for easy setup and maintenance

## Quick Start

```bash
docker compose up -d
```

Access the dashboard at `http://localhost:81`.

**Default Credentials:**

- Username: `admin`
- Password: `changeme` (Please change this immediately!)

## Ports

| Port                         | Description   |
| ---------------------------- | ------------- |
| 80 (host) → 8080 (container) | HTTP Proxy    |
| 81 (host) → 81 (container)   | Dashboard/API |
| 443 (host) → 443 (container) | HTTPS Proxy   |

## Environment Variables

| Variable                          | Default                         | Description                                              |
| --------------------------------- | ------------------------------- | -------------------------------------------------------- |
| `PINGORA_VERSION`                 | `latest`                        | Docker image version                                     |
| `TZ`                              | `UTC`                           | Timezone                                                 |
| `PINGORA_JWT_SECRET`              | `changeme_in_production_please` | JWT secret for authentication (**change in production**) |
| `PINGORA_LOG_LEVEL`               | `info`                          | Log level (trace, debug, info, warn, error)              |
| `PINGORA_HTTP_PORT_OVERRIDE`      | `80`                            | Host port for HTTP proxy                                 |
| `PINGORA_DASHBOARD_PORT_OVERRIDE` | `81`                            | Host port for Dashboard/API                              |
| `PINGORA_HTTPS_PORT_OVERRIDE`     | `443`                           | Host port for HTTPS proxy                                |

## Volumes

| Volume         | Path               | Description                      |
| -------------- | ------------------ | -------------------------------- |
| `pingora_data` | `/app/data`        | SQLite database and certificates |
| `pingora_logs` | `/app/logs`        | Application logs                 |
| `letsencrypt`  | `/etc/letsencrypt` | Let's Encrypt certificates       |

## Architecture

- **Data Plane (8080/443)**: Pingora handles all traffic with high efficiency
- **Control Plane (81)**: Axum serves the API and Dashboard
- **SSL Management**: Integrated Certbot for robust ACME handling
- **State Management**: ArcSwap for lock-free configuration reads
- **Database**: SQLite for persistent storage of hosts and certificates

## Security Notes

- **Always change the default credentials** immediately after deployment
- **Set a strong `JWT_SECRET`** in production environments
- The container runs with minimal capabilities (`NET_BIND_SERVICE` only)
- Read-only root filesystem enabled for enhanced security

## References

- [Pingora Proxy Manager GitHub](https://github.com/DDULDDUCK/pingora-proxy-manager)
- [Cloudflare Pingora](https://github.com/cloudflare/pingora)
- [Docker Hub](https://hub.docker.com/r/dduldduck/pingora-proxy-manager)

## License

MIT License - see the [upstream project](https://github.com/DDULDDUCK/pingora-proxy-manager/blob/master/LICENSE) for details.
