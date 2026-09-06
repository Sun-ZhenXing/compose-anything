# TriliumNext

TriliumNext 是一个持续维护的个人知识库应用，源自 Trilium 项目。本配置使用官方 `triliumnext/trilium:v0.103.0` 镜像及其原生的首次设置网页流程。

## 服务

- `trilium`：TriliumNext 内核和 Web 界面，容器端口为 `8080`。
- 镜像：`triliumnext/trilium:v0.103.0@sha256:8e6bc939a6d5dbeed42d1b5b155bc790b1c28ca3ac414382d04d626903c62081`。

不包含额外服务、自定义镜像或自定义启动脚本。官方镜像负责初始化运行用户，并使用原生 Docker 命令启动 Trilium。

## 快速开始

默认本机启动不需要 `.env` 文件：

```bash
cd apps/trilium
docker compose up -d
docker compose ps
```

打开 <http://localhost:8080>。全新部署会跳转到原生首次设置页面。请先完成设置并配置强密码，再让服务离开本机访问范围。

## 配置

| 变量 | 默认值 | 用途 |
| --- | --- | --- |
| `TRILIUM_VERSION` | 固定的 `v0.103.0` digest | 官方镜像引用 |
| `TRILIUM_BIND_ADDRESS` | `127.0.0.1` | 主机绑定地址 |
| `TRILIUM_PORT_OVERRIDE` | `8080` | Trilium 主机端口 |
| `TRILIUM_CPU_LIMIT` / `TRILIUM_MEMORY_LIMIT` | `1.0` / `1G` | 资源限制 |
| `TZ` | `UTC` | 容器时区 |

只有需要覆盖这些值时，才复制 `.env.example` 为 `.env`。容器端口和数据目录遵循上游镜像约定，不作为可变配置暴露。

## 存储、安全与升级

唯一的命名卷 `trilium_data` 将 SQLite 数据库、配置、笔记和附件保存在 `/home/node/trilium-data`。升级或数据库结构变化前请备份。真实数据不要执行 `docker compose down -v`。本 Compose 配置不会自动迁移原始 Trilium 安装。

由于官方镜像的启动初始化会先创建运行目录并设置所有权，再以 UID/GID `1000:1000` 运行，服务使用可写根文件系统。本配置丢弃其余 Linux 权限，仅恢复初始化所需的文件系统和用户组权限，并启用 `no-new-privileges`。

默认只绑定本机。需要远程访问时，只有在 HTTPS 反向代理、防火墙和强首次设置密码保护下，才可以设置 `TRILIUM_BIND_ADDRESS=0.0.0.0`。不要直接向不受信任的网络暴露首次设置页面。

本配置不承诺桌面客户端兼容性、ARM 验证或同步测试。项目和功能详情请查看对应版本的上游 README、Docker 源码和许可证：

- [官方 TriliumNext README 和 Docker 说明](https://github.com/TriliumNext/Trilium/blob/v0.103.0/README.md)
- [TriliumNext Dockerfile 源码](https://github.com/TriliumNext/Trilium/blob/v0.103.0/Dockerfile)
- [TriliumNext v0.103.0 许可证](https://github.com/TriliumNext/Trilium/blob/v0.103.0/LICENSE)
