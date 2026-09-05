# Logseq

[中文](./README.zh.md) | [English](./README.md)

[Logseq](https://github.com/logseq/logseq) is a local-first outliner for notes and linked knowledge. This stack serves the official file-based Web App through Nginx. Your browser opens graph folders on your computer; this container provides neither a database nor a synchronization server. It does not deploy the Logseq 2.0 DB beta.

## Services

| Service | Image | Default URL |
| ------- | ----- | ----------- |
| `logseq` | `ghcr.io/logseq/logseq-webapp` (digest-pinned) | <http://localhost:3001> |

The selected image supports `linux/amd64` and `linux/arm64`. Upstream provides no release-version tags for this Web App, so this stack pins a multi-platform SHA-256 digest. The selected AMD64 image was built on **2025-05-26**; do not assume it tracks current desktop or DB releases. Review upstream maintenance and security fixes before exposing it beyond your computer.

## Quick Start

From the repository root:

```bash
cd src/logseq
docker compose up -d
```

Open <http://localhost:3001> in a desktop browser that supports the File System Access API, such as Chrome or Edge. Select a local graph folder and grant the browser access. Firefox and Safari cannot open local graph folders through this API.

No setup or `.env` file is required. To customize settings, optionally create `.env` from `.env.example` before starting.

```bash
docker compose ps
docker compose logs -f logseq
docker compose down
```

## Configuration

| Variable | Default | Purpose |
| -------- | ------- | ------- |
| `LOGSEQ_IMAGE_DIGEST` | `sha256:de87c4a2...f26c231` | Full pinned digest appears in `.env.example` and Compose |
| `GLOBAL_REGISTRY` | `ghcr.io/` | Registry prefix, including trailing slash |
| `LOGSEQ_BIND_ADDRESS` | `127.0.0.1` | Host interface for HTTP |
| `LOGSEQ_PORT_OVERRIDE` | `3001` | Host port mapped to container port `80` |
| `TZ` | `UTC` | Container timezone |
| `LOGSEQ_CPU_LIMIT` | `0.5` | CPU limit |
| `LOGSEQ_MEMORY_LIMIT` | `128M` | Memory limit |
| `LOGSEQ_CPU_RESERVATION` | `0.1` | CPU reservation |
| `LOGSEQ_MEMORY_RESERVATION` | `32M` | Memory reservation |

## Storage

No named or anonymous volumes are needed. Graph files live in the folder you select on the **browser's computer**, not on the Docker host unless they are the same computer. Back up that folder with your usual file backup tools. Browser-local state and permissions belong to the site's origin; changing the hostname, port, or protocol can require reopening the graph and granting access again.

The container only serves application files. Its Nginx cache and PID directories use temporary memory mounts. Recreating or removing the container does not delete your local graph files. Mounting a graph folder into this container does not make it available to other clients or enable synchronization.

## Security And Remote Access

- The container runs as UID/GID `101:101`, with a read-only root filesystem, all capabilities dropped, and privilege escalation disabled. CPU, memory, and log sizes are bounded.
- HTTP binds to loopback by default. The image provides no server-side login or TLS termination.
- For remote access, use a trusted HTTPS reverse proxy and restrict access with authentication or a private network. A plain HTTP LAN address is not a secure context for the File System Access API; `http://localhost` works for local access.
- A proxy running on the Docker host can forward to `127.0.0.1:3001`. A containerized proxy needs a shared Docker network and should forward to `logseq:80`; its own `localhost` does not refer to this service.
- Only grant graph access to a trusted deployment. The JavaScript it serves can read and modify files you authorize in the browser. Do not expose the HTTP port directly to the public Internet.

## Updates

Review the [official image package](https://github.com/logseq/logseq/pkgs/container/logseq-webapp), choose a verified multi-platform digest, and update `LOGSEQ_IMAGE_DIGEST` in `.env`. A pull alone does not change the pinned version. Back up your graph before testing an updated app.

```bash
docker compose pull
docker compose up -d
```

## References

- [Source repository](https://github.com/logseq/logseq)
- [Official Docker Web App guide](https://github.com/logseq/logseq/blob/master/docs/docker-web-app-guide.md)
- [File System Access API browser support](https://caniuse.com/native-filesystem-api)
