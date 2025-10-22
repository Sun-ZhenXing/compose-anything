# ClickHouse

ClickHouse 是一个快速的开源列式数据库管理系统，支持实时生成分析数据报告。

## 使用方法

```bash
docker compose up -d
```

## 配置说明

主要环境变量：

- `CLICKHOUSE_DB`：默认数据库名称（默认：`default`）
- `CLICKHOUSE_USER`：默认用户名（默认：`default`）
- `CLICKHOUSE_PASSWORD`：默认用户密码（默认：`clickhouse`）
- `CLICKHOUSE_DEFAULT_ACCESS_MANAGEMENT`：启用 SQL 驱动的访问控制（默认：`1`）

## 端口说明

- `8123`：HTTP 接口
- `9000`：Native TCP 协议
- `9004`：MySQL 协议模拟
- `9005`：PostgreSQL 协议模拟

## 访问方式

### HTTP 接口

```bash
curl 'http://localhost:8123/?user=default&password=clickhouse' -d 'SELECT 1'
```

### ClickHouse 客户端

```bash
docker compose exec clickhouse clickhouse-client --user default --password clickhouse
```

### MySQL 协议

```bash
mysql -h127.0.0.1 -P9004 -udefault -pclickhouse
```

### PostgreSQL 协议

```bash
psql -h127.0.0.1 -p9005 -Udefault
```

## 示例查询

```sql
-- 创建表
CREATE TABLE events (
    event_date Date,
    event_type String,
    user_id UInt32
) ENGINE = MergeTree()
ORDER BY (event_date, event_type);

-- 插入数据
INSERT INTO events VALUES ('2024-01-01', 'click', 1), ('2024-01-01', 'view', 2);

-- 查询数据
SELECT * FROM events;
```

## 注意事项

- ClickHouse 专为 OLAP（在线分析处理）工作负载优化
- 擅长快速聚合大量数据
- 生产环境建议使用集群配置和复制功能
- 自定义配置可以挂载到 `/etc/clickhouse-server/config.d/` 和 `/etc/clickhouse-server/users.d/`

## 参考资料

- [ClickHouse 官方文档](https://clickhouse.com/docs)
- [ClickHouse Docker Hub](https://hub.docker.com/r/clickhouse/clickhouse-server)
