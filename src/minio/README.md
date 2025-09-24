# MinIO

[English](./README.md) | [中文](./README.zh.md)

MinIO is a high-performance, distributed object storage system that is compatible with the Amazon S3 API. It can be used to store and manage large amounts of unstructured data, such as photos, videos, log files, etc.

Open the Web UI: <http://localhost:9001>.

## Services

- `minio`: The MinIO service.

## Configuration

- `MINIO_VERSION`: The version of the MinIO image, default is `RELEASE.2025-09-07T16-13-09Z`.
- `MINIO_PORT_OVERRIDE_API`: The host port for the MinIO API, default is `9000`.
- `MINIO_PORT_OVERRIDE_WEBUI`: The host port for the MinIO Web UI, default is `9001`.
- `MINIO_ROOT_USER`: The root username for MinIO, default is `root`.
- `MINIO_ROOT_PASSWORD`: The root password for MinIO, default is `password`.
- `MINIO_ACCESS_KEY`: The access key for MinIO.
- `MINIO_SECRET_KEY`: The secret key for MinIO.

## Volumes

- `minio_data`: A volume for storing MinIO data.
- `config`: A volume for storing MinIO configuration.
