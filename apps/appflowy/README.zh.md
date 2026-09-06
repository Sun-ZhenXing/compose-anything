# AppFlowy Cloud（legacy）

这是归档的 AppFlowy Cloud `0.9.64` 桌面后端，不是浏览器笔记编辑器，也不代表当前商业自托管支持。上游已于 2026-09-01 停止维护；不要假设它兼容最新桌面客户端。

## 服务

包含 `postgres`、`redis`、`minio`、`gotrue`、`appflowy_cloud`、`admin_frontend` 和仅本机访问的 `nginx` 网关。不包含 Web 镜像、AI、worker、SMTP、额外 SQL 初始化容器。此版本内置 SQL migration，GoTrue 会在启动时创建认证 schema 和确认管理员。

## 快速开始

```bash
cd apps/appflowy
py -3 setup.py                 # Linux/macOS：python3 setup.py
docker compose up -d
```

没有 GNU Make 时可以直接使用上面的 Python 命令。初始化容器设置了 CPU 和内存上限。使用 `docker compose ps` 和 `docker compose config -q` 检查启动状态。网关地址为 <http://localhost:8080>，管理员登录的准确地址为 <http://localhost:8080/console/web/login>。也可以运行 `make init` 生成密钥。

## 配置

| 变量 | 默认值 | 用途 |
| --- | --- | --- |
| `APPFLOWY_PORT_OVERRIDE` | `8080` | 本机回环端口 |
| `APPFLOWY_BASE_URL` | `http://localhost:8080` | 外部 URL，需包含端口 |
| `APPFLOWY_*_VERSION` | 固定的 `0.9.64` 或 registry 版本 | 镜像引用；AppFlowy 镜像同时固定 digest |
| `APPFLOWY_ADMIN_EMAIL` | `admin@example.com` | 初始管理员 |
| `APPFLOWY_POSTGRES_PASSWORD`、`APPFLOWY_ADMIN_PASSWORD`、`APPFLOWY_JWT_SECRET`、`APPFLOWY_MINIO_*`、`APPFLOWY_ADMIN_OAUTH_CLIENT_SECRET`、`APPFLOWY_GOTRUE_OPERATOR_TOKEN` | 自动生成 | 七个密钥，不要提交 `.env` |

默认资源限制为：PostgreSQL `1 CPU/1G`、Redis `0.5 CPU/256M`、MinIO `1 CPU/1G`、GoTrue `0.5 CPU/256M`、Cloud `2 CPU/2G`、admin `0.5 CPU/256M`、Nginx `0.25 CPU/64M`。

`setup.py` 以排他创建方式生成权限为 `0600`（POSIX）的 `.env`，拒绝覆盖已有文件；它只负责初始化，不负责轮换密钥。生成的管理员密码是本地 `.env` 中的 `APPFLOWY_ADMIN_PASSWORD` 值，请在本地读取，不要打印到共享日志。修改非默认端口时，要同步修改 `APPFLOWY_BASE_URL`。上游容器名称和内部 URL 仅在网关之后使用。

## 存储、安全与升级

命名卷为 `appflowy_postgres_data`、`appflowy_redis_data` 和 `appflowy_minio_data`。PostgreSQL、Redis、MinIO 不暴露主机端口。服务设置资源限制、JSON 日志轮换、丢弃 capabilities；网关只绑定回环地址。cloud 和 admin 使用只读根文件系统及 `/tmp` tmpfs，vendor 镜像仅保留自身启动所需权限。

迁移前请备份数据库和全部卷。真实数据不要执行 `docker compose down -v`。升级时必须整体修改完整镜像引用，并先在卷副本上验证；这是 legacy 版本，不承诺兼容最新桌面客户端。

此栈不提供浏览器编辑器、SMTP 投递、AI、worker、imports 或 published pages。SMTP 特意指向回环地址，不能用于发送邀请。已测试初始管理员认证；额外用户创建未测试。标准库 smoke 覆盖密码认证、关闭 signup、用户验证，以及 Cloud 和网关重建后的 workspace/page 持久化、blob 上传读取、WebSocket HTTP upgrade 和服务日志中不存在 token。本版本实际可用的 blob 读取地址为 `/api/file_storage/{workspace_id}/v1/blob/{parent_dir}/{file_id}`，且允许匿名读取；附件 URL 应按公开内容处理。未验证真实桌面客户端的登录、编辑和同步，尚无已验证兼容的桌面客户端版本。

可运行 `python smoke.py` 执行一次性运行时检查：脚本创建临时 `.env`、随机 Compose 项目和空闲的本机回环端口，最后只删除自己创建的容器、网络和命名卷。

## 参考

- [归档后端版本](https://github.com/AppFlowy-IO/AppFlowy-Cloud/releases/tag/0.9.64)
- [归档仓库状态](https://github.com/AppFlowy-IO/AppFlowy-Cloud)
- [版本化 Compose 源码](https://raw.githubusercontent.com/AppFlowy-IO/AppFlowy-Cloud/0.9.64/docker-compose.yml)
