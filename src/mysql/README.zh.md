# MySQL

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署一个 MySQL 数据库。

## 服务

- `mysql`: MySQL 数据库服务。

## 配置

- `MYSQL_VERSION`: MySQL 镜像的版本，默认为 `9.4.0`。
- `MYSQL_PORT_OVERRIDE`: MySQL 的主机端口，默认为 `3306`。
- `MYSQL_ROOT_PASSWORD`: root 密码，默认为 `password`。
- `MYSQL_ROOT_HOST`: root 主机，默认为 `%`。

## 卷

- `mysql_data`: 用于存储 MySQL 数据的卷。
- `init.sql`: 可选的初始化脚本（挂载到 `/docker-entrypoint-initdb.d/init.sql`）。
