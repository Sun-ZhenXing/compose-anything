# Rust MCP Filesystem Server

Rust MCP Filesystem Server is a high-performance filesystem MCP server built with Rust, providing fast and secure file operations.

## Features

- 🚀 **High Performance** - Rust-powered high-performance file operations
- 🔒 **Secure Access** - Configurable access control
- 📁 **File Operations** - File read/write, directory traversal
- 🔍 **File Search** - Fast file searching
- 📊 **File Info** - File metadata queries
- ⚡ **Async I/O** - Asynchronous file I/O operations

## Environment Variables

| Variable                            | Default       | Description                  |
| ----------------------------------- | ------------- | ---------------------------- |
| `RUST_MCP_FILESYSTEM_VERSION`       | `latest`      | Docker image version         |
| `RUST_MCP_FILESYSTEM_PORT_OVERRIDE` | `8000`        | Service port                 |
| `ALLOWED_PATHS`                     | `/projects`   | Allowed access paths         |
| `HOST_WORKSPACE_PATH`               | `./workspace` | Host workspace path to mount |
| `TZ`                                | `UTC`         | Timezone                     |

## Quick Start

### 1. Configure Environment

Create a `.env` file:

```env
RUST_MCP_FILESYSTEM_VERSION=latest
RUST_MCP_FILESYSTEM_PORT_OVERRIDE=8000
ALLOWED_PATHS=/projects
HOST_WORKSPACE_PATH=/path/to/your/workspace
TZ=Asia/Shanghai
```

### 2. Configure File Access

In `docker-compose.yaml`, configure directories to access:

```yaml
volumes:
  # Read-only access
  - /path/to/workspace:/projects/workspace:ro
  # Read-write access (remove :ro)
  - /path/to/data:/projects/data
```

### 3. Start Service

```bash
docker compose up -d
```

### 4. Verify Service

```bash
curl http://localhost:8000/health
```

## Security Features

The service implements multiple layers of security:

1. **Read-only Filesystem**: Container filesystem set to read-only
2. **Permission Restrictions**: Minimized container permissions
3. **Path Restrictions**: Only configured paths can be accessed
4. **No Privilege Escalation**: Prevents privilege escalation
5. **Capability Restrictions**: Only necessary Linux capabilities retained

## Performance Characteristics

- ✅ **Zero-copy**: Leverages Rust's zero-copy features
- ✅ **Async I/O**: High-concurrency file operations
- ✅ **Memory Safety**: Memory safety guaranteed by Rust
- ✅ **Low Resource Usage**: Minimum 64MB memory

## Resource Requirements

- Minimum memory: 64MB
- Recommended memory: 256MB
- CPU: 0.25-1.0 cores

## Common Use Cases

1. **Code Repository Access** - Allow AI to access and analyze codebases
2. **Document Processing** - Read and process document files
3. **Log Analysis** - Analyze log files
4. **Configuration Management** - Read and update configuration files

## Security Recommendations

⚠️ **Important**: When using:

1. Only mount necessary directories
2. Prefer read-only mode (`:ro`)
3. Do not mount sensitive system directories
4. Regularly audit access logs
5. Use firewall to restrict network access

## Comparison with Other Implementations

| Feature       | Rust Implementation | Node.js Implementation |
| ------------- | ------------------- | ---------------------- |
| Performance   | ⭐⭐⭐⭐⭐               | ⭐⭐⭐                    |
| Memory Usage  | 64MB+               | 128MB+                 |
| Concurrency   | Excellent           | Good                   |
| Startup Speed | Fast                | Medium                 |

## References

- [Rust Official Site](https://www.rust-lang.org/)
- [MCP Documentation](https://modelcontextprotocol.io/)
- [Docker Hub - mcp/rust-mcp-filesystem](https://hub.docker.com/r/mcp/rust-mcp-filesystem)

## License

MIT License
