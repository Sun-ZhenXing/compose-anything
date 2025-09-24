# PocketBase

[English](./README.md) | [中文](./README.zh.md)

PocketBase is an open source backend consisting of a realtime database, authentication, file storage and more. It can be used as a standalone app or embedded into your Go projects.

## Services

- `pocketbase`: The PocketBase service.

## Configuration

- `PB_VERSION`: The version of the PocketBase image, default is `0.30.0`.
- `PB_PORT`: The host port for PocketBase, default is `8090`.
- `PB_ADMIN_EMAIL`: The admin email, default is `admin@example.com`.
- `PB_ADMIN_PASSWORD`: The admin password, default is `supersecret123`.
- `PB_ENCRYPTION`: Optional encryption key (32 characters).

## Volumes

- `pb_data`: A volume for storing PocketBase data.
- `pb_public`: Optional public folder.
- `pb_hooks`: Optional hooks folder.
