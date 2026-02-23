# Prometheus

[English](./README.md) | [中文](./README.zh.md)

本服务部署 Prometheus，这是一个开源的系统监控和警报工具包，具有多维数据模型和强大的查询语言。

## 服务

- `prometheus`: 用于抓取和存储时间序列数据的 Prometheus 服务器。

## 环境变量

| 变量名                    | 描述                                                | 默认值                  |
| ------------------------- | --------------------------------------------------- | ----------------------- |
| PROMETHEUS_VERSION        | Prometheus 镜像版本                                 | `v3.5.0`                |
| PROMETHEUS_PORT_OVERRIDE  | 主机端口映射（映射到容器中的 Prometheus 端口 9090） | `9090`                  |
| PROMETHEUS_RETENTION_TIME | 数据保留时间                                        | `15d`                   |
| PROMETHEUS_RETENTION_SIZE | 最大存储大小（空值 = 无限制）                       | `""`                    |
| PROMETHEUS_EXTERNAL_URL   | Prometheus 的外部 URL（用于链接和重定向）           | `http://localhost:9090` |

请根据您的使用情况修改 `.env` 文件。

## 数据卷

- `prometheus_data`: 用于存储 Prometheus 时间序列数据的数据卷。
- `prometheus.yml`: 可选的自定义配置文件（挂载到 `/etc/prometheus/prometheus.yml`）。
- `rules`: 用于警报和记录规则的可选目录（挂载到 `/etc/prometheus/rules`）。

## 默认配置

默认的 Prometheus 配置包括：

- 抓取自身的指标
- 全局抓取间隔为 15 秒
- 基本的 Web 控制台访问

## 配置文件

### 自定义 Prometheus 配置

将自定义 `prometheus.yml` 文件挂载到 `/etc/prometheus/prometheus.yml`：

```yaml
volumes:
  - ./prometheus.yml:/etc/prometheus/prometheus.yml
```

示例 `prometheus.yml`：

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets: ['localhost:9090']

  - job_name: node_exporter
    static_configs:
      - targets: ['node_exporter:9100']
```

### 警报规则

将规则目录挂载到 `/etc/prometheus/rules`：

```yaml
volumes:
  - ./rules:/etc/prometheus/rules
```

## 数据保留

使用环境变量配置数据保留：

- `PROMETHEUS_RETENTION_TIME`: 基于时间的保留（例如，`30d`、`1y`）
- `PROMETHEUS_RETENTION_SIZE`: 基于大小的保留（例如，`10GB`、`1TB`）

## API 访问

- Web UI: `http://localhost:9090`
- API 端点: `http://localhost:9090/api/v1/`
- 启用了管理 API 用于配置重新加载

## 安全注意事项

- 考虑在生产环境中限制对管理 API 的访问
- 为生产部署使用身份验证/授权代理
- 监控资源使用情况，因为 Prometheus 可能消耗大量存储和内存

## 常见用例

### 监控 Docker 容器

添加 cAdvisor 来监控容器指标：

```yaml
services:
  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    ports:
      - '8080:8080'
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
      - /dev/disk/:/dev/disk:ro
```

### 服务发现

使用基于文件的服务发现或与 Consul 或 Kubernetes 等服务发现系统集成。

## 许可证

Prometheus 采用 Apache 2.0 许可证。
