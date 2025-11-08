# Elasticsearch

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署 Elasticsearch，一个分布式搜索和分析引擎。

## 服务

- `elasticsearch`：Elasticsearch 服务

## 环境变量

| 变量名                                  | 说明                                  | 默认值           |
| --------------------------------------- | ------------------------------------- | ---------------- |
| `ELASTICSEARCH_VERSION`                 | Elasticsearch 镜像版本                | `8.16.1`         |
| `ELASTICSEARCH_HTTP_PORT_OVERRIDE`      | HTTP 主机端口映射（映射到端口 9200）  | `9200`           |
| `ELASTICSEARCH_TRANSPORT_PORT_OVERRIDE` | 传输层主机端口映射（映射到端口 9300） | `9300`           |
| `ELASTICSEARCH_CLUSTER_NAME`            | Elasticsearch 集群名称                | `docker-cluster` |
| `ELASTICSEARCH_DISCOVERY_TYPE`          | 单节点设置的发现类型                  | `single-node`    |
| `ELASTICSEARCH_SECURITY_ENABLED`        | 启用 X-Pack 安全功能                  | `false`          |
| `ELASTICSEARCH_SSL_ENABLED`             | 启用 SSL/TLS                          | `false`          |
| `ELASTICSEARCH_HEAP_SIZE`               | JVM 堆大小                            | `1g`             |

请根据实际需求修改 `.env` 文件。

## 卷

- `elasticsearch_data`：Elasticsearch 数据目录
- `elasticsearch_logs`：Elasticsearch 日志目录
- `./elasticsearch.yml`：可选的自定义 Elasticsearch 配置文件

## 使用方法

1. 启动服务：

   ```bash
   docker compose up -d
   ```

2. 等待 Elasticsearch 就绪：

   ```bash
   docker compose logs -f elasticsearch
   ```

3. 测试连接：

   ```bash
   curl http://localhost:9200
   ```

## 基本操作

```bash
# 检查集群健康状态
curl http://localhost:9200/_cluster/health

# 列出所有索引
curl http://localhost:9200/_cat/indices?v

# 创建索引
curl -X PUT "localhost:9200/my-index"

# 索引文档
curl -X POST "localhost:9200/my-index/_doc" \
  -H "Content-Type: application/json" \
  -d '{"name": "John Doe", "age": 30}'

# 搜索文档
curl -X GET "localhost:9200/my-index/_search" \
  -H "Content-Type: application/json" \
  -d '{"query": {"match_all": {}}}'
```

## 内存配置

Elasticsearch 需要足够的内存才能有效运行。默认配置分配 1GB 堆内存。对于生产环境，请考虑：

- 将 `ELASTICSEARCH_HEAP_SIZE` 设置为可用 RAM 的 50%（但不超过 31GB）
- 确保主机至少有 2GB 可用 RAM
- 适当配置交换内存

## 健康检查

该服务包含健康检查，用于验证 Elasticsearch 集群健康状态。

## 安全提示

- 此配置禁用了安全功能以便于开发
- 生产环境请启用 X-Pack 安全、SSL/TLS 和身份验证
- 配置适当的网络安全和防火墙规则
- 定期备份索引并更新 Elasticsearch 版本
