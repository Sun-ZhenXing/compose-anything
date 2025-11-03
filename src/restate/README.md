# Restate Single-Node Server

Restate is a distributed workflow engine for stateful services that provides durable execution, reliable messaging, and state management out of the box.

## Features

- **Durable Execution**: Automatically persist execution state and resume on failures
- **Reliable Messaging**: Built-in message delivery guarantees
- **State Management**: Strongly consistent state with minimal overhead
- **Service Discovery**: Automatic service registration and discovery
- **Admin API**: Rich API for monitoring and managing services

## Quick Start

1. Copy environment file:

   ```bash
   cp .env.example .env
   ```

2. Start the service:

   ```bash
   docker compose up -d
   ```

3. Verify the service is running:

   ```bash
   curl http://localhost:9070/health
   ```

## Service Endpoints

- **Ingress API**: `http://localhost:8080` - Main API for invoking services
- **Admin API**: `http://localhost:9070` - Management and monitoring API
- **Node Communication**: Port 5122 (internal)

## Environment Variables

| Variable                | Default        | Description                             |
| ----------------------- | -------------- | --------------------------------------- |
| `RESTATE_VERSION`       | `1.5.3`        | Restate server version                  |
| `INGRESS_PORT_OVERRIDE` | `8080`         | Ingress API port                        |
| `ADMIN_PORT_OVERRIDE`   | `9070`         | Admin API port                          |
| `NODE_PORT_OVERRIDE`    | `5122`         | Node-to-node communication port         |
| `RESTATE_LOG_FILTER`    | `restate=info` | Log level (trace/debug/info/warn/error) |
| `TZ`                    | `UTC`          | Timezone                                |

## Usage Examples

### Deploy a Service

```bash
# Register a service endpoint
curl -X POST http://localhost:9070/deployments \
  -H 'Content-Type: application/json' \
  -d '{"uri": "http://my-service:9080"}'
```

### List Deployed Services

```bash
curl http://localhost:9070/services
```

### Invoke a Service

```bash
curl -X POST http://localhost:8080/MyService/myMethod \
  -H 'Content-Type: application/json' \
  -d '{"key": "value"}'
```

## Data Persistence

Restate data is stored in the named volume `restate_data`. The server uses node name `restate-1` for data consistency across restarts.

To reset the server and start fresh:

```bash
docker compose down -v
```

## Resource Limits

- CPU: 0.5-2.0 cores
- Memory: 512MB-2GB

Adjust these limits in `docker-compose.yaml` based on your workload.

## Monitoring

Check server health:

```bash
curl http://localhost:9070/health
```

View server metrics (Prometheus format):

```bash
curl http://localhost:9070/metrics
```

## Documentation

- [Official Documentation](https://docs.restate.dev/)
- [Deployment Guide](https://docs.restate.dev/server/deploy/docker)
- [Configuration Reference](https://docs.restate.dev/references/server-config)
- [Architecture](https://docs.restate.dev/references/architecture)

## License

This configuration is provided under the project's license. Restate is licensed under the [Business Source License 1.1](https://github.com/restatedev/restate/blob/main/LICENSE).

## Notes

- For production deployments, consider using a [Restate cluster](../restate-cluster/) for high availability
- Ensure the data directory is on durable storage in production
- The `--node-name` flag ensures consistent data restoration across restarts
- For cluster deployments, see the [restate-cluster](../restate-cluster/) configuration
