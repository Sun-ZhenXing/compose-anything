# MySQL

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署一个 MySQL 数据库。

## 服务

- `mysql`: MySQL 数据库服务。

## 配置

- `MYSQL_VERSION`: MySQL 镜像的版本，默认为 `26.7.0`。
- `MYSQL_PORT_OVERRIDE`: MySQL 的主机端口，默认为 `3306`。
- `MYSQL_ROOT_PASSWORD`: root 密码，默认为 `password`。
- `MYSQL_ROOT_HOST`: root 主机，默认为 `%`。

### 版本线说明

`26.7` 是 MySQL 的 **Innovation** 版本，也是 MySQL 改用日历版本号（`YY.M`）后的首个版本。它是最新的 GA 版本；`9.7.x` 仍是最新的 **LTS**。从 `9.7.x` 就地升级到 `26.7.0` 受支持，但降级需要导出后重新导入，因此请先备份 `mysql_data`。如需继续使用 LTS 版本线，请设置 `MYSQL_VERSION=9.7.2`。

## 卷

- `mysql_data`: 用于存储 MySQL 数据的卷。
- `init.sql`: 可选的初始化脚本（挂载到 `/docker-entrypoint-initdb.d/init.sql`）。
