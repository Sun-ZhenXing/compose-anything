# MinIO

[English](./README.md) | [中文](./README.zh.md)

MinIO is a high-performance, S3-compatible object storage system that can be used to store and manage large amounts of unstructured data, such as photos, videos, log files, and more. This deployment uses Chainguard's production-ready MinIO image, which is distroless, minimal, and continuously updated with security fixes.

Open the Web UI: <http://localhost:9001>.

## Services

- `minio`: The MinIO object storage service (Chainguard Image).

## Configuration

- `MINIO_VERSION`: The version of the MinIO image, default is `0.20251015`.
- `MINIO_PORT_OVERRIDE_API`: The host port for the MinIO API, default is `9000`.
- `MINIO_PORT_OVERRIDE_WEBUI`: The host port for the MinIO Web UI, default is `9001`.
- `MINIO_ROOT_USER`: The root username for MinIO, default is `minioadmin`.
- `MINIO_ROOT_PASSWORD`: The root password for MinIO, default is `minioadmin`.
- `TZ`: Timezone setting, default is `UTC`.

## Volumes

- `minio_data`: A volume for storing MinIO data.

## Notes

- This configuration uses Chainguard's MinIO image (`cgr.dev/chainguard/minio`), which provides enhanced security and is continuously maintained.
- The default credentials are `minioadmin` / `minioadmin`. Change these in production.
