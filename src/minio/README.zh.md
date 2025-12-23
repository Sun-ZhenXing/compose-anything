# MinIO

[English](./README.md) | [中文](./README.zh.md)

MinIO 是一个高性能的 S3 兼容对象存储系统，可以用于存储和管理大量非结构化数据，如照片、视频、日志文件等。该部署使用 Chainguard 的生产级 MinIO 镜像，该镜像是无根的、最小化的，并持续更新安全修复。

打开 Web UI 界面：<http://localhost:9001>。

## 服务

- `minio`: MinIO 对象存储服务（Chainguard 镜像）。

## 配置

- `MINIO_VERSION`: MinIO 镜像的版本，默认为 `0.20251015`。
- `MINIO_PORT_OVERRIDE_API`: MinIO API 的主机端口，默认为 `9000`。
- `MINIO_PORT_OVERRIDE_WEBUI`: MinIO Web UI 的主机端口，默认为 `9001`。
- `MINIO_ROOT_USER`: MinIO 的根用户名，默认为 `minioadmin`。
- `MINIO_ROOT_PASSWORD`: MinIO 的根密码，默认为 `minioadmin`。
- `TZ`: 时区设置，默认为 `UTC`。

## 卷

- `minio_data`: 用于存储 MinIO 数据的卷。

## 注意事项

- 该配置使用 Chainguard 的 MinIO 镜像（`cgr.dev/chainguard/minio`），提供增强的安全性，并持续维护。
- 默认凭据为 `minioadmin` / `minioadmin`。在生产环境中请更改这些凭据。
