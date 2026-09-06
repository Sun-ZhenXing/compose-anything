# TriliumNext

TriliumNext is a maintained personal knowledge-base application derived from the Trilium project. This stack runs the official `triliumnext/trilium:v0.103.0` image with its native first-setup web flow.

## Services

- `trilium`: TriliumNext kernel and web interface on container port `8080`.
- Image: `triliumnext/trilium:v0.103.0@sha256:8e6bc939a6d5dbeed42d1b5b155bc790b1c28ca3ac414382d04d626903c62081`.

There are no extra services, custom images, or custom entrypoints. The official image bootstraps its runtime user and starts Trilium with its native Docker command.

## Quick start

No `.env` file is required for the default local start:

```bash
cd apps/trilium
docker compose up -d
docker compose ps
```

Open <http://localhost:8080>. A fresh deployment redirects to the native first-setup page. Complete setup and set a strong password before exposing the service beyond localhost.

## Configuration

| Variable | Default | Purpose |
| --- | --- | --- |
| `TRILIUM_VERSION` | pinned `v0.103.0` digest | Official image reference |
| `TRILIUM_BIND_ADDRESS` | `127.0.0.1` | Host bind address |
| `TRILIUM_PORT_OVERRIDE` | `8080` | Host port for Trilium |
| `TRILIUM_CPU_LIMIT` / `TRILIUM_MEMORY_LIMIT` | `1.0` / `1G` | Resource limits |
| `TZ` | `UTC` | Container timezone |

Copy `.env.example` to `.env` only when overriding these values. The container port and data directory are fixed by the upstream image contract.

## Storage, security, and upgrades

The single named volume `trilium_data` stores the SQLite database, configuration, notes, and attachments under `/home/node/trilium-data`. Back it up before upgrades or schema changes. Do not run `docker compose down -v` against real data. This Compose file does not perform automatic migration from an original Trilium installation.

The image keeps a writable root filesystem because its startup bootstrap creates and owns runtime paths before running as UID/GID `1000:1000`. The service drops all other Linux capabilities, adds only the filesystem/group capabilities required by that bootstrap, and enables `no-new-privileges`.

The default bind is local-only. For remote access, use `TRILIUM_BIND_ADDRESS=0.0.0.0` only behind an HTTPS reverse proxy, firewall, and strong first-setup password. Do not expose the fresh setup page directly to an untrusted network.

This configuration does not claim desktop-client compatibility, ARM validation, or synchronization testing. Review the versioned upstream README, Docker source, and license for project and feature details:

- [Official TriliumNext README and Docker guidance](https://github.com/TriliumNext/Trilium/blob/v0.103.0/README.md)
- [TriliumNext Dockerfile source](https://github.com/TriliumNext/Trilium/blob/v0.103.0/Dockerfile)
- [TriliumNext v0.103.0 license](https://github.com/TriliumNext/Trilium/blob/v0.103.0/LICENSE)
