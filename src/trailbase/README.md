# TrailBase

[English](./README.md) | [中文](./README.zh.md)

TrailBase is an open, single-binary Firebase alternative that ships type-safe REST & realtime APIs, a built-in admin UI, WebAssembly runtime, and authentication powered by Rust, SQLite, and Wasmtime.
This compose bundle runs the official Docker image with sensible defaults so you can immediately explore the admin console, build data models, and deploy edge components without extra dependencies.

## Services

- `trailbase`: TrailBase application server with the embedded admin UI, REST API, and realtime channels.

## Quick Start

1. Copy the sample environment file and adjust values as needed:

   ```bash
   cp .env.example .env
   ```

2. Launch the stack:

   ```bash
   docker compose up -d
   ```

3. Tail the logs to capture the auto-generated administrator credentials from the first boot:

   ```bash
   docker compose logs -f trailbase
   ```

4. Open `http://localhost:4000/_/admin` and sign in with the printed credentials (or create your own admin; see below).

## Default Endpoints

| Endpoint                                | Description                 |
| --------------------------------------- | --------------------------- |
| `http://localhost:4000/_/admin`         | Admin UI                    |
| `http://localhost:4000/api/healthcheck` | Health probe used by Docker |
| `http://localhost:4000/_/auth/login`    | Optional Auth UI component  |

## Environment Variables

| Variable                       | Description                                         | Default  |
| ------------------------------ | --------------------------------------------------- | -------- |
| `TRAILBASE_VERSION`            | Docker image tag pulled from Docker Hub             | `0.22.4` |
| `TRAILBASE_PORT_OVERRIDE`      | Host port that maps to container port `4000`        | `4000`   |
| `TRAILBASE_RUST_BACKTRACE`     | Enables verbose Rust backtraces for troubleshooting | `1`      |
| `TRAILBASE_LOG_MAX_SIZE`       | Max log file size for the `json-file` driver        | `100m`   |
| `TRAILBASE_LOG_MAX_FILE`       | Number of rotated log files to keep                 | `3`      |
| `TRAILBASE_CPU_LIMIT`          | CPU limit applied via `deploy.resources.limits`     | `1.0`    |
| `TRAILBASE_MEMORY_LIMIT`       | Memory limit applied via `deploy.resources.limits`  | `1G`     |
| `TRAILBASE_CPU_RESERVATION`    | CPU reservation to keep TrailBase responsive        | `0.25`   |
| `TRAILBASE_MEMORY_RESERVATION` | Memory reservation to protect against eviction      | `256M`   |
| `TZ`                           | Timezone passed to the container                    | `UTC`    |

See `.env.example` for the complete, commented list.

## Volumes

- `trailbase_data`: Stores the `traildepot` directory which contains the SQLite database, WASM components, authentication secrets, and uploaded assets. Back up this volume to preserve your project.

## Bootstrap & Admin Accounts

- On the first start TrailBase prints temporary administrator credentials to the logs. Capture them with `docker compose logs -f trailbase`.
- Create additional verified users (or rotate the admin) without restarting the service:

  ```bash
  docker compose exec trailbase /app/trail user add admin@example.com "StrongPassw0rd!"
  ```

- To inspect user records or rotate passwords later, you can use other `trail` CLI commands from the same container.

## Optional Components

- The container already ships the official Auth UI WASM component under `/app/traildepot/wasm`. If you need extra components, install them at runtime:

  ```bash
  docker compose exec trailbase /app/trail components add trailbase/auth_ui
  docker compose exec trailbase /app/trail components add your-org/your-component
  ```

- Mount your own WASM components or configuration alongside the `trailbase_data` volume if you prefer to keep them under version control.

## Health & Maintenance

- The included healthcheck hits `http://localhost:4000/api/healthcheck`. You can perform manual probes with `curl http://localhost:4000/api/healthcheck`.
- Back up the data volume periodically:

  ```bash
  docker compose stop trailbase
  docker run --rm -v compose-anything_trailbase_data:/data -v $(pwd):/backup alpine tar czf /backup/trailbase-backup.tar.gz -C /data .
  docker compose start trailbase
  ```

- Restore by reversing the `tar` command into the named volume.

## Security Notes

- Rotate the default admin credentials immediately and restrict the exposed port with a firewall or reverse proxy.
- Set `TRAILBASE_RUST_BACKTRACE=0` in production to avoid verbose stack traces in logs.
- Terminate TLS with a reverse proxy such as Caddy, nginx, or Traefik and place TrailBase behind it for HTTPS.
- Back up the `trailbase_data` volume before upgrading to new releases.

## References

- Project website: [https://trailbase.io](https://trailbase.io)
- GitHub repository: [https://github.com/trailbaseio/trailbase](https://github.com/trailbaseio/trailbase)
- Documentation: [https://trailbase.io/reference](https://trailbase.io/reference)
- License: Open Software License 3.0 (OSL-3.0)
