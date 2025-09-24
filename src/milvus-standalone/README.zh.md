# Milvus 单机版

[English](./README.md) | [中文](./README.zh.md)

Milvus 是一个开源的向量数据库，专为处理大规模向量数据而设计。它支持高效的相似性搜索和分析，广泛应用于机器学习、深度学习和人工智能等领域。

参见 [使用 Docker Compose 运行 Milvus (Linux)](https://milvus.io/docs/zh/install_standalone-docker-compose.md)。

如果需要身份验证，请访问 [官方文档](https://milvus.io/docs/zh/authenticate.md) 了解如何配置。

## 服务

- `etcd`: 元数据存储服务。
- `minio`: 对象存储服务。
- `milvus-standalone`: Milvus 单机版服务。
- `attu`: Milvus 的网页版管理工具。

## 配置

- `ETCD_VERSION`: etcd 镜像的版本，默认为 `v3.5.18`。
- `MINIO_VERSION`: Minio 镜像的版本，默认为 `RELEASE.2024-12-18T13-15-44Z`。
- `MILVUS_VERSION`: Milvus 镜像的版本，默认为 `v2.6.2`。
- `ATTU_VERSION`: Attu 镜像的版本，默认为 `v2.6.0`。
- `MINIO_ACCESS_KEY`: Minio 的访问密钥，默认为 `minioadmin`。
- `MINIO_SECRET_KEY`: Minio 的秘密密钥，默认为 `minioadmin`。
- `MINIO_PORT_OVERRIDE_API`: Minio API 的主机端口，默认为 `9000`。
- `MINIO_PORT_OVERRIDE_WEBUI`: Minio Web UI 的主机端口，默认为 `9001`。
- `MILVUS_PORT_OVERRIDE_HTTP`: Milvus HTTP 服务的主机端口，默认为 `19530`。
- `MILVUS_PORT_OVERRIDE_WEBUI`: Milvus Web UI 的主机端口，默认为 `9091`。
- `ATTU_PORT`: Attu 服务的主机端口，默认为 `8000`。

## 卷

- `etcd_data`: 用于存储 etcd 数据的卷。
- `minio_data`: 用于存储 Minio 数据的卷。
- `milvus_data`: 用于存储 Milvus 数据的卷。
