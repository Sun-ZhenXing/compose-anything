# MicroSandbox

[中文文档](README.zh.md)

MicroSandbox is a KVM-based secure sandbox environment developed by Zerocore AI. It provides isolated, lightweight virtual machines for running untrusted code safely using hardware-level virtualization.

## Features

- **KVM-Based Virtualization**: Leverages hardware virtualization for strong isolation
- **Lightweight**: Minimal overhead compared to traditional VMs
- **Secure**: Hardware-level isolation protects the host system
- **Fast Startup**: Quick VM initialization for rapid testing
- **Multi-Architecture**: Support for both x86_64 (amd64) and ARM64 (aarch64) platforms

## Prerequisites

- Docker and Docker Compose installed
- Hardware virtualization support (KVM):
  - Intel VT-x or AMD-V enabled in BIOS
  - `/dev/kvm` device available on the host
- Linux host system (KVM is Linux-specific)
- Privileged container access (required for KVM)

### Check KVM Support

Before running MicroSandbox, verify that your system supports KVM:

```bash
# Check if KVM device exists
ls -l /dev/kvm

# Check CPU virtualization support
grep -E 'vmx|svm' /proc/cpuinfo
```

If `/dev/kvm` doesn't exist, ensure virtualization is enabled in your BIOS and the KVM kernel module is loaded:

```bash
# Load KVM module (Intel)
sudo modprobe kvm_intel

# Or for AMD
sudo modprobe kvm_amd
```

## Quick Start

1. Copy the example environment file:

    ```bash
    cp .env.example .env
    ```

2. (Optional) Edit `.env` to customize resource limits:

    ```bash
    # Adjust CPU and memory as needed
    MICROSANDBOX_CPU_LIMIT=4.00
    MICROSANDBOX_MEMORY_LIMIT=4G
    ```

3. Build the Docker image:

    ```bash
    docker compose build
    ```

4. Run MicroSandbox:

    ```bash
    docker compose run --rm microsandbox
    ```

## Usage Examples

### Interactive Session

Start an interactive session with MicroSandbox:

```bash
docker compose run --rm microsandbox
```

### Run a Command in Sandbox

Execute a specific command inside the sandbox:

```bash
docker compose run --rm microsandbox run "echo Hello from sandbox"
```

### Get Help

View available commands and options:

```bash
docker compose run --rm microsandbox --help
```

## Configuration

### Environment Variables

| Variable                          | Description                            | Default   |
| --------------------------------- | -------------------------------------- | --------- |
| `MICROSANDBOX_VERSION`            | MicroSandbox version                   | `latest`  |
| `DEBIAN_VERSION`                  | Debian base image version              | `13.2-slim` |
| `MICROSANDBOX_AUTO_PULL_IMAGES`   | Auto pull base images on build         | `true`    |
| `MICROSANDBOX_DEV_MODE`           | Enable dev mode (no API key required)  | `true`    |
| `MICROSANDBOX_PORT`               | Internal container port                | `5555`    |
| `MICROSANDBOX_PORT_OVERRIDE`      | External host port mapping             | `5555`    |
| `TZ`                              | Container timezone                     | `UTC`     |
| `MICROSANDBOX_CPU_LIMIT`          | Maximum CPU cores                      | `4`       |
| `MICROSANDBOX_CPU_RESERVATION`    | Reserved CPU cores                     | `1`       |
| `MICROSANDBOX_MEMORY_LIMIT`       | Maximum memory allocation              | `4G`      |
| `MICROSANDBOX_MEMORY_RESERVATION` | Reserved memory                        | `1G`      |

### Volume Mounts

- `microsandbox_namespaces`: MicroSandbox namespace configurations and VM state
- `microsandbox_workspace`: Working directory for sandbox operations

## Security Considerations

### Privileged Mode

MicroSandbox requires `privileged: true` to access KVM devices. This is necessary for hardware virtualization but grants the container elevated privileges. Consider the following:

- Only run MicroSandbox on trusted systems
- Review the code you plan to execute in the sandbox
- Keep the MicroSandbox image updated with security patches
- Use network isolation if running untrusted code
- In production environments, disable dev mode by setting `MICROSANDBOX_DEV_MODE=false`

**Why Privileged Mode?**

MicroSandbox uses KVM (Kernel-based Virtual Machine) to provide hardware-level isolation. Unlike Docker containers, which share the host kernel, MicroSandbox creates true virtual machines with their own kernels. This provides much stronger security boundaries, even though the Docker container itself runs in privileged mode.

The privileged container is only the orchestrator - the actual untrusted code runs inside isolated VMs with hardware-enforced boundaries. This architecture is specifically designed for running untrusted code safely.

### KVM Device Access

The container requires access to `/dev/kvm` for hardware virtualization. This is mapped as:

```yaml
devices:
  - /dev/kvm:/dev/kvm
```

Ensure your host system's KVM device has appropriate permissions.

## Architecture Support

MicroSandbox supports both major architectures:

- **amd64** (x86_64): Intel and AMD processors
- **arm64** (aarch64): ARM-based processors (e.g., AWS Graviton, Apple Silicon via Linux VM)

The correct binary is automatically selected during the build process based on your target platform.

## Troubleshooting

### KVM Not Available

If you see errors about KVM not being available:

1. Verify hardware virtualization is enabled in BIOS
2. Check if KVM kernel module is loaded: `lsmod | grep kvm`
3. Ensure `/dev/kvm` exists and has correct permissions
4. Confirm you're running on a Linux host (not WSL2 or macOS)

### Permission Denied on /dev/kvm

```bash
# Add your user to the kvm group
sudo usermod -aG kvm $USER

# Or run with sudo
sudo docker compose run --rm microsandbox
```

### Performance Issues

If you experience slow performance:

- Increase CPU and memory limits in `.env`
- Verify KVM acceleration is working: `dmesg | grep kvm`
- Check host system resource availability

## References

- [MicroSandbox GitHub Repository](https://github.com/zerocore-ai/microsandbox)
- [Zerocore AI](https://zerocore.ai/)
- [KVM Documentation](https://www.linux-kvm.org/)

## License

MicroSandbox is an open-source project by Zerocore AI. Please refer to the [upstream repository](https://github.com/zerocore-ai/microsandbox) for license information.
