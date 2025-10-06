# Stable Diffusion WebUI Docker

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署 Stable Diffusion WebUI (SD.Next) 进行 AI 图像生成。

## 服务

- `stable-diffusion-webui`: 支持 GPU 的 Stable Diffusion WebUI。

## 先决条件

**需要 NVIDIA GPU**: 此服务需要支持 CUDA 的 NVIDIA GPU 和已安装的 NVIDIA Container Toolkit。

### 安装 NVIDIA Container Toolkit

**Linux:**

```bash
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
```

**Windows (Docker Desktop):**

确保已安装带有 NVIDIA 驱动程序的 WSL2，并将 Docker Desktop 配置为使用 WSL2 后端。

## 环境变量

| 变量名                     | 说明              | 默认值                                |
| -------------------------- | ----------------- | ------------------------------------- |
| SD_WEBUI_VERSION           | SD WebUI 镜像版本 | `latest`                              |
| CLI_ARGS                   | 命令行参数        | `--listen --api --skip-version-check` |
| NVIDIA_VISIBLE_DEVICES     | 使用的 GPU        | `all`                                 |
| NVIDIA_DRIVER_CAPABILITIES | 驱动程序功能      | `compute,utility`                     |
| GPU_COUNT                  | 分配的 GPU 数量   | `1`                                   |
| SD_WEBUI_PORT_OVERRIDE     | WebUI 端口        | `7860`                                |

请根据实际需求修改 `.env` 文件。

## 卷

- `sd_webui_data`: 模型文件、扩展和配置。
- `sd_webui_output`: 生成的图像输出目录。

## 使用方法

### 启动服务

```bash
docker-compose up -d
```

### 访问 WebUI

在浏览器中打开:

```text
http://localhost:7860
```

### 下载模型

首次启动时，您需要下载模型。WebUI 会指导您完成此过程，或者您可以手动将模型放置在 `/data/models` 目录中。

常见模型位置:

- Stable Diffusion 模型: `/data/models/Stable-diffusion/`
- VAE 模型: `/data/models/VAE/`
- LoRA 模型: `/data/models/Lora/`
- 嵌入: `/data/models/embeddings/`

### 生成图像

1. 从下拉列表中选择模型
2. 输入您的提示词
3. 调整参数（步数、CFG 比例、采样器等）
4. 点击"生成"

## 功能

- **文本到图像**: 从文本提示生成图像
- **图像到图像**: 转换现有图像
- **修复**: 编辑图像的特定部分
- **放大**: 增强图像分辨率
- **API 访问**: 用于自动化的 RESTful API
- **扩展**: 支持自定义扩展
- **多模型**: 支持各种 SD 模型（1.5、2.x、SDXL 等）

## 注意事项

- 首次启动可能需要时间下载依赖项和模型
- 推荐: SD 1.5 需要 8GB+ 显存，SDXL 需要 12GB+
- 需要 GPU；纯 CPU 模式极其缓慢
- 生成的图像保存在 `sd_webui_output` 卷中
- 模型可能很大（每个 2-7GB）；确保有足够的磁盘空间

## API 使用

启用 `--api` 标志后，在以下地址访问 API:

```text
http://localhost:7860/docs
```

API 调用示例:

```bash
curl -X POST http://localhost:7860/sdapi/v1/txt2img \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "a beautiful landscape",
    "steps": 20
  }'
```

## 许可证

Stable Diffusion 模型有各种许可证。使用前请检查各个模型的许可证。
