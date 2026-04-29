# TurboOCR

[English](./README.md) | [中文](./README.zh.md)

This service deploys [TurboOCR](https://github.com/aiptimizer/TurboOCR), a GPU-accelerated OCR server built on C++ / CUDA / TensorRT / PP-OCRv5. It exposes both an HTTP API and a gRPC API from a single binary that share the same GPU pipeline pool, with Prometheus metrics built in.

## Services

- `turboocr`: TurboOCR HTTP (port 8000) + gRPC (port 50051) inference server

## Requirements

- Linux host with NVIDIA driver 595 or newer
- Turing or newer GPU (RTX 20-series / GTX 16-series and up)
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) installed and configured for Docker

## Environment Variables

| Variable Name                 | Description                                                                       | Default Value |
| ----------------------------- | --------------------------------------------------------------------------------- | ------------- |
| `TURBOOCR_VERSION`            | TurboOCR image version                                                            | `v2.1.1`      |
| `TURBOOCR_LANG`               | Language bundle: `latin`, `chinese`, `greek`, `eslav`, `arabic`, `korean`, `thai` | `""` (latin)  |
| `TURBOOCR_SERVER`             | With `chinese`, set to `1` for the 84 MB server rec                               | `""`          |
| `TURBOOCR_PIPELINE_POOL_SIZE` | Concurrent GPU pipelines (~1.4 GB VRAM each); empty = auto                        | `""`          |
| `TURBOOCR_DISABLE_LAYOUT`     | Disable layout detection model (saves ~300-500 MB VRAM)                           | `0`           |
| `TURBOOCR_PDF_MODE`           | Default PDF mode: `ocr` / `geometric` / `auto` / `auto_verified`                  | `ocr`         |
| `TURBOOCR_DISABLE_ANGLE_CLS`  | Skip angle classifier (~0.4 ms savings)                                           | `0`           |
| `TURBOOCR_DET_MAX_SIDE`       | Max detection input size in pixels                                                | `960`         |
| `TURBOOCR_PDF_DAEMONS`        | PDF render daemons                                                                | `16`          |
| `TURBOOCR_PDF_WORKERS`        | PDF worker threads                                                                | `4`           |
| `TURBOOCR_MAX_PDF_PAGES`      | Maximum pages per PDF request                                                     | `2000`        |
| `TURBOOCR_LOG_LEVEL`          | Log level: `debug` / `info` / `warn` / `error`                                    | `info`        |
| `TURBOOCR_LOG_FORMAT`         | Log format: `json` / `text`                                                       | `json`        |
| `TURBOOCR_HTTP_PORT_OVERRIDE` | Host port for HTTP API                                                            | `8000`        |
| `TURBOOCR_GRPC_PORT_OVERRIDE` | Host port for gRPC API                                                            | `50051`       |
| `TURBOOCR_CPU_LIMIT`          | CPU limit                                                                         | `8.0`         |
| `TURBOOCR_MEMORY_LIMIT`       | Memory limit                                                                      | `12G`         |
| `TURBOOCR_GPU_COUNT`          | Number of NVIDIA GPUs to reserve                                                  | `1`           |
| `TURBOOCR_SHM_SIZE`           | Shared memory size                                                                | `2g`          |

Copy `.env.example` to `.env` and override only the variables you need to change.

## Volumes

- `turboocr_trt_cache`: Caches TensorRT engines built from ONNX on first start. Must be a **named** volume — a bind-mount of an empty host directory would shadow the baked-in language bundles and the server would fail to load models.

## Usage

### Start TurboOCR

```bash
docker compose up -d
```

The first start builds 4 TensorRT engines from ONNX. Measured build times on an RTX 3070 Laptop: det (~5 min) + rec (~30 min) + cls (~4 min) + layout (~28 min) = **~67–90 minutes total**. High-end desktop GPUs finish in ~15 minutes. The container reports `unhealthy` while compilation is in progress — this is expected. Once all engines are built the server starts and the container transitions to `healthy`. Subsequent restarts reuse the cached engines and start in seconds.

> **Tip — faster first boot:** Set `TURBOOCR_DISABLE_LAYOUT=1` to skip the layout detection engine (~28 min on laptop GPUs). Only do this if you don't need the `?layout=1` PDF endpoint.

### Endpoints

- HTTP API: <http://localhost:8000>
- gRPC API: `localhost:50051`
- Health: <http://localhost:8000/health>
- Readiness: <http://localhost:8000/health/ready>
- Metrics (Prometheus): <http://localhost:8000/metrics>

### Test the API

```bash
# Image — raw bytes (fastest path)
curl -X POST http://localhost:8000/ocr/raw \
  --data-binary @document.png \
  -H "Content-Type: image/png"

# Image — base64 JSON
curl -X POST http://localhost:8000/ocr \
  -H "Content-Type: application/json" \
  -d '{"image":"'$(base64 -w0 document.png)'"}'

# PDF — raw bytes
curl -X POST http://localhost:8000/ocr/pdf \
  --data-binary @document.pdf

# PDF with layout detection enabled
curl -X POST "http://localhost:8000/ocr/pdf?layout=1&mode=auto" \
  --data-binary @document.pdf
```

> **Important:** Use HTTP keep-alive. Sending many short-lived connections (e.g. one `curl` per request in a loop) can overwhelm the server. Standard HTTP client libraries (`requests.Session`, `aiohttp`, Go `http.Client`, etc.) reuse connections by default.

### Switching Languages

Edit `.env` and restart:

```bash
TURBOOCR_LANG=chinese
TURBOOCR_SERVER=1   # optional: use the 84 MB Chinese server rec
```

```bash
docker compose up -d
```

All language bundles are baked into the image at build time (SHA256-verified from the pinned PP-OCRv5 release). No runtime downloads.

## Performance Tuning

- **GPU pipelines** — set `TURBOOCR_PIPELINE_POOL_SIZE` based on available VRAM (~1.4 GB each)
- **Layout overhead** — `?layout=1` reduces throughput by ~20%; set `TURBOOCR_DISABLE_LAYOUT=1` to skip loading the model entirely
- **Shared memory** — increase `TURBOOCR_SHM_SIZE` if you process very large PDFs

## Security Notes

- The API has no authentication by default. Put a reverse proxy (nginx, Caddy) in front for production.
- The default PDF mode is `ocr`, which only trusts pixel data and is safe for untrusted PDF uploads.
- Do **not** set `TURBOOCR_PDF_MODE` to `geometric` or `auto` globally if you accept PDFs from untrusted sources — a malicious PDF can embed invisible text or remap glyphs to inject arbitrary strings into the text layer.
- Use `auto_verified` for higher accuracy on trusted documents; it cross-checks the native text layer against OCR results.

## License

TurboOCR is licensed under the MIT License. See the [TurboOCR GitHub repository](https://github.com/aiptimizer/TurboOCR) for details.
