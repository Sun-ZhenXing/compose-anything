# Pingap

[中文说明](./README.zh.md)

A high-performance reverse proxy built on Cloudflare Pingora, designed as a more efficient alternative to Nginx with dynamic configuration, hot-reloading capabilities, and an intuitive web admin interface.

## Features

- **High Performance**: Built on Cloudflare's Pingora framework for exceptional performance
- **Dynamic Configuration**: Hot-reload configuration changes without downtime
- **Web Admin Interface**: Manage your proxy through an intuitive web UI
- **Plugin Ecosystem**: Rich plugin support for extended functionality
- **Full Version Features**: Includes OpenTelemetry, Sentry, and image compression plugins
- **Zero Downtime**: Configuration changes applied without service interruption
- **TOML Configuration**: Simple and concise configuration files

## Quick Start

1. Copy the environment file and configure it:

   ```bash
   cp .env.example .env
   ```

2. **IMPORTANT**: Edit `.env` and set a strong password:

   ```bash
   PINGAP_ADMIN_PASSWORD=your-strong-password-here
   ```

3. Start the service:

   ```bash
   docker compose up -d
   ```

4. Access the web admin interface at:

   ```text
   http://localhost/pingap/
   ```

   - Default username: `admin`
   - Password: The one you set in `.env`

## Configuration

### Environment Variables

| Variable                     | Description                                | Default             |
| ---------------------------- | ------------------------------------------ | ------------------- |
| `PINGAP_VERSION`             | Image version (recommended: `0.12.1-full`) | `0.12.1-full`       |
| `PINGAP_HTTP_PORT_OVERRIDE`  | HTTP port on host                          | `80`                |
| `PINGAP_HTTPS_PORT_OVERRIDE` | HTTPS port on host                         | `443`               |
| `PINGAP_DATA_DIR`            | Data directory for persistent storage      | `./pingap`          |
| `PINGAP_ADMIN_ADDR`          | Admin interface address                    | `0.0.0.0:80/pingap` |
| `PINGAP_ADMIN_USER`          | Admin username                             | `admin`             |
| `PINGAP_ADMIN_PASSWORD`      | Admin password (REQUIRED)                  | -                   |
| `PINGAP_CPU_LIMIT`           | CPU limit                                  | `1.0`               |
| `PINGAP_MEMORY_LIMIT`        | Memory limit                               | `512M`              |

### Image Versions

- `vicanso/pingap:latest` - Latest development version (not recommended for production)
- `vicanso/pingap:full` - Latest development version with all features
- `vicanso/pingap:0.12.1` - Stable version without extra dependencies
- `vicanso/pingap:0.12.1-full` - **Recommended**: Stable version with OpenTelemetry, Sentry, and image compression

### Persistent Storage

Configuration and data are stored in the `PINGAP_DATA_DIR` directory (default: `./pingap`). This directory will be created automatically on first run.

## Usage

### Viewing Logs

```bash
docker compose logs -f pingap
```

### Restarting After Configuration Changes

While Pingap supports hot-reloading for most configuration changes (upstream, location, certificate), changes to server configuration require a restart:

```bash
docker compose restart pingap
```

### Stopping the Service

```bash
docker compose down
```

## Important Notes

### Security

- **Always set a strong password** for `PINGAP_ADMIN_PASSWORD`
- Change the default admin username if possible
- Consider restricting admin interface access to specific IPs
- Use HTTPS for the admin interface in production

### Production Recommendations

- Use versioned tags (e.g., `0.12.1-full`) instead of `latest` or `full`
- Configure appropriate resource limits based on your traffic
- Set up proper monitoring and logging
- Enable HTTPS with valid certificates
- Regular backups of the `pingap` data directory

### Docker Best Practices

- The container runs with `--autoreload` flag for hot configuration updates
- Avoid using `--autorestart` in Docker as it conflicts with container lifecycle
- Use `docker compose restart` for server-level configuration changes

## Links

- [Official Website](https://pingap.io/)
- [Documentation](https://pingap.io/pingap-zh/docs/docker)
- [GitHub Repository](https://github.com/vicanso/pingap)
- [Docker Hub](https://hub.docker.com/r/vicanso/pingap)

## License

This Docker Compose configuration is provided as-is. Pingap is licensed under the Apache License 2.0.
