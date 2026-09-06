# Bifrost 网关

[English](./README.md) | [中文](./README.zh.md)

Bifrost 是一个轻量级、高性能的 LLM 网关，支持多种模型和提供商。

## 服务

- `bifrost`：LLM 网关服务。
- `prometheus`：用于指标收集的 Prometheus（通过 `--profile telemetry` 启用）。
- `grafana`：用于可视化的 Grafana（通过 `--profile telemetry` 启用）。

## 配置

- `BIFROST_VERSION`：Bifrost 镜像的版本，默认为 `v2.0.0`。
- `BIFROST_SETUP_TOKEN`：默认为空，使用首次管理员设置流程时必须提供。
- `BIFROST_PORT`：Bifrost 服务的端口，默认为 `28080`。

### 遥测（Telemetry）

- `PROMETHEUS_VERSION`：Prometheus 版本，默认为 `v3.8.1`。
- `PROMETHEUS_PORT`：Prometheus 端口，默认为 `29090`。
- `GRAFANA_VERSION`：Grafana 版本，默认为 `12.3.1`。
- `GRAFANA_PORT`：Grafana 端口，默认为 `23000`。
- `GRAFANA_ADMIN_USER`：Grafana 管理员用户，默认为 `admin`。
- `GRAFANA_ADMIN_PASSWORD`：Grafana 管理员密码，默认为 `admin`。

## 快速开始

启动网关：

```bash
docker compose up -d
```

全新的本地实例在未提供设置令牌时会以禁用认证的状态启动。请通过 <http://localhost:28080> 打开 UI。不要将这个无认证的本地实例暴露到不受信任的环境。

### 首次管理员设置

若要启用认证并创建首个管理员，请在现有 `.env` 文件中设置 `BIFROST_SETUP_TOKEN`。如果还没有 `.env`，请先复制 `.env.example`，不要覆盖现有的 `.env`：

```bash
# 仅在 .env 不存在时运行。
cp .env.example .env
openssl rand -hex 32
```

将生成的值填入 `BIFROST_SETUP_TOKEN`，使用上面的命令启动，然后在首次设置页面输入相同令牌。此设置令牌是该流程的必需项，不会由 Bifrost 持久化或记录日志，也不是登录凭据或 API 密钥。管理员创建后，普通登录不再需要该令牌。不要提交 `.env` 或令牌。请参阅[上游认证设置指南](https://docs.getbifrost.ai/quickstart/gateway/setting-up-auth)。

启动带有遥测功能（Prometheus + Grafana）的网关：

```bash
docker compose --profile telemetry up -d
```

## 升级说明

升级前请备份 `bifrost_data` 卷。将现有 `.env` 中的 `BIFROST_VERSION` 更新为 `v2.0.0`，然后拉取并重启：

```bash
docker compose pull bifrost
docker compose up -d
```

不要运行 `docker compose down -v`，也不要在数据库迁移后降级，除非先恢复匹配的备份。从 v1.4.x 升级的用户应阅读中间版本的迁移说明，以及 [v2.0.0 迁移指南](https://docs.getbifrost.ai/migration-guides/v2.0.0)，其中包括 [v1.5.0 迁移指南](https://docs.getbifrost.ai/migration-guides/v1.5.0)。在 `config.json` 中，`auth_config.disable_auth_on_inference` 在 v2 中已弃用并会被忽略，请改为检查 `client.enforce_auth_on_inference`。这些是配置字段，不是环境变量。

## 卷

- `bifrost_data`：用于存储 Bifrost 数据的卷。
- `prometheus_data`：用于存储 Prometheus 数据的卷。
- `grafana_data`：用于存储 Grafana 数据的卷。
