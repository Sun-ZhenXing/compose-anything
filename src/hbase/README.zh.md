# HBase

HBase 是一个构建在 Hadoop 之上的分布式、可扩展的大数据存储系统，提供对大数据的随机、实时读写访问。

## 使用方法

```bash
docker compose up -d
```

## 配置说明

此配置运行 HBase 独立模式，内置 ZooKeeper。

## 端口说明

- `16000`：HBase Master 端口
- `16010`：HBase Master Web UI
- `16020`：HBase RegionServer 端口
- `16030`：HBase RegionServer Web UI
- `2181`：ZooKeeper 客户端端口

## 访问方式

### HBase Shell

访问 HBase shell：

```bash
docker compose exec hbase hbase shell
```

### Web UI

- HBase Master UI：<http://localhost:16010>
- HBase RegionServer UI：<http://localhost:16030>

### 示例命令

```bash
# 列出所有表
echo "list" | docker compose exec -T hbase hbase shell -n

# 创建表
echo "create 'test', 'cf'" | docker compose exec -T hbase hbase shell -n

# 插入数据
echo "put 'test', 'row1', 'cf:a', 'value1'" | docker compose exec -T hbase hbase shell -n

# 扫描表
echo "scan 'test'" | docker compose exec -T hbase hbase shell -n
```

## 注意事项

- 这是一个独立模式配置，适合开发和测试
- 生产环境建议使用分布式 HBase 集群，配合外部 ZooKeeper 和 HDFS
- 数据持久化在命名卷中

## 参考资料

- [HBase 官方文档](https://hbase.apache.org/book.html)
- [HBase Docker 镜像](https://hub.docker.com/r/harisekhon/hbase)
