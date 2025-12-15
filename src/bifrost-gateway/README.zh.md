# Bifrost 网关

[English](./README.md) | [中文](./README.zh.md)

Bifrost 是一个轻量级、高性能的 LLM 网关，支持多种模型和提供商。

## 服务

- `bifrost`: LLM 网关服务。

## 配置

- `BIFROST_VERSION`: Bifrost 镜像的版本，默认为 `v1.3.48`。
- `BIFROST_PORT`: Bifrost 服务的端口，默认为 `28080`。

## 卷

- `bifrost_data`: 用于存储 Bifrost 数据的卷。
