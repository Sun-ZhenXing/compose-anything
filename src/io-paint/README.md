# IOPaint (Lama Cleaner)

[English](./README.md) | [中文](./README.zh.md)

IOPaint (formerly LaMa Cleaner) is a free and open-source inpainting & outpainting tool powered by SOTA AI model.

## Prerequisites

- NVIDIA GPU with CUDA support
- Docker with NVIDIA runtime support

## Initialization

1. Copy the example environment file:

   ```bash
   cp .env.example .env
   ```

2. Start the service:

   ```bash
   docker compose up -d
   ```

3. Access the web interface at <http://localhost:8080>

## Services

- `iopaint`: The IOPaint service.

## Configuration

The service runs on port 8080 and uses CUDA device 0 by default.

| Variable          | Description                      | Default     |
| ----------------- | -------------------------------- | ----------- |
| `DOCKER_REGISTRY` | Docker registry to use           | `docker.io` |
| `BUILD_VERSION`   | Build version                    | `latest`    |
| `HF_ENDPOINT`     | Hugging Face endpoint (optional) | -           |

## Models

Models are automatically downloaded and cached in the `./models` directory on first use.

## GPU Support

This configuration requires an NVIDIA GPU and uses CUDA device 0. Make sure you have:

- NVIDIA drivers installed
- Docker with NVIDIA runtime support
- nvidia-docker2 package installed

## Reference

- [Dockerfile](https://github.com/Sanster/IOPaint/blob/main/docker/GPUDockerfile)

## License

Please refer to the official IOPaint project for license information.
