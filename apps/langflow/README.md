# Langflow

Langflow is a low-code visual framework for building AI applications. It's Python-based and agnostic to any model, API, or database, making it easy to build RAG applications, multi-agent systems, and custom AI workflows.

## Features

- **Visual Flow Builder**: Drag-and-drop interface for building AI applications
- **Multi-Model Support**: Works with OpenAI, Anthropic, Google, HuggingFace, and more
- **RAG Components**: Built-in support for vector databases and retrieval
- **Custom Components**: Create your own Python components
- **Agent Support**: Build multi-agent systems with memory and tools
- **Real-Time Monitoring**: Track executions and debug flows
- **API Integration**: REST API for programmatic access

## Quick Start

1. Copy `.env.example` to `.env`:

   ```bash
   cp .env.example .env
   ```

2. (Optional) Edit `.env` to customize settings:
   - Generate a secure `LANGFLOW_SECRET_KEY` for production
   - Set `LANGFLOW_AUTO_LOGIN=false` to require authentication
   - Configure superuser credentials
   - Add API keys for LLM providers

3. Start Langflow:

   ```bash
   docker compose up -d
   ```

4. Wait for services to be ready (usually takes 1-2 minutes)

5. Access Langflow UI at `http://localhost:7860`

6. Start building your AI application!

## Default Configuration

| Service    | Port | Description         |
| ---------- | ---- | ------------------- |
| Langflow   | 7860 | Web UI and API      |
| PostgreSQL | 5432 | Database (internal) |

**Default Credentials** (if authentication enabled):

- Username: `langflow`
- Password: `langflow`

## Environment Variables

Key environment variables (see `.env.example` for full list):

| Variable                      | Description                   | Default    |
| ----------------------------- | ----------------------------- | ---------- |
| `LANGFLOW_VERSION`            | Langflow image version        | `1.1.1`    |
| `LANGFLOW_PORT_OVERRIDE`      | Host port for UI              | `7860`     |
| `POSTGRES_PASSWORD`           | Database password             | `langflow` |
| `LANGFLOW_AUTO_LOGIN`         | Auto-login (disable for auth) | `true`     |
| `LANGFLOW_SUPERUSER`          | Superuser username            | `langflow` |
| `LANGFLOW_SUPERUSER_PASSWORD` | Superuser password            | `langflow` |
| `LANGFLOW_SECRET_KEY`         | Secret key for sessions       | (empty)    |
| `LANGFLOW_COMPONENTS_PATH`    | Custom components directory   | (empty)    |
| `LANGFLOW_LOAD_FLOWS_PATH`    | Auto-load flows directory     | (empty)    |
| `TZ`                          | Timezone                      | `UTC`      |

## Resource Requirements

**Minimum**:

- CPU: 1 core
- RAM: 1GB
- Disk: 5GB

**Recommended**:

- CPU: 2+ cores
- RAM: 2GB+
- Disk: 20GB+

## Volumes

- `postgres_data`: PostgreSQL database data
- `langflow_data`: Langflow configuration, flows, and logs

## Using Langflow

### Building Your First Flow

1. Access the UI at `http://localhost:7860`
2. Click "New Flow" or use a template
3. Drag components from the sidebar to the canvas
4. Connect components by dragging between ports
5. Configure component parameters
6. Click "Run" to test your flow
7. Use the API or integrate with your application

### Adding LLM Providers

To use external LLM providers, configure their API keys:

1. In Langflow UI, go to Settings > Global Variables
2. Add your API keys (e.g., `OPENAI_API_KEY`, `ANTHROPIC_API_KEY`)
3. Reference these variables in your flow components

Alternatively, add them to your `.env` file and restart:

```bash
# Example LLM API Keys (add to .env)
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
GOOGLE_API_KEY=...
```

### Custom Components

To add custom components:

1. Create a directory for your components (e.g., `./custom_components`)
2. Update `.env`:

   ```bash
   LANGFLOW_COMPONENTS_PATH=/app/langflow/custom_components
   ```

3. Mount the directory in `docker-compose.yaml`:

   ```yaml
   volumes:
     - ./custom_components:/app/langflow/custom_components
   ```

4. Restart Langflow

### Auto-Loading Flows

To automatically load flows on startup:

1. Export your flows as JSON files
2. Create a directory (e.g., `./flows`)
3. Update `.env`:

   ```bash
   LANGFLOW_LOAD_FLOWS_PATH=/app/langflow/flows
   ```

