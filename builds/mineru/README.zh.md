# MinerU v2

[English](./README.md) | [中文](./README.zh.md)

此服务运行 MinerU v2。请参阅[参考文档](https://opendatalab.github.io/MinerU/zh/usage/quick_usage/)。

## 启动服务

- **VLM 后端服务器**:

  ```bash
  docker compose --profile vllm-server up -d
  ```

- **文档解析 API**:

  ```bash
  docker compose --profile api up -d
  ```

- **Gradio WebUI**:

  ```bash
  docker compose --profile gradio up -d
  ```

## 测试 vLLM 后端

```bash
pip install mineru
mineru -p demo.pdf -o ./output -b vlm-http-client -u http://localhost:30000
```

## 服务

- `mineru-vllm-server`: VLM 后端服务器。
- `mineru-api`: 文档解析 API。
- `mineru-gradio`: Gradio WebUI。

## 配置

- `MINERU_VERSION`: MinerU 的 Docker 镜像版本，默认为 `2.7.6`。
- `MINERU_PORT_OVERRIDE_VLLM`: VLLM 服务器的主机端口，默认为 `30000`。
- `MINERU_PORT_OVERRIDE_API`: API 服务的主机端口，默认为 `8000`。
- `MINERU_PORT_OVERRIDE_GRADIO`: Gradio WebUI 的主机端口，默认为 `7860`。
