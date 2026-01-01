# Stable Diffusion WebUI Docker

[English](./README.md) | [中文](./README.zh.md)

This service deploys Stable Diffusion WebUI (SD.Next) for AI image generation.

## Services

- `stable-diffusion-webui`: Stable Diffusion WebUI with GPU support.

## Prerequisites

**NVIDIA GPU Required**: This service requires an NVIDIA GPU with CUDA support and the NVIDIA Container Toolkit installed.

### Install NVIDIA Container Toolkit

**Linux:**

```bash
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
```

**Windows (Docker Desktop):**

Ensure you have WSL2 with NVIDIA drivers installed and Docker Desktop configured to use WSL2 backend.

## Environment Variables

| Variable Name              | Description                | Default Value                         |
| -------------------------- | -------------------------- | ------------------------------------- |
| SD_WEBUI_VERSION           | SD WebUI image version     | `latest`                              |
| CLI_ARGS                   | Command-line arguments     | `--listen --api --skip-version-check` |
| NVIDIA_VISIBLE_DEVICES     | GPUs to use                | `all`                                 |
| NVIDIA_DRIVER_CAPABILITIES | Driver capabilities        | `compute,utility`                     |
| GPU_COUNT                  | Number of GPUs to allocate | `1`                                   |
| SD_WEBUI_PORT_OVERRIDE     | WebUI port                 | `7860`                                |

Please modify the `.env` file as needed for your use case.

## Volumes

- `sd_webui_data`: Model files, extensions, and configuration.
- `sd_webui_output`: Generated images output directory.

## Usage

### Start the Service

```bash
docker-compose up -d
```

### Access the WebUI

Open your browser and navigate to:

```text
http://localhost:7860
```

### Download Models

On first start, you need to download models. The WebUI will guide you through this process, or you can manually place models in the `/data/models` directory.

Common model locations:

- Stable Diffusion models: `/data/models/Stable-diffusion/`
- VAE models: `/data/models/VAE/`
- LoRA models: `/data/models/Lora/`
- Embeddings: `/data/models/embeddings/`

### Generate Images

1. Select a model from the dropdown
2. Enter your prompt
3. Adjust parameters (steps, CFG scale, sampler, etc.)
4. Click "Generate"

## Features

- **Text-to-Image**: Generate images from text prompts
- **Image-to-Image**: Transform existing images
- **Inpainting**: Edit specific parts of images
- **Upscaling**: Enhance image resolution
- **API Access**: RESTful API for automation
- **Extensions**: Support for custom extensions
- **Multiple Models**: Support for various SD models (1.5, 2.x, SDXL, etc.)

## Notes

- First startup may take time to download dependencies and models
- Recommended: 8GB+ VRAM for SD 1.5, 12GB+ for SDXL
- GPU is required; CPU-only mode is extremely slow
- Generated images are saved in the `sd_webui_output` volume
- Models can be large (2-7GB each); ensure adequate disk space

## API Usage

With `--api` flag enabled, access the API at:

```text
http://localhost:7860/docs
```

Example API call:

```bash
curl -X POST http://localhost:7860/sdapi/v1/txt2img \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "a beautiful landscape",
    "steps": 20
  }'
```

## License

Stable Diffusion models have various licenses. Please check individual model licenses before use.
