# Qdrant

[English](./README.md) | [中文](./README.zh.md)

Qdrant 是一个用于高效相似性搜索和 AI 应用的向量数据库。

## 鉴权

Qdrant 支持 [API 密钥](https://qdrant.tech/documentation/guides/security/#read-only-api-key) 和 [JWT 令牌](https://qdrant.tech/documentation/guides/security/#granular-access-control-with-jwt) 两种鉴权方式。

## 服务

- `qdrant`: Qdrant 向量数据库服务。

## 配置

- `QDRANT_VERSION`: Qdrant 镜像的版本，默认为 `v1.15.4`。
- `QDRANT_HTTP_PORT`: Qdrant HTTP API 的主机端口，默认为 `6333`。
- `QDRANT_GRPC_PORT`: Qdrant gRPC API 的主机端口，默认为 `6334`。
- `QDRANT_API_KEY`: Qdrant 的 API 密钥。
- `QDRANT_JWT_RBAC`: 是否启用 JWT RBAC，默认为 `false`。

## 卷

- `qdrant_data`: 用于存储 Qdrant 数据的卷。
