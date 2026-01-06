# Open WebUI

[English](./README.md) | [中文](./README.zh.md)

快速开始：<https://docs.openwebui.com/getting-started/quick-start>。

此服务用于部署 Open WebUI，一个面向大语言模型的网页界面。

## 服务

- `openwebui`: Open WebUI 服务。

## 配置

- `GHCR_IO_REGISTRY` ：Open WebUI 镜像的仓库前缀，默认为 `ghcr.io`。
- `OPEN_WEBUI_VERSION` ：Open WebUI 镜像的版本，默认为 `main`。
- `TZ` ：容器的时区，默认为 `UTC`。
- `OPEN_WEBUI_PORT_OVERRIDE` ：Open WebUI 的主机端口，默认为 `8080`。
- `OPEN_WEBUI_CPU_LIMIT` ：Open WebUI 服务的 CPU 限制，默认为 `1`。
- `OPEN_WEBUI_MEMORY_LIMIT` ：Open WebUI 服务的内存限制，默认为 `1024M`。
- `OPEN_WEBUI_CPU_RESERVATION` ：Open WebUI 服务的 CPU 预留，默认为 `0.5`。
- `OPEN_WEBUI_MEMORY_RESERVATION` ：Open WebUI 服务的内存预留，默认为 `512M`。

## 卷

- `open_webui_data`: 用于存储 Open WebUI 数据的卷。
