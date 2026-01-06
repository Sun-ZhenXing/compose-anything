# Open WebUI

[English](./README.md) | [中文](./README.zh.md)

Quick start: <https://docs.openwebui.com/getting-started/quick-start>.

This service deploys Open WebUI, a web-based interface for LLMs.

## Services

- `openwebui`: The Open WebUI service.

## Configuration

- `GHCR_IO_REGISTRY`: The registry prefix for the Open WebUI image, default is `ghcr.io`.
- `OPEN_WEBUI_VERSION`: The version of the Open WebUI image, default is `main`.
- `TZ`: The timezone for the container, default is `UTC`.
- `OPEN_WEBUI_PORT_OVERRIDE`: The host port for Open WebUI, default is `8080`.
- `OPEN_WEBUI_CPU_LIMIT`: The CPU limit for the Open WebUI service, default is `1`.
- `OPEN_WEBUI_MEMORY_LIMIT`: The memory limit for the Open WebUI service, default is `1024M`.
- `OPEN_WEBUI_CPU_RESERVATION`: The CPU reservation for the Open WebUI service, default is `0.5`.
- `OPEN_WEBUI_MEMORY_RESERVATION`: The memory reservation for the Open WebUI service, default is `512M`.

## Volumes

- `open_webui_data`: A volume for storing Open WebUI data.
