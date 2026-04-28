# CubeSandbox

Run [TencentCloud CubeSandbox](https://github.com/TencentCloud/CubeSandbox) — a KVM-based MicroVM sandbox compatible with the E2B SDK — entirely inside a single privileged Docker container, without modifying the host system.

## Why this is unusual

CubeSandbox is **not** a containerized project upstream. Its core components (Cubelet, network-agent, cube-shim, cube-runtime, CubeAPI, CubeMaster) ship as host binaries and the official `install.sh` writes them to `/usr/local/services/cubetoolbox`, then starts them as native processes that talk to the host containerd.

This stack runs the **entire installer inside one privileged container** that:

1. Runs its own `dockerd` (Docker-in-Docker) for MySQL / Redis / CubeProxy / CoreDNS dependencies.
2. Creates an XFS-formatted loop volume at `/data/cubelet` (install.sh hard-requires XFS).
3. Executes the upstream [`online-install.sh`](https://github.com/TencentCloud/CubeSandbox/blob/master/deploy/one-click/online-install.sh) on first boot.
4. Tails logs to keep the container alive.

The result is essentially a **single-node CubeSandbox appliance container** suitable for evaluating CubeSandbox without changing your host.

## Features

- Built on Ubuntu 22.04 (the project's primary test environment)
- Self-contained: no host packages installed, no host paths mounted
- KVM passed through via `/dev/kvm`
- Persistent volumes for installed binaries, sandbox data, and DinD storage
- Health check covering CubeAPI, CubeMaster, and network-agent
- China-mainland mirror (`MIRROR=cn`) used by default
- Smoke-test script included (`smoke-test.sh`)

## Requirements

- Linux host (or WSL2 with KVM passthrough) with `/dev/kvm` available to Docker
- Nested virtualization enabled (Intel VT-x / AMD-V exposed)
- cgroup v2 (modern kernels — Debian 12+, Ubuntu 22.04+, kernel 5.10+)
- ≥ 16 GiB RAM and ≥ 8 vCPU recommended (8 GiB is the upstream minimum)
- ≥ 60 GiB free disk for the XFS loop file + Docker image layers
- Outbound internet to download the install bundle (~hundreds of MB) and Docker images

> On WSL2: confirm `/dev/kvm` is present (`ls -l /dev/kvm`) and your user is in the `kvm` group on the host distro.

## Quick Start

1. Copy the example environment file (optional — defaults work):

   ```bash
   cp .env.example .env
   ```

2. Build and start (the first run downloads the CubeSandbox bundle and several Docker images — expect 5–20 minutes):

   ```bash
   docker compose up -d --build
   ```

3. Watch the bootstrap log:

   ```bash
   docker compose logs -f cube-sandbox
   ```

   Wait for the `==================== CubeSandbox is up ====================` banner.

4. Verify all services are healthy:

   ```bash
   curl -fsS http://127.0.0.1:3000/health        && echo  # CubeAPI
   curl -fsS http://127.0.0.1:8089/notify/health && echo  # CubeMaster
   curl -fsS http://127.0.0.1:19090/healthz      && echo  # network-agent
   ```

5. (Optional) Run the smoke test:

   ```bash
   bash smoke-test.sh                    # Health checks only
   SKIP_TEMPLATE_BUILD=1 bash smoke-test.sh   # Skip the slow template build
   ```

## Endpoints

Because the container uses `network_mode: host`, all CubeSandbox HTTP endpoints are reachable directly on the host loopback:

| Service       | URL                                  |
| ------------- | ------------------------------------ |
| CubeAPI       | `http://127.0.0.1:3000`              |
| CubeMaster    | `http://127.0.0.1:8089`              |
| network-agent | `http://127.0.0.1:19090`             |

The CubeAPI exposes the E2B-compatible REST surface; point the [`e2b` Python SDK](https://e2b.dev) at `http://127.0.0.1:3000` to create sandboxes.

## Configuration

Key environment variables (see `.env.example` for the full list):

| Variable                   | Description                                                  | Default          |
| -------------------------- | ------------------------------------------------------------ | ---------------- |
| `GLOBAL_REGISTRY`          | Image registry prefix when pushing to a private registry     | _(empty)_        |
| `CUBE_SANDBOX_VERSION`     | Tag of the locally built wrapper image                       | `0.1.7`          |
| `UBUNTU_IMAGE`             | Base Ubuntu version                                          | `22.04`          |
| `TZ`                       | Container timezone                                           | `Asia/Shanghai`  |
| `CUBE_MIRROR`              | Installer mirror — `cn` (China CDN) or `gh` (GitHub)         | `cn`             |
| `CUBE_XFS_SIZE`            | Size of the XFS loop file backing `/data/cubelet`            | `50G`            |
| `CUBE_FORCE_REINSTALL`     | Set to `1` to re-run `install.sh` on next start              | `0`              |
| `CUBE_CPU_LIMIT`           | CPU limit                                                    | `8`              |
| `CUBE_MEMORY_LIMIT`        | Memory limit                                                 | `16G`            |
| `CUBE_CPU_RESERVATION`     | CPU reservation                                              | `2`              |
| `CUBE_MEMORY_RESERVATION`  | Memory reservation                                           | `8G`             |

## Storage

Three named volumes hold persistent state — your installed CubeSandbox survives `docker compose down && up`:

| Volume          | Path inside container               | Purpose                                            |
| --------------- | ----------------------------------- | -------------------------------------------------- |
| `cube_dind_data` | `/var/lib/docker`                   | DinD daemon images / containers / volumes          |
| `cube_data`      | `/data`                             | XFS loop image, `/data/cubelet`, sandbox disks, logs |
| `cube_toolbox`   | `/usr/local/services/cubetoolbox`   | Installed CubeSandbox binaries and scripts         |

To wipe everything and reinstall from scratch:

```bash
docker compose down -v
docker compose up -d --build
```

## Security Considerations

⚠️ This stack is **highly privileged by design**. Only run it in trusted environments.

- `privileged: true` — required to mount the XFS loop volume, manage TAP interfaces, and run KVM
- `network_mode: host` — required so Cubelet can register the node IP and manage host TAP interfaces
- `cgroup: host` — required for the in-container `dockerd` to share the host's cgroup v2 hierarchy
- `/dev/kvm` and `/dev/net/tun` are passed through

These permissions are equivalent to what `online-install.sh` would request if it were run directly on your host. The advantage of the container wrapper is that all installer side-effects are confined to the three named volumes above, so removing the stack leaves no host residue.

## Troubleshooting

- **`/dev/kvm not found`** — the host does not expose KVM to Docker. On WSL2, confirm nested virtualization is enabled and the kernel exposes `/dev/kvm`. On bare metal, ensure VT-x / AMD-V is enabled in BIOS.
- **First boot hangs at "Running CubeSandbox one-click installer"** — the installer is downloading the bundle (~hundreds of MB) and pulling several Docker images. Check progress with `docker compose logs -f cube-sandbox`.
- **`quickcheck.sh reported issues`** — open a shell in the container and inspect logs:
  
  ```bash
  docker compose exec cube-sandbox bash
  ls /data/log/
  tail -f /data/log/CubeAPI/*.log
  ```
- **Re-run the installer cleanly** — set `CUBE_FORCE_REINSTALL=1` in `.env` and `docker compose up -d --force-recreate`.

## Project Information

- Upstream: https://github.com/TencentCloud/CubeSandbox
- License: upstream project is Apache-2.0; this configuration is provided as-is for the Compose Anything project.
