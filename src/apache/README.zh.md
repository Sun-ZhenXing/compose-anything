# Apache HTTP 服务器

[English](./README.md) | [中文](./README.zh.md)

此服务部署 Apache HTTP 服务器，一个流行的开源 Web 服务器。

## 服务

- `apache`：Apache HTTP 服务器服务。

## 环境变量

| 变量名                     | 描述                                 | 默认值              |
| -------------------------- | ------------------------------------ | ------------------- |
| APACHE_VERSION             | Apache HTTP 服务器镜像版本           | `2.4.62-alpine3.20` |
| APACHE_HTTP_PORT_OVERRIDE  | HTTP 主机端口映射（映射到端口 80）   | 80                  |
| APACHE_HTTPS_PORT_OVERRIDE | HTTPS 主机端口映射（映射到端口 443） | 443                 |
| APACHE_RUN_USER            | 运行 Apache 的用户                   | `www-data`          |
| APACHE_RUN_GROUP           | 运行 Apache 的组                     | `www-data`          |

请根据您的使用情况修改 `.env` 文件。

## 卷

- `apache_logs`：用于存储 Apache 日志的卷。
- `./htdocs`：Web 内容目录（以只读方式挂载）。
- `./httpd.conf`：可选的自定义 Apache 配置文件。
- `./ssl`：可选的 SSL 证书目录。

## 使用方法

1. 创建服务目录结构：

   ```bash
   mkdir -p htdocs
   ```

2. 将您的 Web 内容添加到 `htdocs` 目录：

   ```bash
   echo "<h1>Hello World</h1>" > htdocs/index.html
   ```

3. 启动服务：

   ```bash
   docker compose up -d
   ```

4. 在 `http://localhost`（或您配置的端口）访问 Web 服务器。

## 配置

- 自定义 Apache 配置可以挂载到 `/usr/local/apache2/conf/httpd.conf`
- SSL 证书可以挂载到 `/usr/local/apache2/conf/ssl/`
- Web 内容应放置在 `htdocs` 目录中

## 安全注意事项

- 默认配置以 `www-data` 用户身份运行 Apache 以确保安全
- 生产环境部署时考虑使用 SSL/TLS 证书
- 定期更新 Apache 版本以获取安全补丁
