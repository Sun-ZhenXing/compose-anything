# Bifrost Gateway

[English](./README.md) | [中文](./README.zh.md)

Bifrost is a lightweight, high-performance LLM gateway that supports multiple models and providers.

## Services

- `bifrost`: The LLM gateway service.

## Configuration

- `BIFROST_VERSION`: The version of the Bifrost image, default is `v1.3.48`.
- `BIFROST_PORT`: The port for the Bifrost service, default is `28080`.

## Volumes

- `bifrost_data`: A volume for storing Bifrost data.
