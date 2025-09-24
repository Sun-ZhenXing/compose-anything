# Milvus Standalone

[English](./README.md) | [中文](./README.zh.md)

Milvus is an open-source vector database designed for processing large-scale vector data. It supports efficient similarity search and analysis, and is widely used in fields such as machine learning, deep learning, and artificial intelligence.

See [Run Milvus with Docker Compose (Linux)](https://milvus.io/docs/install_standalone-docker-compose.md) for more information.

If you need authentication, please visit the [official documentation](https://milvus.io/docs/authenticate.md) to learn how to configure it.

## Services

- `etcd`: Metadata storage service.
- `minio`: Object storage service.
- `milvus-standalone`: The Milvus standalone service.
- `attu`: The web-based management tool for Milvus.

## Configuration

- `ETCD_VERSION`: The version of the etcd image, default is `v3.5.18`.
- `MINIO_VERSION`: The version of the Minio image, default is `RELEASE.2024-12-18T13-15-44Z`.
- `MILVUS_VERSION`: The version of the Milvus image, default is `v2.6.2`.
- `ATTU_VERSION`: The version of the Attu image, default is `v2.6.0`.
- `MINIO_ACCESS_KEY`: The access key for Minio, default is `minioadmin`.
- `MINIO_SECRET_KEY`: The secret key for Minio, default is `minioadmin`.
- `MINIO_PORT_OVERRIDE_API`: The host port for the Minio API, default is `9000`.
- `MINIO_PORT_OVERRIDE_WEBUI`: The host port for the Minio Web UI, default is `9001`.
- `MILVUS_PORT_OVERRIDE_HTTP`: The host port for the Milvus HTTP service, default is `19530`.
- `MILVUS_PORT_OVERRIDE_WEBUI`: The host port for the Milvus Web UI, default is `9091`.
- `ATTU_PORT`: The host port for the Attu service, default is `8000`.

## Volumes

- `etcd_data`: A volume for storing etcd data.
- `minio_data`: A volume for storing Minio data.
- `milvus_data`: A volume for storing Milvus data.
