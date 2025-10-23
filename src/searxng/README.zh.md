# SearXNG

[English](./README.md) | [中文](./README.zh.md)

此服务部署 SearXNG，一个尊重隐私的元搜索引擎，它聚合多个搜索引擎的结果而不跟踪用户。

## 服务

- `searxng`：SearXNG 元搜索引擎
- `redis`：Valkey（Redis 兼容）用于缓存搜索结果
- `caddy`：反向代理和 HTTPS 终止（使用主机网络模式）

## 环境变量

| 变量名                | 说明                                                               | 默认值                |
| --------------------- | ------------------------------------------------------------------ | --------------------- |
| SEARXNG_VERSION       | SearXNG 镜像版本                                                   | `2025.1.20-1ce14ef99` |
| SEARXNG_PORT_OVERRIDE | SearXNG 主机端口映射（映射到容器内端口 8080）                      | 8080                  |
| SEARXNG_HOSTNAME      | Caddy 反向代理的主机名                                             | `http://localhost`    |
| LETSENCRYPT_EMAIL     | Let's Encrypt HTTPS 证书的邮箱（设置为 "internal" 使用自签名证书） | `internal`            |
| SEARXNG_UWSGI_WORKERS | uWSGI 工作进程数                                                   | 4                     |
| SEARXNG_UWSGI_THREADS | 每个 uWSGI 工作进程的线程数                                        | 4                     |
| VALKEY_VERSION        | Valkey（Redis）镜像版本                                            | `8-alpine`            |
| CADDY_VERSION         | Caddy 反向代理版本                                                 | `2-alpine`            |
| TZ                    | 时区设置                                                           | `UTC`                 |

请根据实际需求修改 `.env` 文件。

## 卷

- `caddy-data`：Caddy 数据存储（证书等）
- `caddy-config`：Caddy 配置
- `valkey-data`：Valkey 数据持久化
- `./searxng`：SearXNG 配置目录（挂载到 `/etc/searxng`）

## 端口

- `8080`：SearXNG Web UI（使用主机网络模式时通过 Caddy 反向代理）

## 配置

### SearXNG 设置

编辑 `./searxng` 目录中的配置文件以自定义：

- 要使用的搜索引擎
- UI 主题和外观
- 隐私设置
- 结果过滤

### 使用 Let's Encrypt 启用 HTTPS

要启用 Let's Encrypt 证书的 HTTPS：

1. 在 `.env` 中将 `LETSENCRYPT_EMAIL` 设置为你的邮箱地址
2. 将 `SEARXNG_HOSTNAME` 设置为你的域名（例如，`https://search.example.com`）
3. 确保端口 80 和 443 可从互联网访问
4. 创建或更新 `Caddyfile` 以包含你的域名配置

### 自签名证书

默认情况下（`LETSENCRYPT_EMAIL=internal`），Caddy 将使用自签名证书进行 HTTPS。

## 首次设置

1. 启动服务
2. 访问 SearXNG：`http://localhost:8080`（或你配置的主机名）
3. 将浏览器配置为使用 SearXNG 作为默认搜索引擎（可选）
4. 通过 Web 界面自定义设置

## 附加信息

- 官方文档：<https://docs.searxng.org/>
- GitHub 仓库：<https://github.com/searxng/searxng>
- 原始项目：<https://github.com/searxng/searxng-docker>
