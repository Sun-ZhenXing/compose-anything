# TurboOCR — 自定义构建

[English](README.md)

此目录从源码构建 [TurboOCR](https://github.com/aiptimizer/TurboOCR)，覆盖上游预构建镜像未提供的两个目标：

| 变体 | Dockerfile | Profile | 基础镜像 |
| ---- | ---------- | ------- | -------- |
| **CUDA 12.x** | `Dockerfile.cuda12` | `gpu` | `nvcr.io/nvidia/tensorrt:24.12-py3`（TRT 10.8 / CUDA 12.7） |
| **纯 CPU** | `Dockerfile.cpu` | `cpu` | `ubuntu:24.04`（ONNX Runtime） |

上游预构建镜像针对 CUDA 13.x（Blackwell / CC 12.0）。如果你的 GPU 属于 CUDA 12.x 范围（Turing 到 Ada Lovelace，CC 7.5–8.9），或者没有 GPU，请使用本目录。

## 快速开始

1. 复制示例环境文件：

   ```bash
   cp .env.example .env
   ```

2. 按需构建并启动对应变体：

   **CUDA 12.x（GPU — Turing 到 Ada Lovelace）：**

   ```bash
   docker compose --profile gpu up -d --build
   ```

   **纯 CPU（无需 GPU）：**

   ```bash
   docker compose --profile cpu up -d --build
   ```

3. 访问 API：<http://localhost:8000>。

> **说明：** 首次构建需要从源码编译 Drogon 和 TurboOCR，耗时约 10–30 分钟，具体取决于 CPU 核心数。后续构建会复用 Docker 层缓存，速度很快。

## 首次启动说明

### GPU 变体

容器首次启动时，TensorRT 会将 4 个 ONNX 模型编译为引擎文件。在 RTX 3070 Laptop 上的实测耗时：

| 引擎 | 耗时 |
| ---- | ---- |
| det | 约 5 分钟 |
| rec | 约 30 分钟 |
| cls | 约 4 分钟 |
| layout | 约 28 分钟 |
| **合计** | **约 67–90 分钟** |

高端桌面 GPU 约 15 分钟完成。编译期间容器显示 `unhealthy` 属于正常现象——所有引擎构建完成后服务启动，状态切换为 `healthy`。后续重启会复用缓存引擎，几乎瞬间完成。

> **提示：** 设置 `TURBOOCR_DISABLE_LAYOUT=1` 可跳过版面检测引擎的编译（笔记本 GPU 约节省 28 分钟）。仅在不需要 `?layout=1` PDF 端点时使用此选项。

### CPU 变体

无 TRT 编译过程。ONNX Runtime 在启动时直接加载模型，通常在 60 秒内变为 `healthy`。

## 默认端口

| 端口 | 协议 | 说明 |
| ---- | ---- | ---- |
| 8000 | HTTP | OCR REST API + 健康检查/指标 |
| 50051 | gRPC | OCR gRPC API |

## 主要环境变量

| 变量名 | 说明 | 默认值 |
| ------ | ---- | ------ |
| `TURBOOCR_VERSION` | 构建所用的 Git 标签 | `v2.1.1` |
| `TURBOOCR_HTTP_PORT_OVERRIDE` | HTTP API 主机端口 | `8000` |
| `TURBOOCR_GRPC_PORT_OVERRIDE` | gRPC API 主机端口 | `50051` |
| `TURBOOCR_LANG` | 语言包：`latin`、`chinese`、`greek`、`eslav`、`arabic`、`korean`、`thai` | `""`（latin） |
| `TURBOOCR_SERVER` | 当使用 `chinese` 时，设为 `1` 启用 84 MB 服务端识别模型 | `""` |
| `TURBOOCR_PIPELINE_POOL_SIZE` | 并发 GPU 流水线数（每条约 1.4 GB 显存），留空则自动 | `""` |
| `TURBOOCR_DISABLE_LAYOUT` | 禁用版面检测模型（节省约 300–500 MB 显存） | `0` |
| `TURBOOCR_PDF_MODE` | PDF 解析模式：`ocr` / `geometric` / `auto` / `auto_verified` | `ocr` |
| `TURBOOCR_CPU_LIMIT` | CPU 核心限制（两个变体通用） | `8.0` |
| `TURBOOCR_MEMORY_LIMIT` | 内存限制——GPU 变体 `12G`，CPU 变体 `4G` | 变体默认值 |
| `TURBOOCR_GPU_COUNT` | 预留的 NVIDIA GPU 数量（仅 GPU 变体） | `1` |
| `TURBOOCR_SHM_SIZE` | fastpdf2png 共享内存——GPU 变体 `2g`，CPU 变体 `512m` | 变体默认值 |
| `TZ` | 容器时区 | `UTC` |

## 存储

- `turboocr_build_cache`——命名卷，挂载于 `/home/ocr/.cache/turbo-ocr`。用于存储 TRT 引擎文件（GPU 变体）或模型缓存目录（CPU 变体）。必须使用**命名卷**——绑定挂载空主机目录会遮蔽镜像内置语言包，导致服务无法加载模型。

## 支持的 GPU 架构（CUDA 12.x 变体）

| 算力版本 | 架构 | GPU 型号 |
| -------- | ---- | -------- |
| 7.5 | Turing | GTX 16xx、RTX 20xx |
| 8.0 | Ampere | A100、RTX 30xx（服务器） |
| 8.6 | Ampere | RTX 30xx（桌面/笔记本） |
| 8.9 | Ada Lovelace | RTX 40xx |

Blackwell（CC 12.0，RTX 50xx）需要 CUDA 13.x——请改用 `src/turboocr` 中的上游预构建镜像。

## 说明

- 两个 Dockerfile 均在镜像内通过 `git clone` 从源码构建 TurboOCR，构建时需要可访问互联网。
- CUDA 12.x Dockerfile 将 `CMAKE_CUDA_ARCHITECTURES` 设置为 `75;80;86;89`，去除了 CUDA 12.x 不支持的 CC 12.0。
- TensorRT 10.8 在 `24.12-py3` 基础镜像中位于 `/usr/local/tensorrt`，与 CMake 默认值一致，无需额外的 `-DTENSORRT_DIR` 参数。
- CPU 变体使用 ONNX Runtime 1.22.0，生成同时支持 HTTP 和 gRPC 接口的 `paddle_cpu_server` 二进制文件。

## 访问端点

- HTTP API：<http://localhost:8000>
- gRPC API：`localhost:50051`
- 健康检查：<http://localhost:8000/health>
- 就绪检查：<http://localhost:8000/health/ready>
- Prometheus 指标：<http://localhost:8000/metrics>

## 安全说明

- API 默认无身份认证。生产环境请在前面套一层反向代理（nginx、Caddy 等）。
- PDF 默认模式为 `ocr`，只信任像素数据，可安全处理不可信来源的 PDF 上传。
- 如果你的服务接收不可信来源的 PDF，**不要**将 `TURBOOCR_PDF_MODE` 全局设为 `geometric` 或 `auto`。

## 参考链接

- [TurboOCR 仓库](https://github.com/aiptimizer/TurboOCR)
- [NVIDIA TensorRT 容器发布说明](https://docs.nvidia.com/deeplearning/tensorrt/container-release-notes/)
- [NVIDIA CUDA GPU 算力版本对照表](https://developer.nvidia.com/cuda-gpus)
