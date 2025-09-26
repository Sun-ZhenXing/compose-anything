# Open WebUI

[English](./README.md) | [中文](./README.zh.md)

快速开始：<https://docs.openwebui.com/getting-started/quick-start>。

此服务用于部署 Open WebUI，一个面向大语言模型的网页界面。

## 服务

- `openwebui`: Open WebUI 服务。

## 配置

- `OPEN_WEBUI_VERSION`: Open WebUI 镜像的版本，默认为 `main`。
- `OPEN_WEBUI_PORT_OVERRIDE`: Open WebUI 的主机端口，默认为 `8080`。

## 卷

- `open_webui_data`: 用于存储 Open WebUI 数据的卷。
