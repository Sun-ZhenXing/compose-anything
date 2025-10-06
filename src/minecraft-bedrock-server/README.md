# Minecraft Bedrock Server

[English](./README.md) | [中文](./README.zh.md)

This service deploys a Minecraft Bedrock Edition dedicated server.

## Services

- `minecraft-bedrock`: The Minecraft Bedrock server.

## Environment Variables

| Variable Name           | Description                                      | Default Value      |
| ----------------------- | ------------------------------------------------ | ------------------ |
| BEDROCK_VERSION         | Bedrock server Docker image version              | `latest`           |
| MINECRAFT_VERSION       | Minecraft version (LATEST, PREVIEW, or specific) | `LATEST`           |
| EULA                    | Accept Minecraft EULA (must be TRUE)             | `TRUE`             |
| GAMEMODE                | Game mode (survival, creative, adventure)        | `survival`         |
| DIFFICULTY              | Difficulty (peaceful, easy, normal, hard)        | `easy`             |
| SERVER_NAME             | Server name                                      | `Dedicated Server` |
| MAX_PLAYERS             | Maximum number of players                        | `10`               |
| ALLOW_CHEATS            | Allow cheats                                     | `false`            |
| LEVEL_NAME              | Level/world name                                 | `Bedrock level`    |
| LEVEL_SEED              | Level seed (empty for random)                    | `""`               |
| ONLINE_MODE             | Enable online mode                               | `true`             |
| WHITE_LIST              | Enable whitelist                                 | `false`            |
| SERVER_PORT             | Server port (IPv4)                               | `19132`            |
| SERVER_PORT_V6          | Server port (IPv6)                               | `19133`            |
| SERVER_PORT_OVERRIDE    | Host port mapping for IPv4                       | `19132`            |
| SERVER_PORT_V6_OVERRIDE | Host port mapping for IPv6                       | `19133`            |
| UID                     | User ID to run the server                        | `1000`             |
| GID                     | Group ID to run the server                       | `1000`             |

Please modify the `.env` file as needed for your use case.

## Volumes

- `bedrock_data`: A volume for storing Minecraft world data and server files.

## Ports

- **19132/udp**: The main Bedrock server port (IPv4).
- **19133/udp**: The Bedrock server port (IPv6).

## Notes

- You must accept the Minecraft EULA by setting `EULA=TRUE`.
- The server uses UDP protocol, so ensure your firewall allows UDP traffic on the specified ports.
- To enable whitelist, set `WHITE_LIST=true` and add player XUIDs to the `allowlist.json` file in the data volume.
- Supports both `LATEST` stable releases and `PREVIEW` versions.

## License

Minecraft is a trademark of Mojang AB. This Docker image uses the official Minecraft Bedrock Server software, which is subject to the [Minecraft End User License Agreement](https://minecraft.net/terms).
