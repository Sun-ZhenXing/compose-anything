# OpenList

[English](./README.md) | [中文](./README.zh.md)

This service deploys OpenList, a file list program that supports multiple storage.

## Services

- `openlist`: OpenList service

## Environment Variables

| Variable Name          | Description       | Default Value   |
| ---------------------- | ----------------- | --------------- |
| OPENLIST_VERSION       | OpenList version  | `latest`        |
| PUID                   | User ID           | `0`             |
| PGID                   | Group ID          | `0`             |
| UMASK                  | UMASK             | `022`           |
| TZ                     | Timezone          | `Asia/Shanghai` |
| OPENLIST_PORT_OVERRIDE | Host port mapping | `5244`          |

## Volumes

- `openlist_data`: Data directory

## Usage

### Start OpenList

```bash
docker compose up -d
```

### Access

- Web UI: <http://localhost:5244>

### Initial Setup

1. Open <http://localhost:5244>
2. Complete the initial setup wizard
3. Configure storage providers
4. Start managing files

## Notes

- First startup requires initial configuration
- Supports multiple cloud storage providers
- Community-driven fork of AList

## License

OpenList follows the original AList license. See [OpenList GitHub](https://github.com/OpenListTeam/OpenList) for more information.
