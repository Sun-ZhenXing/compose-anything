# Grafana

[English](./README.md) | [中文](./README.zh.md)

This service deploys Grafana, an open-source analytics and monitoring platform for visualizing metrics from various data sources.

## Services

- `grafana`: The Grafana web interface and API server.

## Environment Variables

| Variable Name          | Description                                                | Default Value           |
| ---------------------- | ---------------------------------------------------------- | ----------------------- |
| GRAFANA_VERSION        | Grafana image version                                      | `12.1.1`                |
| GRAFANA_PORT_OVERRIDE  | Host port mapping (maps to Grafana port 3000 in container) | `3000`                  |
| GRAFANA_ADMIN_USER     | Admin username                                             | `admin`                 |
| GRAFANA_ADMIN_PASSWORD | Admin password                                             | `admin`                 |
| GRAFANA_ALLOW_SIGN_UP  | Allow users to sign up themselves                          | `false`                 |
| GRAFANA_PLUGINS        | Comma-separated list of plugins to install                 | `""`                    |
| GRAFANA_ROOT_URL       | Root URL for Grafana (used for links and redirects)        | `http://localhost:3000` |
| GRAFANA_SECRET_KEY     | Secret key for signing cookies and encrypting database     | `""`                    |

Please modify the `.env` file as needed for your use case.

## Volumes

- `grafana_data`: A volume for storing Grafana's database and configuration.
- `grafana_logs`: A volume for storing Grafana logs.
- `grafana.ini`: Optional custom configuration file (mount to `/etc/grafana/grafana.ini`).
- `provisioning`: Optional directory for provisioning datasources and dashboards (mount to `/etc/grafana/provisioning`).

## Default Credentials

- Username: `admin` (configurable via `GRAFANA_ADMIN_USER`)
- Password: `admin` (configurable via `GRAFANA_ADMIN_PASSWORD`)

## Security Notes

- **Change the default admin password** in production environments.
- Set a strong `GRAFANA_SECRET_KEY` for production use.
- Consider disabling sign-up (`GRAFANA_ALLOW_SIGN_UP=false`) in production.
- Use HTTPS in production by configuring a reverse proxy or Grafana's TLS settings.

## Common Use Cases

### Installing Plugins

Set the `GRAFANA_PLUGINS` environment variable with a comma-separated list of plugin IDs:

```env
GRAFANA_PLUGINS=grafana-clock-panel,grafana-simple-json-datasource
```

### Custom Configuration

Mount a custom `grafana.ini` file to `/etc/grafana/grafana.ini`:

```yaml
volumes:
  - ./grafana.ini:/etc/grafana/grafana.ini
```

### Provisioning Datasources and Dashboards

Mount a provisioning directory with datasource and dashboard configurations:

```yaml
volumes:
  - ./provisioning:/etc/grafana/provisioning
```

## License

Grafana is licensed under the AGPL v3.0 license. Commercial licenses are available from Grafana Labs.
