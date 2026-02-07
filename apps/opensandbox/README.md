# OpenSandbox

English | [中文](README.zh.md)

A general-purpose sandbox platform for AI applications, offering multi-language SDKs, unified sandbox APIs, and Docker/Kubernetes runtimes. Ideal for scenarios like Coding Agents, GUI Agents, Agent Evaluation, AI Code Execution, and RL Training.

## Features

- **Multi-language SDK Support**: Python, JavaScript/TypeScript, Java/Kotlin, and Go client SDKs
- **Unified Sandbox API**: Consistent interface for sandbox lifecycle, command execution, and file operations
- **Multiple Runtime Options**: Docker and Kubernetes runtime support
- **Security Hardening**: Built-in security features including capability dropping, privilege escalation prevention, and resource limits
- **Flexible Configuration**: Support for various network modes, resource constraints, and security profiles
- **Code Interpreter**: Pre-built images with Python, Node.js, Java, and Go kernel support

## Quick Start

### Prerequisites

- Docker Engine (required for Docker runtime)
- Docker Compose
- Sufficient permissions to access Docker socket

> **Note for macOS users using Colima**: You need to set the `DOCKER_HOST` environment variable before starting OpenSandbox:
>
> ```bash
> export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock"
> ```

### Deployment

1. **Copy the environment file and configure as needed:**

   ```bash
   cp .env.example .env
   ```

2. **Edit `config.toml` to set your API key:**

   ```toml
   [server]
   api_key = "your-secret-api-key-change-this"
   ```

   **IMPORTANT**: Change the default API key in production!

3. **Start the service:**

   ```bash
   docker compose up -d
   ```

4. **Verify the service is running:**

   ```bash
   curl http://localhost:8080/health
   ```

   You should receive a successful health check response.

## Configuration

### Environment Variables

Key environment variables (see [.env.example](.env.example) for full list):

| Variable                           | Description                      | Default                       |
| ---------------------------------- | -------------------------------- | ----------------------------- |
| `OPENSANDBOX_SERVER_VERSION`       | OpenSandbox server image version | `v1.0.5`                      |
| `OPENSANDBOX_SERVER_PORT_OVERRIDE` | Host port mapping                | `8080`                        |
| `DOCKER_HOST`                      | Docker socket path               | `unix:///var/run/docker.sock` |
| `OPENSANDBOX_SERVER_CPU_LIMIT`     | CPU cores limit                  | `2.0`                         |
| `OPENSANDBOX_SERVER_MEMORY_LIMIT`  | Memory limit                     | `2G`                          |

### Server Configuration

The main configuration is in [config.toml](config.toml). Key sections:

- **[server]**: HTTP server settings (host, port, log level, API key)
- **[runtime]**: Runtime type and execd image configuration
- **[docker]**: Docker-specific settings including network mode and security options

#### Network Modes

- **bridge** (recommended): Containers have isolated networks, supports multiple sandboxes
- **host**: Containers share host network, only one sandbox instance at a time

#### Security Features

- **Capability dropping**: Removes dangerous Linux capabilities from containers
- **Privilege escalation prevention**: Blocks privilege escalation inside containers
- **Process limits**: Controls maximum number of processes per sandbox
- **AppArmor/Seccomp profiles**: Optional security profiles (leave empty for Docker defaults)

## Usage

### Basic Sandbox Creation (Python SDK)

```python
from opensandbox import Sandbox
from datetime import timedelta

# Create a sandbox with code interpreter
sandbox = await Sandbox.create(
    "opensandbox/code-interpreter:v1.0.1",
    entrypoint="/opt/opensandbox/code-interpreter.sh",
    env={"PYTHON_VERSION": "3.11"},
    timeout=timedelta(minutes=10)
)

async with sandbox:
    # Execute Python code
    result = await sandbox.execute(
        "python",
        "-c",
        "print('Hello from OpenSandbox!')"
    )
    print(result.stdout)
```

### API Authentication

All API requests require the `X-API-Key` header with the key configured in `config.toml`:

```bash
curl -H "X-API-Key: your-secret-api-key-change-this" \
     http://localhost:8080/sandboxes
```

## Pre-built Images

OpenSandbox provides several pre-built sandbox images:

- **opensandbox/code-interpreter**: Multi-language code interpreter (Python, Node.js, Java, Go)
- **opensandbox/vscode**: VS Code Server environment
- **opensandbox/desktop**: Full desktop environment with VNC support
- **opensandbox/playwright**: Browser automation with Playwright
- **opensandbox/chrome**: Chromium browser environment

## Ports

| Port | Service            | Description     |
| ---- | ------------------ | --------------- |
| 8080 | OpenSandbox Server | HTTP API server |

## Data Persistence

- **opensandbox_data**: Server data and state

## Health Check

The service includes a built-in health check endpoint at `/health`:

```bash
curl http://localhost:8080/health
```

## Security Considerations

### Docker Socket Access

This service requires access to the Docker socket (`/var/run/docker.sock`) to create and manage sandbox containers. This is a high-privilege operation.

**Security implications:**

- Containers with Docker socket access can potentially control the host system
- Only deploy in trusted environments
- Consider using Docker-in-Docker or rootless Docker for additional isolation in production

**Alternatives:**

- Use Kubernetes runtime instead of Docker runtime (requires Kubernetes cluster)
- Deploy with restricted user permissions and resource quotas

### API Key Security

- **Never use the default API key in production**
- Store API keys securely (e.g., using Docker secrets, environment variables from secret managers)
- Rotate API keys regularly
- Limit network exposure (use firewall rules, reverse proxy)

### Resource Limits

Always configure appropriate CPU and memory limits to prevent resource exhaustion:

```yaml
deploy:
  resources:
    limits:
      cpus: '2.0'
      memory: 2G
```

## Troubleshooting

### Docker Socket Connection Issues

**Error**: Failed to initialize Docker service

**Solution**:

- Ensure Docker Desktop/Engine is running
- On macOS with Colima: Set `DOCKER_HOST=unix://${HOME}/.colima/default/docker.sock`
- Check Docker socket permissions: `ls -l /var/run/docker.sock`

### Health Check Failing

**Error**: Health check timeout

**Solution**:

- Check container logs: `docker compose logs opensandbox-server`
- Verify the service started successfully: `docker compose ps`
- Increase `start_period` in docker-compose.yaml if the service needs more time to initialize

### Sandbox Creation Failures

**Error**: Failed to create sandbox

**Solution**:

- Ensure the execd image is accessible: `docker pull opensandbox/execd:v1.0.5`
- Check available system resources (CPU, memory, disk space)
- Review server logs for detailed error messages

## License

This project is part of the OpenSandbox suite. See the main [LICENSE](https://github.com/alibaba/OpenSandbox/blob/main/LICENSE) file for details.

## References

- [OpenSandbox GitHub Repository](https://github.com/alibaba/OpenSandbox)
- [OpenSandbox Documentation](https://github.com/alibaba/OpenSandbox/tree/main/docs)
- [Docker Security](https://docs.docker.com/engine/security/)

## Support

For issues and questions:

- [GitHub Issues](https://github.com/alibaba/OpenSandbox/issues)
- [Official Documentation](https://github.com/alibaba/OpenSandbox)
