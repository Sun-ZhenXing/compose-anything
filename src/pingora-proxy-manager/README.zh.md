# Pingora Proxy Manager

基于 Cloudflare [Pingora](https://github.com/cloudflare/pingora) 构建的高性能、零停机反向代理管理器。简单、现代、快速。

## 特性

- **⚡️ 高性能**：基于 Rust 和 Pingora 构建，能够以低延迟处理高流量
- **🔄 零停机配置**：动态重新配置，无需重启进程
- **🔒 SSL/TLS 自动化**：
  - HTTP-01 验证用于单个域名
  - DNS-01 验证用于通配符证书（`*.example.com`），支持 Cloudflare、AWS Route53 等
- **🌐 代理主机**：轻松管理虚拟主机、位置和路径重写
- **📡 流（L4）**：TCP 和 UDP 转发，适用于数据库、游戏服务器等
- **🛡️ 访问控制**：支持 IP 白名单/黑名单和基本认证
- **🎨 现代化仪表板**：使用 React、Tailwind CSS 和 shadcn/ui 构建的简洁响应式 UI
- **🐳 Docker 就绪**：单容器部署，易于设置和维护

## 快速开始

```bash
docker compose up -d
```

访问仪表板：`http://localhost:81`

**默认凭据：**

- 用户名：`admin`
- 密码：`changeme`（请立即更改！）

## 端口

| 端口                     | 描述       |
| ------------------------ | ---------- |
| 80（主机）→ 8080（容器） | HTTP 代理  |
| 81（主机）→ 81（容器）   | 仪表板/API |
| 443（主机）→ 443（容器） | HTTPS 代理 |

## 环境变量

| 变量                              | 默认值                          | 描述                                        |
| --------------------------------- | ------------------------------- | ------------------------------------------- |
| `PINGORA_VERSION`                 | `latest`                        | Docker 镜像版本                             |
| `TZ`                              | `UTC`                           | 时区                                        |
| `PINGORA_JWT_SECRET`              | `changeme_in_production_please` | 认证用的 JWT 密钥（**生产环境必须更改**）   |
| `PINGORA_LOG_LEVEL`               | `info`                          | 日志级别（trace、debug、info、warn、error） |
| `PINGORA_HTTP_PORT_OVERRIDE`      | `80`                            | HTTP 代理的主机端口                         |
| `PINGORA_DASHBOARD_PORT_OVERRIDE` | `81`                            | 仪表板/API 的主机端口                       |
| `PINGORA_HTTPS_PORT_OVERRIDE`     | `443`                           | HTTPS 代理的主机端口                        |

## 卷

| 卷             | 路径               | 描述                |
| -------------- | ------------------ | ------------------- |
| `pingora_data` | `/app/data`        | SQLite 数据库和证书 |
| `pingora_logs` | `/app/logs`        | 应用程序日志        |
| `letsencrypt`  | `/etc/letsencrypt` | Let's Encrypt 证书  |

## 架构

- **数据平面（8080/443）**：Pingora 高效处理所有流量
- **控制平面（81）**：Axum 提供 API 和仪表板服务
- **SSL 管理**：集成 Certbot 进行可靠的 ACME 处理
- **状态管理**：使用 ArcSwap 实现无锁配置读取
- **数据库**：SQLite 用于持久化存储主机和证书

## 安全注意事项

- 部署后**立即更改默认凭据**
- 在生产环境中**设置强密码的 `JWT_SECRET`**
- 容器以最小权限运行（仅 `NET_BIND_SERVICE`）
- 启用只读根文件系统以增强安全性

## 参考链接

- [Pingora Proxy Manager GitHub](https://github.com/DDULDDUCK/pingora-proxy-manager)
- [Cloudflare Pingora](https://github.com/cloudflare/pingora)
- [Docker Hub](https://hub.docker.com/r/dduldduck/pingora-proxy-manager)

## 许可证

MIT 许可证 - 详见[上游项目](https://github.com/DDULDDUCK/pingora-proxy-manager/blob/master/LICENSE)。
