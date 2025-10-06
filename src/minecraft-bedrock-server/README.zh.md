# Minecraft Bedrock 服务器

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署 Minecraft 基岩版专用服务器。

## 服务

- `minecraft-bedrock`: Minecraft 基岩版服务器。

## 环境变量

| 变量名                  | 说明                                      | 默认值             |
| ----------------------- | ----------------------------------------- | ------------------ |
| BEDROCK_VERSION         | 基岩版服务器 Docker 镜像版本              | `latest`           |
| MINECRAFT_VERSION       | Minecraft 版本（LATEST、PREVIEW 或具体）  | `LATEST`           |
| EULA                    | 接受 Minecraft EULA（必须为 TRUE）        | `TRUE`             |
| GAMEMODE                | 游戏模式（survival、creative、adventure） | `survival`         |
| DIFFICULTY              | 难度（peaceful、easy、normal、hard）      | `easy`             |
| SERVER_NAME             | 服务器名称                                | `Dedicated Server` |
| MAX_PLAYERS             | 最大玩家数                                | `10`               |
| ALLOW_CHEATS            | 允许作弊                                  | `false`            |
| LEVEL_NAME              | 世界名称                                  | `Bedrock level`    |
| LEVEL_SEED              | 世界种子（留空随机生成）                  | `""`               |
| ONLINE_MODE             | 启用在线模式                              | `true`             |
| WHITE_LIST              | 启用白名单                                | `false`            |
| SERVER_PORT             | 服务器端口（IPv4）                        | `19132`            |
| SERVER_PORT_V6          | 服务器端口（IPv6）                        | `19133`            |
| SERVER_PORT_OVERRIDE    | 主机端口映射（IPv4）                      | `19132`            |
| SERVER_PORT_V6_OVERRIDE | 主机端口映射（IPv6）                      | `19133`            |
| UID                     | 运行服务器的用户 ID                       | `1000`             |
| GID                     | 运行服务器的组 ID                         | `1000`             |

请根据实际需求修改 `.env` 文件。

## 卷

- `bedrock_data`: 用于存储 Minecraft 世界数据和服务器文件的卷。

## 端口

- **19132/udp**: 主要的基岩版服务器端口（IPv4）。
- **19133/udp**: 基岩版服务器端口（IPv6）。

## 注意事项

- 必须设置 `EULA=TRUE` 以接受 Minecraft 最终用户许可协议。
- 服务器使用 UDP 协议，请确保防火墙允许指定端口的 UDP 流量。
- 要启用白名单，设置 `WHITE_LIST=true` 并在数据卷中的 `allowlist.json` 文件中添加玩家 XUID。
- 支持 `LATEST` 稳定版本和 `PREVIEW` 预览版本。

## 许可证

Minecraft 是 Mojang AB 的商标。此 Docker 镜像使用官方 Minecraft 基岩版服务器软件，受 [Minecraft 最终用户许可协议](https://minecraft.net/terms)约束。
