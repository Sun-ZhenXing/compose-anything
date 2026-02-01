# llama.cpp

[English Documentation](README.md)

[llama.cpp](https://github.com/ggml-org/llama.cpp) 是一个高性能的 C/C++ 实现的大语言模型推理引擎，支持多种硬件加速器。

## 功能特性

- **高速推理**：优化的 C/C++ 实现，提供高效的 LLM 推理
- **多种后端**：支持 CPU、CUDA（NVIDIA）、ROCm（AMD）、MUSA（摩尔线程）、Intel GPU、Vulkan
- **OpenAI 兼容 API**：服务器模式提供 OpenAI 兼容的 REST API
- **CLI 支持**：交互式命令行界面，方便快速测试
- **模型转换**：完整工具包包含模型转换和量化工具
- **GGUF 格式**：支持高效的 GGUF 模型格式
- **跨平台**：支持 Linux（x86-64、ARM64、s390x）、Windows、macOS

## 前置要求

- 已安装 Docker 和 Docker Compose
- 至少 4GB 内存（推荐 8GB 以上）
- GPU 版本需要：
  - **CUDA**：NVIDIA GPU 及 [nvidia-container-toolkit](https://github.com/NVIDIA/nvidia-container-toolkit)
  - **ROCm**：AMD GPU 及相应的 ROCm 驱动
  - **MUSA**：摩尔线程 GPU 及 mt-container-toolkit
- GGUF 格式的模型文件（例如从 [Hugging Face](https://huggingface.co/models?library=gguf) 下载）

## 快速开始

### 1. 服务器模式（CPU）

```bash
# 复制并配置环境变量
cp .env.example .env

# 编辑 .env 并设置模型路径
# LLAMA_CPP_MODEL_PATH=/models/your-model.gguf

# 将 GGUF 模型放在目录中，然后更新 docker-compose.yaml 挂载，例如：
# volumes:
#   - ./models:/models

# 启动服务器
docker compose --profile server up -d

# 测试服务器（OpenAI 兼容 API）
curl http://localhost:8080/v1/models

# 聊天补全请求
curl http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
      {"role": "user", "content": "你好！"}
    ]
  }'
```

### 2. 服务器模式（NVIDIA GPU）

```bash
# 编辑 .env
# 设置 LLAMA_CPP_GPU_LAYERS=99 将所有层卸载到 GPU

# 启动 GPU 加速服务器
docker compose --profile cuda up -d

# 服务器将自动使用 NVIDIA GPU
```

### 3. 服务器模式（AMD GPU）

```bash
# 编辑 .env
# 设置 LLAMA_CPP_GPU_LAYERS=99 将所有层卸载到 GPU

# 启动 GPU 加速服务器
docker compose --profile rocm up -d

# 服务器将自动使用 AMD GPU
```

### 4. CLI 模式

```bash
# 编辑 .env 并配置模型路径和提示词

# 运行 CLI
docker compose --profile cli up

# 交互模式：
docker compose run --rm llama-cpp-cli \
  -m /models/your-model.gguf \
  -p "你的提示词" \
  -n 512
```

### 5. 完整工具包（模型转换）

```bash
# 启动完整容器
docker compose --profile full up -d

# 在容器内执行命令
docker compose exec llama-cpp-full bash

# 在容器内可以使用转换工具
# 示例：转换 Hugging Face 模型
# python3 convert_hf_to_gguf.py /models/source-model --outfile /models/output.gguf
```

## 配置说明

### 环境变量

主要环境变量（完整选项请查看 [.env.example](.env.example)）：

| 变量                             | 说明                                                  | 默认值               |
| -------------------------------- | ----------------------------------------------------- | -------------------- |
| `LLAMA_CPP_SERVER_VARIANT`       | 服务器镜像变体（server、server-cuda、server-rocm 等） | `server`             |
| `LLAMA_CPP_MODEL_PATH`           | 容器内模型文件路径                                    | `/models/model.gguf` |
| `LLAMA_CPP_CONTEXT_SIZE`         | 上下文窗口大小（token 数）                            | `512`                |
| `LLAMA_CPP_GPU_LAYERS`           | 卸载到 GPU 的层数（0=仅 CPU，99=全部）                | `0`                  |
| `LLAMA_CPP_SERVER_PORT_OVERRIDE` | 主机端口                                              | `8080`               |
| `LLAMA_CPP_SERVER_MEMORY_LIMIT`  | 服务器内存限制                                        | `8G`                 |

### 可用配置文件

- `server`：仅 CPU 服务器
- `cuda`：NVIDIA GPU 服务器（需要 nvidia-container-toolkit）
- `rocm`：AMD GPU 服务器（需要 ROCm）
- `cli`：命令行界面
- `full`：包含模型转换工具的完整工具包
- `gpu`：通用 GPU 配置（包括 cuda 和 rocm）

### 镜像变体

每个变体都有多种类型：

- **server**：仅包含 `llama-server` 可执行文件（API 服务器）
- **light**：仅包含 `llama-cli` 和 `llama-completion` 可执行文件
- **full**：完整工具包，包括模型转换工具

后端选项：

- 基础版（CPU）
- `-cuda`（NVIDIA GPU）
- `-rocm`（AMD GPU）
- `-musa`（摩尔线程 GPU）
- `-intel`（Intel GPU，支持 SYCL）
- `-vulkan`（Vulkan GPU）

## 服务器 API

服务器提供 OpenAI 兼容的 API：

- `GET /health` - 健康检查
- `GET /v1/models` - 列出可用模型
- `POST /v1/chat/completions` - 聊天补全
- `POST /v1/completions` - 文本补全
- `POST /v1/embeddings` - 生成嵌入向量

完整 API 详情请参阅 [llama.cpp 服务器文档](https://github.com/ggml-org/llama.cpp/blob/master/examples/server/README.md)。

## 模型来源

下载 GGUF 模型：

- [Hugging Face GGUF 模型](https://huggingface.co/models?library=gguf)
- [TheBloke 的 GGUF 合集](https://huggingface.co/TheBloke)
- 使用完整工具包转换您自己的模型

常用量化格式：

- `Q4_K_M`：质量和大小的良好平衡（推荐）
- `Q5_K_M`：更高质量，更大体积
- `Q8_0`：非常高的质量，大体积
- `Q2_K`：最小体积，较低质量

## 资源需求

按模型大小的最低要求：

| 模型大小   | 内存（CPU） | 显存（GPU） | 上下文大小 |
| ---------- | ----------- | ----------- | ---------- |
| 7B Q4_K_M  | 6GB         | 4GB         | 2048       |
| 13B Q4_K_M | 10GB        | 8GB         | 2048       |
| 34B Q4_K_M | 24GB        | 20GB        | 2048       |
| 70B Q4_K_M | 48GB        | 40GB        | 2048       |

更大的上下文大小需要成比例的更多内存。

## 性能调优

CPU 推理：

- 增加 `LLAMA_CPP_SERVER_CPU_LIMIT` 以使用更多核心
- 使用 `-t` 参数优化线程数（默认：自动）

GPU 推理：

- 设置 `LLAMA_CPP_GPU_LAYERS=99` 卸载所有层
- 增加上下文大小以支持更长对话
- 监控 GPU 内存使用

## 安全注意事项

- 服务器默认绑定到 `0.0.0.0` - 请确保网络安全
- 默认未启用身份验证
- 生产环境建议使用反向代理（nginx、Caddy）
- 限制资源使用以防止系统资源耗尽

## 故障排除

### 内存不足

- 减小 `LLAMA_CPP_CONTEXT_SIZE`
- 使用更小的量化模型（例如 Q4 而不是 Q8）
- 减少 `LLAMA_CPP_GPU_LAYERS`（如果使用 GPU）

### GPU 未检测到

**NVIDIA**：验证 nvidia-container-toolkit 是否已安装：

```bash
docker run --rm --gpus all nvidia/cuda:12.4.0-base-ubuntu22.04 nvidia-smi
```

**AMD**：确保 ROCm 驱动已安装且 `/dev/kfd`、`/dev/dri` 可访问。

### 推理速度慢

- 检查 CPU/GPU 利用率
- 增加 `.env` 中的资源限制
- GPU：验证所有层都已卸载（`LLAMA_CPP_GPU_LAYERS=99`）

## 文档

- [llama.cpp GitHub](https://github.com/ggml-org/llama.cpp)
- [Docker 文档](https://github.com/ggml-org/llama.cpp/blob/master/docs/docker.md)
- [服务器 API 文档](https://github.com/ggml-org/llama.cpp/blob/master/examples/server/README.md)

## 许可证

llama.cpp 使用 MIT 许可证发布。详情请参阅 [LICENSE](https://github.com/ggml-org/llama.cpp/blob/master/LICENSE) 文件。
