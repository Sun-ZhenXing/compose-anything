# MinerU v2

[English](./README.md) | [中文](./README.zh.md)

This service runs MinerU v2. See the [Reference Documentation](https://opendatalab.github.io/MinerU/zh/usage/quick_usage/).

## Start Services

- **VLM backend server**:

  ```bash
  docker compose --profile vllm-server up -d
  ```

- **Document parse API**:

  ```bash
  docker compose --profile api up -d
  ```

- **Gradio WebUI**:

  ```bash
  docker compose --profile gradio up -d
  ```

## Test vLLM backend

```bash
pip install mineru
mineru -p demo.pdf -o ./output -b vlm-http-client -u http://localhost:30000
```

## Services

- `mineru-vllm-server`: The VLM backend server.
- `mineru-api`: The document parsing API.
- `mineru-gradio`: The Gradio WebUI.

## Configuration

- `MINERU_VERSION`: The version for MinerU, default is `2.6.4`.
- `MINERU_PORT_OVERRIDE_VLLM`: The host port for the VLLM server, default is `30000`.
- `MINERU_PORT_OVERRIDE_API`: The host port for the API service, default is `8000`.
- `MINERU_PORT_OVERRIDE_GRADIO`: The host port for the Gradio WebUI, default is `7860`.
