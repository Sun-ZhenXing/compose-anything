# MinIO

[English](./README.md) | [中文](./README.zh.md)

MinIO 是一个高性能的分布式对象存储系统，兼容 Amazon S3 API。它可以用于存储和管理大量非结构化数据，如照片、视频、日志文件等。

打开 Web UI 界面：<http://localhost:9001>。

## 服务

- `minio`: MinIO 服务。

## 配置

- `MINIO_VERSION`: MinIO 镜像的版本，默认为 `RELEASE.2025-09-07T16-13-09Z`。
- `MINIO_PORT_OVERRIDE_API`: MinIO API 的主机端口，默认为 `9000`。
- `MINIO_PORT_OVERRIDE_WEBUI`: MinIO Web UI 的主机端口，默认为 `9001`。
- `MINIO_ROOT_USER`: MinIO 的 root 用户名，默认为 `root`。
- `MINIO_ROOT_PASSWORD`: MinIO 的 root 密码，默认为 `password`。
- `MINIO_ACCESS_KEY`: MinIO 的访问密钥。
- `MINIO_SECRET_KEY`: MinIO 的秘密密钥。

## 卷

- `minio_data`: 用于存储 MinIO 数据的卷。
- `config`: 用于存储 MinIO 配置的卷。
