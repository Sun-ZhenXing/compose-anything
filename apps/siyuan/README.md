# SiYuan

SiYuan is a self-hosted personal knowledge management application. This stack uses the official `b3log/siyuan:v3.8.2` image and one named workspace volume.

## Services

- `siyuan`: SiYuan kernel and web interface on container port `6806`.
- Image: `b3log/siyuan:v3.8.2@sha256:af1442205fd60a8f5710c46c7e4c92bf3c8c1c9405026823496e4459f821549c`.

The official image supports the upstream multi-architecture image manifest. This Compose file does not add an application image, startup script, database, or helper container.

## Quick start

This configuration requires a non-empty access code. Generate one once, then start the stack.

```bash
cd apps/siyuan
python3 setup.py                 # Windows: py -3 setup.py
docker compose up -d
```

`make init` runs the same initializer in a network-isolated, resource-limited Python container. Open <http://localhost:6806> and use the generated `SIYUAN_ACCESS_AUTH_CODE` from the local `.env` file. Read that value locally without printing it to shared logs. The access code is used for browser login; follow the upstream documentation for API authentication. Check startup with `docker compose ps`.

## Configuration

| Variable | Default | Purpose |
| --- | --- | --- |
| `SIYUAN_VERSION` | pinned `v3.8.2` digest | Official image reference |
| `SIYUAN_BIND_ADDRESS` | `127.0.0.1` | Host bind address |
| `SIYUAN_PORT_OVERRIDE` | `6806` | Host port for SiYuan |
| `SIYUAN_ACCESS_AUTH_CODE` | generated | Required workspace web access code |
| `SIYUAN_PUID` / `SIYUAN_PGID` | `1000` / `1000` | Runtime UID/GID after image bootstrap |
| `SIYUAN_CPU_LIMIT` / `SIYUAN_MEMORY_LIMIT` | `1.0` / `1G` | Resource limits |

The service uses a writable root filesystem because the official startup script creates `/etc/group` as root before dropping to the configured UID/GID. It drops all other Linux capabilities, enables `no-new-privileges`, and does not force a Compose `user`.

## Storage, security, and upgrades

`siyuan_data` stores the workspace, settings, documents, assets, and other SiYuan data under `/siyuan/workspace`. Back up this named volume before upgrades. Do not run `docker compose down -v` against real data.

The default bind is local-only. For remote access, use `SIYUAN_BIND_ADDRESS=0.0.0.0` only behind HTTPS, a firewall, and a strong access code. Never bypass authentication.

This configuration does not claim cloud synchronization, desktop-client compatibility, or access to paid features. Review the upstream Docker guidance and license before enabling features in a deployment:

- [Official SiYuan README and Docker guidance](https://github.com/siyuan-note/siyuan/blob/v3.8.2/README.md)
- [SiYuan v3.8.2 license](https://github.com/siyuan-note/siyuan/blob/v3.8.2/LICENSE)
