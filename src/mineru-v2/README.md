# MinerU v2

[Reference Documentation](https://opendatalab.github.io/MinerU/zh/usage/quick_usage/).

VLM backend server:

```bash
docker compose --profile vllm-server up -d
```

Document parse API:

```bash
docker compose --profile api up -d
```

Gradio WebUI:

```bash
docker compose --profile gradio up -d
```

Test vLLM backend:

```bash
pip install mineru
mineru -p demo.pdf -o ./output -b vlm-http-client -u http://localhost:30000
```
