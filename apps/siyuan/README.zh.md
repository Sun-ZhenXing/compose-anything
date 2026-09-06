# 思源笔记（SiYuan）

SiYuan 是一个可自托管的个人知识管理应用。本配置使用官方 `b3log/siyuan:v3.8.2` 镜像和一个命名工作区卷。

## 服务

- `siyuan`：SiYuan 内核和 Web 界面，容器端口为 `6806`。
- 镜像：`b3log/siyuan:v3.8.2@sha256:af1442205fd60a8f5710c46c7e4c92bf3c8c1c9405026823496e4459f821549c`。

官方镜像提供上游多架构镜像清单。本 Compose 文件不增加应用镜像、启动脚本、数据库或辅助容器。

## 快速开始

本配置要求非空访问码，未设置时会拒绝启动。先生成一次访问码，再启动服务：

```bash
cd apps/siyuan
python3 setup.py                 # Windows：py -3 setup.py
docker compose up -d
```

`make init` 会在无网络且有资源限制的 Python 容器中执行同一个初始化脚本。打开 <http://localhost:6806>，使用本地 `.env` 文件中的 `SIYUAN_ACCESS_AUTH_CODE`。请在本地读取该值，不要把它打印到共享日志。访问码用于浏览器登录，API 认证请遵循上游文档。可使用 `docker compose ps` 检查启动状态。

## 配置

| 变量 | 默认值 | 用途 |
| --- | --- | --- |
| `SIYUAN_VERSION` | 固定的 `v3.8.2` digest | 官方镜像引用 |
| `SIYUAN_BIND_ADDRESS` | `127.0.0.1` | 主机绑定地址 |
| `SIYUAN_PORT_OVERRIDE` | `6806` | SiYuan 主机端口 |
| `SIYUAN_ACCESS_AUTH_CODE` | 自动生成 | 必需的工作区 Web 访问码 |
| `SIYUAN_PUID` / `SIYUAN_PGID` | `1000` / `1000` | 镜像初始化后的运行 UID/GID |
| `SIYUAN_CPU_LIMIT` / `SIYUAN_MEMORY_LIMIT` | `1.0` / `1G` | 资源限制 |

由于官方启动脚本会先以 root 创建 `/etc/group`，再切换到配置的 UID/GID，服务使用可写根文件系统。本配置丢弃其余 Linux 权限，启用 `no-new-privileges`，也不强制设置 Compose `user`。

## 存储、安全与升级

`siyuan_data` 将工作区、设置、文档、资源和其他 SiYuan 数据保存在 `/siyuan/workspace`。升级前请备份此命名卷。真实数据不要执行 `docker compose down -v`。

默认只绑定本机。需要远程访问时，只有在 HTTPS、防火墙和强访问码保护下，才可以设置 `SIYUAN_BIND_ADDRESS=0.0.0.0`。不要绕过认证。

本配置不承诺云同步、桌面客户端兼容性或付费功能可用性。启用部署功能前，请查看上游 Docker 说明和许可证：

- [官方 SiYuan README 和 Docker 说明](https://github.com/siyuan-note/siyuan/blob/v3.8.2/README.md)
- [SiYuan v3.8.2 许可证](https://github.com/siyuan-note/siyuan/blob/v3.8.2/LICENSE)
