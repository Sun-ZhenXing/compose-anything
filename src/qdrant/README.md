# Qdrant

[English](./README.md) | [中文](./README.zh.md)

Qdrant is a vector database for efficient similarity search and AI applications.

## Authorization

Qdrant supports [API keys](https://qdrant.tech/documentation/guides/security/#read-only-api-key) and [JWT tokens](https://qdrant.tech/documentation/guides/security/#granular-access-control-with-jwt) for access control.

## Services

- `qdrant`: The Qdrant vector database service.

## Configuration

- `QDRANT_VERSION`: The version of the Qdrant image, default is `v1.15.4`.
- `QDRANT_HTTP_PORT`: The host port for Qdrant HTTP API, default is `6333`.
- `QDRANT_GRPC_PORT`: The host port for Qdrant gRPC API, default is `6334`.
- `QDRANT_API_KEY`: API key for Qdrant.
- `QDRANT_JWT_RBAC`: Enable JWT RBAC, default is `false`.

## Volumes

- `qdrant_data`: A volume for storing Qdrant data.
