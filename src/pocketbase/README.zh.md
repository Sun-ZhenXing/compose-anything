# PocketBase

[English](./README.md) | [中文](./README.zh.md)

PocketBase 是一个开源后端，包含实时数据库、认证、文件存储等功能。可作为独立应用运行，也可嵌入到 Go 项目中。

## 服务

- `pocketbase`: PocketBase 服务。

## 配置

- `PB_VERSION`: PocketBase 镜像的版本，默认为 `0.30.0`。
- `PB_PORT`: PocketBase 的主机端口，默认为 `8090`。
- `PB_ADMIN_EMAIL`: 管理员邮箱，默认为 `admin@example.com`。
- `PB_ADMIN_PASSWORD`: 管理员密码，默认为 `supersecret123`。
- `PB_ENCRYPTION`: 可选加密密钥（32位字符）。

## 卷

- `pb_data`: 用于存储 PocketBase 数据的卷。
- `pb_public`: 可选的公开文件夹。
- `pb_hooks`: 可选的钩子文件夹。
