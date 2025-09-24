# MySQL

[English](./README.md) | [中文](./README.zh.md)

This service deploys a MySQL database.

## Services

- `mysql`: The MySQL database service.

## Configuration

- `MYSQL_VERSION`: The version of the MySQL image, default is `9.4.0`.
- `MYSQL_PORT_OVERRIDE`: The host port for MySQL, default is `3306`.
- `MYSQL_ROOT_PASSWORD`: The root password, default is `password`.
- `MYSQL_ROOT_HOST`: The root host, default is `%`.

## Volumes

- `mysql_data`: A volume for storing MySQL data.
- `init.sql`: Optional initialization script (mount to `/docker-entrypoint-initdb.d/init.sql`).
