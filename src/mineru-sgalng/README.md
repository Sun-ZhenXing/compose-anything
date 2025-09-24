# MinerU SGLang

SGLang backend server:

```bash
docker compose --profile sglang-server up -d
```

Document parse API:

```bash
docker compose --profile api up -d
```

Gradio WebUI:

```bash
docker compose --profile gradio up -d
```

Test SGLang backend:

```bash
pip install mineru
mineru -p demo.pdf -o ./output -b vlm-sglang-client -u http://localhost:30000
```
