# Docker 镜像仓库

[English](./README.md) | [中文](./README.zh.md)

此服务用于搭建一个私有的 Docker 镜像仓库。

## 前提条件

1. 为您的服务器生成一张 TLS 证书。
2. 将证书和密钥文件（PEM 格式）放置在 `certs/` 目录下。
3. 创建 `.env` 文件并配置以下变量：

   ```bash
   REGISTRY_HTTP_TLS_CERTIFICATE=your_cert.crt
   REGISTRY_HTTP_TLS_KEY=your_key.key
   ```

## 服务

- `registry`: Docker 镜像仓库服务。

## 配置

- `REGISTRY_VERSION`: 镜像仓库的版本，默认为 `3.0.0`。
- `REGISTRY_PORT`: 镜像仓库服务的端口，默认为 `5000`。
- `REGISTRY_AUTH`: 认证方式，默认为 `htpasswd`。
- `REGISTRY_AUTH_HTPASSWD_REALM`: htpasswd 认证的领域，默认为 `Registry Realm`。
- `REGISTRY_AUTH_HTPASSWD_PATH`: htpasswd 文件的路径，默认为 `/certs/passwd`。
- `REGISTRY_HTTP_TLS_CERTIFICATE`: TLS 证书文件。
- `REGISTRY_HTTP_TLS_KEY`: TLS 密钥文件。
- `OTEL_TRACES_EXPORTER`: 设置为 `none` 以禁用追踪。

## 卷

- `certs`: 用于存放 TLS 证书。
- `config.yml`: 镜像仓库的配置文件。
- `registry`: 用于存储镜像仓库数据的卷。
