---
applyTo: '**'
---
Compose Anything helps users quickly deploy various services by providing a set of high-quality Docker Compose configuration files. These configurations constrain resource usage, can be easily migrated to systems like K8S, and are easy to understand and modify.

1. Out-of-the-box
    - Configurations should work out-of-the-box with no extra steps (at most, provide a `.env` file).
2. Simple commands
    - Each project ships a single `docker-compose.yaml` file.
    - Command complexity should not exceed `docker compose up -d`; if more is needed, provide a `Makefile`.
    - For initialization, prefer `healthcheck` with `depends_on` using `condition: service_healthy` to orchestrate startup order.
3. Stable versions
    - Pin to the latest stable version instead of `latest`.
    - Expose image versions via environment variables (e.g., `FOO_VERSION`).
4. Configuration conventions
    - Prefer environment variables over complex CLI flags;
    - Pass secrets via env vars or mounted files, never hardcode;
    - Provide sensible defaults to enable zero-config startup;
    - A commented `.env.example` is required;
    - Env var naming: UPPER_SNAKE_CASE with service prefix (e.g., `POSTGRES_*`); use `*_PORT_OVERRIDE` for host port overrides.
5. Profiles
    - Use Profiles for optional components/dependencies;
    - Recommended names: `gpu` (acceleration), `metrics` (observability/exporters), `dev` (dev-only features).
6. Cross-platform & architectures
    - Where images support it, ensure Debian 12+/Ubuntu 22.04+, Windows 10+, macOS 12+ work;
    - Support x86-64 and ARM64 as consistently as possible;
    - Avoid Linux-only host paths like `/etc/localtime` and `/etc/timezone`; prefer `TZ` env var for time zone.
7. Volumes & mounts
    - Prefer relative paths for configuration to improve portability;
    - Prefer named volumes for data directories to avoid permission/compat issues of host paths;
    - If host paths are necessary, provide a top-level directory variable (e.g., `DATA_DIR`).
8. Resources & logging
    - Always limit CPU and memory to prevent resource exhaustion;
    - For GPU services, enable a single GPU by default via `deploy.resources.reservations.devices` (maps to device requests) or `gpus` where applicable;
    - Limit logs (`json-file` driver: `max-size`/`max-file`).
9. Healthchecks
    - Every service should define a `healthcheck` with suitable `interval`, `timeout`, `retries`, and `start_period`;
    - Use `depends_on.condition: service_healthy` for dependency chains.
10. Security baseline (apply when possible)
    - Run as non-root (expose `PUID`/`PGID` or set `user: "1000:1000"`);
    - Read-only root filesystem (`read_only: true`), use `tmpfs`/writable mounts for required paths;
    - Least privilege: `cap_drop: ["ALL"]`, add back only what’s needed via `cap_add`;
    - Avoid `container_name` (hurts scaling and reusable network aliases);
    - If exposing Docker socket or other high-risk mounts, clearly document risks and alternatives.
11. Documentation & discoverability
    - Provide clear docs and examples (include admin/initialization notes, and security/license notes when relevant);
    - Keep docs LLM-friendly;
    - List primary env vars and default ports in the README, and link to `README.md` / `README.zh.md`.

Reference template: `.compose-template.yaml` in the repo root.

If you want to find image tags, try fetch url like `https://hub.docker.com/v2/repositories/library/nginx/tags?page_size=1&ordering=last_updated`.
