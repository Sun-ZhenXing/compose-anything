# llama-swap

[llama-swap](https://github.com/mostlygeek/llama-swap) is a lightweight reverse proxy that provides reliable on-demand model swapping for any local OpenAI/Anthropic-compatible inference server (e.g., llama.cpp, vllm). Only one model is loaded at a time, and it is automatically swapped out when a different model is requested, making it easy to work with many models on a single machine.

See also: [README.zh.md](./README.zh.md)

## Features

- **On-demand model swapping**: Automatically load/unload models based on API requests with zero manual intervention.
- **OpenAI/Anthropic compatible**: Drop-in replacement for any client that uses the OpenAI or Anthropic chat completion API.
- **Multi-backend support**: Works with llama.cpp (llama-server), vllm, and any OpenAI-compatible server.
- **Real-time Web UI**: Built-in interface for monitoring logs, inspecting requests, and manually managing models.
- **TTL-based unloading**: Models can be configured to unload automatically after a period of inactivity.
- **HuggingFace model downloads**: Reference HuggingFace models directly in `config.yaml` and they are downloaded on first use.
- **Multi-GPU support**: Works with NVIDIA CUDA, AMD ROCm/Vulkan, Intel, and CPU-only setups.

## Quick Start

1. Copy the example environment file:

   ```bash
   cp .env.example .env
   ```

2. Edit `config.yaml` to add your models. The provided `config.yaml` includes a commented example for a local GGUF model and a HuggingFace download. See [Configuration](#configuration) for details.

3. Start the service (CPU-only by default):

   ```bash
   docker compose up -d
   ```

4. For NVIDIA GPU support:

   ```bash
   docker compose --profile gpu up -d
   ```

5. For AMD GPU support (Vulkan):

   ```bash
   docker compose --profile gpu-amd up -d
   ```

The API and Web UI are available at: `http://localhost:9292`

## Services

| Service           | Profile     | Description                       |
| ----------------- | ----------- | --------------------------------- |
| `llama-swap`      | _(default)_ | CPU-only inference                |
| `llama-swap-cuda` | `gpu`       | NVIDIA CUDA GPU inference         |
| `llama-swap-amd`  | `gpu-amd`   | AMD GPU inference (Vulkan / ROCm) |

> **Note**: Only start one service at a time. All three services bind to the same host port (`LLAMA_SWAP_PORT_OVERRIDE`).

## Configuration

### `config.yaml`

The `config.yaml` file defines the models llama-swap manages. It is mounted read-only at `/app/config.yaml` inside the container. Edit the provided `config.yaml` to add your models.

Minimal example:

```yaml
healthCheckTimeout: 300

models:
  my-model:
    cmd: /app/llama-server --port ${PORT} --model /root/.cache/llama.cpp/model.gguf --ctx-size 4096
    proxy: 'http://localhost:${PORT}'
    ttl: 900
```

- `${PORT}` is automatically assigned by llama-swap.
- `ttl` (seconds): unload the model after this many seconds of inactivity.
- `cmd`: the command to start the inference server.
- `proxy`: the address llama-swap forwards requests to.

For downloading models from HuggingFace on first use:

```yaml
models:
  Qwen2.5-7B:
    cmd: /app/llama-server --port ${PORT} -hf bartowski/Qwen2.5-7B-Instruct-GGUF:Q4_K_M --ctx-size 8192 --n-gpu-layers 99
    proxy: 'http://localhost:${PORT}'
```

See the [official configuration documentation](https://github.com/mostlygeek/llama-swap/blob/main/docs/config.md) for all options including `groups`, `hooks`, `macros`, `aliases`, `filters`, and more.

### Models Volume

The named volume `llama_swap_models` is mounted to `/root/.cache/llama.cpp` inside the container. To place local GGUF model files inside the volume, you can use:

```bash
# Copy a model into the named volume
docker run --rm -v llama_swap_models:/data -v /path/to/model.gguf:/src/model.gguf alpine cp /src/model.gguf /data/model.gguf
```

Alternatively, change the volume definition in `docker-compose.yaml` to use a host path:

```yaml
volumes:
  llama_swap_models:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /path/to/your/models
```

## Environment Variables

| Variable                        | Default    | Description                                        |
| ------------------------------- | ---------- | -------------------------------------------------- |
| `TZ`                            | `UTC`      | Container timezone                                 |
| `GHCR_REGISTRY`                 | `ghcr.io/` | GitHub Container Registry prefix                   |
| `LLAMA_SWAP_VERSION`            | `cpu`      | Image tag for the default CPU service              |
| `LLAMA_SWAP_CUDA_VERSION`       | `cuda`     | Image tag for the CUDA service                     |
| `LLAMA_SWAP_AMD_VERSION`        | `vulkan`   | Image tag for the AMD service (`vulkan` or `rocm`) |
| `LLAMA_SWAP_PORT_OVERRIDE`      | `9292`     | Host port for the API and Web UI                   |
| `LLAMA_SWAP_GPU_COUNT`          | `1`        | Number of NVIDIA GPUs to use (CUDA profile)        |
| `LLAMA_SWAP_CPU_LIMIT`          | `4.0`      | CPU limit in cores                                 |
| `LLAMA_SWAP_CPU_RESERVATION`    | `2.0`      | CPU reservation in cores                           |
| `LLAMA_SWAP_MEMORY_LIMIT`       | `8G`       | Memory limit                                       |
| `LLAMA_SWAP_MEMORY_RESERVATION` | `4G`       | Memory reservation                                 |

## Default Ports

| Port   | Description                                |
| ------ | ------------------------------------------ |
| `9292` | OpenAI/Anthropic-compatible API and Web UI |

## API Usage

llama-swap exposes an OpenAI-compatible API. Use any OpenAI client by pointing it to `http://localhost:9292`:

```bash
# List available models
curl http://localhost:9292/v1/models

# Chat completion (automatically loads the model if not running)
curl http://localhost:9292/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "my-model",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

The Web UI is available at `http://localhost:9292` and provides real-time log streaming, request inspection, and manual model management.

## NVIDIA GPU Setup

Requires the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html).

```bash
docker compose --profile gpu up -d
```

For non-root security hardening, use the `cuda-non-root` image tag:

```yaml
LLAMA_SWAP_CUDA_VERSION=cuda-non-root
```

## AMD GPU Setup

Requires the `/dev/dri` and `/dev/dri` devices to be accessible on the host.

```bash
docker compose --profile gpu-amd up -d
```

Use `rocm` instead of `vulkan` for full ROCm support:

```bash
LLAMA_SWAP_AMD_VERSION=rocm docker compose --profile gpu-amd up -d
```

## Security Notes

- By default, the container runs as root. Use the `cuda-non-root` or `rocm-non-root` image tags for improved security on GPU deployments.
- The `config.yaml` is mounted read-only (`ro`).
- Consider placing llama-swap behind a reverse proxy (e.g., Nginx, Caddy) when exposing it beyond localhost.

## References

- [llama-swap GitHub](https://github.com/mostlygeek/llama-swap)
- [Configuration Documentation](https://github.com/mostlygeek/llama-swap/blob/main/docs/config.md)
- [Container Security](https://github.com/mostlygeek/llama-swap/blob/main/docs/container-security.md)
- [Docker Compose Wiki](https://github.com/mostlygeek/llama-swap/wiki/Docker-Compose-Example)

## License

llama-swap is released under the MIT License. See the [LICENSE](https://github.com/mostlygeek/llama-swap/blob/main/LICENSE) file for details.
