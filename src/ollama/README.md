# Ollama

拉取 DeepSeek R1 7B 模型：

```bash
docker exec -it ollama ollama pull deepseek-r1:7b
```

列出本地所有模型：

```bash
docker exec -it ollama ollama list
```

API 请求获取本地所有模型：

```bash
curl http://localhost:11434/api/tags 2> /dev/null | jq
```
