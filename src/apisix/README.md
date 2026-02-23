# Apache APISIX

[English](./README.md) | [中文](./README.zh.md)

This service deploys Apache APISIX, a dynamic, real-time, high-performance cloud-native API gateway.

## Services

- `apisix`: The APISIX API gateway.
- `etcd`: The configuration storage backend for APISIX.
- `apisix-dashboard` (optional): Web UI for managing APISIX configuration.

## Environment Variables

| Variable Name                  | Description                                          | Default Value   |
| ------------------------------ | ---------------------------------------------------- | --------------- |
| APISIX_VERSION                 | APISIX image version                                 | `3.13.0-debian` |
| APISIX_HTTP_PORT_OVERRIDE      | Host port mapping for HTTP traffic (9080)            | `9080`          |
| APISIX_HTTPS_PORT_OVERRIDE     | Host port mapping for HTTPS traffic (9443)           | `9443`          |
| APISIX_ADMIN_PORT_OVERRIDE     | Host port mapping for Admin API (9180)               | `9180`          |
| APISIX_STAND_ALONE             | Run APISIX in standalone mode (without etcd)         | `false`         |
| ETCD_VERSION                   | etcd image version                                   | `v3.6.0`        |
| ETCD_CLIENT_PORT_OVERRIDE      | Host port mapping for etcd client connections (2379) | `2379`          |
| APISIX_DASHBOARD_VERSION       | APISIX Dashboard image version                       | `3.0.1-alpine`  |
| APISIX_DASHBOARD_PORT_OVERRIDE | Host port mapping for Dashboard (9000)               | `9000`          |
| APISIX_DASHBOARD_USER          | Dashboard admin username                             | `admin`         |
| APISIX_DASHBOARD_PASSWORD      | Dashboard admin password                             | `admin`         |

Please modify the `.env` file as needed for your use case.

## Volumes

- `apisix_logs`: A volume for storing APISIX logs.
- `etcd_data`: A volume for storing etcd configuration data.
- `dashboard_conf`: A volume for storing Dashboard configuration.
- `config.yaml`: Optional custom APISIX configuration file (mount to `/usr/local/apisix/conf/config.yaml`).
- `apisix.yaml`: Optional custom APISIX route configuration file (mount to `/usr/local/apisix/conf/apisix.yaml`).

## Network Ports

- `9080`: HTTP traffic port
- `9443`: HTTPS traffic port
- `9180`: Admin API port
- `9000`: Dashboard web interface (optional)
- `2379`: etcd client port

## Usage

### Basic Setup

1. Start the services:

   ```bash
   docker compose up -d
   ```

2. Access the Admin API:

   ```bash
   curl http://localhost:9180/apisix/admin/routes
   ```

### With Dashboard

To enable the web dashboard, use the `dashboard` profile:

```bash
docker compose --profile dashboard up -d
```

Access the dashboard at `http://localhost:9000` with credentials:

- Username: `admin` (configurable via `APISIX_DASHBOARD_USER`)
- Password: `admin` (configurable via `APISIX_DASHBOARD_PASSWORD`)

### Creating Routes

#### Using Admin API

Create a simple route:

```bash
curl -X PUT http://localhost:9180/apisix/admin/routes/1 \
  -H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' \
  -H 'Content-Type: application/json' \
  -d '{
    "uri": "/get",
    "upstream": {
      "type": "roundrobin",
      "nodes": {
        "httpbin.org:80": 1
      }
    }
  }'
```

Test the route:

```bash
curl http://localhost:9080/get
```

#### Using Dashboard

1. Access the dashboard at `http://localhost:9000`
2. Login with admin credentials
3. Navigate to "Route" section
4. Create and configure routes through the web interface

### Configuration Files

#### Custom APISIX Configuration

Mount a custom `config.yaml` file:

```yaml
volumes:
  - ./config.yaml:/usr/local/apisix/conf/config.yaml
```

Example `config.yaml`:

```yaml
apisix:
  node_listen: 9080
  enable_ipv6: false
  enable_admin: true
  port_admin: 9180

etcd:
  host:
    - 'http://etcd:2379'
  prefix: /apisix
  timeout: 30

plugin_attr:
  prometheus:
    export_addr:
      ip: 0.0.0.0
      port: 9091
```

#### Standalone Mode

For simple setups without etcd, enable standalone mode:

```env
APISIX_STAND_ALONE=true
```

Mount an `apisix.yaml` file with route definitions:

```yaml
volumes:
  - ./apisix.yaml:/usr/local/apisix/conf/apisix.yaml
```

### SSL/TLS Configuration

To enable HTTPS:

1. Mount SSL certificates
2. Configure SSL in `config.yaml`
3. Create SSL-enabled routes

Example SSL volume mount:

```yaml
volumes:
  - ./ssl:/usr/local/apisix/conf/cert
```

### Plugins

APISIX supports numerous plugins for authentication, rate limiting, logging, etc.:

- Authentication: `jwt-auth`, `key-auth`, `oauth`
- Rate Limiting: `limit-req`, `limit-conn`, `limit-count`
- Observability: `prometheus`, `zipkin`, `skywalking`
- Security: `cors`, `csrf`, `ip-restriction`

Enable plugins through the Admin API or Dashboard.

## Security Notes

- **Change the default Admin API key** (`edd1c9f034335f136f87ad84b625c8f1`) in production
- **Change dashboard credentials** for production use
- Configure proper SSL/TLS certificates for HTTPS
- Use authentication plugins for sensitive routes
- Implement rate limiting to prevent abuse
- Regular security updates are recommended

## Monitoring

APISIX provides built-in metrics for Prometheus:

- Enable the `prometheus` plugin
- Metrics available at `http://localhost:9091/apisix/prometheus/metrics`

## Performance Tuning

- Adjust worker processes based on CPU cores
- Configure appropriate buffer sizes
- Use connection pooling for upstream services
- Enable response caching when appropriate

## License

Apache APISIX is licensed under the Apache 2.0 license.
