# Odoo

[Odoo](https://www.odoo.com/) is a suite of open source business apps that cover all your company needs: CRM, eCommerce, accounting, inventory, point of sale, project management, etc.

## Features

- Modular: Choose from over 30,000 apps
- Integrated: All apps work seamlessly together
- Open Source: Free to use and customize
- Scalable: From small businesses to enterprises
- User-Friendly: Modern and intuitive interface

## Quick Start

Start Odoo with PostgreSQL:

```bash
docker compose up -d
```

## Configuration

### Environment Variables

- `ODOO_VERSION`: Odoo version (default: `19.0`)
- `ODOO_PORT_OVERRIDE`: HTTP port (default: `8069`)
- `POSTGRES_VERSION`: PostgreSQL version (default: `17-alpine`)
- `POSTGRES_USER`: Database user (default: `odoo`)
- `POSTGRES_PASSWORD`: Database password (default: `odoopass`)
- `POSTGRES_DB`: Database name (default: `postgres`)

## Access

- Web UI: <http://localhost:8069>

## First Time Setup

1. Navigate to <http://localhost:8069>
2. Create a new database:
   - Master password: (set a strong password)
   - Database name: (e.g., `mycompany`)
   - Email: Your admin email
   - Password: Your admin password
3. Choose apps to install
4. Start using Odoo!

## Custom Addons

Place custom addons in the `odoo_addons` volume. The directory structure should be:

```text
odoo_addons/
  ├── addon1/
  │   ├── __init__.py
  │   ├── __manifest__.py
  │   └── ...
  └── addon2/
      ├── __init__.py
      ├── __manifest__.py
      └── ...
```

## Database Management

### Create a New Database

1. Go to <http://localhost:8069/web/database/manager>
2. Click "Create Database"
3. Fill in the required information
4. Click "Create"

### Backup Database

1. Go to <http://localhost:8069/web/database/manager>
2. Select your database
3. Click "Backup"
4. Save the backup file

### Restore Database

1. Go to <http://localhost:8069/web/database/manager>
2. Click "Restore Database"
3. Upload your backup file
4. Click "Restore"

## Resources

- Resource Limits: 2 CPU, 2G RAM (Odoo), 1 CPU, 1G RAM (Database)
- Resource Reservations: 0.5 CPU, 1G RAM (Odoo), 0.25 CPU, 512M RAM (Database)

## Production Considerations

For production deployments:

1. Set a strong master password
2. Use HTTPS (configure reverse proxy)
3. Regular database backups
4. Monitor resource usage
5. Keep Odoo and addons updated
6. Configure email settings for notifications
7. Set up proper logging and monitoring
