# Gitea Runner

[English](./README.md) | [中文](./README.zh.md)

This stack runs Gitea Runner 2.1.0 for Gitea Actions. The Compose service is `gitea_runner`; it executes jobs in Docker containers through the host Docker daemon.

## Services

- `gitea_runner`: Registers with Gitea and creates Docker containers for Actions jobs.

## Prerequisite

Create a runner registration token in Gitea under **Settings -> Actions -> Runners**. The token is required.

## Quick Start

```bash
cp .env.example .env
# Set GITEA_RUNNER_REGISTRATION_TOKEN in .env and, when needed, GITEA_INSTANCE_URL.
docker compose up -d
```

The default `http://host.docker.internal:3000` targets a Gitea server published on port 3000 of the Docker host. Compose maps that hostname to the host gateway for the runner, and `config.yaml` does the same for job containers. Change the URL for a remote Gitea server, another port, or a deployment not reachable through the host; the selected URL must be reachable from both the runner and job containers.

## Configuration

| Variable                                                        | Default                                                       | Description                                                                   |
| --------------------------------------------------------------- | ------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| `GLOBAL_REGISTRY`                                               | empty                                                         | Optional registry prefix, including its trailing `/`.                         |
| `GITEA_RUNNER_VERSION`                                          | `2.1.0`                                                       | Runner image version.                                                         |
| `TZ`                                                            | `UTC`                                                         | Container time zone.                                                          |
| `GITEA_INSTANCE_URL`                                            | `http://host.docker.internal:3000`                            | Gitea URL reachable by the runner and jobs.                                   |
| `GITEA_RUNNER_REGISTRATION_TOKEN`                               | empty                                                         | Required registration token.                                                  |
| `GITEA_RUNNER_NAME`                                             | `Gitea-Runner`                                                | Runner name shown in Gitea.                                                   |
| `GITEA_RUNNER_LABELS`                                           | `ubuntu-latest`, `ubuntu-24.04`, `ubuntu-22.04` Docker labels | Comma-separated labels using job images from `docker.io/gitea/runner-images`. |
| `GITEA_RUNNER_HTTP_PROXY`                                       | empty                                                         | HTTP proxy for the runner and every job container. Empty disables proxying.   |
| `GITEA_RUNNER_HTTPS_PROXY`                                      | empty                                                         | HTTPS proxy. Usually the same endpoint as the HTTP proxy.                     |
| `GITEA_RUNNER_NO_PROXY`                                         | `localhost,127.0.0.1,::1,host.docker.internal`                | Hosts that bypass the proxy.                                                  |
| `GITEA_RUNNER_CPU_LIMIT` / `GITEA_RUNNER_CPU_RESERVATION`       | `1.0` / `0.1`                                                 | CPU limit and reservation.                                                    |
| `GITEA_RUNNER_MEMORY_LIMIT` / `GITEA_RUNNER_MEMORY_RESERVATION` | `2G` / `1G`                                                   | Memory limit and reservation.                                                 |

The repository includes a ready-to-use `config.yaml`. To inspect a fresh upstream 2.1.0 configuration instead, run:

```bash
docker run --entrypoint="" --rm gitea/runner:2.1.0 gitea-runner generate-config > config.yaml
```

## Proxy

Set `GITEA_RUNNER_HTTP_PROXY` and `GITEA_RUNNER_HTTPS_PROXY` in `.env` and the whole stack uses the proxy. Both are empty by default, which disables proxying.

The proxy must listen on `0.0.0.0` on the host, not only `127.0.0.1`, otherwise containers cannot reach it through `host.docker.internal`. If the proxy is another container on the same network, use its service name instead.

Coverage:

- The runner's own requests to Gitea and action repositories.
- Every job container, because the runner injects the proxy variables in both upper and lower case.

### Proxying builds

The Docker CLI does not take proxy settings from environment variables, but it does read them from its own config file. Writing that file once as the first step of a job makes every later `docker build`, `docker compose build`, and `docker buildx build` in that job use the proxy without any per-command flags.

```yaml
- run: mkdir -p ~/.docker && printf '{"proxies":{"default":{"httpProxy":"%s","httpsProxy":"%s","noProxy":"%s"}}}' "$HTTP_PROXY" "$HTTPS_PROXY" "$NO_PROXY" > ~/.docker/config.json
```

The job container already has those three variables, because the runner injects them, so the step needs no configuration of its own. When proxying is disabled the values are empty and builds behave as before.

Dockerfiles need no `ARG` lines for this, because the proxy variables are predefined build arguments.

Run this step before any `docker login` in the same job. `docker login` merges into the same file and keeps the proxy section, but writing the file after a login would discard the stored credentials.

Not covered: image pulls. Job container images and the base images pulled during a `docker build` are fetched by the host Docker daemon, which only honors its own proxy configuration. Configure it separately: Docker Desktop under **Settings -> Resources -> Proxies** (Docker Desktop ignores the `proxies` key in `daemon.json`), or on Linux a systemd drop-in at `/etc/systemd/system/docker.service.d/http-proxy.conf` with `Environment="HTTP_PROXY=..."`, or the `proxies` key in `daemon.json` on Docker Engine 23.0 and later.

Do not put CIDR ranges in `GITEA_RUNNER_NO_PROXY`. The runner accepts them but `curl` inside job containers does not.

## Storage and Health

- `gitea_runner_data` stores registration and runner state.
- `./config.yaml` is mounted read-only at `/config.yaml`.
- `/var/run/docker.sock` lets the runner create job containers.
- The healthcheck queries the internal metrics endpoint at `http://127.0.0.1:9101/healthz`.

## Security

Docker socket access is effectively host-level privilege. Do not run untrusted workflows on this runner. For stronger isolation, use a dedicated host or VM, or evaluate a rootless Docker-in-Docker setup.

## Migrating from act_runner

- The image and binary changed from `gitea/act_runner` and `act_runner` to `gitea/runner` and `gitea-runner`.
- Rename `INSTANCE_URL`, `REGISTRATION_TOKEN`, `RUNNER_NAME`, and `RUNNER_LABELS` to the corresponding official `GITEA_*` variables above.
- The default labels now include Ubuntu 24.04 and 22.04 images, and `container.force_pull` now defaults to `false`.
- Runner v2.0 introduced a breaking change for private-image credentials; review and reconfigure those credentials before running private images.
