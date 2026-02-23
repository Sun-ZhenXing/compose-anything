# Apache APISIX

[English](./README.md) | [中文](./README.zh.md)

本服务部署 Apache APISIX，这是一个动态、实时、高性能的云原生 API 网关。

## 服务

- `apisix`: APISIX API 网关。
- `etcd`: APISIX 的配置存储后端。
- `apisix-dashboard`（可选）: 用于管理 APISIX 配置的 Web UI。

## 环境变量

| 变量名                         | 描述                                  | 默认值          |
| ------------------------------ | ------------------------------------- | --------------- |
| APISIX_VERSION                 | APISIX 镜像版本                       | `3.13.0-debian` |
| APISIX_HTTP_PORT_OVERRIDE      | HTTP 流量的主机端口映射（9080）       | `9080`          |
| APISIX_HTTPS_PORT_OVERRIDE     | HTTPS 流量的主机端口映射（9443）      | `9443`          |
| APISIX_ADMIN_PORT_OVERRIDE     | Admin API 的主机端口映射（9180）      | `9180`          |
| APISIX_STAND_ALONE             | 以独立模式运行 APISIX（不使用 etcd）  | `false`         |
| ETCD_VERSION                   | etcd 镜像版本                         | `v3.6.0`        |
| ETCD_CLIENT_PORT_OVERRIDE      | etcd 客户端连接的主机端口映射（2379） | `2379`          |
| APISIX_DASHBOARD_VERSION       | APISIX Dashboard 镜像版本             | `3.0.1-alpine`  |
| APISIX_DASHBOARD_PORT_OVERRIDE | Dashboard 的主机端口映射（9000）      | `9000`          |
| APISIX_DASHBOARD_USER          | Dashboard 管理员用户名                | `admin`         |
| APISIX_DASHBOARD_PASSWORD      | Dashboard 管理员密码                  | `admin`         |

请根据您的使用情况修改 `.env` 文件。

## 数据卷

- `apisix_logs`: 用于存储 APISIX 日志的数据卷。
- `etcd_data`: 用于存储 etcd 配置数据的数据卷。
- `dashboard_conf`: 用于存储 Dashboard 配置的数据卷。
- `config.yaml`: 可选的自定义 APISIX 配置文件（挂载到 `/usr/local/apisix/conf/config.yaml`）。
- `apisix.yaml`: 可选的自定义 APISIX 路由配置文件（挂载到 `/usr/local/apisix/conf/apisix.yaml`）。

## 网络端口

- `9080`: HTTP 流量端口
- `9443`: HTTPS 流量端口
- `9180`: Admin API 端口
- `9000`: Dashboard Web 界面（可选）
- `2379`: etcd 客户端端口

## 使用方法

### 基本设置

1. 启动服务：

   ```bash
   docker compose up -d
   ```

2. 访问 Admin API：

   ```bash
   curl http://localhost:9180/apisix/admin/routes
   ```

### 使用 Dashboard

要启用 Web 仪表板，使用 `dashboard` 配置文件：

```bash
docker compose --profile dashboard up -d
```

在 `http://localhost:9000` 访问仪表板，凭据：

- 用户名: `admin`（可通过 `APISIX_DASHBOARD_USER` 配置）
- 密码: `admin`（可通过 `APISIX_DASHBOARD_PASSWORD` 配置）

### 创建路由

#### 使用 Admin API

创建简单路由：

```bash
curl -X PUT http://localhost:9180/apisix/admin/routes/1 \
  -H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' \
  -H 'Content-Type: application/json' \
  -d '{
    "uri": "/get",
    "upstream": {
      "type": "roundrobin",
      "nodes": {
        "httpbin.org:80": 1
      }
    }
  }'
```

测试路由：

```bash
curl http://localhost:9080/get
```

#### 使用 Admin Dashboard

1. 在 `http://localhost:9000` 访问仪表板
2. 使用管理员凭据登录
3. 导航到"路由"部分
4. 通过 Web 界面创建和配置路由

### 配置文件

#### 自定义 APISIX 配置

挂载自定义 `config.yaml` 文件：

```yaml
volumes:
  - ./config.yaml:/usr/local/apisix/conf/config.yaml
```

示例 `config.yaml`：

```yaml
apisix:
  node_listen: 9080
  enable_ipv6: false
  enable_admin: true
  port_admin: 9180

etcd:
  host:
    - 'http://etcd:2379'
  prefix: /apisix
  timeout: 30

plugin_attr:
  prometheus:
    export_addr:
      ip: 0.0.0.0
      port: 9091
```

#### 独立模式

对于不使用 etcd 的简单设置，启用独立模式：

```env
APISIX_STAND_ALONE=true
```

挂载带有路由定义的 `apisix.yaml` 文件：

```yaml
volumes:
  - ./apisix.yaml:/usr/local/apisix/conf/apisix.yaml
```

### SSL/TLS 配置

要启用 HTTPS：

1. 挂载 SSL 证书
2. 在 `config.yaml` 中配置 SSL
3. 创建启用 SSL 的路由

SSL 卷挂载示例：

```yaml
volumes:
  - ./ssl:/usr/local/apisix/conf/cert
```

### 插件

APISIX 支持众多插件，用于身份验证、速率限制、日志记录等：

- 身份验证: `jwt-auth`、`key-auth`、`oauth`
- 速率限制: `limit-req`、`limit-conn`、`limit-count`
- 可观察性: `prometheus`、`zipkin`、`skywalking`
- 安全性: `cors`、`csrf`、`ip-restriction`

通过 Admin API 或 Dashboard 启用插件。

## 安全注意事项

- **在生产环境中更改默认 Admin API 密钥**（`edd1c9f034335f136f87ad84b625c8f1`）
- **为生产使用更改仪表板凭据**
- 为 HTTPS 配置适当的 SSL/TLS 证书
- 对敏感路由使用身份验证插件
- 实施速率限制以防止滥用
- 建议定期进行安全更新

## 监控

APISIX 为 Prometheus 提供内置指标：

- 启用 `prometheus` 插件
- 指标可在 `http://localhost:9091/apisix/prometheus/metrics` 获得

## 性能调优

- 根据 CPU 核心数调整工作进程
- 配置适当的缓冲区大小
- 为上游服务使用连接池
- 在适当时启用响应缓存

## 许可证

Apache APISIX 采用 Apache 2.0 许可证。
