# MinerU SGLang

[English](./README.md) | [中文](./README.zh.md)

此服务使用 SGLang 后端运行 MinerU。

## 启动服务

- **SGLang 后端服务器**:

  ```bash
  docker compose --profile sglang-server up -d
  ```

- **文档解析 API**:

  ```bash
  docker compose --profile api up -d
  ```

- **Gradio WebUI**:

  ```bash
  docker compose --profile gradio up -d
  ```

## 测试 SGLang 后端

```bash
pip install mineru
mineru -p demo.pdf -o ./output -b vlm-sglang-client -u http://localhost:30000
```

## 服务

- `mineru-sglang-server`: SGLang 后端服务器。
- `mineru-api`: 文档解析 API。
- `mineru-gradio`: Gradio WebUI。

## 配置

- `MINERU_DOCKER_IMAGE`: MinerU SGLang 的 Docker 镜像，默认为 `alexsuntop/mineru-sglang:2.2.2`。
- `MINERU_PORT_OVERRIDE_SGLANG`: SGLang 服务器的主机端口，默认为 `30000`。
- `MINERU_PORT_OVERRIDE_API`: API 服务的主机端口，默认为 `8000`。
- `MINERU_PORT_OVERRIDE_GRADIO`: Gradio WebUI 的主机端口，默认为 `7860`。
