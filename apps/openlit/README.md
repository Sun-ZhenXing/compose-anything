# OpenLIT

OpenLIT is an open-source platform for AI engineering that provides OpenTelemetry-native observability, monitoring, and management tools for large language models (LLMs), GPUs, and vector databases.

## Features

- **📈 Analytics Dashboard**: Monitor your AI application's health and performance with detailed dashboards that track metrics, costs, and user interactions
- **🔌 OpenTelemetry-native Observability SDKs**: Vendor-neutral SDKs to send traces and metrics to your existing observability tools
- **💲 Cost Tracking**: Tailor cost estimations for specific models using custom pricing files for precise budgeting
- **🐛 Exceptions Monitoring**: Quickly spot and resolve issues by tracking common exceptions and errors
- **💭 Prompt Management**: Manage and version prompts using Prompt Hub for consistent and easy access across applications
- **🔑 API Keys and Secrets Management**: Securely handle your API keys and secrets centrally
- **🎮 Experiment with different LLMs**: Use OpenGround to explore, test and compare various LLMs side by side
- **🚀 Fleet Hub for OpAMP Management**: Centrally manage and monitor OpenTelemetry Collectors across your infrastructure using the OpAMP (Open Agent Management Protocol) with secure TLS communication

## Quick Start

1. Copy `.env.example` to `.env` and customize as needed:

   ```bash
   cp .env.example .env
   ```

2. Start the services:

   ```bash
   docker compose up -d
   ```

3. Access OpenLIT at `http://localhost:3000`

4. Login with default credentials:
   - Email: `user@openlit.io`
   - Password: `openlituser`

## Components

This deployment includes:

- **OpenLIT Platform**: Main application providing the UI and API (Port: 3000)
- **ClickHouse**: Database for storing telemetry data (Ports: 8123, 9000)
- **OTLP Receivers**:
  - gRPC: Port 4317
  - HTTP: Port 4318

## Integration with Your Applications

To integrate OpenLIT with your AI applications:

### Python SDK

```bash
pip install openlit
```

```python
import openlit

openlit.init(
    otlp_endpoint="http://localhost:4318"
)
```

### TypeScript SDK

```bash
npm install openlit
```

```typescript
import Openlit from 'openlit';

Openlit.init({ 
    otlpEndpoint: 'http://localhost:4318'
});
```

## Environment Variables

Key configuration options (see `.env.example` for all options):

| Variable                          | Description                         | Default      |
| --------------------------------- | ----------------------------------- | ------------ |
| `OPENLIT_VERSION`                 | OpenLIT image version               | `latest`     |
| `CLICKHOUSE_VERSION`              | ClickHouse version                  | `24.4.1`     |
| `OPENLIT_PORT_OVERRIDE`           | UI port on host                     | `3000`       |
| `OPENLIT_OTLP_HTTP_PORT_OVERRIDE` | OTLP HTTP port                      | `4318`       |
| `OPENLIT_OTLP_GRPC_PORT_OVERRIDE` | OTLP gRPC port                      | `4317`       |
| `OPENLIT_DB_PASSWORD`             | ClickHouse password                 | `OPENLIT`    |
| `OPAMP_ENVIRONMENT`               | OpAMP mode (development/production) | `production` |

## Resource Requirements

Default resource allocations:

- **OpenLIT**:
  - Limits: 1 CPU, 2GB RAM
  - Reservations: 0.25 CPU, 512MB RAM
- **ClickHouse**:
  - Limits: 2 CPU, 4GB RAM
  - Reservations: 0.5 CPU, 2GB RAM

Adjust these in `.env` file based on your workload.

## OAuth Configuration (Optional)

To enable OAuth authentication:

1. Configure Google OAuth:

   ```env
   GOOGLE_CLIENT_ID=your-client-id
   GOOGLE_CLIENT_SECRET=your-client-secret
   ```

2. Configure GitHub OAuth:

   ```env
   GITHUB_CLIENT_ID=your-client-id
   GITHUB_CLIENT_SECRET=your-client-secret
   ```

## OpAMP Fleet Hub

OpenLIT includes an OpAMP server for centralized management of OpenTelemetry Collectors:

- Access Fleet Hub at: `http://localhost:3000/fleet-hub`
- OpAMP endpoint: `wss://localhost:4320/v1/opamp` (production mode)
- API endpoint: `http://localhost:8080`

For production deployments, ensure proper TLS configuration:

```env
OPAMP_ENVIRONMENT=production
OPAMP_TLS_INSECURE_SKIP_VERIFY=false
OPAMP_TLS_REQUIRE_CLIENT_CERT=true
```

## Supported Integrations

OpenLIT provides automatic instrumentation for 50+ LLM providers, vector databases, and frameworks including:

- **LLM Providers**: OpenAI, Anthropic, Cohere, Azure OpenAI, Google Vertex AI, Bedrock, and more
- **Vector Databases**: Pinecone, Weaviate, ChromaDB, Qdrant, Milvus, and more
- **Frameworks**: LangChain, LlamaIndex, Haystack, AutoGen, CrewAI, and more

## Health Checks

The OpenLIT service includes health checks to ensure proper startup. The service is considered healthy when:

- The web interface responds on the configured port
- Interval: 30 seconds
- Timeout: 10 seconds
- Start period: 60 seconds

## Data Persistence

Data is persisted in Docker volumes:

- `clickhouse_data`: ClickHouse database files
- `openlit_data`: OpenLIT application data including SQLite database

## Monitoring

Monitor your deployment:

```bash
# View logs
docker compose logs -f openlit

# Check service status
docker compose ps

# View resource usage
docker stats
```

## Security Notes

1. **Change default password**: Update `OPENLIT_DB_PASSWORD` in production
2. **TLS Configuration**: For production, use proper TLS certificates with OpAMP
3. **OAuth**: Consider enabling OAuth for enhanced security
4. **Network**: By default, services are exposed on all interfaces. Consider using a reverse proxy in production

## Troubleshooting

### Service won't start

- Check logs: `docker compose logs openlit`
- Verify ClickHouse is healthy: `docker compose ps`
- Ensure ports are not in use

### Cannot connect to OTLP endpoint

- Verify firewall settings
- Check port configuration in `.env`
- Ensure the endpoint URL is correct in your application

### High resource usage

- Adjust resource limits in `.env`
- Monitor with: `docker stats`
- Consider scaling ClickHouse resources for large workloads

## Documentation

- Official Documentation: <https://docs.openlit.io/>
- GitHub Repository: <https://github.com/openlit/openlit>
- Python SDK: <https://github.com/openlit/openlit/tree/main/sdk/python>
- TypeScript SDK: <https://github.com/openlit/openlit/tree/main/sdk/typescript>

## License

OpenLIT is available under the Apache-2.0 license.

## Support

- [Slack Community](https://join.slack.com/t/openlit/shared_invite/zt-2etnfttwg-TjP_7BZXfYg84oAukY8QRQ)
- [Discord](https://discord.gg/CQnXwNT3)
- [GitHub Issues](https://github.com/openlit/openlit/issues)
- [X/Twitter](https://twitter.com/openlit_io)
