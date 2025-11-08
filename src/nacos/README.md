# Nacos

[English](./README.md) | [中文](./README.zh.md)

This service deploys Nacos, a dynamic service discovery, configuration management, and service management platform.

## Services

- `nacos`: Nacos server in standalone mode

## Quick Start

```bash
docker compose up -d
```

## Environment Variables

| Variable Name                | Description                              | Default Value                                                           |
| ---------------------------- | ---------------------------------------- | ----------------------------------------------------------------------- |
| `GLOBAL_REGISTRY`            | Global registry prefix for all images    | `""`                                                                    |
| `NACOS_VERSION`              | Nacos image version                      | `v3.1.0-slim`                                                           |
| `NACOS_HTTP_PORT_OVERRIDE`   | Host port for HTTP (maps to port 8848)   | `8848`                                                                  |
| `NACOS_GRPC_PORT_OVERRIDE`   | Host port for gRPC (maps to port 9848)   | `9848`                                                                  |
| `NACOS_GRPC_PORT2_OVERRIDE`  | Host port for gRPC 2 (maps to port 9849) | `9849`                                                                  |
| `NACOS_MODE`                 | Nacos mode (standalone/cluster)          | `standalone`                                                            |
| `NACOS_AUTH_ENABLE`          | Enable authentication                    | `true`                                                                  |
| `NACOS_AUTH_TOKEN`           | Authentication token (32+ chars)         | `SecretKey012345678901234567890123456789012345678901234567890123456789` |
| `NACOS_AUTH_IDENTITY_KEY`    | Identity key for authentication          | `serverIdentity`                                                        |
| `NACOS_AUTH_IDENTITY_VALUE`  | Identity value for authentication        | `security`                                                              |
| `SPRING_DATASOURCE_PLATFORM` | Database platform (empty for embedded)   | `""`                                                                    |
| `JVM_XMS`                    | JVM initial heap size                    | `512m`                                                                  |
| `JVM_XMX`                    | JVM maximum heap size                    | `512m`                                                                  |
| `JVM_XMN`                    | JVM young generation heap size           | `256m`                                                                  |
| `TZ`                         | Timezone                                 | `UTC`                                                                   |

Please modify the `.env` file as needed for your use case.

## Volumes

- `nacos_logs`: Nacos log directory

## Ports

- `8848`: Nacos HTTP API and Console
- `9848`: Nacos gRPC port (for client-server communication)
- `9849`: Nacos gRPC port 2 (for server-server communication in cluster mode)

## Access Points

- Nacos Console: <http://localhost:8848/nacos>
- Default credentials: `nacos` / `nacos`

## Basic Usage

### Register a Service

```bash
curl -X POST 'http://localhost:8848/nacos/v1/ns/instance' \
  -d 'serviceName=example-service&ip=127.0.0.1&port=8080'
```

### Discover Services

```bash
curl 'http://localhost:8848/nacos/v1/ns/instance/list?serviceName=example-service'
```

### Publish Configuration

```bash
curl -X POST 'http://localhost:8848/nacos/v1/cs/configs' \
  -d 'dataId=example.properties&group=DEFAULT_GROUP&content=key=value'
```

### Get Configuration

```bash
curl 'http://localhost:8848/nacos/v1/cs/configs?dataId=example.properties&group=DEFAULT_GROUP'
```

## External Database (Optional)

For production use with external MySQL database, set these environment variables:

```env
SPRING_DATASOURCE_PLATFORM=mysql
MYSQL_SERVICE_HOST=mysql-host
MYSQL_SERVICE_PORT=3306
MYSQL_SERVICE_DB_NAME=nacos
MYSQL_SERVICE_USER=nacos
MYSQL_SERVICE_PASSWORD=nacos
```

## Security Notes

- Change default credentials immediately after first login
- Use strong authentication token (32+ characters)
- For production, use external MySQL database instead of embedded Derby
- Enable HTTPS for production deployments
- Regularly update Nacos version for security patches

## License

Nacos is licensed under Apache License 2.0. See [Nacos GitHub](https://github.com/alibaba/nacos) for more information.
