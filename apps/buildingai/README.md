# BuildingAI

BuildingAI is an intelligent AI application development platform that empowers developers to quickly build and deploy AI-powered applications. Built on NestJS + Vue 3, it provides a comprehensive solution for creating, managing, and deploying AI agents with a modern, user-friendly interface.

## Features

- 🤖 **AI Agent Builder**: Create and customize AI agents with drag-and-drop interface
- 💬 **Conversation Management**: Advanced chat interface with context awareness
- 🔌 **MCP Server Integration**: Support for Model Context Protocol servers
- 🎨 **Modern UI**: Built with Vue 3 and Nuxt for excellent user experience
- 🔒 **Enterprise Ready**: Built-in user management, authentication, and multi-tenancy
- 📊 **Analytics**: Track usage and performance of your AI applications
- 🌐 **i18n Support**: Multi-language interface support
- 🔧 **Extensible**: Plugin system for custom extensions

## Tech Stack

- **Backend**: NestJS 11.x + TypeORM 0.3.x
- **Database**: PostgreSQL 17.x
- **Cache**: Redis 8.x
- **Frontend**: Vue.js 3.x + Nuxt + Vite 7.x
- **TypeScript**: 5.x
- **Monorepo**: Turbo 2.x

## Quick Start

### Prerequisites

- Docker and Docker Compose installed
- At least 4GB RAM available
- 5GB free disk space

### Deployment

1. Copy the environment file:

    ```bash
    cp .env.example .env
    ```

2. (Optional) Modify the `.env` file to customize your configuration:
   - Set `DB_PASSWORD` for database security
   - Set `REDIS_PASSWORD` for Redis security
   - Configure `BUILDINGAI_PORT_OVERRIDE` if you need a different port
   - Set `NPM_REGISTRY_URL` if you need a custom npm registry mirror

3. Start the services:

    ```bash
    docker compose up -d
    ```

4. Wait for services to be ready (may take a few minutes on first start):

    ```bash
    docker compose logs -f buildingai
    ```

5. Access BuildingAI at [http://localhost:4090/install](http://localhost:4090/install) to complete the initial setup wizard.

### Default Ports

- **BuildingAI**: 4090 (web interface)
- **PostgreSQL**: 5432 (database)
- **Redis**: 6379 (cache)

You can override these ports in the `.env` file.

## Configuration

### Environment Variables

All configuration is done through the `.env` file. See [.env.example](.env.example) for all available options.

#### Key Settings

- `DB_USERNAME` / `DB_PASSWORD`: Database credentials
- `REDIS_PASSWORD`: Redis password (optional, but recommended for production)
- `SERVER_PORT`: Internal application port
- `NPM_REGISTRY_URL`: Custom npm registry mirror (useful in China or private networks)

### Resource Limits

Default resource limits are configured for small to medium deployments:

- **BuildingAI**: 2 CPU cores, 3584MB RAM
- **PostgreSQL**: 1 CPU core, 512MB RAM
- **Redis**: 0.25 CPU cores, 256MB RAM

Adjust these in `.env` based on your workload.

## Data Persistence

All data is stored in Docker volumes:

- `buildingai_data`: Application data and uploads
- `postgres_data`: Database files
- `redis_data`: Redis persistence

### Backup

To backup your data:

```bash
# Backup database
docker compose exec postgres pg_dump -U postgres buildingai > backup.sql

# Backup application data
docker run --rm -v buildingai_buildingai_data:/data -v $(pwd):/backup alpine tar czf /backup/buildingai-data.tar.gz -C /data .
```

### Restore

```bash
# Restore database
docker compose exec -T postgres psql -U postgres buildingai < backup.sql

# Restore application data
docker run --rm -v buildingai_buildingai_data:/data -v $(pwd):/backup alpine tar xzf /backup/buildingai-data.tar.gz -C /data
```

## Maintenance

### View Logs

```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f buildingai
```

### Restart Services

```bash
# All services
docker compose restart

# Specific service
docker compose restart buildingai
```

### Update BuildingAI

```bash
# Pull latest images
docker compose pull

# Restart with new images
docker compose up -d
```

### Stop Services

```bash
# Stop all services
docker compose down

# Stop and remove volumes (WARNING: deletes all data)
docker compose down -v
```

## Troubleshooting

### BuildingAI won't start

1. Check service health:

   ```bash
   docker compose ps
   ```

2. Check logs for errors:

   ```bash
   docker compose logs buildingai
   ```

3. Ensure PostgreSQL and Redis are healthy:

   ```bash
   docker compose ps postgres redis
   ```

### Database connection errors

- Verify `DB_USERNAME`, `DB_PASSWORD`, and `DB_DATABASE` in `.env`
- Check PostgreSQL logs: `docker compose logs postgres`
- Ensure PostgreSQL healthcheck is passing

### Redis connection errors

- If `REDIS_PASSWORD` is set, ensure it matches in all services
- Check Redis logs: `docker compose logs redis`
- Verify Redis healthcheck status

### Performance issues

- Increase resource limits in `.env`
- Monitor resource usage: `docker stats`
- Check for sufficient disk space

## Security Recommendations

For production deployments:

1. **Set strong passwords** for `DB_PASSWORD` and `REDIS_PASSWORD`
2. **Do not expose** PostgreSQL and Redis ports externally (remove port mappings or use firewall rules)
3. **Use a reverse proxy** (nginx, Caddy) with HTTPS for the BuildingAI web interface
4. **Regular backups** of database and application data
5. **Monitor logs** for suspicious activity
6. **Keep images updated** regularly

## Links

- [GitHub Repository](https://github.com/BidingCC/BuildingAI)
- [Official Website](https://www.buildingai.cc/)
- [Live Demo](http://demo.buildingai.cc/)
- [Documentation](https://www.buildingai.cc/docs/introduction/install)

## License

Please refer to the [original repository](https://github.com/BidingCC/BuildingAI) for license information.

## Support

For issues and questions:

- GitHub Issues: [BuildingAI Issues](https://github.com/BidingCC/BuildingAI/issues)
- Official Documentation: [BuildingAI Docs](https://www.buildingai.cc/docs/)
