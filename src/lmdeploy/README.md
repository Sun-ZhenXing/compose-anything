# LMDeploy Docker Compose

[LMDeploy](https://github.com/InternLM/lmdeploy) is a toolkit for compressing, deploying, and serving LLMs.

## Quick Start

1. (Optional) Configure the model and port in `.env`.
2. Start the service:
   ```bash
   docker compose up -d
   ```
3. Access the OpenAI compatible API at `http://localhost:23333/v1`.

## Configuration

| Environment Variable     | Default                        | Description                          |
| ------------------------ | ------------------------------ | ------------------------------------ |
| `LMDEPLOY_VERSION`       | `v0.11.1-cu12.8`               | LMDeploy image version               |
| `LMDEPLOY_PORT_OVERRIDE` | `23333`                        | Host port for the API server         |
| `LMDEPLOY_MODEL`         | `internlm/internlm2-chat-1_8b` | HuggingFace model ID or local path   |
| `HF_TOKEN`               |                                | HuggingFace token for private models |

## Monitoring Health

The service includes a health check that verifies if the OpenAI `/v1/models` endpoint is responsive.

## GPU Support

By default, this configuration reserves 1 NVIDIA GPU. Ensure you have the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) installed on your host.
