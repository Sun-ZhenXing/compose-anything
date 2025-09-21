# Compose Anything

Compose Anything helps users quickly deploy various services by providing a set of high-quality Docker Compose configuration files. These configurations constrain resource usage, can be easily migrated to systems like K8S, and are easy to understand and modify.

## Supported Services

| Service              | Version |
| -------------------- | ------- |
| [Redis](./src/redis) | 8.2.1   |

## Guidelines

1. **Out-of-the-box**: Configurations should work out-of-the-box, requiring no setup to start (at most, provide a `.env` file).
2. **Simple Commands**
    - Each project provides a single `docker-compose.yaml` file.
    - Command complexity should not exceed the `docker compose` command; if it does, provide a `Makefile`.
    - If a service requires initialization, use `depends_on` to simulate Init containers.
3. **Stable Versions**
    - Provide the latest stable image version instead of `latest`.
    - Allow version configuration via environment variables.
4. **Highly Configurable**
    - Prefer configuration via environment variables rather than complex command-line arguments.
    - Sensitive information like passwords should be passed via environment variables or mounted files, not hardcoded.
    - Provide reasonable defaults so services can start with zero configuration.
    - Provide a well-commented `.env.example` file to help users get started quickly.
    - Use Profiles for optional dependencies.
5. **Cross-Platform**: (Where supported by the image) Ensure compatibility with major platforms.
    - Compatibility: Debian 12+/Ubuntu 22.04+, Windows 10+, macOS 12+.
    - Support multiple architectures where possible, such as x86-64 and ARM64.
6. **Careful Mounting**
    - Use relative paths for configuration file mounts to ensure cross-platform compatibility.
    - Use named volumes for data directories to avoid permission and compatibility issues with host path mounts.
7. **Default Resource Limits**
    - Limit CPU and memory usage for each service to prevent accidental resource exhaustion.
    - Limit log file size to prevent logs from filling up the disk.
    - For GPU services, enable single GPU by default.
8. **Comprehensive Documentation**
    - Provide good documentation and examples to help users get started and understand the configurations.
    - Clearly explain how to initialize accounts, admin accounts, etc.
    - Provide security and license notes when necessary.
    - Offer LLM-friendly documentation for easy querying and understanding by language models.
9. **Best Practices**: Follow other best practices to ensure security, performance, and maintainability.

## License

MIT License.
