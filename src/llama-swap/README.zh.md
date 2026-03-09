# llama-swap

[llama-swap](https://github.com/mostlygeek/llama-swap) 是一个轻量级反向代理，为任何本地 OpenAI/Anthropic 兼容的推理服务器（如 llama.cpp、vllm 等）提供可靠的按需模型切换功能。同一时间只加载一个模型，当收到对不同模型的请求时，llama-swap 会自动切换，让你可以在单台机器上轻松使用多个模型。

参见：[README.md](./README.md)

## 功能特性

- **按需模型切换**：根据 API 请求自动加载/卸载模型，无需手动干预。
- **兼容 OpenAI/Anthropic**：可直接替代任何使用 OpenAI 或 Anthropic 聊天补全 API 的客户端。
- **多后端支持**：适用于 llama.cpp（llama-server）、vllm 及任何 OpenAI 兼容服务器。
- **实时 Web UI**：内置界面，可监控日志、检查请求、手动管理模型。
- **基于 TTL 的自动卸载**：可配置模型在闲置一段时间后自动卸载。
- **HuggingFace 模型下载**：在 `config.yaml` 中直接引用 HuggingFace 模型，首次使用时自动下载。
- **多 GPU 支持**：支持 NVIDIA CUDA、AMD ROCm/Vulkan、Intel 及纯 CPU 部署。

## 快速开始

1. 复制环境变量示例文件：

   ```bash
   cp .env.example .env
   ```

2. 编辑 `config.yaml`，添加你的模型配置。提供的 `config.yaml` 包含本地 GGUF 模型和 HuggingFace 下载的注释示例。详见[配置说明](#配置说明)。

3. 启动服务（默认仅使用 CPU）：

   ```bash
   docker compose up -d
   ```

4. 启用 NVIDIA GPU 支持：

   ```bash
   docker compose --profile gpu up -d
   ```

5. 启用 AMD GPU 支持（Vulkan）：

   ```bash
   docker compose --profile gpu-amd up -d
   ```

API 和 Web UI 地址：`http://localhost:9292`

## 服务说明

| 服务名称          | Profile    | 说明                          |
| ----------------- | ---------- | ----------------------------- |
| `llama-swap`      | _（默认）_ | 纯 CPU 推理                   |
| `llama-swap-cuda` | `gpu`      | NVIDIA CUDA GPU 推理          |
| `llama-swap-amd`  | `gpu-amd`  | AMD GPU 推理（Vulkan / ROCm） |

> **注意**：每次只启动一个服务，三个服务均绑定到同一主机端口（`LLAMA_SWAP_PORT_OVERRIDE`）。

## 配置说明

### `config.yaml`

`config.yaml` 文件定义了 llama-swap 管理的模型列表，以只读方式挂载到容器内的 `/app/config.yaml`。编辑提供的 `config.yaml` 即可添加你的模型。

最简示例：

```yaml
healthCheckTimeout: 300

models:
  my-model:
    cmd: /app/llama-server --port ${PORT} --model /root/.cache/llama.cpp/model.gguf --ctx-size 4096
    proxy: 'http://localhost:${PORT}'
    ttl: 900
```

- `${PORT}` 由 llama-swap 自动分配。
- `ttl`（秒）：模型闲置超过该时长后自动卸载。
- `cmd`：启动推理服务器的命令。
- `proxy`：llama-swap 转发请求的地址。

直接使用 HuggingFace 模型（首次使用时自动下载）：

```yaml
models:
  Qwen2.5-7B:
    cmd: /app/llama-server --port ${PORT} -hf bartowski/Qwen2.5-7B-Instruct-GGUF:Q4_K_M --ctx-size 8192 --n-gpu-layers 99
    proxy: 'http://localhost:${PORT}'
```

完整配置选项（包括 `groups`、`hooks`、`macros`、`aliases`、`filters` 等）请参阅[官方配置文档](https://github.com/mostlygeek/llama-swap/blob/main/docs/config.md)。

### 模型卷

命名卷 `llama_swap_models` 挂载到容器内的 `/root/.cache/llama.cpp`。可以通过以下方式将本地 GGUF 模型文件放入卷中：

```bash
# 将模型文件复制到命名卷
docker run --rm -v llama_swap_models:/data -v /path/to/model.gguf:/src/model.gguf alpine cp /src/model.gguf /data/model.gguf
```

或者将 `docker-compose.yaml` 中的卷定义改为主机路径绑定：

```yaml
volumes:
  llama_swap_models:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /path/to/your/models
```

## 环境变量

| 变量名                          | 默认值     | 说明                                   |
| ------------------------------- | ---------- | -------------------------------------- |
| `TZ`                            | `UTC`      | 容器时区                               |
| `GHCR_REGISTRY`                 | `ghcr.io/` | GitHub 容器镜像仓库前缀                |
| `LLAMA_SWAP_VERSION`            | `cpu`      | 默认 CPU 服务镜像标签                  |
| `LLAMA_SWAP_CUDA_VERSION`       | `cuda`     | CUDA 服务镜像标签                      |
| `LLAMA_SWAP_AMD_VERSION`        | `vulkan`   | AMD 服务镜像标签（`vulkan` 或 `rocm`） |
| `LLAMA_SWAP_PORT_OVERRIDE`      | `9292`     | API 和 Web UI 的主机端口               |
| `LLAMA_SWAP_GPU_COUNT`          | `1`        | 使用的 NVIDIA GPU 数量（gpu profile）  |
| `LLAMA_SWAP_CPU_LIMIT`          | `4.0`      | CPU 上限（核心数）                     |
| `LLAMA_SWAP_CPU_RESERVATION`    | `2.0`      | CPU 预留（核心数）                     |
| `LLAMA_SWAP_MEMORY_LIMIT`       | `8G`       | 内存上限                               |
| `LLAMA_SWAP_MEMORY_RESERVATION` | `4G`       | 内存预留                               |

## 默认端口

| 端口   | 说明                                |
| ------ | ----------------------------------- |
| `9292` | OpenAI/Anthropic 兼容 API 及 Web UI |

## API 使用示例

llama-swap 暴露 OpenAI 兼容 API。将任何 OpenAI 客户端指向 `http://localhost:9292` 即可使用：

```bash
# 列出可用模型
curl http://localhost:9292/v1/models

# 聊天补全（若模型未运行则自动加载）
curl http://localhost:9292/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "my-model",
    "messages": [{"role": "user", "content": "你好！"}]
  }'
```

Web UI 可通过 `http://localhost:9292` 访问，提供实时日志流、请求检查和手动模型管理功能。

## NVIDIA GPU 配置

需要安装 [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)。

```bash
docker compose --profile gpu up -d
```

如需非 root 安全加固，可使用 `cuda-non-root` 镜像标签：

```bash
LLAMA_SWAP_CUDA_VERSION=cuda-non-root docker compose --profile gpu up -d
```

## AMD GPU 配置

需要主机上 `/dev/dri` 和 `/dev/kfd` 设备可访问。

```bash
docker compose --profile gpu-amd up -d
```

如需完整 ROCm 支持，可使用 `rocm` 替代 `vulkan`：

```bash
LLAMA_SWAP_AMD_VERSION=rocm docker compose --profile gpu-amd up -d
```

## 安全说明

- 默认情况下容器以 root 用户运行。GPU 部署时建议使用 `cuda-non-root` 或 `rocm-non-root` 镜像标签提升安全性。
- `config.yaml` 以只读方式（`ro`）挂载。
- 若需在 localhost 之外暴露服务，建议在 llama-swap 前部署反向代理（如 Nginx、Caddy）。

## 参考链接

- [llama-swap GitHub](https://github.com/mostlygeek/llama-swap)
- [配置文档](https://github.com/mostlygeek/llama-swap/blob/main/docs/config.md)
- [容器安全文档](https://github.com/mostlygeek/llama-swap/blob/main/docs/container-security.md)
- [Docker Compose Wiki](https://github.com/mostlygeek/llama-swap/wiki/Docker-Compose-Example)

## 许可证

llama-swap 使用 MIT 许可证发布。详情请参阅 [LICENSE](https://github.com/mostlygeek/llama-swap/blob/main/LICENSE) 文件。
