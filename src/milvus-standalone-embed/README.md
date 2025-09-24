# Milvus Standalone with Embedded Etcd

[English](./README.md) | [中文](./README.zh.md)

Run Milvus in standalone mode with embedded etcd using Docker Compose.

## Start the service

```bash
docker compose up -d
```

Start the Attu dashboard:

```bash
docker compose --profile attu up -d
```

## Services

- `milvus-standalone-embed`: The Milvus standalone service with embedded etcd.
- `attu`: The web-based management tool for Milvus.

## Configuration

- `MILVUS_VERSION`: The version of the Milvus image, default is `v2.6.2`.
- `ATTU_VERSION`: The version of the Attu image, default is `v2.6.0`.
- `MILVUS_PORT_OVERRIDE_HTTP`: The host port for the Milvus HTTP service, default is `19530`.
- `MILVUS_PORT_OVERRIDE_WEBUI`: The host port for the Milvus Web UI, default is `9091`.
- `MILVUS_PORT_OVERRIDE_ETCD`: The host port for the etcd service, default is `2379`.
- `ATTU_OVERRIDE_PORT`: The host port for the Attu service, default is `8000`.
- `MILVUS_URL`: The address of the Milvus service for Attu to connect to, default is `milvus-standalone-embed:19530`.

## Volumes

- `milvus_data`: A volume for storing Milvus and embedded etcd data.
- `embed_etcd.yaml`: The configuration file for the embedded etcd.
- `user.yaml`: The user configuration file for Milvus.
