# DuckDB

DuckDB 是一个进程内 SQL OLAP 数据库管理系统，专为支持分析查询工作负载而设计。它是嵌入式的、零依赖的，并且速度极快。

## 使用方法

```bash
docker compose up -d
```

## 访问方式

### 交互式 Shell

访问 DuckDB CLI：

```bash
docker compose exec duckdb duckdb /data/duckdb.db
```

### 执行查询

直接运行查询：

```bash
docker compose exec duckdb duckdb /data/duckdb.db -c "SELECT 1"
```

### 执行 SQL 文件

```bash
docker compose exec duckdb duckdb /data/duckdb.db < query.sql
```

## 使用示例

```sql
-- 创建表
CREATE TABLE users (id INTEGER, name VARCHAR);

-- 插入数据
INSERT INTO users VALUES (1, 'Alice'), (2, 'Bob');

-- 查询数据
SELECT * FROM users;

-- 加载 CSV 文件
COPY users FROM '/import/users.csv' (HEADER);

-- 导出到 CSV
COPY users TO '/data/users_export.csv' (HEADER);

-- 直接读取 Parquet 文件
SELECT * FROM '/import/data.parquet';
```

## 特性

- **可嵌入**：无需单独的服务器进程
- **快速**：向量化查询执行引擎
- **功能丰富**：完整的 SQL 支持，包括窗口函数、CTE 等
- **文件格式**：原生支持 CSV、JSON、Parquet
- **扩展**：兼容 PostgreSQL 的扩展

## 挂载数据文件

要导入数据文件，将它们作为卷挂载：

```yaml
volumes:
  - ./data:/import:ro
```

然后在 SQL 中访问文件：

```sql
SELECT * FROM '/import/data.csv';
```

## 注意事项

- DuckDB 专为分析（OLAP）工作负载设计，而非事务（OLTP）
- 数据库文件存储在 `/data/duckdb.db`
- 数据持久化在命名卷 `duckdb_data` 中
- DuckDB 可以直接查询文件而无需导入
- 生产工作负载需确保分配足够的内存

## 参考资料

- [DuckDB 官方文档](https://duckdb.org/docs/)
- [DuckDB Docker 镜像](https://hub.docker.com/r/davidgasquez/duckdb)
