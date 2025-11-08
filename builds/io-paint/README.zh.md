# IOPaint (Lama Cleaner)

[English](./README.md) | [中文](./README.zh.md)

IOPaint（原 LaMa Cleaner）是一个由最先进的 AI 模型驱动的免费开源图像修复和扩展工具。

## 先决条件

- 支持 CUDA 的 NVIDIA GPU
- 支持 NVIDIA 运行时的 Docker

## 初始化

1. 复制示例环境文件：

   ```bash
   cp .env.example .env
   ```

2. 启动服务：

   ```bash
   docker compose up -d
   ```

3. 在 <http://localhost:8080> 访问 Web 界面

## 服务

- `iopaint`: IOPaint 服务。

## 配置

服务默认在端口 8080 运行，使用 CUDA 设备 0。

| 变量              | 描述                      | 默认值      |
| ----------------- | ------------------------- | ----------- |
| `DOCKER_REGISTRY` | 使用的 Docker 镜像仓库    | `docker.io` |
| `BUILD_VERSION`   | 构建版本                  | `latest`    |
| `HF_ENDPOINT`     | Hugging Face 端点（可选） | -           |

## 模型

模型在首次使用时会自动下载并缓存在 `./models` 目录中。

## GPU 支持

此配置需要 NVIDIA GPU 并使用 CUDA 设备 0。确保你已安装：

- NVIDIA 驱动程序
- 支持 NVIDIA 运行时的 Docker
- nvidia-docker2 软件包

请参考官方 IOPaint 项目的许可信息。
