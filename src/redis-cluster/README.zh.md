# Redis Cluster

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署一个包含 6 个节点（3 个主节点 + 3 个从节点）的 Redis 集群。

## 服务

- `redis-1` 到 `redis-6`：Redis 集群节点
- `redis-cluster-init`：初始化容器（一次性设置）

## 环境变量

| 变量名          | 说明           | 默认值         |
| --------------- | -------------- | -------------- |
| `REDIS_VERSION` | Redis 镜像版本 | `8.2.1-alpine` |

请根据实际需求修改 `.env` 文件。

## 卷

- `redis_1_data` 到 `redis_6_data`：每个 Redis 节点的数据持久化

## 使用方法

### 启动 Redis 集群

```bash
# 启动所有 Redis 节点
docker compose up -d

# 初始化集群（仅首次）
docker compose --profile init up redis-cluster-init

# 验证集群状态
docker exec redis-1 redis-cli --cluster check redis-1:6379
```

### 连接到集群

```bash
# 使用 redis-cli 连接
docker exec -it redis-1 redis-cli -c

# 测试集群
127.0.0.1:6379> CLUSTER INFO
127.0.0.1:6379> SET mykey "Hello"
127.0.0.1:6379> GET mykey
```

### 从应用程序访问

在应用程序中使用集群模式连接：

```python
# Python 示例
from redis.cluster import RedisCluster

startup_nodes = [
    {"host": "localhost", "port": "7000"},
    {"host": "localhost", "port": "7001"},
    {"host": "localhost", "port": "7002"},
]
rc = RedisCluster(startup_nodes=startup_nodes, decode_responses=True)
rc.set("foo", "bar")
print(rc.get("foo"))
```

## 端口

- 7000-7005：映射到每个 Redis 节点的 6379 端口

## 集群信息

- **主节点**：3 个节点（redis-1、redis-2、redis-3）
- **从节点**：3 个节点（redis-4、redis-5、redis-6）
- **总槽数**：16384（分布在主节点间）

## 添加新节点

向集群添加更多节点：

1. 在 `docker-compose.yaml` 中添加新服务
2. 启动新节点
3. 添加到集群：

```bash
docker exec redis-1 redis-cli --cluster add-node new-node-ip:6379 redis-1:6379
docker exec redis-1 redis-cli --cluster reshard redis-1:6379
```

## 移除节点

```bash
# 移除节点
docker exec redis-1 redis-cli --cluster del-node redis-1:6379 <node-id>
```

## 注意事项

- 集群初始化只需执行一次
- 每个节点存储数据的子集
- Redis 集群自动处理故障转移
- 生产环境至少需要 3 个主节点
- 数据自动复制到从节点

## 安全性

- 生产环境添加密码验证：

```bash
command: redis-server --requirepass yourpassword --cluster-enabled yes ...
```

- 使用防火墙规则限制访问
- 生产环境中考虑使用 TLS 进行节点间通信

## 许可证

Redis 采用 Redis Source Available License 2.0（RSALv2）许可。详情请参见 [Redis GitHub](https://github.com/redis/redis)。
