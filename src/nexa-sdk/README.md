# NexaSDK

[English](./README.md) | [中文](./README.zh.md)

This service deploys NexaSDK Docker for running AI models with OpenAI-compatible REST API. Supports LLM, Embeddings, Reranking, Computer Vision, and ASR models.

## Features

- **OpenAI-compatible API**: Drop-in replacement for OpenAI API endpoints
- **Multiple Model Types**: LLM, VLM, Embeddings, Reranking, CV, ASR
- **GPU Acceleration**: CUDA support for NVIDIA GPUs
- **NPU Support**: Optimized for Qualcomm NPU on ARM64

## Supported Models

| Modality      | Models                                                  |
| ------------- | ------------------------------------------------------- |
| **LLM**       | `NexaAI/LFM2-1.2B-npu`, `NexaAI/Granite-4.0-h-350M-NPU` |
| **VLM**       | `NexaAI/OmniNeural-4B`                                  |
| **Embedding** | `NexaAI/embeddinggemma-300m-npu`, `NexaAI/EmbedNeural`  |
| **Rerank**    | `NexaAI/jina-v2-rerank-npu`                             |
| **CV**        | `NexaAI/yolov12-npu`, `NexaAI/convnext-tiny-npu-IoT`    |
| **ASR**       | `NexaAI/parakeet-tdt-0.6b-v3-npu`                       |

## Usage

### CPU Mode

```bash
docker compose up -d
```

### GPU Mode (CUDA)

```bash
docker compose --profile gpu up -d nexa-sdk-cuda
```

### Pull a Model

```bash
docker exec -it nexa-sdk nexa pull NexaAI/Granite-4.0-h-350M-NPU
```

### Interactive CLI

```bash
docker exec -it nexa-sdk nexa infer NexaAI/Granite-4.0-h-350M-NPU
```

### API Examples

- Chat completions:

  ```bash
  curl -X POST http://localhost:18181/v1/chat/completions \
    -H "Content-Type: application/json" \
    -d '{
      "model": "NexaAI/Granite-4.0-h-350M-NPU",
      "messages": [{"role": "user", "content": "Hello!"}]
    }'
  ```

- Embeddings:

  ```bash
  curl -X POST http://localhost:18181/v1/embeddings \
    -H "Content-Type: application/json" \
    -d '{
      "model": "NexaAI/EmbedNeural",
      "input": "Hello, world!"
    }'
  ```

- Swagger UI: Visit `http://localhost:18181/docs/ui`

## Services

- `nexa-sdk`: CPU-based NexaSDK service (default)
- `nexa-sdk-cuda`: GPU-accelerated service with CUDA support (profile: `gpu`)

## Configuration

| Variable                 | Description               | Default   |
| ------------------------ | ------------------------- | --------- |
| `NEXA_SDK_VERSION`       | NexaSDK image version     | `v0.2.62` |
| `NEXA_SDK_PORT_OVERRIDE` | Host port for REST API    | `18181`   |
| `NEXA_TOKEN`             | Nexa API token (required) | -         |
| `TZ`                     | Timezone                  | `UTC`     |

## Volumes

- `nexa_data`: Volume for storing downloaded models and data

## Getting a Token

1. Create an account at [sdk.nexa.ai](https://sdk.nexa.ai)
2. Go to **Deployment → Create Token**
3. Copy the token to your `.env` file

## References

- [NexaSDK Documentation](https://docs.nexa.ai/nexa-sdk-docker/overview)
- [Docker Hub](https://hub.docker.com/r/nexa4ai/nexasdk)
- [Supported Models](https://docs.nexa.ai/nexa-sdk-docker/overview#supported-models)
