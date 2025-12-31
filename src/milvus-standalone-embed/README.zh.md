# Milvus 单机版 (内嵌 etcd)

[English](./README.md) | [中文](./README.zh.md)

使用 Docker Compose 以单机模式运行 Milvus，并内嵌 etcd。

## 启动服务

```bash
docker compose up -d
```

启动 Attu 仪表盘：

```bash
docker compose --profile attu up -d
```

## 服务

- `milvus-standalone-embed`: Milvus 单机版服务，内嵌 etcd。
- `attu`: Milvus 的网页版管理工具。

## 配置

- `MILVUS_VERSION`: Milvus 镜像的版本，默认为 `v2.6.7`。
- `ATTU_VERSION`: Attu 镜像的版本，默认为 `v2.6.4`。
- `MILVUS_PORT_OVERRIDE_HTTP`: Milvus HTTP 服务的主机端口，默认为 `19530`。
- `MILVUS_PORT_OVERRIDE_WEBUI`: Milvus Web UI 的主机端口，默认为 `9091`。
- `MILVUS_PORT_OVERRIDE_ETCD`: etcd 服务的主机端口，默认为 `2379`。
- `ATTU_OVERRIDE_PORT`: Attu 服务的主机端口，默认为 `8000`。
- `MILVUS_URL`: Milvus 服务的地址，供 Attu 连接，默认为 `milvus-standalone-embed:19530`。

## 卷

- `milvus_data`: 用于存储 Milvus 和内嵌 etcd 数据的卷。
- `embed_etcd.yaml`: 内嵌 etcd 的配置文件。
- `user.yaml`: Milvus 的用户配置文件。
