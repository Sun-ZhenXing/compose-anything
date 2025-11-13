# Open WebUI Rust

High-performance Rust implementation of Open WebUI with native async runtime and improved resource efficiency.

## Overview

Open WebUI Rust is a complete rewrite of the Open WebUI backend in Rust, offering:

- **10-50x faster response times** for API endpoints
- **70% lower memory usage** under load
- **Native concurrency** with Tokio's async runtime
- **Type safety** preventing entire classes of runtime errors
- **Zero-copy streaming** for chat completions
- **Production-ready** with comprehensive error handling

This deployment includes:

- **Rust Backend**: High-performance API server with WebSocket support
- **PostgreSQL**: Primary database for data persistence
- **Redis**: Caching and WebSocket session management
- **Sandbox Executor**: Secure code execution environment with Docker isolation
- **Frontend**: SvelteKit-based user interface with Nginx reverse proxy

## Features

- ✅ **Full API Compatibility** with Open WebUI Python backend
- ✅ **Native WebSocket/Socket.IO** implementation in Rust
- ✅ **Secure Code Execution** via isolated Docker containers
- ✅ **Multi-language Support** (Python, JavaScript, Shell, Rust)
- ✅ **RAG & Embeddings** with vector database integration
- ✅ **Authentication & Authorization** with JWT tokens
- ✅ **Rate Limiting & Security** built-in protection
- ✅ **Comprehensive Logging** for debugging and monitoring

## Prerequisites

- Docker 20.10+
- Docker Compose 2.0+
- 4GB+ available memory
- Access to Docker socket (for sandbox execution)

## Quick Start

### 1. Create `.env` file

```bash
cp .env.example .env
```

Edit `.env` and set required variables:

```bash
# IMPORTANT: Generate a secure secret key (min 32 characters)
WEBUI_SECRET_KEY=$(uuidgen | tr '[:upper:]' '[:lower:]' | tr -d '-')

# Optional: Configure OpenAI API
OPENAI_API_KEY=sk-your-api-key
OPENAI_API_BASE_URL=https://api.openai.com/v1
```

### 2. Start services

```bash
docker compose up -d
```

### 3. Access the application

- **Frontend UI**: <http://localhost:3000>
- **Rust Backend API**: <http://localhost:8080>
- **Sandbox Executor**: <http://localhost:8090>

### 4. Initial setup

1. Open <http://localhost:3000>
2. Create an admin account (first user becomes admin)
3. Configure your AI models in Settings

## Architecture

```text
┌─────────────┐
│  Frontend   │ :3000
│ (SvelteKit) │
└──────┬──────┘
       │
       ↓
┌─────────────┐     ┌──────────────┐
│Rust Backend │────→│  PostgreSQL  │ :5432
│   (API)     │     │  (Database)  │
└──────┬──────┘     └──────────────┘
       │
       ├───────────→┌──────────────┐
       │            │    Redis     │ :6379
       │            │   (Cache)    │
       │            └──────────────┘
       │
       └───────────→┌──────────────┐
                    │   Sandbox    │ :8090
                    │  Executor    │
                    └──────────────┘
```

## Configuration

### Core Environment Variables

| Variable                     | Default               | Description                              |
| ---------------------------- | --------------------- | ---------------------------------------- |
| `WEBUI_SECRET_KEY`           | (required)            | Secret key for JWT tokens (min 32 chars) |
| `POSTGRES_PASSWORD`          | `open_webui_password` | PostgreSQL password                      |
| `FRONTEND_PORT_OVERRIDE`     | `3000`                | Frontend access port                     |
| `RUST_BACKEND_PORT_OVERRIDE` | `8080`                | Backend API port                         |
| `TZ`                         | `UTC`                 | Timezone setting                         |

### Feature Flags

| Variable                  | Default | Description                  |
| ------------------------- | ------- | ---------------------------- |
| `ENABLE_CODE_EXECUTION`   | `true`  | Enable secure code execution |
| `ENABLE_CODE_INTERPRETER` | `true`  | Enable code interpreter      |
| `ENABLE_IMAGE_GENERATION` | `false` | Enable image generation      |
| `ENABLE_WEB_SEARCH`       | `false` | Enable web search            |
| `ENABLE_SIGNUP`           | `true`  | Allow new user registration  |

### Resource Limits

Each service has configurable CPU and memory limits:

```bash
# Rust Backend
RUST_BACKEND_CPU_LIMIT=2
RUST_BACKEND_MEMORY_LIMIT=2G

# PostgreSQL
POSTGRES_CPU_LIMIT=1
POSTGRES_MEMORY_LIMIT=1G

# Sandbox Executor
SANDBOX_EXECUTOR_CPU_LIMIT=2
SANDBOX_EXECUTOR_MEMORY_LIMIT=2G
```

