# vLLM

[English](./README.md) | [中文](./README.zh.md)

This service deploys vLLM, a high-throughput and memory-efficient inference and serving engine for LLMs.

## Services

- `vllm`: vLLM OpenAI-compatible API server

## Environment Variables

| Variable Name        | Description                            | Default Value       |
| -------------------- | -------------------------------------- | ------------------- |
| VLLM_VERSION         | vLLM image version                     | `v0.13.0`           |
| VLLM_MODEL           | Model name or path                     | `facebook/opt-125m` |
| VLLM_MAX_MODEL_LEN   | Maximum context length                 | `2048`              |
| VLLM_GPU_MEMORY_UTIL | GPU memory utilization (0.0-1.0)       | `0.9`               |
| HF_TOKEN             | Hugging Face token for model downloads | `""`                |
| VLLM_PORT_OVERRIDE   | Host port mapping                      | `8000`              |

Please modify the `.env` file as needed for your use case.

## Volumes

- `vllm_models`: Cached model files from Hugging Face

## GPU Support

This service requires NVIDIA GPU to run properly. Uncomment the GPU configuration in `docker-compose.yaml`:

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

## Usage

### Start vLLM

```bash
docker compose up -d
```

### Access

- API Endpoint: <http://localhost:8000>
- OpenAI-compatible API: <http://localhost:8000/v1>

### Test the API

```bash
curl http://localhost:8000/v1/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "facebook/opt-125m",
    "prompt": "San Francisco is a",
    "max_tokens": 50,
    "temperature": 0.7
  }'
```

### Chat Completions

```bash
curl http://localhost:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "facebook/opt-125m",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

## Supported Models

vLLM supports a wide range of models:

- **LLaMA**: LLaMA, LLaMA-2, LLaMA-3
- **Mistral**: Mistral, Mixtral
- **Qwen**: Qwen, Qwen2
- **Yi**: Yi, Yi-VL
- **Many others**: See [vLLM supported models](https://docs.vllm.ai/en/latest/models/supported_models.html)

To use a different model, change the `VLLM_MODEL` environment variable:

```bash
# Example: Use Qwen2-7B-Instruct
VLLM_MODEL="Qwen/Qwen2-7B-Instruct"
```

## Performance Tuning

### GPU Memory

Adjust GPU memory utilization based on your model size and available VRAM:

```bash
VLLM_GPU_MEMORY_UTIL=0.85  # Use 85% of GPU memory
```

### Context Length

Set maximum context length according to your needs:

```bash
VLLM_MAX_MODEL_LEN=4096  # Support up to 4K tokens
```

### Shared Memory

For larger models, increase shared memory:

```yaml
shm_size: 8g  # Increase to 8GB
```

## Notes

- Requires NVIDIA GPU with CUDA support
- Model downloads can be large (several GB to 100+ GB)
- First startup may take time as it downloads the model
- Ensure sufficient GPU memory for the model you want to run
- Default model is small (125M parameters) for testing purposes

## Security

- The API has no authentication by default
- Add authentication layer (e.g., nginx with basic auth) for production
- Restrict network access to trusted sources

## License

vLLM is licensed under Apache License 2.0. See [vLLM GitHub](https://github.com/vllm-project/vllm) for more information.
