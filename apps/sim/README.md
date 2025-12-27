# Sim - AI Agent Workflow Builder

Open-source platform to build and deploy AI agent workflows. Developers at trail-blazing startups to Fortune 500 companies deploy agentic workflows on the Sim platform.

## Features

- **Visual Workflow Builder**: Multi-step AI agents and tools with drag-and-drop interface
- **LLM Orchestration**: Coordinate LLM calls, tools, webhooks, and external APIs
- **Scheduled Execution**: Event-driven and scheduled agent executions
- **RAG Support**: First-class support for retrieval-augmented generation
- **Multi-tenant**: Workspace-based access model for teams
- **100+ Integrations**: Connect with popular services and APIs

## Requirements

| Resource | Minimum   | Recommended |
| -------- | --------- | ----------- |
| CPU      | 2 cores   | 4+ cores    |
| RAM      | 12 GB     | 16+ GB      |
| Storage  | 20 GB SSD | 50+ GB SSD  |
| Docker   | 20.10+    | Latest      |

## Quick Start

```bash
# Copy environment file
cp .env.example .env

# IMPORTANT: Generate secure secrets in production
sed -i "s/your_auth_secret_here/$(openssl rand -hex 32)/" .env
sed -i "s/your_encryption_key_here/$(openssl rand -hex 32)/" .env

# Start services
docker compose up -d

# View logs
docker compose logs -f simstudio
```

Access the application at [http://localhost:3000](http://localhost:3000)

## Configuration

### Required Environment Variables

Before deployment, update these critical settings in `.env`:

```bash
# Security (REQUIRED - generate with: openssl rand -hex 32)
BETTER_AUTH_SECRET=<your-secret-here>
ENCRYPTION_KEY=<your-secret-here>

# Application URLs (update for production)
NEXT_PUBLIC_APP_URL=https://sim.yourdomain.com
BETTER_AUTH_URL=https://sim.yourdomain.com
NEXT_PUBLIC_SOCKET_URL=https://sim.yourdomain.com

# Database credentials (change defaults in production)
POSTGRES_USER=postgres
POSTGRES_PASSWORD=<strong-password>
POSTGRES_DB=simstudio
```

### Using with Ollama

Sim can work with local AI models using [Ollama](https://ollama.ai):

**External Ollama (running on host machine)**:

```bash
# macOS/Windows
OLLAMA_URL=http://host.docker.internal:11434

# Linux - use your actual host IP
OLLAMA_URL=http://192.168.1.100:11434
```

> **Note**: Inside Docker, `localhost` refers to the container. Use `host.docker.internal` (macOS/Windows) or your host's IP address (Linux).

### Port Configuration

Default ports can be overridden via environment variables:

```bash
SIM_PORT_OVERRIDE=3000              # Main application
SIM_REALTIME_PORT_OVERRIDE=3002     # Realtime server
POSTGRES_PORT_OVERRIDE=5432         # PostgreSQL database
```

### Resource Limits

Adjust resource allocation based on your workload:

```bash
# Main application
SIM_CPU_LIMIT=4.0
SIM_MEMORY_LIMIT=8G

# Realtime server
SIM_REALTIME_CPU_LIMIT=2.0
SIM_REALTIME_MEMORY_LIMIT=4G

# PostgreSQL
POSTGRES_CPU_LIMIT=2.0
POSTGRES_MEMORY_LIMIT=2G
```

## Service Architecture

The deployment consists of 4 services:

1. **simstudio**: Main Next.js application (port 3000)
2. **realtime**: WebSocket server for real-time features (port 3002)
3. **migrations**: Database schema management (runs once)
4. **db**: PostgreSQL 17 with pgvector extension (port 5432)

## Common Operations

### View Logs

```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f simstudio
```

### Stop Services

```bash
docker compose down
```

### Update to Latest Version

```bash
docker compose pull
docker compose up -d
```

### Backup Database

```bash
docker compose exec db pg_dump -U postgres simstudio > backup_$(date +%Y%m%d).sql
```

### Restore Database

```bash
cat backup.sql | docker compose exec -T db psql -U postgres simstudio
```

## Security Considerations

- **Change default credentials**: Update `POSTGRES_PASSWORD` in production
- **Generate strong secrets**: Use `openssl rand -hex 32` for all secret values
- **Use HTTPS**: Configure reverse proxy (Nginx/Caddy) with SSL certificates
- **Network isolation**: Keep database on internal network
- **Regular backups**: Automate database backups
- **Update regularly**: Pull latest images to get security patches

## Production Deployment

For production deployments:

1. **Use reverse proxy** (Nginx, Caddy, Traefik) for SSL/TLS termination
2. **Configure firewall** to restrict database access
3. **Set up monitoring** (health checks, metrics, logs)
4. **Enable backups** (automated PostgreSQL backups)
5. **Use external database** for better performance and reliability (optional)

Example Caddy configuration:

```caddy
sim.yourdomain.com {
    reverse_proxy localhost:3000

    handle /socket.io/* {
        reverse_proxy localhost:3002
    }
}
```

## Troubleshooting

### Models not showing in dropdown

If using external Ollama on host machine, ensure `OLLAMA_URL` uses `host.docker.internal` or your host's IP address, not `localhost`.

### Database connection errors

- Verify PostgreSQL is healthy: `docker compose ps`
- Check database logs: `docker compose logs db`
- Ensure migrations completed: `docker compose logs migrations`

### Port conflicts

If ports are already in use, override them:

```bash
SIM_PORT_OVERRIDE=3100 \
SIM_REALTIME_PORT_OVERRIDE=3102 \
POSTGRES_PORT_OVERRIDE=5433 \
docker compose up -d
```

## Additional Resources

- **Official Documentation**: [https://docs.sim.ai](https://docs.sim.ai)
- **GitHub Repository**: [https://github.com/simstudioai/sim](https://github.com/simstudioai/sim)
- **Cloud-hosted Version**: [https://sim.ai](https://sim.ai)
- **Self-hosting Guide**: [https://docs.sim.ai/self-hosting](https://docs.sim.ai/self-hosting)

## License

This configuration follows the Sim project licensing. Check the [official repository](https://github.com/simstudioai/sim) for license details.

## Support

For issues and questions:

- GitHub Issues: [https://github.com/simstudioai/sim/issues](https://github.com/simstudioai/sim/issues)
- Documentation: [https://docs.sim.ai](https://docs.sim.ai)
