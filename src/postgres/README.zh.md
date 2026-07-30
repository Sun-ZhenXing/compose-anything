# Postgres

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署一个 PostgreSQL 数据库。

## 服务

- `postgres`: PostgreSQL 数据库服务。

## 配置

- `POSTGRES_VERSION`: PostgreSQL 镜像的版本，默认为 `18.4`。
- `POSTGRES_USER`: 数据库用户名，默认为 `postgres`。
- `POSTGRES_PASSWORD`: 数据库密码，默认为 `postgres`。
- `POSTGRES_DB`: 数据库名称，默认为 `postgres`。
- `POSTGRES_PORT_OVERRIDE`: PostgreSQL 的主机端口，默认为 `5432`。

## 卷

- `postgres_data`: 用于存储 PostgreSQL 数据的卷。
- `init.sql`: 可选的初始化脚本（挂载到 `/docker-entrypoint-initdb.d/init.sql`）。

## 升级警告

PostgreSQL 18 将数据存储在 `/var/lib/postgresql` 下。不能直接复用 PostgreSQL 18 之前的数据目录；替换现有部署前，请先备份，并使用 `pg_upgrade` 或转储与恢复方式迁移。
