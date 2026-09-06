# Bifrost Gateway

[English](./README.md) | [中文](./README.zh.md)

Bifrost is a lightweight, high-performance LLM gateway that supports multiple models and providers.

## Services

- `bifrost`: The LLM gateway service.
- `prometheus`: Prometheus for metrics collection (enabled with `--profile telemetry`).
- `grafana`: Grafana for visualization (enabled with `--profile telemetry`).

## Configuration

- `BIFROST_VERSION`: The version of the Bifrost image, default is `v2.0.0`.
- `BIFROST_SETUP_TOKEN`: Empty by default. Required when using the first-administrator setup flow.
- `BIFROST_PORT`: The port for the Bifrost service, default is `28080`.

### Telemetry

- `PROMETHEUS_VERSION`: Prometheus version, default `v3.8.1`.
- `PROMETHEUS_PORT`: Prometheus port, default `29090`.
- `GRAFANA_VERSION`: Grafana version, default `12.3.1`.
- `GRAFANA_PORT`: Grafana port, default `23000`.
- `GRAFANA_ADMIN_USER`: Grafana admin user, default `admin`.
- `GRAFANA_ADMIN_PASSWORD`: Grafana admin password, default `admin`.

## Quick start

Start the gateway:

```bash
docker compose up -d
```

The fresh local instance starts with authentication disabled when no setup token is supplied. Open the UI at <http://localhost:28080>. Do not expose this no-auth local instance beyond a trusted environment.

### First administrator setup

To enable authentication and create the first administrator, set `BIFROST_SETUP_TOKEN` in an existing `.env` file. If you do not have one yet, copy `.env.example` first; do not overwrite an existing `.env`:

```bash
# Run this only when .env does not already exist.
cp .env.example .env
openssl rand -hex 32
```

Put the generated value in `BIFROST_SETUP_TOKEN`, start with the command above, and enter the same token in the initial setup screen. This setup token is required for that flow, is not persisted or logged by Bifrost, and is not a login credential or API key. It is not needed for ordinary login after an administrator exists. Never commit `.env` or the token. See the [upstream authentication setup guide](https://docs.getbifrost.ai/quickstart/gateway/setting-up-auth).

Start with telemetry (Prometheus + Grafana):

```bash
docker compose --profile telemetry up -d
```

## Upgrade notes

Back up the `bifrost_data` volume before upgrading. Update an existing `.env` to `BIFROST_VERSION=v2.0.0`, then pull and restart:

```bash
docker compose pull bifrost
docker compose up -d
```

Do not run `docker compose down -v`, and do not downgrade a migrated database without restoring a matching backup. Users upgrading from v1.4.x should review the intervening migration guidance and the [v2.0.0 migration guide](https://docs.getbifrost.ai/migration-guides/v2.0.0), including the [v1.5.0 migration guide](https://docs.getbifrost.ai/migration-guides/v1.5.0). In `config.json`, `auth_config.disable_auth_on_inference` is deprecated and ignored in v2; review `client.enforce_auth_on_inference` instead. These are configuration fields, not environment variables.

## Volumes

- `bifrost_data`: A volume for storing Bifrost data.
- `prometheus_data`: A volume for storing Prometheus data.
- `grafana_data`: A volume for storing Grafana data.
