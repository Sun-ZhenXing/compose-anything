# DeepTutor

[中文说明](README.zh.md) | English

## Overview

DeepTutor is an AI-powered personalized learning assistant that transforms any document into an interactive learning experience with multi-agent intelligence. It helps you solve problems, generate questions, conduct research, collaborate on writing, organize notes, and guides you through learning paths.

**Project:** <https://github.com/HKUDS/DeepTutor>
**License:** Apache-2.0
**Documentation:** <https://hkuds.github.io/DeepTutor/>

## Features

- **Problem Solving** — Detailed step-by-step solutions with visual diagrams
- **Question Generation** — Adaptive questions based on your knowledge level
- **Research Assistant** — Deep research with multi-agent collaboration
- **Co-Writer** — Interactive idea generation and writing assistance
- **Smart Notebook** — Organize and retrieve learning materials efficiently
- **Guided Learning** — Personalized learning paths and progress tracking
- **Multi-Agent System** — Specialized agents for different learning tasks
- **RAG Integration** — LightRAG and RAG-Anything for knowledge retrieval
- **Code Execution** — Built-in code playground for practice

## Quick Start

### Prerequisites

- Docker and Docker Compose
- OpenAI API key (required)
- Optional: Anthropic, Perplexity, or DashScope API keys

### Installation

1. **Clone this repository**

    ```bash
    git clone <your-compose-anything-repo>
    cd apps/deeptutor
    ```

2. **Configure environment**

    ```bash
    cp .env.example .env
    # Edit .env and add your API keys
    ```

    **Required configuration:**
    - `OPENAI_API_KEY` — Your OpenAI API key

    **Optional configuration:**
    - `ANTHROPIC_API_KEY` — For Claude models
    - `PERPLEXITY_API_KEY` — For web search
    - `DASHSCOPE_API_KEY` — For Alibaba Cloud models
    - Adjust ports if needed (default: 8001 for backend, 3782 for frontend)
    - Set `NEXT_PUBLIC_API_BASE_EXTERNAL` for cloud deployments

3. **Optional: Custom agent configuration**

    Create a `config/agents.yaml` file to customize agent behaviors (see [documentation](https://hkuds.github.io/DeepTutor/guide/config.html) for details).

4. **Start the service**

    ```bash
    docker compose up -d
    ```

    First run takes approximately 30-60 seconds to initialize.

5. **Access the application**

      - **Frontend:** <http://localhost:3782>
      - **Backend API:** <http://localhost:8001>
      - **API Documentation:** <http://localhost:8001/docs>

## Usage

### Create Knowledge Base

1. Navigate to <http://localhost:3782/knowledge>
2. Click "New Knowledge Base"
3. Upload documents (supports PDF, DOCX, TXT, Markdown, HTML, etc.)
4. Wait for processing to complete

### Learning Modes

- **Solve** — Get step-by-step solutions to problems
- **Question** — Generate practice questions based on your materials
- **Research** — Deep research with multi-agent collaboration
- **Co-Writer** — Interactive writing and idea generation
- **Notebook** — Organize and manage your learning materials
- **Guide** — Follow personalized learning paths

### Advanced Features

- **Code Execution** — Practice coding directly in the interface
- **Visual Diagrams** — Automatic diagram generation for complex concepts
- **Export** — Download your work as PDF or Markdown
- **Multi-language** — Support for multiple languages

## Configuration

### Environment Variables

Key environment variables (see [.env.example](.env.example) for all options):

| Variable                 | Default    | Description               |
| ------------------------ | ---------- | ------------------------- |
| `OPENAI_API_KEY`         | (required) | Your OpenAI API key       |
| `DEFAULT_MODEL`          | `gpt-4o`   | Default LLM model         |
| `BACKEND_PORT`           | `8001`     | Backend server port       |
| `FRONTEND_PORT`          | `3782`     | Frontend application port |
| `DEEPTUTOR_CPU_LIMIT`    | `4.00`     | CPU limit (cores)         |
| `DEEPTUTOR_MEMORY_LIMIT` | `8G`       | Memory limit              |

### Ports

- **8001** — Backend API server
- **3782** — Frontend web interface

### Volumes

- `deeptutor_data` — User data, knowledge bases, and learning materials
- `./config` — Custom agent configurations (optional)

## Resource Requirements

**Minimum:**

- CPU: 1 core
- Memory: 2GB
- Disk: 2GB + space for knowledge bases

**Recommended:**

- CPU: 4 cores
- Memory: 8GB
- Disk: 10GB+

## Supported Models

DeepTutor supports multiple LLM providers:

- **OpenAI** — GPT-4, GPT-4 Turbo, GPT-3.5 Turbo
- **Anthropic** — Claude 3 (Opus, Sonnet, Haiku)
- **Perplexity** — For web search integration
- **DashScope** — Alibaba Cloud models
- **OpenAI-compatible APIs** — Any API compatible with OpenAI format

## Troubleshooting

### Backend fails to start

- Verify `OPENAI_API_KEY` is set correctly in `.env`
- Check logs: `docker compose logs -f`
- Ensure ports 8001 and 3782 are not in use
- Verify sufficient disk space for volumes

### Frontend cannot connect to backend

- Confirm backend is running: visit <http://localhost:8001/docs>
- For cloud deployments, set `NEXT_PUBLIC_API_BASE_EXTERNAL` to your public URL
- Check firewall settings

### Knowledge base processing fails

- Ensure sufficient memory (recommended 8GB+)
- Check document format is supported
- Review logs for specific errors

### API rate limits

- Monitor your API usage on provider dashboards
- Consider upgrading your API plan
- Use different models for different tasks

## Security Notes

- **API Keys** — Keep your API keys secure, never commit them to version control
- **Network Exposure** — For production deployments, use HTTPS and proper authentication
- **Data Privacy** — User data is stored in Docker volumes; ensure proper backup and security
- **Resource Limits** — Set appropriate CPU and memory limits to prevent resource exhaustion

## Updates

To update to the latest version:

```bash
# Pull the latest image
docker compose pull

# Recreate containers
docker compose up -d
```

To update to a specific version, edit `DEEPTUTOR_VERSION` in `.env` and run:

```bash
docker compose up -d
```

## Advanced Usage

### Custom Agent Configuration

Create `config/agents.yaml` to customize agent behaviors:

```yaml
agents:
  solver:
    model: gpt-4o
    temperature: 0.7
  researcher:
    model: gpt-4-turbo
    max_tokens: 4000
```

See [official documentation](https://hkuds.github.io/DeepTutor/guide/config.html) for detailed configuration options.

### Cloud Deployment

For cloud deployment, additional configuration is needed:

1. Set public URL in `.env`:

    ```env
    NEXT_PUBLIC_API_BASE_EXTERNAL=https://your-domain.com:8001
    ```

2. Configure reverse proxy (nginx/Caddy) for HTTPS
3. Ensure proper firewall rules
4. Consider using environment-specific secrets management

### Using Different Embedding Models

DeepTutor uses `text-embedding-3-large` by default. To use different embedding models, refer to the [official documentation](https://hkuds.github.io/DeepTutor/guide/config.html).

## Links

- **GitHub:** <https://github.com/HKUDS/DeepTutor>
- **Documentation:** <https://hkuds.github.io/DeepTutor/>
- **Issues:** <https://github.com/HKUDS/DeepTutor/issues>
- **Discussions:** <https://github.com/HKUDS/DeepTutor/discussions>

## License

DeepTutor is licensed under the Apache-2.0 License. See the [official repository](https://github.com/HKUDS/DeepTutor) for details.
