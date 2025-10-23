# LiteLLM

[English](./README.md) | [中文](./README.zh.md)

This service deploys LiteLLM, a unified interface to 100+ LLM APIs (OpenAI, Azure, Anthropic, Cohere, Replicate, etc.) with load balancing, fallbacks, and cost tracking.

## Services

- `litellm`: The LiteLLM proxy service
- `db`: PostgreSQL database for storing model configurations and usage data
- `prometheus`: Prometheus metrics collector (optional, enabled with `--profile metrics`)

## Environment Variables

| Variable Name            | Description                                                    | Default Value |
| ------------------------ | -------------------------------------------------------------- | ------------- |
| LITELLM_VERSION          | LiteLLM image version                                          | `main-stable` |
| LITELLM_PORT_OVERRIDE    | Host port mapping for LiteLLM (maps to port 4000 in container) | 4000          |
| POSTGRES_VERSION         | PostgreSQL image version                                       | `16`          |
| POSTGRES_PASSWORD        | PostgreSQL database password                                   | `xxxxxx`      |
| POSTGRES_PORT_OVERRIDE   | Host port mapping for PostgreSQL                               | 5432          |
| PROMETHEUS_VERSION       | Prometheus image version (used with metrics profile)           | `v3.3.1`      |
| PROMETHEUS_PORT_OVERRIDE | Host port mapping for Prometheus                               | 9090          |
| LITELLM_MASTER_KEY       | Master key for LiteLLM authentication                          | `sk-xxxxxx`   |
| LITELLM_SALT_KEY         | Salt key for secure key generation                             | `sk-xxxxxx`   |
| TZ                       | Timezone setting                                               | `UTC`         |

Additional API keys can be configured in the `.env` file for various LLM providers (OpenAI, Azure, Anthropic, etc.).

Please modify the `.env` file as needed for your use case.

## Volumes

- `postgres_data`: PostgreSQL data persistence
- `prometheus_data`: Prometheus data storage (optional)
- `./config.yaml`: LiteLLM configuration file (optional, uncomment in docker-compose.yaml to use)
- `./prometheus.yml`: Prometheus configuration file (optional)

## Ports

- `4000`: LiteLLM proxy API and Web UI
- `5432`: PostgreSQL database
- `9090`: Prometheus metrics (optional, enabled with `--profile metrics`)

## First-Time Setup

1. Start the services (with optional metrics):

   ```bash
   docker compose up -d
   # Or with Prometheus metrics:
   docker compose --profile metrics up -d
   ```

2. Access LiteLLM UI at `http://localhost:4000`

3. Default credentials:
   - Username: `admin`
   - Password: Value of `LITELLM_MASTER_KEY` environment variable

4. Configure your LLM API keys in the `.env` file or through the web UI

## Configuration

### Using a Config File

To use a `config.yaml` file for configuration:

1. Create a `config.yaml` file in the same directory as `docker-compose.yaml`
2. Uncomment the volumes and command sections in `docker-compose.yaml`
3. Configure your models, API keys, and routing rules in `config.yaml`

### API Keys

Add API keys for your LLM providers in the `.env` file:

- `OPENAI_API_KEY`: OpenAI API key
- `ANTHROPIC_API_KEY`: Anthropic API key
- `AZURE_API_KEY`: Azure OpenAI API key
- And more (see `.env.example`)

## Usage

### Making API Calls

Use the LiteLLM proxy endpoint with your master key:

```bash
curl -X POST http://localhost:4000/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $LITELLM_MASTER_KEY" \
  -d '{
    "model": "gpt-3.5-turbo",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

### Monitoring with Prometheus

If you enabled the metrics profile, access Prometheus at `http://localhost:9090` to view metrics about:

- Request counts and latencies
- Token usage
- Cost tracking
- Error rates

## Additional Information

- Official Documentation: <https://docs.litellm.ai/>
- GitHub Repository: <https://github.com/BerriAI/litellm>
- Supported LLM Providers: <https://docs.litellm.ai/docs/providers>
