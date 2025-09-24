# Gitea

[English](./README.md) | [中文](./README.zh.md)

This service sets up a Gitea service.

## Services

- `server`: The Gitea application service.
- `db`: The PostgreSQL database service.

## Initial Setup

On the initial setup page, you need to fill in the database information:

- Database Type: `PostgreSQL`
- Host: `db:5432`
- User: `gitea`
- Password: `gitea` (default)
- Database Name: `gitea`

The first registered user will have administrator privileges.

## Configuration

You can configure the basic information of Gitea through the `./config/app.ini` file. For example, you can disable the registration function with the following configuration:

```ini
[service]
DISABLE_REGISTRATION = true
```

### Environment Variables

- `POSTGRES_USER`: The username for the PostgreSQL database, default is `gitea`.
- `POSTGRES_PASSWORD`: The password for the PostgreSQL database, default is `gitea`.
- `POSTGRES_DB`: The name of the PostgreSQL database, default is `gitea`.

## Volumes

- `data`: A volume for storing Gitea data.
- `config`: A volume for storing Gitea configuration.
- `postgres`: A volume for storing PostgreSQL data.
