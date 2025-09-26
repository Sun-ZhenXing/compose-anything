# etcd

[English](./README.md) | [中文](./README.zh.md)

本服务部署 etcd，这是一个分布式、可靠的键值存储，用于分布式系统的最关键数据。

## 服务

- `etcd`: etcd 键值存储服务。

## 环境变量

| 变量名                         | 描述                                | 默认值                            |
| ------------------------------ | ----------------------------------- | --------------------------------- |
| ETCD_VERSION                   | etcd 镜像版本                       | `v3.6.0`                          |
| ETCD_CLIENT_PORT_OVERRIDE      | 客户端连接的主机端口映射（2379）    | `2379`                            |
| ETCD_PEER_PORT_OVERRIDE        | 对等连接的主机端口映射（2380）      | `2380`                            |
| ETCD_NAME                      | 此 etcd 成员的人类可读名称          | `etcd-node`                       |
| ETCD_INITIAL_CLUSTER           | 初始集群配置                        | `etcd-node=http://localhost:2380` |
| ETCD_INITIAL_CLUSTER_STATE     | 初始集群状态（'new' 或 'existing'） | `new`                             |
| ETCD_INITIAL_CLUSTER_TOKEN     | 用于引导的初始集群令牌              | `etcd-cluster`                    |
| ETCD_AUTO_COMPACTION_RETENTION | 自动压缩保留时间（小时）            | `1`                               |
| ETCD_QUOTA_BACKEND_BYTES       | 存储大小限制（字节）                | `2147483648` (2GB)                |
| ETCD_HEARTBEAT_INTERVAL        | 心跳间隔（毫秒）                    | `100`                             |
| ETCD_ELECTION_TIMEOUT          | 选举超时（毫秒）                    | `1000`                            |
| ETCD_ENABLE_V2                 | 启用 etcd v2 API                    | `false`                           |

请根据您的使用情况修改 `.env` 文件。

## 数据卷

- `etcd_data`: 用于持久存储 etcd 数据的数据卷。

## 网络端口

- `2379`: 客户端通信端口
- `2380`: 对等通信端口（用于集群）

## 单节点设置

默认配置将 etcd 作为单节点运行，适用于开发和测试。

## 集群设置

要设置多节点 etcd 集群，您需要：

1. 在您的 compose 文件中定义多个 etcd 服务
2. 正确配置 `ETCD_INITIAL_CLUSTER` 变量
3. 为每个节点设置唯一名称

3 节点集群示例：

```yaml
services:
  etcd1:
    # ... 基础配置
    environment:
      - ETCD_NAME=etcd1
      - ETCD_INITIAL_CLUSTER=etcd1=http://etcd1:2380,etcd2=http://etcd2:2380,etcd3=http://etcd3:2380
      - ETCD_ADVERTISE_CLIENT_URLS=http://etcd1:2379
      - ETCD_INITIAL_ADVERTISE_PEER_URLS=http://etcd1:2380

  etcd2:
    # ... 基础配置
    environment:
      - ETCD_NAME=etcd2
      - ETCD_INITIAL_CLUSTER=etcd1=http://etcd1:2380,etcd2=http://etcd2:2380,etcd3=http://etcd3:2380
      - ETCD_ADVERTISE_CLIENT_URLS=http://etcd2:2379
      - ETCD_INITIAL_ADVERTISE_PEER_URLS=http://etcd2:2380

  etcd3:
    # ... 基础配置
    environment:
      - ETCD_NAME=etcd3
      - ETCD_INITIAL_CLUSTER=etcd1=http://etcd1:2380,etcd2=http://etcd2:2380,etcd3=http://etcd3:2380
      - ETCD_ADVERTISE_CLIENT_URLS=http://etcd3:2379
      - ETCD_INITIAL_ADVERTISE_PEER_URLS=http://etcd3:2380
```

## 客户端访问

### 使用 etcdctl

使用 etcdctl 客户端连接到 etcd：

```bash
# 设置端点
export ETCDCTL_ENDPOINTS=http://localhost:2379

# 放置键值对
etcdctl put mykey myvalue

# 获取值
etcdctl get mykey

# 列出所有键
etcdctl get --prefix ""
```

### 使用 HTTP API

etcd 提供 RESTful HTTP API：

```bash
# 放置键值对
curl -X PUT http://localhost:2379/v3/kv/put \
  -H 'Content-Type: application/json' \
  -d '{"key":"bXlrZXk=","value":"bXl2YWx1ZQ=="}'

# 获取值
curl -X POST http://localhost:2379/v3/kv/range \
  -H 'Content-Type: application/json' \
  -d '{"key":"bXlrZXk="}'
```

## 性能调优

- 根据您的存储需求调整 `ETCD_QUOTA_BACKEND_BYTES`
- 根据您的网络延迟调整 `ETCD_HEARTBEAT_INTERVAL` 和 `ETCD_ELECTION_TIMEOUT`
- 配置 `ETCD_AUTO_COMPACTION_RETENTION` 来管理数据大小

## 安全注意事项

- 默认配置仅适用于开发/测试
- 对于生产环境，启用 TLS 加密和身份验证
- 考虑网络安全和防火墙规则
- 建议定期备份

## 监控

etcd 在 `http://localhost:2379/metrics` 以 Prometheus 格式公开指标。

## 许可证

etcd 采用 Apache 2.0 许可证。
