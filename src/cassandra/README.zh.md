# Apache Cassandra

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署 Apache Cassandra，一个高度可扩展的 NoSQL 分布式数据库。

## 服务

- `cassandra`：Cassandra 数据库服务

## 环境变量

| 变量名                           | 说明                                   | 默认值                        |
| -------------------------------- | -------------------------------------- | ----------------------------- |
| `CASSANDRA_VERSION`              | Cassandra 镜像版本                     | `5.0.2`                       |
| `CASSANDRA_CQL_PORT_OVERRIDE`    | CQL 主机端口映射（映射到端口 9042）    | `9042`                        |
| `CASSANDRA_THRIFT_PORT_OVERRIDE` | Thrift 主机端口映射（映射到端口 9160） | `9160`                        |
| `CASSANDRA_CLUSTER_NAME`         | Cassandra 集群名称                     | `Test Cluster`                |
| `CASSANDRA_DC`                   | 数据中心名称                           | `datacenter1`                 |
| `CASSANDRA_RACK`                 | 机架名称                               | `rack1`                       |
| `CASSANDRA_ENDPOINT_SNITCH`      | 端点嗅探器配置                         | `GossipingPropertyFileSnitch` |
| `CASSANDRA_NUM_TOKENS`           | 每个节点的令牌数                       | `256`                         |
| `CASSANDRA_SEEDS`                | 用于集群发现的种子节点                 | `cassandra`                   |
| `CASSANDRA_START_RPC`            | 启用 Thrift RPC 接口                   | `false`                       |
| `MAX_HEAP_SIZE`                  | JVM 最大堆大小                         | `1G`                          |
| `HEAP_NEWSIZE`                   | JVM 新生代堆大小                       | `100M`                        |

请根据实际需求修改 `.env` 文件。

## 卷

- `cassandra_data`：Cassandra 数据目录
- `cassandra_logs`：Cassandra 日志目录
- `./cassandra.yaml`：可选的自定义 Cassandra 配置文件

## 使用方法

1. 启动服务：

   ```bash
   docker compose up -d
   ```

2. 等待 Cassandra 就绪（查看日志）：

   ```bash
   docker compose logs -f cassandra
   ```

3. 使用 cqlsh 连接：

   ```bash
   docker exec -it cassandra cqlsh
   ```

## 基本 CQL 命令

```sql
-- 创建键空间
CREATE KEYSPACE test_keyspace
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

-- 使用键空间
USE test_keyspace;

-- 创建表
CREATE TABLE users (
    id UUID PRIMARY KEY,
    name TEXT,
    email TEXT
);

-- 插入数据
INSERT INTO users (id, name, email)
VALUES (uuid(), 'John Doe', 'john@example.com');

-- 查询数据
SELECT * FROM users;
```

## 健康检查

该服务包含健康检查，用于验证 Cassandra 是否响应 CQL 查询。

## 安全提示

- 此配置用于开发/测试目的
- 生产环境请启用身份验证和 SSL/TLS
- 配置适当的网络安全和防火墙规则
- 定期备份数据并更新 Cassandra 版本
