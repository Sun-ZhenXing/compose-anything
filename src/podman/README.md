# Podman (Podman-in-Container)

[English](./README.md) | [中文](./README.zh.md)

This service provides a Podman environment running inside a container (Podman-in-Container). It allows you to run and manage OCI containers using Podman without installing it directly on your host.

## Quick Start

1. (Optional) Customize the configuration in `.env`.
2. Start the service:

   ```bash
   docker compose up -d
   ```

3. You can either use the Podman API on port `8888` or execute commands directly:

   ```bash
   docker compose exec podman podman info
   ```

## Services

- `podman`: The Podman engine service.

## Configuration

| Environment Variable   | Description                | Default  |
| ---------------------- | -------------------------- | -------- |
| `PODMAN_VERSION`       | Version of Podman image    | `v5.7.1` |
| `PODMAN_PORT_OVERRIDE` | Host port for Podman API   | `8888`   |
| `TZ`                   | Timezone for the container | `UTC`    |
| `PODMAN_CPU_LIMIT`     | Maximum CPU usage          | `2.0`    |
| `PODMAN_MEMORY_LIMIT`  | Maximum Memory usage       | `4G`     |

## Security Note

This container requires `privileged: true` to function correctly as it needs to manage container namespaces and mounts. Use it only in trusted environments.
