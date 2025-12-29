# TrailBase

[English](./README.md) | [中文](./README.zh.md)

TrailBase 是一个开源的单可执行后端，提供 type-safe REST 与实时 API、内置管理界面、WebAssembly 运行时以及身份认证功能，底层由 Rust、SQLite 与 Wasmtime 驱动。
本配置使用官方 Docker 镜像并提供合理的默认值，方便你立即访问管理后台、定义数据模型并在本地体验 TrailBase。

## 服务

- `trailbase`：包含管理后台、REST API 以及实时通道的核心服务。

## 快速开始

1. 复制示例环境文件并按需修改：

   ```bash
   cp .env.example .env
   ```

2. 启动服务：

   ```bash
   docker compose up -d
   ```

3. 首次启动会在日志中输出自动生成的管理员账号，使用以下命令查看：

   ```bash
   docker compose logs -f trailbase
   ```

4. 打开 `http://localhost:4000/_/admin`，使用日志中的凭据登录（或按照下文创建新的管理员）。

## 默认访问入口

| 入口                                    | 说明                |
| --------------------------------------- | ------------------- |
| `http://localhost:4000/_/admin`         | 管理界面            |
| `http://localhost:4000/api/healthcheck` | 健康检查端点        |
| `http://localhost:4000/_/auth/login`    | 可选的 Auth UI 入口 |

## 环境变量

| 变量名                         | 描述                                | 默认值   |
| ------------------------------ | ----------------------------------- | -------- |
| `TRAILBASE_VERSION`            | Docker 镜像标签                     | `0.22.4` |
| `TRAILBASE_PORT_OVERRIDE`      | 暴露到宿主机的端口（容器端口 4000） | `4000`   |
| `TRAILBASE_RUST_BACKTRACE`     | 是否输出 Rust 堆栈，便于排障        | `1`      |
| `TRAILBASE_LOG_MAX_SIZE`       | `json-file` 日志的最大文件大小      | `100m`   |
| `TRAILBASE_LOG_MAX_FILE`       | 日志轮转时保留的文件数量            | `3`      |
| `TRAILBASE_CPU_LIMIT`          | CPU 限制（`deploy.resources`）      | `1.0`    |
| `TRAILBASE_MEMORY_LIMIT`       | 内存限制                            | `1G`     |
| `TRAILBASE_CPU_RESERVATION`    | CPU 预留                            | `0.25`   |
| `TRAILBASE_MEMORY_RESERVATION` | 内存预留                            | `256M`   |
| `TZ`                           | 容器时区                            | `UTC`    |

完整说明请参考 `.env.example`。

## 数据卷

- `trailbase_data`：对应容器内的 `traildepot`，保存 SQLite 数据库、WASM 组件、认证密钥及上传的静态资源。升级或迁移前务必备份该卷。

## 初始化与管理员账号

- 首次启动后，TrailBase 会在日志中打印一次性管理员账号与密码。请立即登录并修改。
- 也可以直接在容器内创建新的已验证用户：

  ```bash
  docker compose exec trailbase /app/trail user add admin@example.com "StrongPassw0rd!"
  ```

- 使用同一个 `trail` CLI 可以重置密码、导入导出数据等，不需要重启服务。

## 可选组件

- 镜像已经预置官方 Auth UI WASM 组件，若需要其他组件，可在运行中安装：

  ```bash
  docker compose exec trailbase /app/trail components add trailbase/auth_ui
  docker compose exec trailbase /app/trail components add your-org/your-component
  ```

- 如果希望通过 Git 管理组件或静态资源，可以将本地目录挂载到 `trailbase_data`。

## 健康检查与维护

- 默认健康检查请求 `http://localhost:4000/api/healthcheck`，也可以手动使用 `curl` 进行验证。
- 备份流程示例：

  ```bash
  docker compose stop trailbase
  docker run --rm -v compose-anything_trailbase_data:/data -v $(pwd):/backup alpine tar czf /backup/trailbase-backup.tar.gz -C /data .
  docker compose start trailbase
  ```

- 恢复时将备份解压回同名数据卷即可。

## 安全提示

- 启动后立即更换默认管理员凭据，并在防火墙或反向代理层限制 4000 端口的访问。
- 生产环境建议将 `TRAILBASE_RUST_BACKTRACE` 设置为 `0`，避免日志泄露系统细节。
- 配合 Caddy、nginx 或 Traefik 等反向代理启用 TLS，必要时再开启 WAF、IP 白名单等防护。
- 升级新版本前务必备份 `trailbase_data` 数据卷。

## 参考资料

- 官网：<https://trailbase.io>
- 仓库：<https://github.com/trailbaseio/trailbase>
- 文档：<https://trailbase.io/reference>
- 许可证：Open Software License 3.0（OSL-3.0）
