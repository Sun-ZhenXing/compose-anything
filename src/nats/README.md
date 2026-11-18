# NATS

[English](./README.md) | [中文](./README.zh.md)

This service deploys NATS Server with JetStream enabled, a lightweight and high-performance messaging system for publish/subscribe, request/reply, and persistent event streaming.

## Services

- `nats`: The NATS server (client port 4222, monitoring port 8222 internal)

## Quick Start

```bash
docker compose up -d
```

Check that the server is healthy:

```bash
docker compose ps
docker compose exec nats wget -qO- http://127.0.0.1:8222/healthz
```

## Usage

Use the [NATS CLI](https://github.com/nats-io/natscli) against the published client port:

```bash
# Subscribe in one terminal
nats --server nats://admin:password@localhost:4222 sub 'hello.>'

# Publish in another terminal
nats --server nats://admin:password@localhost:4222 pub hello.world 'Hello NATS'
```

JetStream streams and consumers are persisted in the `nats_data` volume.

## Environment Variables

| Variable Name              | Description                                   | Default Value        |
| -------------------------- | --------------------------------------------- | -------------------- |
| `GLOBAL_REGISTRY`          | Global registry prefix for all images         | `""`                 |
| `NATS_VERSION`             | NATS Server image version                     | `2.15.3-alpine3.22`  |
| `NATS_USER`                | Username for client authentication            | `admin`              |
| `NATS_PASSWORD`            | Password for client authentication            | `password`           |
| `NATS_PORT_OVERRIDE`       | Host port for client connections (maps to 4222) | `4222`             |
| `TZ`                       | Timezone                                      | `UTC`                |
| `NATS_CPU_LIMIT`           | CPU limit                                     | `1.0`                |
| `NATS_CPU_RESERVATION`     | CPU reservation                               | `0.1`                |
| `NATS_MEMORY_LIMIT`        | Memory limit                                  | `1G`                 |
| `NATS_MEMORY_RESERVATION`  | Memory reservation                            | `256M`               |

Please modify the `.env` file as needed for your use case.

## Ports

| Port   | Purpose                        | Exposed on host |
| ------ | ------------------------------ | --------------- |
| `4222` | Client connections             | Yes             |
| `8222` | HTTP monitoring and health     | No              |

The monitoring endpoint stays on the internal Compose network. Publish it only if you need metrics or dashboards from the host.

## Volumes

- `nats_data`: A named volume storing JetStream data under `/data`

## Security Notes

- The default credentials `admin` / `password` are for local evaluation only. Change `NATS_USER` and `NATS_PASSWORD` before exposing the port beyond localhost.
- The monitoring endpoint on port 8222 is not authenticated and is intentionally not published.
- The official NATS image runs as root. This stack drops all Linux capabilities and uses a read-only root filesystem to reduce risk. For stricter isolation, add an init step that gives the data volume to a fixed UID and run the service with `user: "1000:1000"`.
- Terminate TLS at a reverse proxy or configure NATS TLS before exposing client traffic to untrusted networks.

## License

NATS Server is open source and licensed under the [Apache License 2.0](https://github.com/nats-io/nats-server/blob/main/LICENSE).