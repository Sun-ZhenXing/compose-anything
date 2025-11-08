# Kong Gateway

[English](./README.md) | [中文](./README.zh.md)

This service deploys Kong Gateway, a cloud-native API gateway and service mesh, with PostgreSQL database and optional Konga GUI.

## Services

- `kong-db`: PostgreSQL database for Kong
- `kong-migrations`: Database migration service (runs once)
- `kong`: Kong Gateway service
- `kong-gui`: Konga GUI for Kong management (profile: `gui`)

## Quick Start

```bash
docker compose up -d
```

To enable Konga GUI:

```bash
docker compose --profile gui up -d
```

## Environment Variables

| Variable Name                  | Description                                          | Default Value           |
| ------------------------------ | ---------------------------------------------------- | ----------------------- |
| `GLOBAL_REGISTRY`              | Global registry prefix for all images                | `""`                    |
| `KONG_VERSION`                 | Kong image version                                   | `3.8.0-alpine`          |
| `KONGA_VERSION`                | Konga GUI image version                              | `latest`                |
| `POSTGRES_VERSION`             | PostgreSQL image version                             | `16.6-alpine3.21`       |
| `KONG_DB_PASSWORD`             | PostgreSQL password for Kong database                | `kongpass`              |
| `KONG_PROXY_PORT_OVERRIDE`     | Host port for Kong proxy (maps to port 8000)         | `8000`                  |
| `KONG_PROXY_SSL_PORT_OVERRIDE` | Host port for Kong proxy SSL (maps to port 8443)     | `8443`                  |
| `KONG_ADMIN_API_PORT_OVERRIDE` | Host port for Kong Admin API (maps to port 8001)     | `8001`                  |
| `KONG_ADMIN_SSL_PORT_OVERRIDE` | Host port for Kong Admin API SSL (maps to port 8444) | `8444`                  |
| `KONG_GUI_PORT_OVERRIDE`       | Host port for Konga GUI (maps to port 1337)          | `1337`                  |
| `KONG_ADMIN_LISTEN`            | Kong Admin API listen address                        | `0.0.0.0:8001`          |
| `KONG_ADMIN_GUI_URL`           | Kong Admin GUI URL                                   | `http://localhost:8002` |
| `TZ`                           | Timezone                                             | `UTC`                   |

Please modify the `.env` file as needed for your use case.

## Volumes

- `kong_db_data`: PostgreSQL data for Kong
- `konga_data`: Konga application data (if using GUI profile)

## Ports

- `8000`: Kong proxy (HTTP)
- `8443`: Kong proxy (HTTPS)
- `8001`: Kong Admin API (HTTP)
- `8444`: Kong Admin API (HTTPS)
- `1337`: Konga GUI (optional, with `gui` profile)

## Access Points

- Kong Proxy: <http://localhost:8000>
- Kong Admin API: <http://localhost:8001>
- Konga GUI: <http://localhost:1337> (if enabled)

## Basic Usage

### Add a Service

```bash
curl -i -X POST http://localhost:8001/services \
  --data name=example-service \
  --data url='http://example.com'
```

### Add a Route

```bash
curl -i -X POST http://localhost:8001/services/example-service/routes \
  --data 'paths[]=/example'
```

### Test the Route

```bash
curl -i http://localhost:8000/example
```

## Custom Configuration

To use a custom Kong configuration file, uncomment the volume mount in `docker-compose.yaml`:

```yaml
volumes:
  - ./kong.conf:/etc/kong/kong.conf:ro
```

## Security Notes

- Change the default database password in production
- Enable authentication for Kong Admin API in production
- Use SSL/TLS for all communications in production
- Regularly update Kong and its plugins for security patches
- Consider using Kong's RBAC and authentication plugins

## License

Kong Gateway is licensed under Apache License 2.0. See [Kong GitHub](https://github.com/Kong/kong) for more information.
