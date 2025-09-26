# Grafana

[English](./README.md) | [中文](./README.zh.md)

本服务部署 Grafana，这是一个开源的分析和监控平台，用于可视化来自各种数据源的指标。

## 服务

- `grafana`: Grafana Web 界面和 API 服务器。

## 环境变量

| 变量名                 | 描述                                             | 默认值                  |
| ---------------------- | ------------------------------------------------ | ----------------------- |
| GRAFANA_VERSION        | Grafana 镜像版本                                 | `12.1.1`                |
| GRAFANA_PORT_OVERRIDE  | 主机端口映射（映射到容器中的 Grafana 端口 3000） | `3000`                  |
| GRAFANA_ADMIN_USER     | 管理员用户名                                     | `admin`                 |
| GRAFANA_ADMIN_PASSWORD | 管理员密码                                       | `admin`                 |
| GRAFANA_ALLOW_SIGN_UP  | 允许用户自行注册                                 | `false`                 |
| GRAFANA_PLUGINS        | 要安装的插件列表（逗号分隔）                     | `""`                    |
| GRAFANA_ROOT_URL       | Grafana 的根 URL（用于链接和重定向）             | `http://localhost:3000` |
| GRAFANA_SECRET_KEY     | 用于签名 cookies 和加密数据库的密钥              | `""`                    |

请根据您的使用情况修改 `.env` 文件。

## 数据卷

- `grafana_data`: 用于存储 Grafana 数据库和配置的数据卷。
- `grafana_logs`: 用于存储 Grafana 日志的数据卷。
- `grafana.ini`: 可选的自定义配置文件（挂载到 `/etc/grafana/grafana.ini`）。
- `provisioning`: 用于预配置数据源和仪表板的可选目录（挂载到 `/etc/grafana/provisioning`）。

## 默认凭据

- 用户名: `admin`（可通过 `GRAFANA_ADMIN_USER` 配置）
- 密码: `admin`（可通过 `GRAFANA_ADMIN_PASSWORD` 配置）

## 安全注意事项

- **在生产环境中更改默认管理员密码**。
- 为生产环境设置强 `GRAFANA_SECRET_KEY`。
- 考虑在生产环境中禁用注册（`GRAFANA_ALLOW_SIGN_UP=false`）。
- 通过配置反向代理或 Grafana 的 TLS 设置在生产环境中使用 HTTPS。

## 常见用例

### 安装插件

使用逗号分隔的插件 ID 列表设置 `GRAFANA_PLUGINS` 环境变量：

```env
GRAFANA_PLUGINS=grafana-clock-panel,grafana-simple-json-datasource
```

### 自定义配置

将自定义 `grafana.ini` 文件挂载到 `/etc/grafana/grafana.ini`：

```yaml
volumes:
  - ./grafana.ini:/etc/grafana/grafana.ini
```

### 预配置数据源和仪表板

挂载包含数据源和仪表板配置的预配置目录：

```yaml
volumes:
  - ./provisioning:/etc/grafana/provisioning
```

## 许可证

Grafana 采用 AGPL v3.0 许可证。商业许可证可从 Grafana Labs 获得。
