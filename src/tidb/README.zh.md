# TiDB

TiDB 是一个开源、云原生、分布式 SQL 数据库，专为现代应用程序设计。它兼容 MySQL 协议，提供水平扩展能力、强一致性和高可用性。

## 使用方法

```bash
docker compose up -d
```

## 组件说明

此配置包含：

- **PD (Placement Driver)**：管理和调度 TiKV
- **TiKV**：分布式事务键值存储
- **TiDB**：无状态 SQL 层

## 端口说明

- `4000`：TiDB MySQL 协议端口
- `10080`：TiDB 状态和指标端口
- `2379`：PD 客户端端口
- `20160`：TiKV 端口

## 访问方式

### MySQL 客户端

TiDB 兼容 MySQL 协议：

```bash
mysql -h127.0.0.1 -P4000 -uroot
```

### 使用示例

```sql
-- 创建数据库
CREATE DATABASE test;
USE test;

-- 创建表
CREATE TABLE users (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(100)
);

-- 插入数据
INSERT INTO users VALUES (1, 'Alice', 'alice@example.com');

-- 查询数据
SELECT * FROM users;
```

### 状态和指标

检查 TiDB 状态：

```bash
curl http://localhost:10080/status
```

## 特性

- **MySQL 兼容**：可作为 MySQL 的直接替代品
- **水平扩展**：通过添加更多节点进行扩展
- **强一致性**：分布式数据的 ACID 事务
- **高可用性**：自动故障转移，无数据丢失
- **混合事务/分析处理（HTAP）**：同时支持 OLTP 和 OLAP 工作负载

## 注意事项

- 这是一个最小的单节点配置，适合开发环境
- 生产环境需要部署多个 PD、TiKV 和 TiDB 节点
- 考虑添加 TiFlash 以支持分析工作负载
- 生产部署使用 Prometheus 和 Grafana 进行监控
- 数据持久化在命名卷中

## 高级配置

生产部署建议：

- 为 PD、TiKV 和 TiDB 使用独立的机器
- 部署至少 3 个 PD 节点以实现高可用
- 部署至少 3 个 TiKV 节点以实现数据复制
- 添加 TiFlash 以提供列式存储和更快的分析查询
- 使用 TiDB Dashboard、Prometheus 和 Grafana 设置监控

## 参考资料

- [TiDB 官方文档](https://docs.pingcap.com/zh/tidb/stable)
- [TiDB 快速开始](https://docs.pingcap.com/zh/tidb/stable/quick-start-with-tidb)
- [TiDB Docker 镜像](https://hub.docker.com/u/pingcap)
