# GPUStack

[English](./README.md) | [中文](./README.zh.md)

This service deploys GPUStack, an open-source GPU cluster manager for running large language models (LLMs).

## Services

- `gpustack`: GPUStack server with built-in worker

## Environment Variables

| Variable Name               | Description                            | Default Value |
| --------------------------- | -------------------------------------- | ------------- |
| GPUSTACK_VERSION            | GPUStack image version                 | `v0.5.3`      |
| GPUSTACK_HOST               | Host to bind the server to             | `0.0.0.0`     |
| GPUSTACK_PORT               | Port to bind the server to             | `80`          |
| GPUSTACK_DEBUG              | Enable debug mode                      | `false`       |
| GPUSTACK_BOOTSTRAP_PASSWORD | Password for the bootstrap admin user  | `admin`       |
| GPUSTACK_TOKEN              | Token for worker registration          | (auto)        |
| HF_TOKEN                    | Hugging Face token for model downloads | `""`          |
| GPUSTACK_PORT_OVERRIDE      | Host port mapping                      | `80`          |

Please modify the `.env` file as needed for your use case.

## Volumes

- `gpustack_data`: Data directory for GPUStack

## GPU Support

### NVIDIA GPU

Uncomment the GPU-related configuration in `docker-compose.yaml`:

```yaml
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
    runtime: nvidia
```

### AMD GPU (ROCm)

Use the ROCm-specific image:

```yaml
image: gpustack/gpustack:v0.5.3-rocm
```

## Usage

### Start GPUStack

```bash
docker compose up -d
```

### Access

- Web UI: <http://localhost:80>
- Default credentials: `admin` / `admin` (configured via `GPUSTACK_BOOTSTRAP_PASSWORD`)

### Deploy a Model

1. Log in to the web UI
2. Navigate to Models
3. Click "Deploy Model"
4. Select a model from the catalog or add a custom model
5. Configure the model parameters
6. Click "Deploy"

### Add Worker Nodes

To add more GPU nodes to the cluster:

1. Get the registration token from the server:

    ```bash
    docker exec gpustack cat /var/lib/gpustack/token
    ```

2. Start a worker on another node:

    ```bash
    docker run -d --name gpustack-worker \
      --gpus all \
      --network host \
      --ipc host \
      -v gpustack-data:/var/lib/gpustack \
      gpustack/gpustack:v0.5.3 \
      --server-url http://your-server-ip:80 \
      --token YOUR_TOKEN
    ```

## Features

- **Model Management**: Deploy and manage LLM models from Hugging Face, ModelScope, or custom sources
- **GPU Scheduling**: Automatic GPU allocation and scheduling
- **Multi-Backend**: Supports llama-box, vLLM, and other backends
- **API Compatible**: OpenAI-compatible API endpoint
- **Web UI**: User-friendly web interface for management
- **Monitoring**: Resource usage and model metrics

## API Usage

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

## Notes

- For production use, change the default password
- GPU support requires NVIDIA Docker runtime or AMD ROCm support
- Model downloads can be large (several GB), ensure sufficient disk space
- First model deployment may take time as it downloads the model files

## Security

- Change default admin password after first login
- Use strong passwords for API keys
- Consider using TLS for production deployments
- Restrict network access to trusted sources

## License

GPUStack is licensed under Apache License 2.0. See [GPUStack GitHub](https://github.com/gpustack/gpustack) for more information.
