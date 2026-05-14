# llama.cpp

[中文文档](README.zh.md)

[llama.cpp](https://github.com/ggml-org/llama.cpp) is a high-performance C/C++ implementation for LLM inference with support for various hardware accelerators.

## Features

- **Fast Inference**: Optimized C/C++ implementation for efficient LLM inference
- **Multiple Backends**: CPU, CUDA (NVIDIA), ROCm (AMD), MUSA (Moore Threads), Intel GPU, Vulkan
- **OpenAI-compatible API**: Server mode with OpenAI-compatible REST API
- **CLI Support**: Interactive command-line interface for quick testing
- **Model Conversion**: Full toolkit includes tools to convert and quantize models
- **GGUF Format**: Support for the efficient GGUF model format
- **Cross-platform**: Linux (x86-64, ARM64, s390x), Windows, macOS

## Prerequisites

- Docker and Docker Compose installed
- At least 4GB of RAM (8GB+ recommended)
- For GPU variants:
  - **CUDA**: NVIDIA GPU with [nvidia-container-toolkit](https://github.com/NVIDIA/nvidia-container-toolkit)
  - **ROCm**: AMD GPU with proper ROCm drivers
  - **MUSA**: Moore Threads GPU with mt-container-toolkit
- GGUF format model file (e.g., from [Hugging Face](https://huggingface.co/models?library=gguf))

## Quick Start

### 1. Server Mode (CPU)

```bash
# Copy and configure environment
cp .env.example .env

# Edit .env and set your model path
# LLAMA_CPP_MODEL_PATH=/models/your-model.gguf

# Place your GGUF model in a directory, then update docker-compose.yaml
# to mount it, e.g.:
# volumes:
#   - ./models:/models

# Start the server
docker compose --profile server up -d

# Test the server (OpenAI-compatible API)
curl http://localhost:8080/v1/models

# Chat completion request
curl http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
      {"role": "user", "content": "Hello!"}
    ]
  }'
```

### 2. Server Mode with NVIDIA GPU

```bash
# Edit .env
# Set LLAMA_CPP_GPU_LAYERS=99 to offload all layers to GPU

# Start GPU-accelerated server
docker compose --profile cuda up -d

# The server will automatically use NVIDIA GPU
```

### 3. Server Mode with AMD GPU

```bash
# Edit .env
# Set LLAMA_CPP_GPU_LAYERS=99 to offload all layers to GPU

# Start GPU-accelerated server
docker compose --profile rocm up -d

# The server will automatically use AMD GPU
```

### 4. CLI Mode

```bash
# Edit .env and configure model path and prompt

# Run CLI
docker compose --profile cli up

# For interactive mode, use:
docker compose run --rm llama-cpp-cli \
  -m /models/your-model.gguf \
  -p "Your prompt here" \
  -n 512
```

### 5. Full Toolkit (Model Conversion)

```bash
# Start the full container
docker compose --profile full up -d

# Execute commands inside the container
docker compose exec llama-cpp-full bash

# Inside container, you can use conversion tools
# Example: Convert a Hugging Face model
# python3 convert_hf_to_gguf.py /models/source-model --outfile /models/output.gguf
```

## Configuration

### Environment Variables

Key environment variables (see [.env.example](.env.example) for all options):

| Variable                         | Description                                                   | Default              |
| -------------------------------- | ------------------------------------------------------------- | -------------------- |
| `LLAMA_CPP_SERVER_VARIANT`       | Server image variant (server, server-cuda, server-rocm, etc.) | `server`             |
| `LLAMA_CPP_MODEL_PATH`           | Model file path inside container                              | `/models/model.gguf` |
| `LLAMA_CPP_CONTEXT_SIZE`         | Context window size in tokens                                 | `512`                |
| `LLAMA_CPP_GPU_LAYERS`           | Number of layers to offload to GPU (0=CPU only, 99=all)       | `0`                  |
| `LLAMA_CPP_SERVER_PORT_OVERRIDE` | Server port on host                                           | `8080`               |
| `LLAMA_CPP_SERVER_MEMORY_LIMIT`  | Memory limit for server                                       | `8G`                 |

### Available Profiles

- `server`: CPU-only server
- `cuda`: NVIDIA GPU server (requires nvidia-container-toolkit)
- `rocm`: AMD GPU server (requires ROCm)
- `cli`: Command-line interface
- `full`: Full toolkit with model conversion tools
- `gpu`: Generic GPU profile (includes cuda and rocm)

### Image Variants

Each variant comes in multiple flavors:

- **server**: Only `llama-server` executable (API server)
- **light**: Only `llama-cli` and `llama-completion` executables
- **full**: Complete toolkit including model conversion tools

Backend options:

- Base (CPU)
- `-cuda` (NVIDIA GPU)
- `-rocm` (AMD GPU)
- `-musa` (Moore Threads GPU)
- `-intel` (Intel GPU with SYCL)
- `-vulkan` (Vulkan GPU)

## Server API

The server provides an OpenAI-compatible API:

- `GET /health` - Health check
- `GET /v1/models` - List available models
- `POST /v1/chat/completions` - Chat completion
- `POST /v1/completions` - Text completion
- `POST /v1/embeddings` - Generate embeddings

See the [llama.cpp server documentation](https://github.com/ggml-org/llama.cpp/blob/master/examples/server/README.md) for full API details.

## Model Sources

Download GGUF models from:

- [Hugging Face GGUF Models](https://huggingface.co/models?library=gguf)
- [TheBloke's GGUF Collection](https://huggingface.co/TheBloke)
- Convert your own models using the full toolkit

Popular quantization formats:

- `Q4_K_M`: Good balance of quality and size (recommended)
- `Q5_K_M`: Higher quality, larger size
- `Q8_0`: Very high quality, large size
- `Q2_K`: Smallest size, lower quality

## Resource Requirements

Minimum requirements by model size:

| Model Size | RAM (CPU) | VRAM (GPU) | Context Size |
| ---------- | --------- | ---------- | ------------ |
| 7B Q4_K_M  | 6GB       | 4GB        | 2048         |
| 13B Q4_K_M | 10GB      | 8GB        | 2048         |
| 34B Q4_K_M | 24GB      | 20GB       | 2048         |
| 70B Q4_K_M | 48GB      | 40GB       | 2048         |

Larger context sizes require proportionally more memory.

## Performance Tuning

For CPU inference:

- Increase `LLAMA_CPP_SERVER_CPU_LIMIT` for more cores
- Optimize threads with `-t` flag (default: auto)

For GPU inference:

- Set `LLAMA_CPP_GPU_LAYERS=99` to offload all layers
- Increase context size for longer conversations
- Monitor GPU memory usage

## Security Notes

- The server binds to `0.0.0.0` by default - ensure proper network security
- No authentication is enabled by default
- Consider using a reverse proxy (nginx, Caddy) for production deployments
- Limit resource usage to prevent system exhaustion

## Troubleshooting

### Out of Memory

- Reduce `LLAMA_CPP_CONTEXT_SIZE`
- Use a smaller quantized model (e.g., Q4 instead of Q8)
- Reduce `LLAMA_CPP_GPU_LAYERS` if using GPU

### GPU Not Detected

**NVIDIA**: Verify nvidia-container-toolkit is installed:

```bash
docker run --rm --gpus all nvidia/cuda:12.4.0-base-ubuntu22.04 nvidia-smi
```

**AMD**: Ensure ROCm drivers and `/dev/kfd`, `/dev/dri` are accessible.

### Slow Inference

- Check CPU/GPU utilization
- Increase resource limits in `.env`
- For GPU: Verify all layers are offloaded (`LLAMA_CPP_GPU_LAYERS=99`)

## Documentation

- [llama.cpp GitHub](https://github.com/ggml-org/llama.cpp)
- [Docker Documentation](https://github.com/ggml-org/llama.cpp/blob/master/docs/docker.md)
- [Server API Docs](https://github.com/ggml-org/llama.cpp/blob/master/examples/server/README.md)

## License

llama.cpp is released under the MIT License. See the [LICENSE](https://github.com/ggml-org/llama.cpp/blob/master/LICENSE) file for details.
