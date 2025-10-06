# Consul

[Consul](https://www.consul.io/) 是一个服务网络解决方案，用于自动化网络配置、发现服务，并在任何云或运行时环境中实现安全连接。

## 功能特性

- 服务发现：自动发现和注册服务
- 健康检查：监控服务健康状态和可用性
- 键值存储：存储配置数据
- 多数据中心：支持多个数据中心
- 服务网格：安全的服务间通信

## 快速开始

启动 Consul 服务器：

```bash
docker compose up -d
```

## 配置

### 环境变量

- `CONSUL_VERSION`: Consul 版本（默认：`1.20.3`）
- `CONSUL_HTTP_PORT_OVERRIDE`: HTTP API 端口（默认：`8500`）
- `CONSUL_DNS_PORT_OVERRIDE`: DNS 查询端口（默认：`8600`）
- `CONSUL_SERF_LAN_PORT_OVERRIDE`: Serf LAN 端口（默认：`8301`）
- `CONSUL_SERF_WAN_PORT_OVERRIDE`: Serf WAN 端口（默认：`8302`）
- `CONSUL_SERVER_RPC_PORT_OVERRIDE`: 服务器 RPC 端口（默认：`8300`）
- `CONSUL_BIND_INTERFACE`: 绑定的网络接口（默认：`eth0`）
- `CONSUL_CLIENT_INTERFACE`: 客户端网络接口（默认：`eth0`）

## 访问

- Web UI: <http://localhost:8500>
- HTTP API: <http://localhost:8500/v1>
- DNS 查询: localhost:8600

## 默认配置

默认配置以服务器模式运行 Consul：

- 单节点（引导模式）
- 启用 Web UI
- 日志级别：INFO
- 数据中心：dc1

## 自定义配置

在 `docker-compose.yaml` 中取消配置卷的注释，并创建 `consul.json`：

```json
{
  "datacenter": "dc1",
  "server": true,
  "ui_config": {
    "enabled": true
  },
  "bootstrap_expect": 1,
  "log_level": "INFO"
}
```

## 健康检查

检查 Consul 集群成员：

```bash
docker compose exec consul consul members
```

## 资源配置

- 资源限制：1 CPU，512MB 内存
- 资源预留：0.25 CPU，128MB 内存
