# TurboOCR

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署 [TurboOCR](https://github.com/aiptimizer/TurboOCR)，一个基于 C++ / CUDA / TensorRT / PP-OCRv5 的 GPU 加速 OCR 服务器。单一二进制同时提供 HTTP 与 gRPC 两套接口，共享同一个 GPU 流水线池，并内置 Prometheus 指标。

## 服务

- `turboocr`：TurboOCR HTTP（端口 8000）+ gRPC（端口 50051）推理服务

## 运行要求

- Linux 主机，NVIDIA 驱动 595 或更高版本
- Turing 及以上架构 GPU（RTX 20 系列 / GTX 16 系列及更新）
- 已安装并配置好 [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)

## 环境变量

| 变量名                        | 说明                                                                     | 默认值        |
| ----------------------------- | ------------------------------------------------------------------------ | ------------- |
| `TURBOOCR_VERSION`            | TurboOCR 镜像版本                                                        | `v2.1.1`      |
| `TURBOOCR_LANG`               | 语言包：`latin`、`chinese`、`greek`、`eslav`、`arabic`、`korean`、`thai` | `""`（latin） |
| `TURBOOCR_SERVER`             | 当 `chinese` 时，设为 `1` 使用 84 MB 服务端识别模型                      | `""`          |
| `TURBOOCR_PIPELINE_POOL_SIZE` | 并发 GPU 流水线数（每条约 1.4 GB 显存），留空则自动                      | `""`          |
| `TURBOOCR_DISABLE_LAYOUT`     | 禁用版面检测模型（节省约 300-500 MB 显存）                               | `0`           |
| `TURBOOCR_PDF_MODE`           | PDF 默认模式：`ocr` / `geometric` / `auto` / `auto_verified`             | `ocr`         |
| `TURBOOCR_DISABLE_ANGLE_CLS`  | 跳过方向分类器（约节省 0.4 ms）                                          | `0`           |
| `TURBOOCR_DET_MAX_SIDE`       | 检测输入最大尺寸（像素）                                                 | `960`         |
| `TURBOOCR_PDF_DAEMONS`        | PDF 渲染守护进程数                                                       | `16`          |
| `TURBOOCR_PDF_WORKERS`        | PDF 工作线程数                                                           | `4`           |
| `TURBOOCR_MAX_PDF_PAGES`      | 单次 PDF 请求最大页数                                                    | `2000`        |
| `TURBOOCR_LOG_LEVEL`          | 日志级别：`debug` / `info` / `warn` / `error`                            | `info`        |
| `TURBOOCR_LOG_FORMAT`         | 日志格式：`json` / `text`                                                | `json`        |
| `TURBOOCR_HTTP_PORT_OVERRIDE` | HTTP API 主机端口                                                        | `8000`        |
| `TURBOOCR_GRPC_PORT_OVERRIDE` | gRPC API 主机端口                                                        | `50051`       |
| `TURBOOCR_CPU_LIMIT`          | CPU 限制                                                                 | `8.0`         |
| `TURBOOCR_MEMORY_LIMIT`       | 内存限制                                                                 | `12G`         |
| `TURBOOCR_GPU_COUNT`          | 预留的 NVIDIA GPU 数量                                                   | `1`           |
| `TURBOOCR_SHM_SIZE`           | 共享内存大小                                                             | `2g`          |

复制 `.env.example` 为 `.env`，仅覆盖你需要修改的变量。

## 卷

- `turboocr_trt_cache`：缓存首次启动时由 ONNX 构建出的 TensorRT 引擎。必须使用**命名卷**，如果绑定挂载一个空的主机目录，会覆盖镜像内置的语言包，导致服务无法加载模型。

## 使用方法

### 启动 TurboOCR

```bash
docker compose up -d
```

首次启动需要从 ONNX 构建 TensorRT 引擎，耗时因 GPU 而异：高端桌面 GPU 约 5 分钟，笔记本 GPU 约 20–30 分钟。编译期间容器可能显示 `unhealthy`，这属于正常现象——构建完成后服务会自动启动并切换为 `healthy`。后续重启会复用缓存的引擎，几乎瞬间完成。

### 访问端点

- HTTP API：<http://localhost:8000>
- gRPC API：`localhost:50051`
- 健康检查：<http://localhost:8000/health>
- 就绪检查：<http://localhost:8000/health/ready>
- Prometheus 指标：<http://localhost:8000/metrics>

### 测试 API

```bash
# 图片 —— 原始字节（最快路径）
curl -X POST http://localhost:8000/ocr/raw \
  --data-binary @document.png \
  -H "Content-Type: image/png"

# 图片 —— base64 JSON
curl -X POST http://localhost:8000/ocr \
  -H "Content-Type: application/json" \
  -d '{"image":"'$(base64 -w0 document.png)'"}'

# PDF —— 原始字节
curl -X POST http://localhost:8000/ocr/pdf \
  --data-binary @document.pdf

# PDF 启用版面检测
curl -X POST "http://localhost:8000/ocr/pdf?layout=1&mode=auto" \
  --data-binary @document.pdf
```

> **重要提示**：请使用 HTTP keep-alive。如果在循环中频繁建立短连接（例如每次请求一个 `curl`），可能会压垮服务。标准 HTTP 客户端库（`requests.Session`、`aiohttp`、Go `http.Client` 等）默认会复用连接。

### 切换语言

修改 `.env` 后重启：

```bash
TURBOOCR_LANG=chinese
TURBOOCR_SERVER=1   # 可选：使用 84 MB 的中文服务端识别模型
```

```bash
docker compose up -d
```

所有语言包都在构建镜像时打包进来（基于固定版本的 PP-OCRv5 发布，并校验 SHA256），运行时无需联网下载。

## 性能调优

- **GPU 流水线**：根据显存大小设置 `TURBOOCR_PIPELINE_POOL_SIZE`（每条约 1.4 GB）
- **版面开销**：`?layout=1` 会使吞吐下降约 20%；设置 `TURBOOCR_DISABLE_LAYOUT=1` 可完全跳过模型加载
- **共享内存**：处理超大 PDF 时可增加 `TURBOOCR_SHM_SIZE`

## 安全说明

- API 默认无身份认证。生产环境请在前面套一层反向代理（nginx、Caddy 等）。
- PDF 默认模式为 `ocr`，只信任像素数据，可安全处理不可信来源的 PDF 上传。
- 如果你的服务接收不可信来源的 PDF，**不要**将 `TURBOOCR_PDF_MODE` 全局设为 `geometric` 或 `auto`：恶意 PDF 可以嵌入隐形文字、重映射 ToUnicode 字符或在文本层注入任意字符串。
- 在可信文档场景下可使用 `auto_verified` 模式，会先做 OCR，再用文本层与之对照校验。

## 许可证

TurboOCR 采用 MIT 许可证。详情请参见 [TurboOCR GitHub 仓库](https://github.com/aiptimizer/TurboOCR)。
