# Memos

[English](./README.md) | [中文](./README.zh.md)

This service deploys Memos, a privacy-first, lightweight note-taking service. Easily capture and share your great thoughts.

## Services

- `memos`: The Memos note-taking service.

## Configuration

- `MEMOS_VERSION`: The version of the Memos image, default is `0.25.3`.
- `MEMOS_PORT_OVERRIDE`: The host port for Memos, default is `5230`.
- `MEMOS_MODE`: Server mode (`dev`, `prod`, or `demo`), default is `prod`.
- `MEMOS_ADDR`: Server address, default is `0.0.0.0`.
- `MEMOS_PORT`: Server port inside the container, default is `5230`.
- `MEMOS_DATA`: Data directory path inside the container, default is `/var/opt/memos`.
- `MEMOS_DRIVER`: Database driver (`sqlite`, `postgres`, or `mysql`), default is `sqlite`.
- `MEMOS_DSN`: Database connection string (required for PostgreSQL or MySQL).
- `MEMOS_INSTANCE_URL`: Public URL of your Memos instance (optional).

## Volumes

- `memos_data`: A volume for storing Memos data.

## Usage

### Quick Start with SQLite (Default)

1. Start the service:

    ```bash
    docker compose up -d
    ```

2. Access Memos at `http://localhost:5230`.

### Using PostgreSQL or MySQL

To use PostgreSQL or MySQL instead of SQLite:

1. Edit `.env` file and set:

    ```env
    MEMOS_DRIVER=postgres  # or mysql
    MEMOS_DSN=postgres://user:password@host:port/dbname?sslmode=disable
    ```

2. Start the service:

    ```bash
    docker compose up -d
    ```

## First-Time Setup

After starting Memos for the first time:

1. Open `http://localhost:5230` in your browser.
2. Create your admin account.
3. Start taking notes!

## Data Persistence

All data is stored in the `memos_data` volume, which persists across container restarts and upgrades.

## Updates

To update Memos:

1. Edit `.env` and change `MEMOS_VERSION` to the desired version.
2. Restart the service:

```bash
docker compose down
docker compose pull
docker compose up -d
```

## Official Documentation

- [Memos Official Website](https://usememos.com/)
- [Memos Documentation](https://usememos.com/docs)
- [Memos GitHub Repository](https://github.com/usememos/memos)

## License

Memos is licensed under the [MIT License](https://github.com/usememos/memos/blob/main/LICENSE).
