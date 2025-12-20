# NexaSDK

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署 NexaSDK Docker，运行兼容 OpenAI 的 REST API 的 AI 模型。支持 LLM、Embeddings、Reranking、计算机视觉和 ASR 模型。

## 特性

- **OpenAI 兼容 API**：可直接替换 OpenAI API 端点
- **多种模型类型**：LLM、VLM、Embeddings、Reranking、CV、ASR
- **GPU 加速**：支持 NVIDIA GPU 的 CUDA 加速
- **NPU 支持**：针对 ARM64 上的 Qualcomm NPU 优化

## 支持的模型

| 类型          | 模型                                                    |
| ------------- | ------------------------------------------------------- |
| **LLM**       | `NexaAI/LFM2-1.2B-npu`、`NexaAI/Granite-4.0-h-350M-NPU` |
| **VLM**       | `NexaAI/OmniNeural-4B`                                  |
| **Embedding** | `NexaAI/embeddinggemma-300m-npu`、`NexaAI/EmbedNeural`  |
| **Rerank**    | `NexaAI/jina-v2-rerank-npu`                             |
| **CV**        | `NexaAI/yolov12-npu`、`NexaAI/convnext-tiny-npu-IoT`    |
| **ASR**       | `NexaAI/parakeet-tdt-0.6b-v3-npu`                       |

## 用法

### CPU 模式

```bash
docker compose --profile cpu up -d
```

### GPU 模式（CUDA）

```bash
docker compose --profile gpu up -d nexa-sdk-cuda
```

### 拉取模型

```bash
docker exec -it nexa-sdk nexa pull NexaAI/Granite-4.0-h-350M-NPU
```

### 交互式 CLI

```bash
docker exec -it nexa-sdk nexa infer NexaAI/Granite-4.0-h-350M-NPU
```

### API 示例

- 聊天补全：

  ```bash
  curl -X POST http://localhost:18181/v1/chat/completions \
    -H "Content-Type: application/json" \
    -d '{
      "model": "NexaAI/Granite-4.0-h-350M-NPU",
      "messages": [{"role": "user", "content": "Hello!"}]
    }'
  ```

- Embeddings：

  ```bash
  curl -X POST http://localhost:18181/v1/embeddings \
    -H "Content-Type: application/json" \
    -d '{
      "model": "NexaAI/EmbedNeural",
      "input": "Hello, world!"
    }'
  ```

- Swagger UI：访问 `http://localhost:18181/docs/ui`

## 服务

- `nexa-sdk`：基于 CPU 的 NexaSDK 服务（默认）
- `nexa-sdk-cuda`：支持 CUDA 的 GPU 加速服务（profile：`gpu`）

## 配置

| 变量                     | 描述                  | 默认值    |
| ------------------------ | --------------------- | --------- |
| `NEXA_SDK_VERSION`       | NexaSDK 镜像版本      | `v0.2.65` |
| `NEXA_SDK_PORT_OVERRIDE` | REST API 的主机端口   | `18181`   |
| `NEXA_TOKEN`             | Nexa API 令牌（必需） | -         |
| `TZ`                     | 时区                  | `UTC`     |

## 卷

- `nexa_data`：用于存储下载的模型和数据的卷

## 获取令牌

1. 在 [sdk.nexa.ai](https://sdk.nexa.ai) 创建账户
2. 进入 **Deployment → Create Token**
3. 将令牌复制到 `.env` 文件中

## 参考资料

- [NexaSDK 文档](https://docs.nexa.ai/nexa-sdk-docker/overview)
- [Docker Hub](https://hub.docker.com/r/nexa4ai/nexasdk)
- [支持的模型](https://docs.nexa.ai/nexa-sdk-docker/overview#supported-models)
