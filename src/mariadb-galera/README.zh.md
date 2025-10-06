# MariaDB Galera 集群

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署 3 节点 MariaDB Galera 集群，提供高可用性和同步多主复制。

## 服务

- `mariadb-galera-1`: 第一个 MariaDB Galera 节点（引导节点）。
- `mariadb-galera-2`: 第二个 MariaDB Galera 节点。
- `mariadb-galera-3`: 第三个 MariaDB Galera 节点。

## 环境变量

| 变量名                      | 说明             | 默认值           |
| --------------------------- | ---------------- | ---------------- |
| MARIADB_VERSION             | MariaDB 镜像版本 | `11.7.2`         |
| MARIADB_ROOT_PASSWORD       | root 用户密码    | `galera`         |
| MARIADB_GALERA_CLUSTER_NAME | Galera 集群名称  | `galera_cluster` |
| MARIADB_PORT_1_OVERRIDE     | 节点 1 端口      | `3306`           |
| MARIADB_PORT_2_OVERRIDE     | 节点 2 端口      | `3307`           |
| MARIADB_PORT_3_OVERRIDE     | 节点 3 端口      | `3308`           |

请根据实际需求修改 `.env` 文件。

## 卷

- `mariadb_galera_1_data`: 节点 1 数据存储。
- `mariadb_galera_2_data`: 节点 2 数据存储。
- `mariadb_galera_3_data`: 节点 3 数据存储。

## 使用方法

### 启动集群

```bash
docker-compose up -d
```

第一个节点 (mariadb-galera-1) 使用 `--wsrep-new-cluster` 引导集群。其他节点自动加入。

### 连接到集群

连接到任何节点:

```bash
mysql -h 127.0.0.1 -P 3306 -u root -p
```

或者:

```bash
mysql -h 127.0.0.1 -P 3307 -u root -p
mysql -h 127.0.0.1 -P 3308 -u root -p
```

### 检查集群状态

```sql
SHOW STATUS LIKE 'wsrep_cluster_size';
SHOW STATUS LIKE 'wsrep_local_state_comment';
```

`wsrep_cluster_size` 应该为 3，`wsrep_local_state_comment` 应显示 "Synced"。

## 功能

- **多主复制**: 所有节点同时接受写入
- **同步复制**: 数据在提交前复制到所有节点
- **自动故障转移**: 如果一个节点失败，集群继续运行
- **高可用性**: 3 个节点无单点故障
- **任意节点读写**: 连接到任何节点进行读写操作

## 注意事项

- 第一个节点 (mariadb-galera-1) 必须首先启动作为引导节点
- 所有节点必须能够相互通信
- 对于生产环境，考虑添加更多节点（5、7 等）以获得更好的容错能力
- 使用奇数个节点以避免脑裂场景
- 生产环境请更改默认 root 密码
- 集群使用 `rsync` 进行状态快照传输（SST）

## 扩展

要添加更多节点，请按照节点 2 和 3 的模式添加新的服务定义，并更新 `wsrep_cluster_address` 以包含所有节点。

## 许可证

MariaDB 使用 GPL v2 许可证授权。
