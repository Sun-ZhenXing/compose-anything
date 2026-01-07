# Podman (容器内 Podman)

[English](./README.md) | [中文](./README.zh.md)

此服务提供一个运行在容器内的 Podman 环境（Podman-in-Container）。它允许你在不直接在主机上安装 Podman 的情况下，使用 Podman 运行和管理 OCI 容器。

## 快速开始

1. （可选）在 `.env` 中自定义配置。
2. 启动服务：

   ```bash
   docker compose up -d
   ```

3. 你可以使用端口 `8888` 上的 Podman API，或者直接执行命令：

   ```bash
   docker compose exec podman podman info
   ```

## 服务

- `podman`：Podman 引擎服务。

## 配置

| 环境变量               | 描述                  | 默认值   |
| ---------------------- | --------------------- | -------- |
| `PODMAN_VERSION`       | Podman 镜像版本       | `v5.7.1` |
| `PODMAN_PORT_OVERRIDE` | Podman API 的主机端口 | `8888`   |
| `TZ`                   | 容器的时区            | `UTC`    |
| `PODMAN_CPU_LIMIT`     | 最大 CPU 限制         | `2.0`    |
| `PODMAN_MEMORY_LIMIT`  | 最大内存限制          | `4G`     |

## 安全说明

此容器需要 `privileged: true` 才能正常运行，因为它需要管理容器命名空间和挂载。请仅在受信任的环境中使用。