4. Mount the directory in `docker-compose.yaml`:

   ```yaml
   volumes:
     - ./flows:/app/langflow/flows
   ```

5. Restart Langflow

## API Usage

Langflow provides a REST API for running flows programmatically.

### Get Flow ID

1. Open your flow in the UI
2. The flow ID is in the URL: `http://localhost:7860/flow/{flow_id}`

### Run Flow via API

```bash
curl -X POST http://localhost:7860/api/v1/run/{flow_id} \
  -H "Content-Type: application/json" \
  -d '{
    "inputs": {
      "input_field": "your input value"
    }
  }'
```

### With Authentication

If authentication is enabled, first get a token:

```bash
# Login
curl -X POST http://localhost:7860/api/v1/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "langflow",
    "password": "langflow"
  }'

# Use token in subsequent requests
curl -X POST http://localhost:7860/api/v1/run/{flow_id} \
  -H "Authorization: Bearer {token}" \
  -H "Content-Type: application/json" \
  -d '{
    "inputs": {
      "input_field": "your input value"
    }
  }'
```

## Production Deployment

For production deployments:

1. **Enable Authentication**:

   ```bash
   LANGFLOW_AUTO_LOGIN=false
   LANGFLOW_SUPERUSER=admin
   LANGFLOW_SUPERUSER_PASSWORD=<strong-password>
   ```

2. **Set Secret Key**:

   ```bash
   # Generate a secure key
   python -c "from secrets import token_urlsafe; print(token_urlsafe(32))"

   # Add to .env
   LANGFLOW_SECRET_KEY=<generated-key>
   ```

3. **Use Strong Database Password**:

   ```bash
   POSTGRES_PASSWORD=<strong-password>
   ```

4. **Enable SSL/TLS**: Use a reverse proxy (nginx, traefik) with SSL certificates

5. **Configure Resource Limits**: Adjust CPU and memory limits based on your workload

6. **Backup Database**: Regularly backup the PostgreSQL data volume

## Troubleshooting

### Langflow Won't Start

- Check logs: `docker compose logs langflow`
- Ensure PostgreSQL is healthy: `docker compose ps postgres`
- Verify port 7860 is not in use

### Components Not Loading

- Check custom components path is correct
- Ensure Python dependencies are installed in custom components
- Check logs for component errors

### Slow Performance

- Increase resource limits in `.env`
- Reduce `LANGFLOW_WORKERS` if low on memory
- Optimize your flows (reduce unnecessary components)

### Database Connection Errors

- Verify PostgreSQL is running: `docker compose ps postgres`
- Check database credentials in `.env`
- Ensure `LANGFLOW_DATABASE_URL` is correct

## Maintenance

### Backup

Backup volumes:

```bash
docker compose down
docker run --rm -v compose-anything_postgres_data:/data -v $(pwd):/backup alpine tar czf /backup/postgres-backup.tar.gz -C /data .
docker run --rm -v compose-anything_langflow_data:/data -v $(pwd):/backup alpine tar czf /backup/langflow-backup.tar.gz -C /data .
docker compose up -d
```

### Restore

Restore from backup:

```bash
docker compose down
docker run --rm -v compose-anything_postgres_data:/data -v $(pwd):/backup alpine sh -c "cd /data && tar xzf /backup/postgres-backup.tar.gz"
docker run --rm -v compose-anything_langflow_data:/data -v $(pwd):/backup alpine sh -c "cd /data && tar xzf /backup/langflow-backup.tar.gz"
docker compose up -d
```

### Upgrade

To upgrade Langflow:

1. Update version in `.env`:

   ```bash
   LANGFLOW_VERSION=1.2.0
   ```

2. Pull new image and restart:

   ```bash
   docker compose pull
   docker compose up -d
   ```

3. Check for breaking changes in release notes

## Useful Commands

```bash
# View logs
docker compose logs -f langflow

# Restart Langflow
docker compose restart langflow

# Access PostgreSQL
docker compose exec postgres psql -U langflow -d langflow

# Check resource usage
docker stats

# Clean up
docker compose down -v  # WARNING: Deletes all data
```

## References

- [Official Documentation](https://docs.langflow.org/)
- [GitHub Repository](https://github.com/langflow-ai/langflow)
- [Component Documentation](https://docs.langflow.org/components/)
- [API Documentation](https://docs.langflow.org/api/)
- [Community Discord](https://discord.gg/langflow)

## License

MIT - See [LICENSE](https://github.com/langflow-ai/langflow/blob/main/LICENSE)
