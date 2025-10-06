# OpenSearch

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署 OpenSearch（Elasticsearch 分支）和 OpenSearch Dashboards（Kibana 分支）。

## 服务

- `opensearch`: 用于搜索和分析的 OpenSearch 服务器。
- `opensearch-dashboards`: 用于可视化的 OpenSearch Dashboards。

## 环境变量

| 变量名                                 | 说明                       | 默认值               |
| -------------------------------------- | -------------------------- | -------------------- |
| OPENSEARCH_VERSION                     | OpenSearch 镜像版本        | `2.19.0`             |
| OPENSEARCH_DASHBOARDS_VERSION          | OpenSearch Dashboards 版本 | `2.19.0`             |
| CLUSTER_NAME                           | 集群名称                   | `opensearch-cluster` |
| OPENSEARCH_HEAP_SIZE                   | JVM 堆大小                 | `512m`               |
| OPENSEARCH_ADMIN_PASSWORD              | 管理员密码                 | `Admin@123`          |
| DISABLE_SECURITY_PLUGIN                | 禁用安全插件               | `false`              |
| OPENSEARCH_PORT_OVERRIDE               | OpenSearch API 端口        | `9200`               |
| OPENSEARCH_PERF_ANALYZER_PORT_OVERRIDE | 性能分析器端口             | `9600`               |
| OPENSEARCH_DASHBOARDS_PORT_OVERRIDE    | Dashboards UI 端口         | `5601`               |

请根据实际需求修改 `.env` 文件。

## 卷

- `opensearch_data`: OpenSearch 数据存储。

## 使用方法

### 启动服务

```bash
docker-compose up -d
```

### 访问 OpenSearch

OpenSearch API:

```bash
curl -XGET https://localhost:9200 -u 'admin:Admin@123' --insecure
```

### 访问 OpenSearch Dashboards

在浏览器中打开:

```text
http://localhost:5601
```

使用用户名 `admin` 和 `OPENSEARCH_ADMIN_PASSWORD` 中设置的密码登录。

### 创建索引

```bash
curl -XPUT https://localhost:9200/my-index -u 'admin:Admin@123' --insecure
```

### 索引文档

```bash
curl -XPOST https://localhost:9200/my-index/_doc -u 'admin:Admin@123' --insecure \
  -H 'Content-Type: application/json' \
  -d '{"title": "Hello OpenSearch", "content": "This is a test document"}'
```

### 搜索文档

```bash
curl -XGET https://localhost:9200/my-index/_search -u 'admin:Admin@123' --insecure \
  -H 'Content-Type: application/json' \
  -d '{"query": {"match": {"title": "Hello"}}}'
```

## 功能

- **全文搜索**: 具有相关性评分的高级搜索功能
- **分析**: 实时数据分析和聚合
- **可视化**: 使用 OpenSearch Dashboards 创建丰富的仪表板
- **安全性**: 内置安全插件，具有身份验证和加密功能
- **RESTful API**: 易于与任何编程语言集成
- **可扩展**: 开发环境使用单节点，生产环境使用集群模式

## 注意事项

- 默认管理员密码必须至少包含 8 个字符，包括大写字母、小写字母、数字和特殊字符
- 对于生产环境，请更改管理员密码并考虑使用外部证书
- JVM 堆大小应设置为可用内存的 50%（最大 31GB）
- 可以通过设置 `DISABLE_SECURITY_PLUGIN=true` 禁用安全插件进行测试
- 对于集群模式，添加更多节点并配置 `discovery.seed_hosts`

## 许可证

OpenSearch 使用 Apache License 2.0 授权。
