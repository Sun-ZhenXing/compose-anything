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

- `MINERU_VERSION`: The version for MinerU, default is `3.1.0`.
- `MINERU_PORT_OVERRIDE_VLLM`: The host port for the VLLM server, default is `30000`.
- `MINERU_PORT_OVERRIDE_API`: The host port for the API service, default is `8000`.
- `MINERU_PORT_OVERRIDE_GRADIO`: The host port for the Gradio WebUI, default is `7860`.
- `MINERU_API_OUTPUT_ROOT`: The root directory for API server task outputs (inside the container), default is `/tmp/mineru-output`.

## Output Path Structure

MinerU API server (`mineru-api`) creates a UUID-based subdirectory for each parsing task to provide isolation between concurrent requests:

```text
{MINERU_API_OUTPUT_ROOT}/
  {UUID}/
    {filename}/
      auto/            # or "vlm", "hybrid_auto", etc.
        {filename}.md
        {filename}_content_list.json
        images/
```

**Important**: The ZIP response returned by the API automatically strips the UUID prefix. Downstream consumers (including RAGFlow) receive files structured as `{filename}/{parse_method}/{files}` without any UUID.

## RAGFlow Integration

RAGFlow integrates with MinerU via the API server using `response_format_zip=True`. The returned ZIP archive does **not** contain UUIDs, and RAGFlow extracts it into a temporary directory for processing.

### Common Misconception

Users sometimes observe the UUID-based paths on disk (inside the MinerU container) and assume RAGFlow cannot locate the output files. However:

1. RAGFlow communicates with MinerU via HTTP API, not shared filesystem.
2. The API returns a ZIP file with the UUID stripped from paths.
3. RAGFlow has a robust multi-stage file finder that searches several path patterns as fallback.

### Correct Setup

Ensure RAGFlow is configured to call the MinerU API endpoint:

- Set `MINERU_APISERVER=http://<mineru-api-host>:8000` in RAGFlow's environment.
- Set `MINERU_SERVER_URL=http://<mineru-vllm-host>:30000` if using VLM backend.

**Do not** rely on shared filesystem mounts between RAGFlow and MinerU containers — use the HTTP API instead.

### Environment Variables That Do NOT Exist

The following environment variables are **not recognized** by MinerU and have no effect:

- `MINERU_FLAT_OUTPUT`
- `MAGIC_PDF_FLAT_OUTPUT`
- `ENABLE_TASK_ID_DIR`

These are not part of MinerU's configuration. The UUID-based task isolation is an architectural design that cannot be disabled.