### Sandbox Security

Configure sandbox execution limits:

```bash
SANDBOX_MAX_EXECUTION_TIME=60        # Max execution time in seconds
SANDBOX_MAX_MEMORY_MB=512           # Max memory per execution
SANDBOX_MAX_CONCURRENT_EXECUTIONS=10 # Max parallel executions
SANDBOX_NETWORK_MODE=none           # Disable network access
```

## Usage Examples

### Basic Chat

```bash
curl -X POST http://localhost:8080/api/chat/completions \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-3.5-turbo",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

### Code Execution

```bash
curl -X POST http://localhost:8090/api/v1/execute \
  -H "Content-Type: application/json" \
  -d '{
    "language": "python",
    "code": "print(\"Hello from sandbox!\")"
  }'
```

## Monitoring

### View Logs

```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f rust-backend
docker compose logs -f sandbox-executor
```

### Check Service Health

```bash
# Rust Backend
curl http://localhost:8080/health

# Sandbox Executor
curl http://localhost:8090/api/v1/health

# PostgreSQL
docker compose exec postgres pg_isready
```

### Resource Usage

```bash
docker stats
```

## Maintenance

### Backup Database

```bash
docker compose exec postgres pg_dump -U open_webui open_webui > backup.sql
```

### Restore Database

```bash
cat backup.sql | docker compose exec -T postgres psql -U open_webui open_webui
```

### Update Services

```bash
docker compose pull
docker compose up -d
```

### Clean Reset

```bash
# Stop and remove all data
docker compose down -v

# Start fresh
docker compose up -d
```

## Troubleshooting

### Cannot connect to services

Check if all containers are healthy:

```bash
docker compose ps
```

### JWT token errors

Ensure `WEBUI_SECRET_KEY` is set and consistent across restarts.

### Code execution fails

1. Verify Docker socket is accessible
2. Check sandbox executor logs: `docker compose logs sandbox-executor`
3. Ensure runtime image is available: `docker images | grep sandbox-runtime`

### High memory usage

Adjust resource limits in `.env`:

```bash
RUST_BACKEND_MEMORY_LIMIT=1G
SANDBOX_EXECUTOR_MEMORY_LIMIT=1G
```

## Security Considerations

### Production Deployment

1. **Change default passwords**

   ```bash
   POSTGRES_PASSWORD=$(openssl rand -base64 32)
   WEBUI_SECRET_KEY=$(openssl rand -base64 48)
   ```

2. **Restrict network access**

   ```bash
   CORS_ALLOW_ORIGIN=https://yourdomain.com
   ```

3. **Disable signup after initial setup**

   ```bash
   ENABLE_SIGNUP=false
   ```

4. **Enable HTTPS** using a reverse proxy (nginx, Traefik, Caddy)

5. **Limit sandbox resources**

   ```bash
   SANDBOX_MAX_EXECUTION_TIME=30
   SANDBOX_MAX_MEMORY_MB=256
   SANDBOX_NETWORK_MODE=none
   ```

### Docker Socket Access

The sandbox executor requires access to the Docker socket (`/var/run/docker.sock`) for container isolation. This is a privileged operation and should be:

- Used only in trusted environments
- Protected with proper network isolation
- Monitored for suspicious activity

Consider using alternatives like:

- Docker-in-Docker (DinD) for better isolation
- Kubernetes with pod security policies
- Dedicated sandbox service on separate nodes

## Performance

Typical resource usage:

| Service          | CPU (idle) | Memory (idle) | CPU (load) | Memory (load) |
| ---------------- | ---------- | ------------- | ---------- | ------------- |
| Rust Backend     | ~1%        | 50MB          | 10-30%     | 200MB         |
| PostgreSQL       | ~1%        | 50MB          | 5-15%      | 300MB         |
| Redis            | <1%        | 10MB          | 2-5%       | 50MB          |
| Sandbox Executor | <1%        | 30MB          | varies     | 512MB         |
| Frontend         | <1%        | 50MB          | 5-10%      | 200MB         |

## License

This project follows the original Open WebUI license.

## Related Projects

- [Open WebUI](https://github.com/open-webui/open-webui) - Original Python implementation
- [Open WebUI Rust](https://github.com/knoxchat/open-webui-rust) - Official Rust backend repository

## Support

For issues and questions:

- [Open WebUI Rust Issues](https://github.com/knoxchat/open-webui-rust/issues)
- [Open WebUI Documentation](https://docs.openwebui.com/)
