# Bifrost 网关

[English](./README.md) | [中文](./README.zh.md)

Bifrost 是一个轻量级、高性能的 LLM 网关，支持多种模型和提供商。

## 服务

- `bifrost`: LLM 网关服务。
- `prometheus`: 用于指标收集的 Prometheus（通过 `--profile telemetry` 启用）。
- `grafana`: 用于可视化的 Grafana（通过 `--profile telemetry` 启用）。

## 配置

- `BIFROST_VERSION`: Bifrost 镜像的版本，默认为 `v1.3.59`。
- `BIFROST_PORT`: Bifrost 服务的端口，默认为 `28080`。

### 遥测 (Telemetry)

- `PROMETHEUS_VERSION`: Prometheus 版本，默认为 `v3.0.1`。
- `PROMETHEUS_PORT`: Prometheus 端口，默认为 `29090`。
- `GRAFANA_VERSION`: Grafana 版本，默认为 `11.4.0`。
- `GRAFANA_PORT`: Grafana 端口，默认为 `23000`。
- `GRAFANA_ADMIN_USER`: Grafana 管理员用户，默认为 `admin`。
- `GRAFANA_ADMIN_PASSWORD`: Grafana 管理员密码，默认为 `admin`。

## 使用

启动网关：

```bash
docker compose up -d
```

启动带有遥测功能（Prometheus + Grafana）的网关：

```bash
docker compose --profile telemetry up -d
```

## 卷

- `bifrost_data`: 用于存储 Bifrost 数据的卷。
- `prometheus_data`: 用于存储 Prometheus 数据的卷。
- `grafana_data`: 用于存储 Grafana 数据的卷。
