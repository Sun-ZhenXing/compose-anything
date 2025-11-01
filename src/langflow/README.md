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

4. Wait for services to be ready

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
| `LANGFLOW_VERSION`            | Langflow image version        | `latest`   |
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

### Adding API Keys

You can add API keys for LLM providers in two ways:

#### Option 1: Global Variables (Recommended)

1. Click your profile icon → Settings
2. Go to "Global Variables"
3. Add your API keys (e.g., `OPENAI_API_KEY`)
4. Reference them in components using `{OPENAI_API_KEY}`

#### Option 2: Environment Variables

Add to your `.env` file:

```text
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
GOOGLE_API_KEY=...
```

Langflow will automatically create global variables from these.

### Using the API

Get your API token from the UI:

1. Click your profile icon → Settings
2. Go to "API Keys"
3. Create a new API key

Example: Run a flow

```bash
curl -X POST http://localhost:7860/api/v1/run/YOUR_FLOW_ID \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"input_value": "Hello"}'
```

### Custom Components

1. Create a directory for your components
2. Set `LANGFLOW_COMPONENTS_PATH` in `.env`
3. Create Python files with your component classes
4. Restart Langflow to load them

Example component structure:

```python
from langflow import CustomComponent

class MyComponent(CustomComponent):
    display_name = "My Component"
    description = "Does something cool"
    
    def build(self):
        # Your component logic
        return result
```

## Security Considerations

1. **Secret Key**: Generate a strong `LANGFLOW_SECRET_KEY` for production:

   ```bash
   python -c "from secrets import token_urlsafe; print(token_urlsafe(32))"
   ```

2. **Authentication**: Set `LANGFLOW_AUTO_LOGIN=false` to require login
3. **Database Password**: Use a strong PostgreSQL password
4. **API Keys**: Store sensitive keys as global variables, not in flows
5. **SSL/TLS**: Use reverse proxy with HTTPS in production
6. **Network Access**: Restrict access with firewall rules

## Upgrading

To upgrade Langflow:

1. Update `LANGFLOW_VERSION` in `.env` (or use `latest`)
2. Pull and restart:

   ```bash
   docker compose pull
   docker compose up -d
   ```

3. Check logs:

   ```bash
   docker compose logs -f langflow
   ```

## Troubleshooting

**Service won't start:**

- Check logs: `docker compose logs langflow`
- Verify database: `docker compose ps postgres`
- Ensure sufficient resources allocated

**Cannot access UI:**

- Check port 7860 is not in use: `netstat -an | findstr 7860`
- Verify firewall settings
- Check container health: `docker compose ps`

**API key not working:**

- Verify the key is set in Global Variables
- Check the variable name matches in your components
- Ensure `LANGFLOW_STORE_ENVIRONMENT_VARIABLES=true`

**Flow execution errors:**

- Check component configurations
- Review logs in the UI under each component
- Verify API keys have sufficient credits/permissions

## References

- Official Website: <https://langflow.org>
- Documentation: <https://docs.langflow.org>
- GitHub: <https://github.com/langflow-ai/langflow>
- Discord Community: <https://discord.gg/EqksyE2EX9>
- Docker Hub: <https://hub.docker.com/r/langflowai/langflow>

## License

Langflow is licensed under MIT. See [LICENSE](https://github.com/langflow-ai/langflow/blob/main/LICENSE) for more information.
