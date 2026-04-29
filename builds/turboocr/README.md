# TurboOCR — Custom Builds

[中文文档](README.zh.md)

This directory builds [TurboOCR](https://github.com/aiptimizer/TurboOCR) from source for two targets that are not covered by the upstream pre-built images:

| Variant | Dockerfile | Profile | Base image |
| ------- | ---------- | ------- | ---------- |
| **CUDA 12.x** | `Dockerfile.cuda12` | `gpu` | `nvcr.io/nvidia/tensorrt:24.12-py3` (TRT 10.8 / CUDA 12.7) |
| **CPU-only** | `Dockerfile.cpu` | `cpu` | `ubuntu:24.04` (ONNX Runtime) |

The upstream pre-built image targets CUDA 13.x (Blackwell / CC 12.0). Use this directory if your GPU is on CUDA 12.x (Turing through Ada Lovelace, CC 7.5–8.9) or if you have no GPU at all.

## Quick Start

1. Copy the example environment file:

   ```bash
   cp .env.example .env
   ```

2. Build and start the variant you need:

   **CUDA 12.x (GPU — Turing through Ada Lovelace):**

   ```bash
   docker compose --profile gpu up -d --build
   ```

   **CPU-only (no GPU required):**

   ```bash
   docker compose --profile cpu up -d --build
   ```

3. Access the API at <http://localhost:8000>.

> **Note:** The first build compiles Drogon and TurboOCR from source, which takes 10–30 minutes depending on your CPU core count. Subsequent builds use the Docker layer cache and are fast.

## First-Start Behavior

### GPU variant

On the very first container start, TensorRT compiles 4 ONNX models into engine files. Measured times on an RTX 3070 Laptop:

| Engine | Time |
| ------ | ---- |
| det | ~5 min |
| rec | ~30 min |
| cls | ~4 min |
| layout | ~28 min |
| **Total** | **~67–90 min** |

High-end desktop GPUs finish in ~15 minutes. The container shows `unhealthy` during compilation — this is expected. Once all engines are ready the server starts and the status transitions to `healthy`. Subsequent restarts reuse the cached engines and start in seconds.

> **Tip:** Set `TURBOOCR_DISABLE_LAYOUT=1` to skip the layout detection engine (~28 min savings on laptop GPUs). Use this only if you do not need the `?layout=1` PDF endpoint.

### CPU variant

No TRT compilation occurs. ONNX Runtime loads the models directly at startup. The container is typically `healthy` within 60 seconds.

## Default Ports

| Port | Protocol | Description |
| ---- | -------- | ----------- |
| 8000 | HTTP | OCR REST API + health/metrics |
| 50051 | gRPC | OCR gRPC API |

## Important Environment Variables

| Variable | Description | Default |
| -------- | ----------- | ------- |
| `TURBOOCR_VERSION` | Git tag used for the source build | `v2.1.1` |
| `TURBOOCR_HTTP_PORT_OVERRIDE` | Host port for the HTTP API | `8000` |
| `TURBOOCR_GRPC_PORT_OVERRIDE` | Host port for the gRPC API | `50051` |
| `TURBOOCR_LANG` | Language bundle: `latin`, `chinese`, `greek`, `eslav`, `arabic`, `korean`, `thai` | `""` (latin) |
| `TURBOOCR_SERVER` | With `chinese`, set to `1` for the 84 MB server rec model | `""` |
| `TURBOOCR_PIPELINE_POOL_SIZE` | Concurrent GPU pipelines (~1.4 GB VRAM each); empty = auto | `""` |
| `TURBOOCR_DISABLE_LAYOUT` | Disable layout detection model (saves ~300–500 MB VRAM) | `0` |
| `TURBOOCR_PDF_MODE` | PDF parsing mode: `ocr` / `geometric` / `auto` / `auto_verified` | `ocr` |
| `TURBOOCR_CPU_LIMIT` | CPU core limit (both variants) | `8.0` |
| `TURBOOCR_MEMORY_LIMIT` | Memory limit — `12G` for GPU, `4G` for CPU | variant default |
| `TURBOOCR_GPU_COUNT` | NVIDIA GPUs to reserve (GPU variant only) | `1` |
| `TURBOOCR_SHM_SIZE` | Shared memory for fastpdf2png — `2g` for GPU, `512m` for CPU | variant default |
| `TZ` | Container timezone | `UTC` |

## Storage

- `turboocr_build_cache` — named volume at `/home/ocr/.cache/turbo-ocr`. Stores TRT engine files (GPU) or the model cache directory (CPU). Must be a named volume — a bind-mount of an empty host directory would shadow the baked-in language bundles and the server would fail to load models.

## Supported GPU Architectures (CUDA 12.x variant)

| Compute Capability | Architecture | GPUs |
| ------------------ | ------------ | ---- |
| 7.5 | Turing | GTX 16xx, RTX 20xx |
| 8.0 | Ampere | A100, RTX 30xx (server) |
| 8.6 | Ampere | RTX 30xx (desktop / laptop) |
| 8.9 | Ada Lovelace | RTX 40xx |

Blackwell (CC 12.0, RTX 50xx) requires CUDA 13.x — use the upstream pre-built image from `src/turboocr` instead.

## Notes

- Both Dockerfiles build TurboOCR from source via `git clone` inside the image. A working internet connection is required at build time.
- The CUDA 12.x Dockerfile overrides `CMAKE_CUDA_ARCHITECTURES` to `75;80;86;89`, removing CC 12.0 which is not supported by CUDA 12.x.
- TensorRT 10.8 is located at `/usr/local/tensorrt` in the `24.12-py3` base image, which matches the CMake default. No `-DTENSORRT_DIR` override is needed.
- The CPU variant uses ONNX Runtime 1.22.0 and produces a `paddle_cpu_server` binary with both HTTP and gRPC interfaces.

## Endpoints

- HTTP API: <http://localhost:8000>
- gRPC API: `localhost:50051`
- Health: <http://localhost:8000/health>
- Readiness: <http://localhost:8000/health/ready>
- Metrics (Prometheus): <http://localhost:8000/metrics>

## Security Notes

- The API has no authentication by default. Put a reverse proxy (nginx, Caddy) in front for production.
- The default PDF mode is `ocr`, which only trusts pixel data and is safe for untrusted PDF uploads.
- Do **not** set `TURBOOCR_PDF_MODE` to `geometric` or `auto` globally if you accept PDFs from untrusted sources.

## References

- [TurboOCR Repository](https://github.com/aiptimizer/TurboOCR)
- [NVIDIA TensorRT Container Releases](https://docs.nvidia.com/deeplearning/tensorrt/container-release-notes/)
- [NVIDIA CUDA GPU Compute Capability Table](https://developer.nvidia.com/cuda-gpus)
