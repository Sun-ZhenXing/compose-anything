# Flowise

[English](./README.md) | [中文](./README.zh.md)

Quick start: <https://docs.flowiseai.com>.

This service deploys Flowise, a visual LLM orchestration platform.

## Services

- `flowise`: The Flowise service.

## Configuration

- `GLOBAL_REGISTRY`: The registry prefix for the Flowise image, default is empty.
- `FLOWISE_VERSION`: The version of the Flowise image, default is `3.0.12`.
- `TZ`: The timezone for the container, default is `UTC`.
- `FLOWISE_PORT_OVERRIDE`: The host port for Flowise, default is `3000`.
- `FLOWISE_CPU_LIMIT`: The CPU limit for the Flowise service, default is `1`.
- `FLOWISE_MEMORY_LIMIT`: The memory limit for the Flowise service, default is `1024M`.
- `FLOWISE_CPU_RESERVATION`: The CPU reservation for the Flowise service, default is `0.5`.
- `FLOWISE_MEMORY_RESERVATION`: The memory reservation for the Flowise service, default is `512M`.
- `FLOWISE_USERNAME`: Optional basic auth username. Leave empty to disable.
- `FLOWISE_PASSWORD`: Optional basic auth password. Leave empty to disable.

## Volumes

- `flowise_data`: A volume for storing Flowise data.

## Notes

- The health check uses the `/api/v1/ping` endpoint.
