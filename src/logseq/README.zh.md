# Logseq

[中文](./README.zh.md) | [English](./README.md)

[Logseq](https://github.com/logseq/logseq) 是一款本地优先的大纲笔记和知识管理工具。本配置通过 Nginx 提供官方文件版 Web 应用。浏览器直接打开您电脑上的知识库目录，容器不提供数据库或同步服务器，也不部署 Logseq 2.0 DB 测试版。

## 服务

| 服务 | 镜像 | 默认地址 |
| ---- | ---- | -------- |
| `logseq` | `ghcr.io/logseq/logseq-webapp`（固定摘要） | <http://localhost:3001> |

所选镜像支持 `linux/amd64` 和 `linux/arm64`。上游没有为此 Web 应用提供正式版本标签，因此本配置固定多架构镜像的 SHA-256 摘要。所选 AMD64 镜像构建于 **2025-05-26**，不能视为当前桌面版或 DB 版。在向其他设备提供访问之前，请评估上游维护状态和安全修复情况。

## 快速开始

在仓库根目录执行：

```bash
cd src/logseq
docker compose up -d
```

使用支持 File System Access API 的桌面浏览器（如 Chrome 或 Edge）打开 <http://localhost:3001>，选择本地知识库目录并授予浏览器访问权限。Firefox 和 Safari 无法通过此 API 打开本地知识库目录。

默认无需初始化或创建 `.env` 文件。如需调整配置，可在启动前根据 `.env.example` 创建 `.env`。

```bash
docker compose ps
docker compose logs -f logseq
docker compose down
```

## 配置

| 变量 | 默认值 | 用途 |
| ---- | ------ | ---- |
| `LOGSEQ_IMAGE_DIGEST` | `sha256:de87c4a2...f26c231` | 完整的固定摘要见 `.env.example` 和 Compose 文件 |
| `GLOBAL_REGISTRY` | `ghcr.io/` | 镜像仓库前缀，包含末尾斜杠 |
| `LOGSEQ_BIND_ADDRESS` | `127.0.0.1` | HTTP 绑定的宿主机地址 |
| `LOGSEQ_PORT_OVERRIDE` | `3001` | 映射到容器端口 `80` 的宿主机端口 |
| `TZ` | `UTC` | 容器时区 |
| `LOGSEQ_CPU_LIMIT` | `0.5` | CPU 上限 |
| `LOGSEQ_MEMORY_LIMIT` | `128M` | 内存上限 |
| `LOGSEQ_CPU_RESERVATION` | `0.1` | CPU 预留 |
| `LOGSEQ_MEMORY_RESERVATION` | `32M` | 内存预留 |

## 存储

本服务不需要命名卷或匿名卷。知识库文件保存在您选择的**浏览器所在电脑**的目录中，而非 Docker 宿主机上，除非两者是同一台电脑。请使用常规文件备份工具备份该目录。浏览器本地状态和授权与站点来源关联；更改域名、端口或协议后，可能需要重新打开知识库并授权。

容器只提供应用文件，Nginx 缓存和 PID 目录使用临时内存挂载。重建或删除容器不会删除本地知识库文件。向容器挂载知识库目录不会让其他客户端访问该目录，也不会启用同步。

## 安全与远程访问

- 容器以 UID/GID `101:101` 运行，使用只读根文件系统，移除全部 Linux capabilities，并禁止提权。配置包含 CPU、内存和日志大小限制。
- HTTP 默认仅绑定回环地址。镜像不提供服务端登录认证或 TLS 终止功能。
- 远程访问需要可信的 HTTPS 反向代理，并通过认证或私有网络限制访问。普通 HTTP 局域网地址不满足 File System Access API 的安全上下文要求；本地访问可使用 `http://localhost`。
- 在 Docker 宿主机运行的代理可转发到 `127.0.0.1:3001`。容器化代理需要共享 Docker 网络，并转发到 `logseq:80`；代理容器自己的 `localhost` 并不指向本服务。
- 只向可信部署授予知识库访问权限，站点提供的 JavaScript 可以读取和修改您在浏览器中授权的文件。不要将 HTTP 端口直接暴露到公网。

## 更新

检查[官方镜像包](https://github.com/logseq/logseq/pkgs/container/logseq-webapp)，选择经过验证的多架构摘要，然后更新 `.env` 中的 `LOGSEQ_IMAGE_DIGEST`。只执行拉取命令不会改变固定版本。测试新版本应用前，请备份知识库。

```bash
docker compose pull
docker compose up -d
```

## 参考资料

- [源码仓库](https://github.com/logseq/logseq)
- [官方 Docker Web 应用指南](https://github.com/logseq/logseq/blob/master/docs/docker-web-app-guide.md)
- [File System Access API 浏览器支持情况](https://caniuse.com/native-filesystem-api)
