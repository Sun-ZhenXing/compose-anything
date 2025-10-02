# Nginx

[English](./README.md) | [中文](./README.zh.md)

此服务部署 Nginx，一个高性能的 Web 服务器和反向代理服务器。

## 服务

- `nginx`：Nginx Web 服务器服务。

## 环境变量

| 变量名                    | 描述                                 | 默认值              |
| ------------------------- | ------------------------------------ | ------------------- |
| NGINX_VERSION             | Nginx 镜像版本                       | `1.29.1-alpine3.20` |
| NGINX_HTTP_PORT_OVERRIDE  | HTTP 主机端口映射（映射到端口 80）   | 80                  |
| NGINX_HTTPS_PORT_OVERRIDE | HTTPS 主机端口映射（映射到端口 443） | 443                 |
| NGINX_HOST                | 配置的服务器主机名                   | `localhost`         |
| NGINX_PORT                | 配置的服务器端口                     | 80                  |

请根据您的使用情况修改 `.env` 文件。

## 卷

- `nginx_logs`：用于存储 Nginx 日志的卷。
- `./html`：Web 内容目录（以只读方式挂载）。
- `./nginx.conf`：可选的自定义 Nginx 配置文件。
- `./conf.d`：可选的附加配置文件目录。
- `./ssl`：可选的 SSL 证书目录。

## 使用方法

1. `html` 目录已创建并包含默认的 `index.html` 文件。

2. 启动服务：

   ```bash
   docker compose up -d
   ```

3. 在 `http://localhost`（或您配置的端口）访问 Web 服务器。

## 配置

- 自定义 Nginx 配置可以挂载到 `/etc/nginx/nginx.conf`
- 附加服务器配置可以放置在 `conf.d` 目录中
- SSL 证书可以挂载到 `/etc/nginx/ssl/`
- Web 内容应放置在 `html` 目录中

## 安全注意事项

- 生产环境部署时考虑使用 SSL/TLS 证书
- 定期更新 Nginx 版本以获取安全补丁
- 根据您的具体需求审查和自定义 Nginx 配置
