# Nexa SDK

Nexa SDK is a comprehensive toolkit for running AI models locally. It provides inference for various model types including LLM, VLM (Vision Language Models), TTS (Text-to-Speech), ASR (Automatic Speech Recognition), and more. Built with performance in mind, it supports both CPU and GPU acceleration.

## Features

- **Multi-Model Support**: Run LLM, VLM, TTS, ASR, embedding, reranking, and image generation models
- **OpenAI-Compatible API**: Provides standard OpenAI API endpoints for easy integration
- **GPU Acceleration**: Optional GPU support via NVIDIA CUDA for faster inference
- **Resource Management**: Configurable CPU/memory limits and GPU layer offloading
- **Model Caching**: Persistent model storage for faster startup
- **Profile Support**: Easy switching between CPU-only and GPU-accelerated modes

## Quick Start

### Prerequisites

- Docker and Docker Compose
- For GPU support: NVIDIA Docker runtime and compatible GPU

### Basic Usage (CPU)

```bash
# Copy environment file
cp .env.example .env

# Edit .env to configure your model and settings
# NEXA_MODEL=gemma-2-2b-instruct

# Start the service with CPU profile
docker compose --profile cpu up -d
```

### GPU-Accelerated Usage

```bash
# Copy environment file
cp .env.example .env

# Configure for GPU usage
# NEXA_MODEL=gemma-2-2b-instruct
# NEXA_GPU_LAYERS=-1  # -1 means all layers on GPU

# Start the service with GPU profile
docker compose --profile gpu up -d
```

## Configuration

### Environment Variables

| Variable                 | Default               | Description                                            |
| ------------------------ | --------------------- | ------------------------------------------------------ |
| `NEXA_SDK_VERSION`       | `latest`              | Nexa SDK Docker image version                          |
| `NEXA_SDK_PORT_OVERRIDE` | `8080`                | Host port for API access                               |
| `NEXA_MODEL`             | `gemma-2-2b-instruct` | Model to load (e.g., qwen3-4b, llama-3-8b, mistral-7b) |
| `NEXA_HOST`              | `0.0.0.0:8080`        | Server bind address                                    |
| `NEXA_KEEPALIVE`         | `300`                 | Model keepalive timeout in seconds                     |
| `NEXA_ORIGINS`           | `*`                   | CORS allowed origins                                   |
| `NEXA_HFTOKEN`           | -                     | HuggingFace token for private models                   |
| `NEXA_LOG`               | `none`                | Logging level (none, debug, info, warn, error)         |
| `NEXA_GPU_LAYERS`        | `-1`                  | GPU layers to offload (-1 = all, 0 = CPU only)         |
| `NEXA_SHM_SIZE`          | `2g`                  | Shared memory size                                     |
| `TZ`                     | `UTC`                 | Container timezone                                     |

### Resource Limits

| Variable                      | Default | Description        |
| ----------------------------- | ------- | ------------------ |
| `NEXA_SDK_CPU_LIMIT`          | `4.0`   | Maximum CPU cores  |
| `NEXA_SDK_MEMORY_LIMIT`       | `8G`    | Maximum memory     |
| `NEXA_SDK_CPU_RESERVATION`    | `2.0`   | Reserved CPU cores |
| `NEXA_SDK_MEMORY_RESERVATION` | `4G`    | Reserved memory    |

### Profiles

- `cpu`: Run with CPU-only inference (default profile needed)
- `gpu`: Run with GPU acceleration (requires NVIDIA GPU)

## Usage Examples

### Test the API

```bash
# Check available models
curl http://localhost:8080/v1/models

# Chat completion
curl http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gemma-2-2b-instruct",
    "messages": [
      {"role": "user", "content": "Hello!"}
    ]
  }'
```

### Using Different Models

Edit `.env` to change the model:

```bash
# Small models for limited resources
NEXA_MODEL=gemma-2-2b-instruct
# or
NEXA_MODEL=qwen3-4b

# Larger models for better quality
NEXA_MODEL=llama-3-8b
# or
NEXA_MODEL=mistral-7b
```

### GPU Configuration

For GPU acceleration, adjust the number of layers:

```bash
# Offload all layers to GPU (fastest)
NEXA_GPU_LAYERS=-1

# Offload 30 layers (hybrid mode)
NEXA_GPU_LAYERS=30

# CPU only
NEXA_GPU_LAYERS=0
```

## Model Management

Models are automatically downloaded on first run and cached in the `nexa_models` volume. The default cache location inside the container is `/root/.cache/nexa`.

To use a different model:

1. Update `NEXA_MODEL` in `.env`
2. Restart the service: `docker compose --profile <cpu|gpu> restart`

## API Endpoints

Nexa SDK provides OpenAI-compatible API endpoints:

- `GET /v1/models` - List available models
- `POST /v1/chat/completions` - Chat completions
- `POST /v1/completions` - Text completions
- `POST /v1/embeddings` - Text embeddings
- `GET /health` - Health check
- `GET /docs` - API documentation (Swagger UI)

## Troubleshooting

### Out of Memory

Increase memory limits or use a smaller model:

```bash
NEXA_SDK_MEMORY_LIMIT=16G
NEXA_SDK_MEMORY_RESERVATION=8G
# Or switch to a smaller model
NEXA_MODEL=gemma-2-2b-instruct
```

### GPU Not Detected

Ensure NVIDIA Docker runtime is installed:

```bash
# Check GPU availability
docker run --rm --gpus all nvidia/cuda:12.8.1-base-ubuntu22.04 nvidia-smi
```

### Model Download Issues

Set HuggingFace token if accessing private models:

```bash
NEXA_HFTOKEN=your_hf_token_here
```

### Slow Performance

- Use GPU profile for better performance
- Increase `NEXA_GPU_LAYERS` to offload more computation to GPU
- Allocate more resources or use a smaller model

## Advanced Configuration

### Custom Model Path

If you want to use local model files, mount them as a volume:

```yaml
volumes:
  - ./models:/models
  - nexa_models:/root/.cache/nexa
```

Then reference the model by its path in the command.

### HTTPS Configuration

Set environment variables for HTTPS:

```bash
NEXA_ENABLEHTTPS=true
```

Mount certificate files:

```yaml
volumes:
  - ./certs/cert.pem:/app/cert.pem:ro
  - ./certs/key.pem:/app/key.pem:ro
```

## Health Check

The service includes a health check that verifies the API is responding:

```bash
curl http://localhost:8080/v1/models
```

## License

Nexa SDK is developed by Nexa AI. Please refer to the [official repository](https://github.com/NexaAI/nexa-sdk) for license information.

## Links

- [Official Repository](https://github.com/NexaAI/nexa-sdk)
- [Nexa AI Website](https://nexa.ai)
- [Documentation](https://docs.nexa.ai)
- [Model Hub](https://sdk.nexa.ai)
