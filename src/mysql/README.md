# MySQL

[English](./README.md) | [中文](./README.zh.md)

This service deploys a MySQL database.

## Services

- `mysql`: The MySQL database service.

## Configuration

- `MYSQL_VERSION`: The version of the MySQL image, default is `26.7.0`.
- `MYSQL_PORT_OVERRIDE`: The host port for MySQL, default is `3306`.
- `MYSQL_ROOT_PASSWORD`: The root password, default is `password`.
- `MYSQL_ROOT_HOST`: The root host, default is `%`.

### Version line

`26.7` is a MySQL **Innovation** release and the first to use MySQL's calendar versioning (`YY.M`). It is the newest GA release; `9.7.x` remains the newest **LTS**. An in-place upgrade from `9.7.x` to `26.7.0` is supported, but downgrading requires a dump and reload, so back up `mysql_data` first. To stay on the LTS line instead, set `MYSQL_VERSION=9.7.2`.

## Volumes

- `mysql_data`: A volume for storing MySQL data.
- `init.sql`: Optional initialization script (mount to `/docker-entrypoint-initdb.d/init.sql`).
