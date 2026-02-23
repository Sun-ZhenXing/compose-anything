# Kibana

[Kibana](https://www.elastic.co/kibana) 是一个免费且开源的用户界面，可让您可视化 Elasticsearch 数据并浏览 Elastic Stack。

## 功能特性

- 数据可视化：创建美观的可视化和仪表板
- 搜索和过滤：强大的搜索功能
- 机器学习：检测异常和模式
- 告警：基于数据设置告警
- 安全性：用户身份验证和授权

## 快速开始

启动 Kibana（需要 Elasticsearch）：

```bash
docker compose up -d
```

## 配置

### 环境变量

- `KIBANA_VERSION`: Kibana 版本（默认：`8.16.1`）
- `KIBANA_PORT_OVERRIDE`: HTTP 端口（默认：`5601`）
- `ELASTICSEARCH_HOSTS`: Elasticsearch 主机（默认：`http://elasticsearch:9200`）
- `ELASTICSEARCH_USERNAME`: Elasticsearch 用户名
- `ELASTICSEARCH_PASSWORD`: Elasticsearch 密码
- `KIBANA_SECURITY_ENABLED`: 启用安全（默认：`false`）
- `KIBANA_ENCRYPTION_KEY`: 保存对象的加密密钥
- `KIBANA_LOG_LEVEL`: 日志级别（默认：`info`）

## 访问

- Web UI: <http://localhost:5601>

## 前置要求

Kibana 需要运行 Elasticsearch。确保 Elasticsearch 在配置的 `ELASTICSEARCH_HOSTS` 可访问。

## 自定义配置

在 `docker-compose.yaml` 中取消配置卷的注释，并创建 `kibana.yml`：

```yaml
server.name: kibana
server.host: 0.0.0.0
elasticsearch.hosts: ['http://elasticsearch:9200']
monitoring.ui.container.elasticsearch.enabled: true
```

## 健康检查

检查 Kibana 状态：

```bash
curl http://localhost:5601/api/status
```

## 资源配置

- 资源限制：1 CPU，1G 内存
- 资源预留：0.25 CPU，512M 内存

## 常见任务

### 创建索引模式

1. 导航到 Management → Stack Management → Index Patterns
2. 点击 "Create index pattern"
3. 输入索引模式（例如：`logstash-*`）
4. 选择时间字段
5. 点击 "Create index pattern"

### 创建可视化

1. 导航到 Analytics → Visualize Library
2. 点击 "Create visualization"
3. 选择可视化类型
4. 配置可视化
5. 保存可视化

## 集成

Kibana 与以下组件配合使用：

- Elasticsearch（必需）
- Logstash（可选）
- Beats（可选）
- APM Server（可选）
