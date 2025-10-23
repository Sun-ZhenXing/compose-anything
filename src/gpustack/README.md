# GPUStack

[English](./README.md) | [中文](./README.zh.md)

GPUStack is an open-source GPU cluster manager for running and scaling large language models (LLMs).

## Quick Start

```bash
docker compose up -d
```

Access the web UI at <http://localhost:80> with default credentials `admin` / `admin`.

## Services

- `gpustack`: GPUStack server with GPU support enabled by default

## Ports

| Service  | Port |
| -------- | ---- |
| gpustack | 80   |

## Environment Variables

| Variable                    | Description                            | Default   |
| --------------------------- | -------------------------------------- | --------- |
| GPUSTACK_VERSION            | GPUStack image version                 | `v0.7.1`  |
| TZ                          | Timezone setting                       | `UTC`     |
| GPUSTACK_HOST               | Host to bind the server to             | `0.0.0.0` |
| GPUSTACK_PORT               | Port to bind the server to             | `80`      |
| GPUSTACK_DEBUG              | Enable debug mode                      | `false`   |
| GPUSTACK_BOOTSTRAP_PASSWORD | Password for the bootstrap admin user  | `admin`   |
| GPUSTACK_TOKEN              | Token for worker registration          | (auto)    |
| HF_TOKEN                    | Hugging Face token for model downloads | (empty)   |
| GPUSTACK_PORT_OVERRIDE      | Host port mapping                      | `80`      |

## Volumes

- `gpustack_data`: Data directory for GPUStack

## GPU Support

This service is configured with NVIDIA GPU support enabled by default. The configuration uses:

```yaml
deploy:
  resources:
    reservations:
      devices:
        - driver: nvidia
          device_ids: [ '0' ]
          capabilities: [ gpu ]
```

### Requirements

- NVIDIA GPU with CUDA support
- NVIDIA Container Toolkit installed on the host
- Docker 19.03+ with GPU support

### AMD GPU (ROCm)

To use AMD GPUs with ROCm support:

1. Use the ROCm-specific image in `docker-compose.yaml`:

   ```yaml
   image: gpustack/gpustack:${GPUSTACK_VERSION:-v0.7.1}-rocm
   ```

2. Change the device driver to `amdgpu`:

   ```yaml
   deploy:
     resources:
       reservations:
         devices:
           - driver: amdgpu
             device_ids: [ '0' ]
             capabilities: [ gpu ]
   ```

## Usage

### Deploy a Model

1. Log in to the web UI at <http://localhost:80>
2. Navigate to **Models** → **Deploy Model**
3. Select a model from the catalog or add a custom model
4. Configure the model parameters
5. Click **Deploy**

### Add Worker Nodes

To scale your cluster by adding more GPU nodes:

1. Get the registration token from the server:

   ```bash
   docker exec gpustack gpustack show-token
   ```

2. Start a worker on another node:

   ```bash
   docker run -d --name gpustack-worker \
     --gpus all \
     --network host \
     --ipc host \
     -v gpustack-worker-data:/var/lib/gpustack \
     gpustack/gpustack:v0.7.1 \
     gpustack start --server-url http://your-server-ip:80 --token YOUR_TOKEN
   ```

### API Usage

GPUStack provides an OpenAI-compatible API:

```bash
curl http://localhost:80/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -d '{
    "model": "llama-3.2-3b-instruct",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

## Features

- **Model Management**: Deploy and manage LLM models from Hugging Face, ModelScope, or custom sources
- **GPU Scheduling**: Automatic GPU allocation and load balancing
- **Multi-Backend**: Supports llama-box, vLLM, and other inference backends
- **OpenAI-Compatible API**: Drop-in replacement for OpenAI API
- **Web UI**: User-friendly web interface for cluster management
- **Monitoring**: Real-time resource usage and model performance metrics
- **Multi-Node**: Scale across multiple GPU servers

## Notes

- **Production Security**: Change the default `GPUSTACK_BOOTSTRAP_PASSWORD` before deploying
- **GPU Requirements**: NVIDIA GPU with CUDA support is required; ensure NVIDIA Container Toolkit is installed
- **Disk Space**: Model downloads can be several gigabytes; ensure sufficient storage
- **First Deployment**: Initial model deployment may take time as it downloads model files
- **Network**: By default, the service binds to all interfaces (`0.0.0.0`); restrict access in production

## Security

- **Change Default Password**: Update `GPUSTACK_BOOTSTRAP_PASSWORD` after first login
- **API Keys**: Use strong, unique API keys for accessing the API
- **TLS/HTTPS**: Consider using a reverse proxy with TLS for production
- **Network Access**: Restrict access to trusted networks using firewalls
- **Updates**: Keep GPUStack updated to the latest stable version

## License

GPUStack is licensed under Apache License 2.0. See [GPUStack GitHub](https://github.com/gpustack/gpustack) for more information.
