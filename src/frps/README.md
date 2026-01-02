# FRPS (FRP Server)

[English](./README.md) | [中文](./README.zh.md)

FRPS is a fast reverse proxy server that helps expose local servers behind NAT and firewalls to the internet. This is the server component of the FRP (Fast Reverse Proxy) tool.

## Quick Start

1. Create a `.env` file from `.env.example`:

    ```bash
    cp .env.example .env
    ```

2. Edit the `.env` file and configure authentication credentials:

    ```properties
    FRP_SERVER_TOKEN=your_secure_token_here
    FRP_ADMIN_USER=your_admin_username
    FRP_ADMIN_PASSWORD=your_secure_password
    ```

3. Create a `frps.toml` configuration file or use the provided template.

4. Start the service:

    ```bash
    docker compose up -d
    ```

The server will be accessible on:

- FRP server port: `7000` (default)
- Admin dashboard: `http://localhost:7500` (default)

## Configuration File

Example `frps.toml`:

```toml
bindPort = {{ .Envs.FRP_SERVER_PORT }}

auth.method = "{{ .Envs.FRP_AUTH_METHOD }}"
auth.token = "{{ .Envs.FRP_SERVER_TOKEN }}"

webServer.addr = "{{ .Envs.FRP_ADMIN_ADDR }}"
webServer.port = {{ .Envs.FRP_ADMIN_PORT }}
webServer.user = "{{ .Envs.FRP_ADMIN_USER }}"
webServer.password = "{{ .Envs.FRP_ADMIN_PASSWORD }}"
```

## Network Modes

### Standard Mode (Default)

Uses port mapping as configured in `docker-compose.yaml`.

### Host Network Mode

For better performance and access to all ports, use host network mode:

```yaml
services:
  frps:
    # ...
    network_mode: host
```

**Note**: When using host network mode, the `ports` section is ignored and the service directly uses host ports.

## Environment Variables

### Image Configuration

- `GLOBAL_REGISTRY`: Optional global registry prefix for pulling images
- `FRPS_VERSION`: FRPS image version (default: `0.65.0`)
- `TZ`: Timezone setting (default: `UTC`)

### Server Configuration

- `FRP_AUTH_METHOD`: Authentication method (default: `token`)
- `FRP_SERVER_TOKEN`: Token for client authentication (**change this for security**)
- `FRP_SERVER_PORT`: FRP server port (default: `7000`)

### Admin Dashboard

- `FRP_ADMIN_ADDR`: Admin dashboard bind address (default: `0.0.0.0`)
- `FRP_ADMIN_PORT`: Admin dashboard port (default: `7500`)
- `FRP_ADMIN_USER`: Admin dashboard username (default: `admin`)
- `FRP_ADMIN_PASSWORD`: Admin dashboard password (**change this for security**)

### Port Overrides

- `FRP_PORT_OVERRIDE_SERVER`: Host port to map to FRP server port (default: `7000`)
- `FRP_PORT_OVERRIDE_ADMIN`: Host port to map to admin dashboard (default: `7500`)

### Resource Limits

- `FRPS_CPU_LIMIT`: CPU limit (default: `0.5`)
- `FRPS_MEMORY_LIMIT`: Memory limit (default: `128M`)
- `FRPS_CPU_RESERVATION`: CPU reservation (default: `0.1`)
- `FRPS_MEMORY_RESERVATION`: Memory reservation (default: `64M`)

## Volumes

- `./frps.toml:/etc/frp/frps.toml`: FRPS configuration file

## Security Notes

1. **Change default credentials**: Always change `FRP_SERVER_TOKEN`, `FRP_ADMIN_USER`, and `FRP_ADMIN_PASSWORD` from their default values
2. **Use strong passwords**: Use complex, randomly generated passwords and tokens
3. **Firewall rules**: Consider limiting access to the admin dashboard to trusted IP addresses
4. **TLS/SSL**: For production use, consider setting up TLS encryption in the FRP configuration

## Health Check

The service includes a health check that verifies the admin dashboard is accessible. The health check:

- Runs every 30 seconds
- Has a 10-second timeout
- Retries up to 3 times
- Waits 10 seconds before the first check after startup

## License

FRP is licensed under the Apache License 2.0. See the [FRP GitHub repository](https://github.com/fatedier/frp) for more details.
