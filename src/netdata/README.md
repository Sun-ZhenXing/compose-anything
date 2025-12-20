# Netdata

[English](./README.md) | [中文](./README.zh.md)

Netdata is a high-performance, real-time monitoring and troubleshooting tool for systems and applications. It provides unparalleled insights into your infrastructure with per-second metrics and interactive visualizations.

## Services

- `netdata`: The Netdata Agent (port 19999)

## Quick Start

```bash
docker compose up -d
```

## Environment Variables

| Variable Name                | Description           | Default Value |
| :--------------------------- | :-------------------- | :------------ |
| `NETDATA_VERSION`            | Netdata image version | `v2.8.4`      |
| `TZ`                         | Timezone              | `UTC`         |
| `NETDATA_CPU_LIMIT`          | CPU limit             | `1.0`         |
| `NETDATA_MEMORY_LIMIT`       | Memory limit          | `1G`          |
| `NETDATA_CPU_RESERVATION`    | CPU reservation       | `0.1`         |
| `NETDATA_MEMORY_RESERVATION` | Memory reservation    | `256M`        |

Please modify the `.env` file as needed for your use case.

## Volumes

- `netdataconfig`: Stores Netdata configuration files
- `netdatalib`: Stores Netdata libraries and databases
- `netdatacache`: Stores Netdata cache files

## Notes

- This configuration uses `network_mode: host` to provide full monitoring capabilities of the host system.
- The Netdata dashboard is available at `http://localhost:19999`.
