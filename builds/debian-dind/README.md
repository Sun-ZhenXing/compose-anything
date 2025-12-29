# Debian DinD

A Docker-in-Docker (DinD) service based on Debian, allowing you to run Docker inside a Docker container. Useful for CI/CD pipelines, development environments, and containerized build systems.

## Features

- Based on latest stable Debian (13.2-slim)
- Out-of-the-box Docker daemon
- Optional NVIDIA Container Toolkit for GPU support
- Resource limits configured
- Healthcheck included
- Customizable via environment variables

## Quick Start

1. Copy the example environment file:

   ```bash
   cp .env.example .env
   ```

2. Start the service:

   ```bash
   docker compose up -d
   ```

3. Verify Docker is running inside the container:

   ```bash
   docker compose exec dind docker info
   docker compose exec dind docker run hello-world
   ```

## Configuration

Key environment variables (see `.env.example` for all options):

| Variable                 | Description                         | Default     |
| ------------------------ | ----------------------------------- | ----------- |
| `DEBIAN_VERSION`         | Debian base image version           | `13.2-slim` |
| `DIND_PORT_OVERRIDE`     | Host port for Docker daemon         | `2375`      |
| `INSTALL_NVIDIA_TOOLKIT` | Install NVIDIA toolkit during build | `false`     |
| `TZ`                     | Timezone                            | `UTC`       |
| `DIND_CPU_LIMIT`         | CPU limit                           | `2.0`       |
| `DIND_MEMORY_LIMIT`      | Memory limit                        | `4G`        |

## GPU Support

To use DinD with GPU support:

1. Set `INSTALL_NVIDIA_TOOLKIT=true` in `.env`
2. Use the `gpu` profile:

   ```bash
   docker compose --profile gpu up -d
   ```

Or use the dedicated GPU service:

```bash
docker compose up -d dind-gpu
```

## Security Considerations

⚠️ **Important**: This service runs in privileged mode, which grants the container extensive access to the host system. Only use this in trusted environments.

- Privileged mode is required for DinD to function
- Docker daemon exposed on port 2375 without TLS (development only)
- For production, enable TLS by setting `DOCKER_TLS_CERTDIR=/certs`

## Volume

- `dind-data`: Stores Docker daemon data (images, containers, volumes)
- `dind-gpu-data`: Separate volume for GPU-enabled service

## Resource Limits

Default resource limits:

- CPU: 2.0 cores (limit), 1.0 core (reservation)
- Memory: 4GB (limit), 2GB (reservation)

Adjust these in `.env` based on your workload.

## Advanced Usage

### Connect from host

You can connect to the Docker daemon from your host machine:

```bash
export DOCKER_HOST=tcp://localhost:2375
docker info
```

### Use in CI/CD

Example GitLab CI configuration:

```yaml
services:
  - name: your-registry/debian-dind:latest
    alias: docker

variables:
  DOCKER_HOST: tcp://docker:2375
```

## Build Arguments

When building the image manually:

- `DEBIAN_VERSION`: Debian base version (default: `13.2-slim`)
- `INSTALL_NVIDIA_TOOLKIT`: Install NVIDIA toolkit (default: `false`)

Example:

```bash
docker build --build-arg DEBIAN_VERSION=13.2-slim --build-arg INSTALL_NVIDIA_TOOLKIT=true -t debian-dind-gpu .
```

## License

This configuration is provided as-is for use with the Compose Anything project.
