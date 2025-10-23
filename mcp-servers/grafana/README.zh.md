# Grafana MCP Server

Grafana MCP Server 提供通过模型上下文协议（MCP）与 Grafana 监控和可视化平台集成的能力。

## 功能特性

- 📊 **仪表板管理** - 创建和管理仪表板
- 📈 **查询数据源** - 查询数据源
- 🔍 **搜索仪表板** - 搜索仪表板
- 🚨 **事件调查** - 调查事件
- 📉 **指标分析** - 分析指标
- 🎨 **可视化** - 数据可视化

## 架构

该服务包含两个容器：

- **mcp-grafana**：MCP 服务器，提供与 Grafana 的 AI 交互接口
- **grafana**：Grafana 实例

## 环境变量

| 变量                        | 默认值                  | 说明                             |
| --------------------------- | ----------------------- | -------------------------------- |
| `MCP_GRAFANA_VERSION`       | `latest`                | MCP Grafana 镜像版本             |
| `GRAFANA_VERSION`           | `latest`                | Grafana 版本                     |
| `MCP_GRAFANA_PORT_OVERRIDE` | `8000`                  | MCP 服务端口                     |
| `GRAFANA_PORT_OVERRIDE`     | `3000`                  | Grafana 端口                     |
| `GRAFANA_URL`               | `http://grafana:3000`   | Grafana 实例 URL                 |
| `GRAFANA_API_KEY`           | -                       | Grafana API 密钥（必需）         |
| `GRAFANA_ADMIN_USER`        | `admin`                 | 管理员用户名                     |
| `GRAFANA_ADMIN_PASSWORD`    | `admin`                 | 管理员密码（⚠️ 生产环境请修改！） |
| `GRAFANA_INSTALL_PLUGINS`   | -                       | 要安装的插件（逗号分隔）         |
| `GRAFANA_ROOT_URL`          | `http://localhost:3000` | Grafana 根 URL                   |
| `TZ`                        | `UTC`                   | 时区                             |

## 快速开始

### 1. 配置环境

创建 `.env` 文件：

```env
MCP_GRAFANA_VERSION=latest
GRAFANA_VERSION=latest
MCP_GRAFANA_PORT_OVERRIDE=8000
GRAFANA_PORT_OVERRIDE=3000
GRAFANA_ADMIN_USER=admin
GRAFANA_ADMIN_PASSWORD=your_secure_password
GRAFANA_ROOT_URL=http://localhost:3000
TZ=Asia/Shanghai
```

### 2. 启动服务

```bash
docker compose up -d
```

### 3. 获取 API 密钥

1. 访问 Grafana：<http://localhost:3000>
2. 使用管理员凭据登录
3. 导航到 **Configuration** → **API Keys**
4. 创建新的 API 密钥
5. 将密钥添加到 `.env` 文件：`GRAFANA_API_KEY=your_key_here`
6. 重启 mcp-grafana 服务：`docker compose restart mcp-grafana`

### 4. 验证服务

```bash
# 验证 MCP 服务
curl http://localhost:8000/health

# 验证 Grafana 服务
curl http://localhost:3000/api/health
```

## 资源需求

- **MCP 服务**：128MB-512MB 内存，0.25-1.0 CPU
- **Grafana**：256MB-1GB 内存，0.5-2.0 CPU

## 常见使用场景

1. **仪表板搜索** - 使用自然语言查找仪表板
2. **数据查询** - 从数据源查询指标数据
3. **告警管理** - 查看和管理告警规则
4. **可视化创建** - 创建新的可视化面板
5. **事件分析** - 调查和分析监控事件

## 安全建议

⚠️ **重要**：在生产环境中：

1. 修改默认管理员密码
2. 使用强密码和安全的 API 密钥
3. 启用 HTTPS/TLS 加密
4. 限制网络访问
5. 定期轮换 API 密钥
6. 设置适当的用户权限

## 数据持久化

- `grafana_data`：Grafana 数据目录
- `grafana_config`：Grafana 配置目录
- `grafana_logs`：Grafana 日志目录

## 参考链接

- [Grafana 官方网站](https://grafana.com/)
- [Grafana API 文档](https://grafana.com/docs/grafana/latest/developers/http_api/)
- [MCP 文档](https://modelcontextprotocol.io/)
- [Docker Hub - grafana/grafana](https://hub.docker.com/r/grafana/grafana)

## 许可证

MIT License
