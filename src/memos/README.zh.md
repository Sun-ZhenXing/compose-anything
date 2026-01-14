# Memos

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署 Memos，一个隐私优先的轻量级笔记服务。轻松捕捉和分享你的灵感。

## 服务

- `memos`: Memos 笔记服务。

## 配置

- `MEMOS_VERSION`: Memos 镜像的版本，默认为 `0.25.3`。
- `MEMOS_PORT_OVERRIDE`: Memos 的主机端口，默认为 `5230`。
- `MEMOS_MODE`: 服务器模式（`dev`、`prod` 或 `demo`），默认为 `prod`。
- `MEMOS_ADDR`: 服务器地址，默认为 `0.0.0.0`。
- `MEMOS_PORT`: 容器内的服务器端口，默认为 `5230`。
- `MEMOS_DATA`: 容器内的数据目录路径，默认为 `/var/opt/memos`。
- `MEMOS_DRIVER`: 数据库驱动（`sqlite`、`postgres` 或 `mysql`），默认为 `sqlite`。
- `MEMOS_DSN`: 数据库连接字符串（使用 PostgreSQL 或 MySQL 时必需）。
- `MEMOS_INSTANCE_URL`: Memos 实例的公网 URL（可选）。

## 卷

- `memos_data`: 用于存储 Memos 数据的卷。

## 使用

### 快速开始（使用默认 SQLite）

1. 启动服务：

    ```bash
    docker compose up -d
    ```

2. 在浏览器中访问 `http://localhost:5230`。

### 使用 PostgreSQL 或 MySQL

如果要使用 PostgreSQL 或 MySQL 替代 SQLite：

1. 编辑 `.env` 文件并设置：

    ```env
    MEMOS_DRIVER=postgres  # 或 mysql
    MEMOS_DSN=postgres://user:password@host:port/dbname?sslmode=disable
    ```

2. 启动服务：

    ```bash
    docker compose up -d
    ```

## 首次设置

首次启动 Memos 后：

1. 在浏览器中打开 `http://localhost:5230`。
2. 创建你的管理员账户。
3. 开始记笔记！

## 数据持久化

所有数据都存储在 `memos_data` 卷中，在容器重启和升级时会保留。

## 更新

更新 Memos：

1. 编辑 `.env` 文件，将 `MEMOS_VERSION` 改为所需版本。
2. 重启服务：

```bash
docker compose down
docker compose pull
docker compose up -d
```

## 官方文档

- [Memos 官方网站](https://usememos.com/)
- [Memos 文档](https://usememos.com/docs)
- [Memos GitHub 仓库](https://github.com/usememos/memos)

## 许可证

Memos 采用 [MIT License](https://github.com/usememos/memos/blob/main/LICENSE) 许可。
