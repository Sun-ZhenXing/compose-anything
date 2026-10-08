# RustDesk Server OSS

[English](./README.md) | [中文](./README.zh.md)

Self-host the open-source RustDesk ID/rendezvous (`hbbs`) and relay (`hbbr`) servers. This stack uses the official pinned s6 image, which supervises both daemons in one container to keep the deployment small. It is the OSS server, not the Pro web console or account/API service.

## Services

| Compose service | Daemon | Purpose |
| --- | --- | --- |
| `rustdesk` | `hbbs` and `hbbr` | ID/rendezvous and relay services, supervised together |

## Quick Start

```sh
cd src/rustdesk
docker compose up -d
docker compose ps
```

The default advertised relay address (`127.0.0.1:21117`) only supports clients on the same Docker host. Before remote use, create `.env` from `.env.example` and set `RUSTDESK_RELAY_SERVER` to an address reachable by clients, for example `rustdesk.example.com:21117`, then start the stack. The value must be one `host:port` with no whitespace.

Retrieve the public key for client configuration:

```sh
docker compose exec rustdesk cat /data/id_ed25519.pub
```

In the RustDesk client, set **ID Server** to the reachable server address (port `21116` by default), **Relay Server** to the same address configured in `RUSTDESK_RELAY_SERVER`, and **Key** to the public key above. Leave **API Server** blank.

For same-host evaluation, use `127.0.0.1:21116` as **ID Server** and `127.0.0.1:21117` as **Relay Server**.

## Ports

| Host port | Protocol | Purpose |
| --- | --- | --- |
| `21115` | TCP | NAT test |
| `21116` | TCP and UDP | ID/rendezvous |
| `21117` | TCP | Relay |

Ports `21114` (Pro API) and `21118`/`21119` (optional web client/websocket services) are not published. They are not needed for standard desktop clients. If enabling optional web access, add explicit mappings and place it behind a trusted reverse proxy.

## Environment Variables

| Variable | Description | Default |
| --- | --- | --- |
| `RUSTDESK_VERSION` | Official server image version | `1.1.16` |
| `TZ` | Container timezone | `UTC` |
| `RUSTDESK_RELAY_SERVER` | Relay address advertised to clients (`host:port`) | `127.0.0.1:21117` |
| `RUSTDESK_NAT_PORT_OVERRIDE` | Published NAT-test TCP port | `21115` |
| `RUSTDESK_ID_PORT_OVERRIDE` | Published ID/rendezvous TCP and UDP port | `21116` |
| `RUSTDESK_RELAY_PORT_OVERRIDE` | Published relay TCP port | `21117` |
| `RUSTDESK_CPU_LIMIT` / `RUSTDESK_MEMORY_LIMIT` | Container resource limits | `1` / `256M` |
| `RUSTDESK_CPU_RESERVATION` / `RUSTDESK_MEMORY_RESERVATION` | Resource reservations | `0.1` / `64M` |

When changing the ID port, set the NAT-test port to the ID port minus one, and keep TCP and UDP on the same ID port. If changing the relay port, also update `RUSTDESK_RELAY_SERVER` and the client configuration.

## Storage

The named volume `rustdesk_data` persists `/data`, including `id_ed25519`, `id_ed25519.pub`, and `db_v2.sqlite3`. Back up this volume; deleting it with `docker compose down -v` permanently removes the server identity and state.

## Security and Networking

- Only distribute `id_ed25519.pub`; keep the private `id_ed25519` key secret and protect volume backups.
- Open and forward TCP `21115`–`21117` and UDP `21116` in the host firewall/router as applicable. Remote clients require actual network reachability; the default localhost relay address is not remotely reachable.
- Bridge networking is portable but can impair peer-to-peer/direct connectivity compared with Linux host networking. The relay remains available when reachable; this configuration does not guarantee full client networking through every NAT/firewall.
- `ENCRYPTED_ONLY=1` passes `-k _` to both daemons, enabling server-key matching. Clients must supply the matching public key; mismatches are rejected.
- The official s6 image initializes key ownership as root and uses writable runtime paths. This stack retains the upstream user, capabilities, and filesystem settings rather than imposing unverified non-root or read-only settings. It adds `no-new-privileges` and does not require privileged mode or host socket mounts.
- Healthcheck confirms that both supervised daemons report as up. It does not establish public reachability or successful peer-to-peer connections.

## References

- [RustDesk server Docker documentation](https://rustdesk.com/docs/en/self-host/rustdesk-server-oss/docker/)
- [RustDesk client configuration](https://rustdesk.com/docs/en/self-host/client-configuration/)
- [Official s6 image Dockerfile](https://github.com/rustdesk/rustdesk-server/blob/1.1.16/docker/Dockerfile)
