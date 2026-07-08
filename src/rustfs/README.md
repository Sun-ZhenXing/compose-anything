# RustFS

[English](./README.md) | [中文](./README.zh.md)

RustFS is a high-performance, S3-compatible distributed object storage system built in Rust. It is 2.3x faster than MinIO for 4KB object payloads, fully open-source under the Apache 2.0 license, and supports migration and coexistence with other S3-compatible platforms such as MinIO and Ceph.

Open the Console: <http://localhost:9001>.

## Services

- `rustfs`: The RustFS object storage service.

## Quick Start

```bash
docker compose up -d
```

The default credentials are `rustfsadmin` / `rustfsadmin`. The S3 API is available at <http://localhost:9000> and the Console at <http://localhost:9001>.

## Configuration

- `RUSTFS_VERSION`: The version of the RustFS image (glibc-based), default is `1.0.0-beta.8-glibc`.
- `RUSTFS_PORT_OVERRIDE_API`: The host port for the S3 API, default is `9000`.
- `RUSTFS_PORT_OVERRIDE_CONSOLE`: The host port for the Console Web UI, default is `9001`.
- `RUSTFS_ACCESS_KEY`: The root access key, default is `rustfsadmin`.
- `RUSTFS_SECRET_KEY`: The root secret key, default is `rustfsadmin`.
- `RUSTFS_ADDRESS`: The S3 API listen address, default is `0.0.0.0:9000`.
- `RUSTFS_CONSOLE_ADDRESS`: The Console listen address, default is `0.0.0.0:9001`.
- `RUSTFS_CONSOLE_ENABLE`: Enable the Web Console, default is `true`.
- `RUSTFS_CONSOLE_CORS_ALLOWED_ORIGINS`: CORS allowed origins for the Console, default is `*`.
- `RUSTFS_OBS_LOGGER_LEVEL`: Log level (`info`, `debug`, `warn`, `error`), default is `info`.
- `RUSTFS_UNSAFE_BYPASS_DISK_CHECK`: Bypass strict disk topology checks (for local dev only), default is `false`.
- `TZ`: Timezone setting, default is `UTC`.

## Volumes

- `rustfs_data`: A named volume for storing RustFS object data.

## Security Notes

- The container runs as a non-root user (`10001:10001`). If you switch to host bind mounts, ensure the mounted directories are writable by this user.
- The default credentials are `rustfsadmin` / `rustfsadmin`. Change these in production.
- `no-new-privileges:true` is enforced by default.
