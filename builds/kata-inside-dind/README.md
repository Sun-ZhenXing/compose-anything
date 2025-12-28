# Kata Containers inside Docker-in-Docker

[中文文档](README.zh.md)

A VM-based container runtime (Kata Containers with Firecracker VMM) running inside a Docker-in-Docker (DinD) container. This setup provides lightweight virtual machines with strong security isolation while maintaining container-like performance and simplicity. Kata Containers can use multiple hypervisors (QEMU, Firecracker, Cloud Hypervisor), and this image includes Firecracker by default for optimal performance.

## Features

- ✅ Complete Kata Containers runtime with official installation
- ✅ Firecracker VMM for lightweight VM isolation
- ✅ QEMU fallback support
- ✅ Docker-in-Docker support for managing containers
- ✅ VM-based container isolation with hardware security
- ✅ Resource limits to prevent system exhaustion
- ✅ Health checks for runtime readiness
- ✅ Persistent storage for Kata and Docker data
- ✅ Configurable logging levels
- ✅ Compatible with Kubernetes via RuntimeClass

## Prerequisites

**Critical Requirements:**

- Docker Engine 20.10+
- Docker Compose 2.0+
- **Host machine must support nested virtualization (KVM)**
- `/dev/kvm` device available on the host
- `/lib/modules` available on the host (for kernel module verification)
- At least 2 CPU cores and 4GB RAM available
- Privileged container support required

### Verify Host Prerequisites

```bash
# Check if KVM is available
ls -l /dev/kvm

# For Intel CPUs, verify nested virtualization is enabled
cat /sys/module/kvm_intel/parameters/nested
# Should output 'Y' or '1'. If not:
# sudo modprobe -r kvm_intel
# sudo modprobe kvm_intel nested=1
```

## Quick Start

1. Copy the environment file:

   ```bash
   cp .env.example .env
   ```

2. (Optional) Customize the configuration in `.env`

3. Build and start the service:

   ```bash
   docker compose up -d --build
   ```

4. Wait for Kata runtime to be ready:

   ```bash
   docker compose logs -f kata-dind
   ```

5. Access the Docker daemon inside:

   ```bash
   # Get the container ID
   docker compose ps

   # Execute commands inside the container
   docker compose exec kata-dind docker ps

   # Run a container with Kata runtime (Firecracker)
   docker compose exec kata-dind docker run --rm --runtime=kata-fc debian:bookworm uname -a

   # Or run with QEMU (fallback)
   docker compose exec kata-dind docker run --rm --runtime=kata debian:bookworm uname -a
   ```

## Configuration

### Environment Variables

| Variable                       | Default  | Description                                   |
| ------------------------------ | -------- | --------------------------------------------- |
| `DEBIAN_VERSION`               | `13.2`   | Base Debian version                           |
| `KATA_VERSION`                 | `3.24.0` | Kata Containers version                       |
| `FIRECRACKER_VERSION`          | `1.10.1` | Version of Firecracker VMM to install         |
| `KATA_DIND_VERSION`            | `0.2.0`  | Built image version tag                       |
| `TZ`                           | `UTC`    | Timezone for the container                    |
| `KATA_LOGGING_LEVEL`           | `info`   | Kata logging level (debug, info, warn, error) |
| `KATA_DIND_CPU_LIMIT`          | `2.00`   | CPU limit in cores                            |
| `KATA_DIND_MEMORY_LIMIT`       | `4G`     | Memory limit                                  |
| `KATA_DIND_CPU_RESERVATION`    | `0.50`   | CPU reservation in cores                      |
| `KATA_DIND_MEMORY_RESERVATION` | `1G`     | Memory reservation                            |

## Usage Examples

### Running a Secure Container

```bash
docker compose exec kata-dind docker run -it --rm --runtime=kata-fc alpine sh
```

### Checking Runtime Information

```bash
docker compose exec kata-dind docker info | grep -i runtime
```
