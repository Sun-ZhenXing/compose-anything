# NebulaGraph

[English](./README.md) | [中文](./README.zh.md)

This service deploys NebulaGraph, a distributed, fast open-source graph database.

## Services

- `metad`: Meta service for cluster management
- `storaged`: Storage service for data persistence
- `graphd`: Query service for client connections

## Environment Variables

| Variable Name               | Description          | Default Value |
| --------------------------- | -------------------- | ------------- |
| NEBULA_VERSION              | NebulaGraph version  | `v3.8.0`      |
| NEBULA_GRAPHD_PORT_OVERRIDE | GraphD port override | `9669`        |

## Volumes

- `nebula_meta_data`: Meta service data
- `nebula_storage_data`: Storage service data
- `nebula_*_logs`: Log files for each service

## Usage

### Start NebulaGraph

```bash
docker compose up -d
```

### Connect to NebulaGraph

```bash
# Using console
docker run --rm -it --network host vesoft/nebula-console:v3.8.0 -addr 127.0.0.1 -port 9669 -u root -p nebula
```

## Access

- GraphD: <tcp://localhost:9669>

## Notes

- Default credentials: root/nebula
- Wait 20-30 seconds after startup for services to be ready
- Suitable for development and testing

## License

NebulaGraph is licensed under Apache License 2.0.
