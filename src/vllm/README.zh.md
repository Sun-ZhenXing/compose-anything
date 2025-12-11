# vLLM

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署 vLLM，一个用于大语言模型的高吞吐量和内存高效的推理和服务引擎。

## 服务

- `vllm`：vLLM OpenAI 兼容 API 服务器

## 环境变量

| 变量名                 | 说明                             | 默认值              |
| ---------------------- | -------------------------------- | ------------------- |
| `VLLM_VERSION`         | vLLM 镜像版本                    | `v0.12.0`           |
| `VLLM_MODEL`           | 模型名称或路径                   | `facebook/opt-125m` |
| `VLLM_MAX_MODEL_LEN`   | 最大上下文长度                   | `2048`              |
| `VLLM_GPU_MEMORY_UTIL` | GPU 内存利用率（0.0-1.0）        | `0.9`               |
| `HF_TOKEN`             | 用于模型下载的 Hugging Face 令牌 | `""`                |
| `VLLM_PORT_OVERRIDE`   | 主机端口映射                     | `8000`              |

请根据实际需求修改 `.env` 文件。

## 卷

- `vllm_models`：来自 Hugging Face 的缓存模型文件

## GPU 支持

此服务需要 NVIDIA GPU 才能正常运行。在 `docker-compose.yaml` 中取消注释 GPU 配置：

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

## 使用方法

### 启动 vLLM

```bash
docker compose up -d
```

### 访问

- API 端点：<http://localhost:8000>
- OpenAI 兼容 API：<http://localhost:8000/v1>

### 测试 API

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

### 聊天补全

```bash
curl http://localhost:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "facebook/opt-125m",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

## 支持的模型

vLLM 支持多种模型：

- **LLaMA**：LLaMA、LLaMA-2、LLaMA-3
- **Mistral**：Mistral、Mixtral
- **Qwen**：Qwen、Qwen2
- **Yi**：Yi、Yi-VL
- **以及更多**：参见 [vLLM 支持的模型](https://docs.vllm.ai/en/latest/models/supported_models.html)

要使用不同的模型，请更改 `VLLM_MODEL` 环境变量：

```bash
# 示例：使用 Qwen2-7B-Instruct
VLLM_MODEL="Qwen/Qwen2-7B-Instruct"
```

## 性能调优

### GPU 内存

根据模型大小和可用 VRAM 调整 GPU 内存利用率：

```bash
VLLM_GPU_MEMORY_UTIL=0.85  # 使用 85% 的 GPU 内存
```

### 上下文长度

根据需要设置最大上下文长度：

```bash
VLLM_MAX_MODEL_LEN=4096  # 支持最多 4K tokens
```

### 共享内存

对于更大的模型，增加共享内存：

```yaml
shm_size: 8g  # 增加到 8GB
```

## 注意事项

- 需要支持 CUDA 的 NVIDIA GPU
- 模型下载可能很大（几 GB 到 100+ GB）
- 首次启动可能需要时间来下载模型
- 确保 GPU 内存足够运行所需模型
- 默认模型较小（125M 参数）用于测试

## 安全性

- API 默认没有身份验证
- 生产环境添加身份验证层（例如，带基本身份验证的 nginx）
- 限制网络访问到受信任的来源

## 许可证

vLLM 采用 Apache License 2.0 许可。详情请参见 [vLLM GitHub](https://github.com/vllm-project/vllm)。
