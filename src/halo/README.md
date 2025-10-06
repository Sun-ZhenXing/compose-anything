# Halo

[English](./README.md) | [中文](./README.zh.md)

This service deploys Halo, a powerful and easy-to-use open-source blogging and content management system.

## Services

- `halo`: The main Halo application server.
- `halo-db`: PostgreSQL database for Halo.

## Environment Variables

| Variable Name            | Description                                                    | Default Value           |
| ------------------------ | -------------------------------------------------------------- | ----------------------- |
| HALO_VERSION             | Halo image version                                             | `2.21.9`                |
| HALO_PORT                | Host port mapping for Halo web interface                       | `8090`                  |
| POSTGRES_VERSION         | PostgreSQL image version                                       | `17.2-alpine3.21`       |
| POSTGRES_USER            | PostgreSQL username                                            | `postgres`              |
| POSTGRES_PASSWORD        | PostgreSQL password (required)                                 | `postgres`              |
| POSTGRES_DB              | PostgreSQL database name                                       | `halo`                  |
| SPRING_R2DBC_URL         | R2DBC connection URL                                           | (auto-configured)       |
| SPRING_SQL_INIT_PLATFORM | SQL platform type                                              | `postgresql`            |
| HALO_EXTERNAL_URL        | External URL for Halo                                          | `http://localhost:8090` |
| HALO_ADMIN_USERNAME      | Initial admin username                                         | `admin`                 |
| HALO_ADMIN_PASSWORD      | Initial admin password (leave empty to set during first login) | `""`                    |

Please create a `.env` file and modify it as needed for your use case.

## Volumes

- `halo_data`: A volume for storing Halo application data.
- `halo_db_data`: A volume for storing PostgreSQL data.

## Getting Started

1. (Optional) Create a `.env` file to customize settings:

   ```env
   POSTGRES_PASSWORD=your-secure-password
   HALO_EXTERNAL_URL=https://yourdomain.com
   ```

2. Start the services:

   ```bash
   docker compose up -d
   ```

3. Access Halo at `http://localhost:8090`

4. Follow the setup wizard to create your admin account (if `HALO_ADMIN_PASSWORD` is not set)

## Initial Setup

On first access, you'll be guided through the initial setup:

- Set your admin account credentials (if not configured via environment)
- Configure site information
- Choose and install a theme from the marketplace

## Documentation

For more information, visit the [official Halo documentation](https://docs.halo.run).

## Theme and Plugin Marketplace

Visit the [Halo Application Store](https://www.halo.run/store/apps) to browse themes and plugins.

## Security Notes

- Change default database password in production
- Use HTTPS in production environments
- Set a strong admin password
- Regularly backup both data volumes
- Keep Halo and PostgreSQL updated to the latest stable versions
