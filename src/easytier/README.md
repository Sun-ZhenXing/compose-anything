# EasyTier

[English](./README.md) | [中文](./README.zh.md)

[EasyTier](https://github.com/EasyTier/EasyTier) is a mesh VPN networking tool that lets you build a private, encrypted overlay network across hosts that are behind NAT or firewalls. This stack deploys EasyTier as a **public relay server** — a stable entry point that peers can use for discovery and traffic relay when direct connections are not possible.

## Services

- `easytier`: EasyTier core node running in relay-only mode (`--no-tun`), without creating a local TUN interface.

## Ports

| Port       | Protocol | Description                                                        |
| ---------- | -------- | ------------------------------------------------------------------ |
| `11010`    | TCP      | Peer connection listener — must be publicly reachable              |
| `11010`    | UDP      | Peer connection listener — must be publicly reachable              |
| `15888`    | TCP      | Management RPC portal (bound to `127.0.0.1` by default)           |

## Environment Variables

| Variable                    | Description                                         | Default          |
| --------------------------- | --------------------------------------------------- | ---------------- |
| `EASYTIER_VERSION`          | EasyTier image version                              | `v2.6.0`         |
| `TZ`                        | Timezone                                            | `UTC`            |
| `EASYTIER_NETWORK_NAME`     | Virtual network name shared by all peers            | `easytier`       |
| `EASYTIER_NETWORK_SECRET`   | Network secret (password); **required**             | `""`             |
| `EASYTIER_IPV4`             | Virtual IPv4 of this server node                    | `10.144.144.1`   |
| `EASYTIER_TCP_PORT_OVERRIDE`| Host port for peer TCP listener                     | `11010`          |
| `EASYTIER_UDP_PORT_OVERRIDE`| Host port for peer UDP listener                     | `11010`          |
| `EASYTIER_RPC_PORT_OVERRIDE`| Host port for management RPC (localhost only)       | `15888`          |
| `EASYTIER_CPU_LIMIT`        | CPU limit                                           | `0.50`           |
| `EASYTIER_MEMORY_LIMIT`     | Memory limit                                        | `128M`           |

## Quick Start

1. Copy `.env.example` and set a strong network secret:

   ```bash
   cp .env.example .env
   ```

   Edit `.env`:

   ```env
   EASYTIER_NETWORK_NAME=myvpn
   EASYTIER_NETWORK_SECRET=<your-strong-secret>
   ```

   Generate a secret with: `openssl rand -hex 16`

2. Start the server:

   ```bash
   docker compose up -d
   ```

3. Verify the node is healthy:

   ```bash
   docker compose exec easytier easytier-cli -p 127.0.0.1:15888 node info
   ```

4. On each peer machine, connect to this server:

   ```bash
   easytier-core \
     --network-name myvpn \
     --network-secret <your-strong-secret> \
     --peers tcp://<server-public-ip>:11010 \
     --ipv4 10.144.144.2
   ```

## Storage

This stack does not use persistent volumes. Configuration is provided entirely via command-line flags derived from environment variables.

## Security Notes

- **`EASYTIER_NETWORK_SECRET` is required.** An empty secret leaves the network open to any peer that knows the network name. Always set a strong random value before exposing this server to the internet.
- The management RPC port (`15888`) is bound to `127.0.0.1` by default. Do not expose it publicly unless you have separate authentication in place.
- Ports `11010/tcp` and `11010/udp` must be open in your firewall / cloud security group for peers to reach this server.
- This stack runs in `--no-tun` relay mode. No kernel TUN device is created, so no elevated capabilities (`NET_ADMIN`) are required and `cap_drop: ALL` is applied.
- If you need this server node to also participate as a VPN peer (with a local virtual interface), remove `--no-tun` from `command` and add `cap_add: [NET_ADMIN]` to the service.

## Documentation

- [EasyTier GitHub](https://github.com/EasyTier/EasyTier)
- [EasyTier Documentation](https://www.easytier.top/guide/introduction.html)
