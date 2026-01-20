# Flowise

[English](./README.md) | [中文](./README.zh.md)

快速开始：<https://docs.flowiseai.com>。

此服务用于部署 Flowise，一个可视化的 LLM 编排平台。

## 服务

- `flowise`：Flowise 服务。

## 配置

- `GLOBAL_REGISTRY`：Flowise 镜像的仓库前缀，默认为空。
- `FLOWISE_VERSION`：Flowise 镜像版本，默认是 `3.0.12`。
- `TZ`：容器时区，默认是 `UTC`。
- `FLOWISE_PORT_OVERRIDE`：Flowise 的宿主机端口，默认是 `3000`。
- `FLOWISE_CPU_LIMIT`：Flowise 服务的 CPU 限制，默认是 `1`。
- `FLOWISE_MEMORY_LIMIT`：Flowise 服务的内存限制，默认是 `1024M`。
- `FLOWISE_CPU_RESERVATION`：Flowise 服务的 CPU 预留，默认是 `0.5`。
- `FLOWISE_MEMORY_RESERVATION`：Flowise 服务的内存预留，默认是 `512M`。
- `FLOWISE_USERNAME`：可选的基础认证用户名，不设置则禁用。
- `FLOWISE_PASSWORD`：可选的基础认证密码，不设置则禁用。

## 数据卷

- `flowise_data`：用于存储 Flowise 数据的卷。

## 说明

- 健康检查使用 `/api/v1/ping` 端点。
