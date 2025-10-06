# Valkey 集群

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署包含 6 个节点（3 个主节点和 3 个副本）的 Valkey 集群。

## 服务

- `valkey-node-1` 到 `valkey-node-6`: 六个 Valkey 集群节点。
- `valkey-cluster-init`: 创建集群的初始化服务。

## 环境变量

| 变量名              | 说明               | 默认值       |
| ------------------- | ------------------ | ------------ |
| VALKEY_VERSION      | Valkey 镜像版本    | `8.0-alpine` |
| VALKEY_PASSWORD     | 认证密码           | `passw0rd`   |
| VALKEY_PORT_1-6     | 节点的主机端口     | 7001-7006    |
| VALKEY_BUS_PORT_1-6 | 集群总线的主机端口 | 17001-17006  |

请根据实际需求修改 `.env` 文件。

## 卷

- `valkey_data_1` 到 `valkey_data_6`: 用于存储每个节点的 Valkey 数据的卷。

## 集群配置

集群配置如下：

- **6 个节点**: 3 个主节点和 3 个副本
- **复制因子**: 1（每个主节点有 1 个副本）
- **哈希槽**: 自动分布在主节点之间
- **自动故障转移**: 已启用

## 连接

使用任何启用集群模式的 Valkey/Redis 客户端连接到集群：

```bash
# 使用 valkey-cli
valkey-cli -c -h localhost -p 7001 -a passw0rd

# 使用 redis-cli（兼容）
redis-cli -c -h localhost -p 7001 -a passw0rd
```

## 注意事项

- `valkey-cluster-init` 服务运行一次以创建集群，然后停止。
- 如果需要重新创建集群，请删除所有卷并重新启动。
- 对于生产环境，建议在不同的机器上使用至少 6 个节点。
- 集群要求所有节点彼此可达。

## 扩展

要向集群添加更多节点：

1. 在 `docker-compose.yaml` 中添加新的节点服务
2. 启动新节点
3. 使用 `valkey-cli --cluster add-node` 将它们添加到集群
4. 如果需要，重新平衡哈希槽

## 许可证

Valkey 使用 BSD 3-Clause 许可证授权。
