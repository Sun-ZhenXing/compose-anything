# LibreOffice

[English](./README.md) | [中文](./README.zh.md)

此服务部署 LibreOffice，一个免费开源的办公套件。linuxserver.io 镜像提供了一个可通过网络浏览器访问的桌面 GUI，支持 HTTPS。

## 服务

- `libreoffice`：可通过网络浏览器访问的 LibreOffice 桌面环境。

## 环境变量

| 变量名                          | 描述                                  | 默认值   |
| ------------------------------- | ------------------------------------- | -------- |
| LIBREOFFICE_VERSION             | LibreOffice 镜像版本                  | `latest` |
| LIBREOFFICE_HTTP_PORT_OVERRIDE  | HTTP 主机端口映射（映射到端口 3000）  | 3000     |
| LIBREOFFICE_HTTPS_PORT_OVERRIDE | HTTPS 主机端口映射（映射到端口 3001） | 3001     |
| PUID                            | 用户 ID，用于权限管理                 | `1000`   |
| PGID                            | 组 ID，用于权限管理                   | `1000`   |
| CUSTOM_USER                     | HTTP 基本身份验证用户名               | `abc`    |
| PASSWORD                        | HTTP 基本身份验证密码（留空禁用）     | (空)     |
| TZ                              | 时区                                  | `UTC`    |
| UMASK                           | 文件权限掩码                          | `022`    |

请根据您的使用情况修改 `.env` 文件。

## 卷

- `libreoffice_config`：用于存储 LibreOffice 用户主目录、程序设置和文档的卷。

## 使用方法

1. 启动服务：

   ```bash
   docker compose up -d
   ```

2. 该服务将在以下地址可用：
   - HTTP：`http://localhost:3000`
   - HTTPS：`https://localhost:3001`

3. 通过网络浏览器访问 LibreOffice 桌面。

## 安全

**完整功能需要 HTTPS。** 现代浏览器功能（如用于视频和音频的 WebCodecs）在不安全的 HTTP 连接上无法运行。

### 身份验证

默认情况下，容器没有身份验证。要启用 HTTP 基本身份验证：

1. 在 `.env` 文件中设置 `PASSWORD` 环境变量
2. 可选地自定义 `CUSTOM_USER`（默认：`abc`）

对于互联网暴露，我们强烈建议将容器放在具有强大身份验证机制的反向代理后面。

### 重要安全注意事项

此容器包括：

- 对系统资源的特权访问（由于 GUI 需求）
- 容器内无密码 `sudo` 访问的终端
- 任何有权访问 GUI 的用户都可以在容器内获得 root 控制权

**除非适当保护，否则不要将此容器暴露到互联网。**

## 配置

- 用户和组 ID 可通过 `PUID` 和 `PGID` 自定义以匹配您的主机系统
- 语言支持可通过 `LC_ALL` 环境变量获得（例如 `LC_ALL=zh_CN.UTF-8` 用于中文）
- `seccomp: unconfined` 设置允许现代 GUI 应用程序在 Docker 上运行

## 资源限制

- CPU：限制为 2 核，预留 0.5 核
- 内存：限制为 2 GB，预留 512 MB

## 故障排除

如果遇到系统调用相关错误，已包含的 `--security-opt seccomp=unconfined` 设置应该可以解决旧内核版本上的问题。

有关更多信息，请访问 [linuxserver.io LibreOffice 文档](https://docs.linuxserver.io/images/docker-libreoffice/)。
