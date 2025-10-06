# Logstash

[Logstash](https://www.elastic.co/logstash) 是一个免费且开源的服务器端数据处理管道，从多种来源摄取数据，转换数据，然后将其发送到您喜欢的"存储"位置。

## 功能特性

- 数据摄取：从各种来源收集数据
- 数据转换：解析、过滤和丰富数据
- 数据输出：将数据发送到 Elasticsearch、数据库或其他目标
- 插件生态系统：用于输入、过滤器和输出的广泛插件库

## 快速开始

启动 Logstash：

```bash
docker compose up -d
```

## 配置

### 环境变量

- `LOGSTASH_VERSION`: Logstash 版本（默认：`8.16.1`）
- `LOGSTASH_BEATS_PORT_OVERRIDE`: Beats 输入端口（默认：`5044`）
- `LOGSTASH_TCP_PORT_OVERRIDE`: TCP 输入端口（默认：`5000`）
- `LOGSTASH_UDP_PORT_OVERRIDE`: UDP 输入端口（默认：`5000`）
- `LOGSTASH_HTTP_PORT_OVERRIDE`: HTTP API 端口（默认：`9600`）
- `LOGSTASH_MONITORING_ENABLED`: 启用监控（默认：`false`）
- `ELASTICSEARCH_HOSTS`: Elasticsearch 主机（默认：`http://elasticsearch:9200`）
- `ELASTICSEARCH_USERNAME`: Elasticsearch 用户名
- `ELASTICSEARCH_PASSWORD`: Elasticsearch 密码
- `LS_JAVA_OPTS`: Java 选项（默认：`-Xmx1g -Xms1g`）
- `LOGSTASH_PIPELINE_WORKERS`: 管道工作线程数（默认：`2`）
- `LOGSTASH_PIPELINE_BATCH_SIZE`: 管道批处理大小（默认：`125`）
- `LOGSTASH_PIPELINE_BATCH_DELAY`: 管道批处理延迟（毫秒）（默认：`50`）
- `LOGSTASH_LOG_LEVEL`: 日志级别（默认：`info`）

## 管道配置

在 `./pipeline` 目录中创建管道配置文件。示例 `logstash.conf`：

```conf
input {
  beats {
    port => 5044
  }
  tcp {
    port => 5000
  }
}

filter {
  grok {
    match => { "message" => "%{COMBINEDAPACHELOG}" }
  }
  date {
    match => [ "timestamp", "dd/MMM/yyyy:HH:mm:ss Z" ]
  }
}

output {
  elasticsearch {
    hosts => ["${ELASTICSEARCH_HOSTS}"]
    index => "logstash-%{+YYYY.MM.dd}"
  }
  stdout {
    codec => rubydebug
  }
}
```

## 访问

- HTTP API: <http://localhost:9600>
- 监控: <http://localhost:9600/_node/stats>

## 健康检查

检查 Logstash 状态：

```bash
curl http://localhost:9600/_node/stats
```

## 自定义配置

在 `docker-compose.yaml` 中取消配置卷的注释，并创建：

- `logstash.yml`: 主配置
- `pipelines.yml`: 管道定义

## 资源配置

- 资源限制：1.5 CPU，2G 内存
- 资源预留：0.5 CPU，1G 内存
