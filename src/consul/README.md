# Consul

[Consul](https://www.consul.io/) is a service networking solution to automate network configurations, discover services, and enable secure connectivity across any cloud or runtime.

## Features

- Service Discovery: Automatically discover and register services
- Health Checking: Monitor service health and availability
- Key/Value Store: Store configuration data
- Multi-Datacenter: Support for multiple datacenters
- Service Mesh: Secure service-to-service communication

## Quick Start

Start Consul server:

```bash
docker compose up -d
```

## Configuration

### Environment Variables

- `CONSUL_VERSION`: Consul version (default: `1.20.3`)
- `CONSUL_HTTP_PORT_OVERRIDE`: HTTP API port (default: `8500`)
- `CONSUL_DNS_PORT_OVERRIDE`: DNS query port (default: `8600`)
- `CONSUL_SERF_LAN_PORT_OVERRIDE`: Serf LAN port (default: `8301`)
- `CONSUL_SERF_WAN_PORT_OVERRIDE`: Serf WAN port (default: `8302`)
- `CONSUL_SERVER_RPC_PORT_OVERRIDE`: Server RPC port (default: `8300`)
- `CONSUL_BIND_INTERFACE`: Network interface to bind (default: `eth0`)
- `CONSUL_CLIENT_INTERFACE`: Client network interface (default: `eth0`)

## Access

- Web UI: <http://localhost:8500>
- HTTP API: <http://localhost:8500/v1>
- DNS Query: localhost:8600

## Default Configuration

The default configuration runs Consul in server mode with:

- Single node (bootstrap mode)
- Web UI enabled
- Log level: INFO
- Datacenter: dc1

## Custom Configuration

Uncomment the configuration volume in `docker-compose.yaml` and create `consul.json`:

```json
{
  "datacenter": "dc1",
  "server": true,
  "ui_config": {
    "enabled": true
  },
  "bootstrap_expect": 1,
  "log_level": "INFO"
}
```

## Health Check

Check Consul cluster members:

```bash
docker compose exec consul consul members
```

## Resources

- Resource Limits: 1 CPU, 512MB RAM
- Resource Reservations: 0.25 CPU, 128MB RAM
