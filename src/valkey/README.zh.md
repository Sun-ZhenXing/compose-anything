# Valkey

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署 Valkey，一个开源的 Redis 替代方案，从 Redis 7.2 分叉而来。

## 服务

- `valkey`: Valkey 服务。

## 环境变量

| 变量名               | 说明                                          | 默认值       |
| -------------------- | --------------------------------------------- | ------------ |
| VALKEY_VERSION       | Valkey 镜像版本                               | `8.0-alpine` |
| VALKEY_PASSWORD      | 认证密码                                      | `passw0rd`   |
| VALKEY_PORT_OVERRIDE | 主机端口映射（映射到容器内 Valkey 端口 6379） | `6379`       |

请根据实际需求修改 `.env` 文件。

## 卷

- `valkey_data`: 用于存储 Valkey 数据的卷，启用了 AOF（仅追加文件）持久化。
- `valkey.conf`: 可选的自定义配置文件（挂载到 `/etc/valkey/valkey.conf`）。

## 功能

Valkey 完全兼容 Redis 并提供：

- 内存数据结构存储
- 支持字符串、哈希、列表、集合、有序集合
- 发布/订阅消息传递
- 事务
- 持久化（RDB 快照和 AOF）
- 复制
- Lua 脚本
- LRU 驱逐

## 注意事项

- 默认启用 AOF 持久化以提高数据持久性。
- 对于生产环境，建议使用自定义配置文件。
- Valkey 与 Redis 客户端和命令 100% 兼容。
- 这是由 Linux 基金会维护的开源替代方案。

## 许可证

Valkey 使用 BSD 3-Clause 许可证授权。
