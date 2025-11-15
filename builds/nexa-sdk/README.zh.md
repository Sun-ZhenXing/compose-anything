# Nexa SDK

Nexa SDK 是一个功能全面的本地 AI 模型运行工具包。它支持多种模型类型的推理，包括 LLM、VLM（视觉语言模型）、TTS（文本转语音）、ASR（自动语音识别）等。该工具专注于性能优化，支持 CPU 和 GPU 加速。

## 特性

- **多模型支持**：运行 LLM、VLM、TTS、ASR、嵌入、重排序和图像生成模型
- **OpenAI 兼容 API**：提供标准的 OpenAI API 端点，便于集成
- **GPU 加速**：通过 NVIDIA CUDA 提供可选的 GPU 支持，实现更快的推理速度
- **资源管理**：可配置的 CPU/内存限制和 GPU 层卸载
- **模型缓存**：持久化模型存储，加快启动速度
- **配置文件支持**：轻松在 CPU 模式和 GPU 加速模式之间切换

## 快速开始

### 前置要求

- Docker 和 Docker Compose
- GPU 支持需要：NVIDIA Docker runtime 和兼容的 GPU

### 基本使用（CPU）

```bash
# 复制环境配置文件
cp .env.example .env

# 编辑 .env 配置模型和设置
# NEXA_MODEL=gemma-2-2b-instruct

# 使用 CPU 配置文件启动服务
docker compose --profile cpu up -d
```

### GPU 加速使用

```bash
# 复制环境配置文件
cp .env.example .env

# 配置 GPU 使用
# NEXA_MODEL=gemma-2-2b-instruct
# NEXA_GPU_LAYERS=-1  # -1 表示所有层都在 GPU 上

# 使用 GPU 配置文件启动服务
docker compose --profile gpu up -d
```

## 配置

### 环境变量

| 变量                     | 默认值                | 说明                                                |
| ------------------------ | --------------------- | --------------------------------------------------- |
| `NEXA_SDK_VERSION`       | `latest`              | Nexa SDK Docker 镜像版本                            |
| `NEXA_SDK_PORT_OVERRIDE` | `8080`                | API 访问的主机端口                                  |
| `NEXA_MODEL`             | `gemma-2-2b-instruct` | 要加载的模型（如 qwen3-4b、llama-3-8b、mistral-7b） |
| `NEXA_HOST`              | `0.0.0.0:8080`        | 服务器绑定地址                                      |
| `NEXA_KEEPALIVE`         | `300`                 | 模型保活超时时间（秒）                              |
| `NEXA_ORIGINS`           | `*`                   | CORS 允许的源                                       |
| `NEXA_HFTOKEN`           | -                     | 用于私有模型的 HuggingFace 令牌                     |
| `NEXA_LOG`               | `none`                | 日志级别（none、debug、info、warn、error）          |
| `NEXA_GPU_LAYERS`        | `-1`                  | 卸载到 GPU 的层数（-1 = 全部，0 = 仅 CPU）          |
| `NEXA_SHM_SIZE`          | `2g`                  | 共享内存大小                                        |
| `TZ`                     | `UTC`                 | 容器时区                                            |

### 资源限制

| 变量                          | 默认值 | 说明            |
| ----------------------------- | ------ | --------------- |
| `NEXA_SDK_CPU_LIMIT`          | `4.0`  | 最大 CPU 核心数 |
| `NEXA_SDK_MEMORY_LIMIT`       | `8G`   | 最大内存        |
| `NEXA_SDK_CPU_RESERVATION`    | `2.0`  | 预留 CPU 核心数 |
| `NEXA_SDK_MEMORY_RESERVATION` | `4G`   | 预留内存        |

### 配置文件

- `cpu`：使用 CPU 推理运行（需要指定默认配置文件）
- `gpu`：使用 GPU 加速运行（需要 NVIDIA GPU）

## 使用示例

### 测试 API

```bash
# 检查可用模型
curl http://localhost:8080/v1/models

# 聊天完成
curl http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gemma-2-2b-instruct",
    "messages": [
      {"role": "user", "content": "你好！"}
    ]
  }'
```

### 使用不同的模型

编辑 `.env` 更改模型：

```bash
# 资源受限时使用小模型
NEXA_MODEL=gemma-2-2b-instruct
# 或
NEXA_MODEL=qwen3-4b

# 追求更好质量时使用大模型
NEXA_MODEL=llama-3-8b
# 或
NEXA_MODEL=mistral-7b
```

### GPU 配置

对于 GPU 加速，调整层数：

```bash
# 将所有层卸载到 GPU（最快）
NEXA_GPU_LAYERS=-1

# 卸载 30 层（混合模式）
NEXA_GPU_LAYERS=30

# 仅 CPU
NEXA_GPU_LAYERS=0
```

## 模型管理

模型会在首次运行时自动下载，并缓存在 `nexa_models` 卷中。容器内的默认缓存位置是 `/root/.cache/nexa`。

要使用不同的模型：

1. 在 `.env` 中更新 `NEXA_MODEL`
2. 重启服务：`docker compose --profile <cpu|gpu> restart`

## API 端点

Nexa SDK 提供 OpenAI 兼容的 API 端点：

- `GET /v1/models` - 列出可用模型
- `POST /v1/chat/completions` - 聊天完成
- `POST /v1/completions` - 文本完成
- `POST /v1/embeddings` - 文本嵌入
- `GET /health` - 健康检查
- `GET /docs` - API 文档（Swagger UI）

## 故障排除

### 内存不足

增加内存限制或使用更小的模型：

```bash
NEXA_SDK_MEMORY_LIMIT=16G
NEXA_SDK_MEMORY_RESERVATION=8G
# 或切换到更小的模型
NEXA_MODEL=gemma-2-2b-instruct
```

### GPU 未检测到

确保已安装 NVIDIA Docker runtime：

```bash
# 检查 GPU 可用性
docker run --rm --gpus all nvidia/cuda:12.8.1-base-ubuntu22.04 nvidia-smi
```

### 模型下载问题

如果访问私有模型，设置 HuggingFace 令牌：

```bash
NEXA_HFTOKEN=your_hf_token_here
```

### 性能缓慢

- 使用 GPU 配置文件以获得更好的性能
- 增加 `NEXA_GPU_LAYERS` 以将更多计算卸载到 GPU
- 分配更多资源或使用更小的模型

## 高级配置

### 自定义模型路径

如果要使用本地模型文件，将它们挂载为卷：

```yaml
volumes:
  - ./models:/models
  - nexa_models:/root/.cache/nexa
```

然后在命令中通过路径引用模型。

### HTTPS 配置

设置 HTTPS 的环境变量：

```bash
NEXA_ENABLEHTTPS=true
```

挂载证书文件：

```yaml
volumes:
  - ./certs/cert.pem:/app/cert.pem:ro
  - ./certs/key.pem:/app/key.pem:ro
```

## 健康检查

服务包含验证 API 是否响应的健康检查：

```bash
curl http://localhost:8080/v1/models
```

## 许可证

Nexa SDK 由 Nexa AI 开发。许可证信息请参考[官方仓库](https://github.com/NexaAI/nexa-sdk)。

## 链接

- [官方仓库](https://github.com/NexaAI/nexa-sdk)
- [Nexa AI 网站](https://nexa.ai)
- [文档](https://docs.nexa.ai)
- [模型中心](https://sdk.nexa.ai)
