# Node Exporter

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署 Prometheus Node Exporter，用于暴露 *NIX 内核的硬件和操作系统指标。

## 服务

- `node-exporter`：Prometheus Node Exporter 服务

## 环境变量

| 变量名                        | 说明               | 默认值   |
| ----------------------------- | ------------------ | -------- |
| `NODE_EXPORTER_VERSION`       | Node Exporter 版本 | `v1.8.2` |
| `NODE_EXPORTER_PORT_OVERRIDE` | 主机端口映射       | `9100`   |

请根据实际需求修改 `.env` 文件。

## 使用方法

### 启动 Node Exporter

```bash
docker compose up -d
```

### 访问指标

- 指标端点：<http://localhost:9100/metrics>

### 配置 Prometheus

在 Prometheus 配置中添加此抓取配置：

```yaml
scrape_configs:
  - job_name: 'node'
    static_configs:
      - targets: ['localhost:9100']
```

## 收集的指标

Node Exporter 收集各种系统指标：

- **CPU**：使用率、频率、温度
- **内存**：使用量、可用量、缓存
- **磁盘**：I/O、空间使用
- **网络**：流量、错误
- **文件系统**：挂载点、使用情况
- **负载**：系统负载平均值
- **以及更多**

## 网络模式

为了获得更准确的指标，您可以使用主机网络模式运行 Node Exporter。在 `docker-compose.yaml` 中取消注释：

```yaml
network_mode: host
```

注意：使用主机网络模式时，不需要端口映射。

## 注意事项

- Node Exporter 应在您想要监控的每台主机上运行
- 该服务需要访问主机文件系统和进程
- 指标以 Prometheus 格式暴露
- 默认情况下不提供身份验证

## 安全性

- 如果 Prometheus 在同一主机上运行，仅绑定到 localhost
- 使用防火墙规则限制对指标端点的访问
- 生产环境中考虑使用带身份验证的反向代理
- 监控访问日志以发现可疑活动

## 许可证

Node Exporter 采用 Apache License 2.0 许可。详情请参见 [Node Exporter GitHub](https://github.com/prometheus/node_exporter)。
