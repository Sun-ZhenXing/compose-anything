# Bifrost Gateway

[English](./README.md) | [中文](./README.zh.md)

Bifrost is a lightweight, high-performance LLM gateway that supports multiple models and providers.

## Services

- `bifrost`: The LLM gateway service.
- `prometheus`: Prometheus for metrics collection (enabled with `--profile telemetry`).
- `grafana`: Grafana for visualization (enabled with `--profile telemetry`).

## Configuration

- `BIFROST_VERSION`: The version of the Bifrost image, default is `v1.3.59`.
- `BIFROST_PORT`: The port for the Bifrost service, default is `28080`.

### Telemetry

- `PROMETHEUS_VERSION`: Prometheus version, default `v3.0.1`.
- `PROMETHEUS_PORT`: Prometheus port, default `29090`.
- `GRAFANA_VERSION`: Grafana version, default `11.4.0`.
- `GRAFANA_PORT`: Grafana port, default `23000`.
- `GRAFANA_ADMIN_USER`: Grafana admin user, default `admin`.
- `GRAFANA_ADMIN_PASSWORD`: Grafana admin password, default `admin`.

## Usage

Start the gateway:

```bash
docker compose up -d
```

Start with telemetry (Prometheus + Grafana):

```bash
docker compose --profile telemetry up -d
```

## Volumes

- `bifrost_data`: A volume for storing Bifrost data.
- `prometheus_data`: A volume for storing Prometheus data.
- `grafana_data`: A volume for storing Grafana data.
