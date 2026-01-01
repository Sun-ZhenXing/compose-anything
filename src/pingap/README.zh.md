# Pingap

[English](./README.md)

基于 Cloudflare Pingora 构建的高性能反向代理，设计为比 Nginx 更高效的替代方案，具有动态配置、热重载功能和直观的 Web 管理界面。

## 功能特性

- **高性能**：基于 Cloudflare 的 Pingora 框架，性能卓越
- **动态配置**：支持热重载配置更改，无需停机
- **Web 管理界面**：通过直观的 Web UI 管理代理服务
- **插件生态系统**：丰富的插件支持，可扩展功能
- **完整版功能**：包含 OpenTelemetry、Sentry 和图片压缩插件
- **零停机时间**：配置变更无需中断服务
- **TOML 配置**：简单明了的配置文件格式

## 快速开始

1. 复制环境变量文件并进行配置：

   ```bash
   cp .env.example .env
   ```

2. **重要**：编辑 `.env` 文件，设置强密码：

   ```bash
   PINGAP_ADMIN_PASSWORD=your-strong-password-here
   ```

3. 启动服务：

   ```bash
   docker compose up -d
   ```

4. 访问 Web 管理后台：

   ```text
   http://localhost/pingap/
   ```

   - 默认用户名：`admin`
   - 密码：在 `.env` 中设置的密码

## 配置说明

### 环境变量

| 变量名                       | 说明                            | 默认值              |
| ---------------------------- | ------------------------------- | ------------------- |
| `PINGAP_VERSION`             | 镜像版本（推荐：`0.12.7-full`） | `0.12.7-full`       |
| `PINGAP_HTTP_PORT_OVERRIDE`  | 主机 HTTP 端口                  | `80`                |
| `PINGAP_HTTPS_PORT_OVERRIDE` | 主机 HTTPS 端口                 | `443`               |
| `PINGAP_DATA_DIR`            | 持久化数据目录                  | `./pingap`          |
| `PINGAP_ADMIN_ADDR`          | 管理界面地址                    | `0.0.0.0:80/pingap` |
| `PINGAP_ADMIN_USER`          | 管理员用户名                    | `admin`             |
| `PINGAP_ADMIN_PASSWORD`      | 管理员密码                      | `password`          |
| `PINGAP_CPU_LIMIT`           | CPU 限制                        | `1.0`               |
| `PINGAP_MEMORY_LIMIT`        | 内存限制                        | `512M`              |

### 镜像版本

- `vicanso/pingap:latest` - 最新开发版（不推荐用于生产环境）
- `vicanso/pingap:full` - 包含所有功能的最新开发版
- `vicanso/pingap:0.12.7` - 不含额外依赖的稳定版
- `vicanso/pingap:0.12.7-full` - **推荐**：包含 OpenTelemetry、Sentry 和图片压缩的稳定版

### 持久化存储

配置和数据存储在 `PINGAP_DATA_DIR` 目录中（默认：`./pingap`）。该目录将在首次运行时自动创建。

## 使用方法

### 查看日志

```bash
docker compose logs -f pingap
```

### 配置更改后重启

虽然 Pingap 支持大多数配置更改的热重载（upstream、location、certificate），但对 server 配置的更改需要重启：

```bash
docker compose restart pingap
```

### 停止服务

```bash
docker compose down
```

## 重要提示

### 安全性

- **务必设置强密码**给 `PINGAP_ADMIN_PASSWORD`
- 建议更改默认的管理员用户名
- 考虑限制管理界面只能从特定 IP 访问
- 生产环境中建议对管理界面启用 HTTPS

### 生产环境建议

- 使用带版本号的标签（如 `0.12.7-full`），而非 `latest` 或 `full`
- 根据流量情况配置适当的资源限制
- 设置适当的监控和日志记录
- 启用 HTTPS 并使用有效证书
- 定期备份 `pingap` 数据目录

### Docker 最佳实践

- 容器使用 `--autoreload` 标志以支持配置热更新
- 避免在 Docker 中使用 `--autorestart`，因为它与容器生命周期冲突
- 对于服务器级别的配置更改，使用 `docker compose restart`

## 相关链接

- [官方网站](https://pingap.io/)
- [文档](https://pingap.io/pingap-zh/docs/docker)
- [GitHub 仓库](https://github.com/vicanso/pingap)
- [Docker Hub](https://hub.docker.com/r/vicanso/pingap)

## 许可证

本 Docker Compose 配置按原样提供。Pingap 基于 Apache License 2.0 许可证。
