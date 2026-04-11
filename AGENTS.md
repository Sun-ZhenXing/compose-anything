# Docker Compose Repository Guidelines

Compose Anything is a collection of production-ready, portable Docker Compose stacks. The default experience should remain simple: users should be able to enter a service directory and start it with `docker compose up -d`, while still getting sensible defaults for resource limits, health checks, security, and documentation.

## Primary Goals

1. Keep every stack easy to start and easy to understand.
2. Prefer portable Compose patterns that work across Windows, macOS, and Linux.
3. Default to production-aware settings instead of demo-only shortcuts.
4. Keep service documentation and root indexes accurate whenever a service changes.

## Required Workflow For Service Changes

1. Read the existing service folder before editing anything.
2. Use the repo root `.compose-template.yaml` as the structural reference when applicable.
3. Update these files together when a service changes: `docker-compose.yaml`, `.env.example`, `README.md`, and `README.zh.md`.
4. Update the root `README.md` and `README.zh.md` whenever a service is added, renamed, removed, or needs a new quick-start entry.
5. Keep the default startup path within `docker compose up -d`. If extra setup is unavoidable, document it clearly and prefer a `Makefile` over ad-hoc instructions.

## Compose Standards

1. Out-of-the-box startup
    - A stack should work with zero extra steps, except optionally creating a `.env` file from `.env.example`.
    - Defaults must be usable for local evaluation without forcing users to edit configuration first.
2. Command simplicity
    - Each project should ship a single `docker-compose.yaml` file.
    - Initialization order should use `healthcheck` plus `depends_on.condition: service_healthy` whenever a dependency chain exists.
3. Version pinning
    - Pin to a stable image version instead of `latest` whenever a stable tag exists.
    - Expose image versions via environment variables such as `REDIS_VERSION` or `POSTGRES_VERSION`.
4. Configuration style
    - Prefer environment variables over long CLI flags.
    - Never hardcode secrets.
    - Provide a fully commented `.env.example` in English.
    - Use UPPER_SNAKE_CASE names with a service prefix.
    - Use `*_PORT_OVERRIDE` for host port overrides.
5. Profiles
    - Use Compose profiles for optional components only.
    - Preferred profile names: `gpu`, `metrics`, `dev`.
6. Cross-platform support
    - Favor patterns that work on Debian 12+, Ubuntu 22.04+, Windows 10+, and macOS 12+ when upstream images support them.
    - Support both x86-64 and ARM64 as consistently as practical.
    - Avoid Linux-only host paths such as `/etc/localtime`; prefer `TZ`.
7. Storage and mounts
    - Prefer named volumes for application data.
    - Prefer relative paths for repo-managed configuration files.
    - If host paths are necessary, expose a top-level directory variable such as `DATA_DIR`.
8. Resources and logging
    - Every service must define CPU and memory limits.
    - GPU services should default to one GPU via `deploy.resources.reservations.devices` or `gpus`.
    - Limit container logs with the `json-file` driver and `max-size` / `max-file`.
9. Health checks
    - Every long-running service should define a meaningful `healthcheck`.
    - Tune `interval`, `timeout`, `retries`, and `start_period` for the actual startup profile of the service.
10. Security baseline
    - Run as non-root when practical.
    - Use `read_only: true` plus writable mounts or `tmpfs` where feasible.
    - Default to `cap_drop: ["ALL"]` and add back only what is required.
    - Do not use `container_name`.
    - If a stack requires the Docker socket or another high-risk mount, document the risk and safer alternatives.

## Documentation Standards

1. Every service must provide both `README.md` and `README.zh.md`.
2. Service READMEs should at minimum cover: purpose, services, quick start, key environment variables, storage, and security notes when relevant.
3. The root `README.md` and `README.zh.md` should remain useful as entry points, not just service indexes. Include concise quick-start guidance and at least one concrete example when it helps discovery.
4. List the main environment variables and default ports in the service README.
5. Keep documentation LLM-friendly: predictable headings, short paragraphs, and concrete command examples.

Reference template: `/.compose-template.yaml`

If you need image tags, check the Docker Hub API, for example:
`https://hub.docker.com/v2/repositories/library/nginx/tags?page_size=1&ordering=last_updated`

## Final Checklist

1. Is `.env.example` present and fully commented in English?
2. Are CPU and memory limits defined?
3. Has `container_name` been avoided or removed?
4. Are `healthcheck` and `depends_on.condition: service_healthy` used correctly?
5. Are `README.md` and `README.zh.md` both updated for the service?
6. Are the root `README.md` and `README.zh.md` updated if discoverability changed?
7. Are Chinese docs using Chinese punctuation, with spaces between Chinese and English terms?

**注意**：所有中文文档都使用中文标点，如 “，”、“（）” 等，中文与英文之间保留空格。Docker Compose 文件和 `.env.example` 文件中的注释必须使用英文。每个服务都必须提供英文 `README.md` 和中文 `README.zh.md`。
