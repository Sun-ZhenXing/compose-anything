# RustFS

[English](./README.md) | [中文](./README.zh.md)

RustFS 是一个高性能、S3 兼容的分布式对象存储系统，使用 Rust 构建。对 4KB 对象负载，它比 MinIO 快 2.3 倍，完全开源（Apache 2.0 许可），并支持与其他 S3 兼容平台（如 MinIO 和 Ceph）的迁移与共存。

打开控制台：<http://localhost:9001>。

## 服务

- `rustfs`：RustFS 对象存储服务。

## 快速开始

```bash
docker compose up -d
```

默认凭据为 `rustfsadmin` / `rustfsadmin`。S3 API 地址为 <http://localhost:9000>，控制台地址为 <http://localhost:9001>。

## 配置

- `RUSTFS_VERSION`：RustFS 镜像版本（基于 glibc），默认为 `1.0.0-beta.8-glibc`。
- `RUSTFS_PORT_OVERRIDE_API`：S3 API 的主机端口，默认为 `9000`。
- `RUSTFS_PORT_OVERRIDE_CONSOLE`：控制台 Web UI 的主机端口，默认为 `9001`。
- `RUSTFS_ACCESS_KEY`：根访问密钥，默认为 `rustfsadmin`。
- `RUSTFS_SECRET_KEY`：根秘密密钥，默认为 `rustfsadmin`。
- `RUSTFS_ADDRESS`：S3 API 监听地址，默认为 `0.0.0.0:9000`。
- `RUSTFS_CONSOLE_ADDRESS`：控制台监听地址，默认为 `0.0.0.0:9001`。
- `RUSTFS_CONSOLE_ENABLE`：是否启用 Web 控制台，默认为 `true`。
- `RUSTFS_CONSOLE_CORS_ALLOWED_ORIGINS`：控制台 CORS 允许的来源，默认为 `*`。
- `RUSTFS_OBS_LOGGER_LEVEL`：日志级别（`info`、`debug`、`warn`、`error`），默认为 `info`。
- `RUSTFS_UNSAFE_BYPASS_DISK_CHECK`：跳过严格的磁盘拓扑检查（仅用于本地开发），默认为 `false`。
- `TZ`：时区设置，默认为 `UTC`。

## 存储卷

- `rustfs_data`：用于存储 RustFS 对象数据的命名卷。

## 安全说明

- 容器以非 root 用户（`10001:10001`）运行。如果改用主机绑定挂载，请确保挂载目录对该用户可写。
- 默认凭据为 `rustfsadmin` / `rustfsadmin`，请在生产环境中更换。
- 默认启用 `no-new-privileges:true`。
