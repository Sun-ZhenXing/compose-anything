# Valkey

[English](./README.md) | [中文](./README.zh.md)

This service deploys Valkey, an open-source alternative to Redis that began as a fork of Redis 7.2.

## Services

- `valkey`: The Valkey service.

## Environment Variables

| Variable Name        | Description                                               | Default Value |
| -------------------- | --------------------------------------------------------- | ------------- |
| VALKEY_VERSION       | Valkey image version                                      | `8.0-alpine`  |
| VALKEY_PASSWORD      | Password for authentication                               | `passw0rd`    |
| VALKEY_PORT_OVERRIDE | Host port mapping (maps to Valkey port 6379 in container) | `6379`        |

Please modify the `.env` file as needed for your use case.

## Volumes

- `valkey_data`: A volume for storing Valkey data with AOF (Append Only File) persistence enabled.
- `valkey.conf`: Optional custom configuration file (mount to `/etc/valkey/valkey.conf`).

## Features

Valkey is fully compatible with Redis and provides:

- In-memory data structure store
- Support for strings, hashes, lists, sets, sorted sets
- Pub/Sub messaging
- Transactions
- Persistence (RDB snapshots and AOF)
- Replication
- Lua scripting
- LRU eviction

## Notes

- AOF persistence is enabled by default for better data durability.
- For production use, consider using a custom configuration file.
- Valkey is 100% compatible with Redis clients and commands.
- This is an open-source alternative maintained by the Linux Foundation.

## License

Valkey is licensed under the BSD 3-Clause License.
