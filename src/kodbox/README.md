# Kodbox

[English](./README.md) | [中文](./README.zh.md)

This service deploys Kodbox, a powerful web-based file manager and cloud storage platform with Windows-like user experience.

## Services

- `kodbox`: The main Kodbox application server.
- `kodbox-db`: MySQL database for Kodbox.
- `kodbox-redis`: Redis for caching and session management.

## Environment Variables

| Variable Name       | Description                                | Default Value      |
| ------------------- | ------------------------------------------ | ------------------ |
| KODBOX_VERSION      | Kodbox image version                       | `1.62`             |
| KODBOX_PORT         | Host port mapping for Kodbox web interface | `80`               |
| MYSQL_VERSION       | MySQL image version                        | `9.4.0`            |
| MYSQL_HOST          | MySQL host                                 | `kodbox-db`        |
| MYSQL_PORT          | MySQL port                                 | `3306`             |
| MYSQL_DATABASE      | MySQL database name                        | `kodbox`           |
| MYSQL_USER          | MySQL username                             | `kodbox`           |
| MYSQL_PASSWORD      | MySQL password                             | `kodbox123`        |
| MYSQL_ROOT_PASSWORD | MySQL root password                        | `root123`          |
| REDIS_VERSION       | Redis image version                        | `8.2.1-alpine3.22` |
| REDIS_HOST          | Redis host                                 | `kodbox-redis`     |
| REDIS_PORT          | Redis port                                 | `6379`             |
| REDIS_PASSWORD      | Redis password (leave empty for no auth)   | `""`               |

Please create a `.env` file and modify it as needed for your use case.

## Volumes

- `kodbox_data`: A volume for storing Kodbox application and user files.
- `kodbox_db_data`: A volume for storing MySQL data.
- `kodbox_redis_data`: A volume for storing Redis data.

## Getting Started

1. (Optional) Create a `.env` file to customize settings:

   ```env
   KODBOX_PORT=8080
   MYSQL_PASSWORD=your-secure-password
   MYSQL_ROOT_PASSWORD=your-secure-root-password
   ```

2. Start the services:

   ```bash
   docker compose up -d
   ```

3. Access Kodbox at `http://localhost` (or your configured port)

4. Follow the installation wizard on first access

## Initial Setup

On first access, the installation wizard will guide you through:

- Database configuration (automatically filled from environment variables)
- Admin account creation
- Basic settings configuration

**Note**: If you change database credentials in `.env`, make sure to update them during the installation wizard as well.

## Features

- **Windows-like Interface**: Familiar desktop experience in web browser
- **Multi-cloud Support**: Connect to local disk, FTP, WebDAV, and various cloud storage services
- **File Management**: Full-featured file operations with drag-and-drop support
- **Online Preview**: Preview 100+ file formats including Office, PDF, images, videos
- **Online Editing**: Built-in text editor with syntax highlighting for 120+ languages
- **Team Collaboration**: Fine-grained permission control and file sharing
- **Plugin System**: Extend functionality with plugins

## Documentation

For more information, visit the [official Kodbox documentation](https://doc.kodcloud.com/).

## Security Notes

- Change all default passwords in production
- Use HTTPS in production environments
- Regularly backup all data volumes
- Keep Kodbox, MySQL, and Redis updated to the latest stable versions
- Consider setting a Redis password in production environments
