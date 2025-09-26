# Postgres

[English](./README.md) | [中文](./README.zh.md)

This service deploys a PostgreSQL database.

## Services

- `postgres`: The PostgreSQL database service.

## Configuration

- `POSTGRES_VERSION`: The version of the PostgreSQL image, default is `17.6`.
- `POSTGRES_USER`: The database username, default is `postgres`.
- `POSTGRES_PASSWORD`: The database password, default is `postgres`.
- `POSTGRES_DB`: The database name, default is `postgres`.
- `POSTGRES_PORT_OVERRIDE`: The host port for PostgreSQL, default is `5432`.

## Volumes

- `postgres_data`: A volume for storing PostgreSQL data.
- `init.sql`: Optional initialization script (mount to `/docker-entrypoint-initdb.d/init.sql`).
