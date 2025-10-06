# Kodbox

[English](./README.md) | [中文](./README.zh.md)

此服务部署 Kodbox,一个功能强大的 Web 文件管理器和云存储平台,具有类似 Windows 的用户体验。

## 服务

- `kodbox`: Kodbox 主应用服务器。
- `kodbox-db`: Kodbox 的 MySQL 数据库。
- `kodbox-redis`: 用于缓存和会话管理的 Redis。

## 环境变量

| 变量名              | 描述                           | 默认值             |
| ------------------- | ------------------------------ | ------------------ |
| KODBOX_VERSION      | Kodbox 镜像版本                | `1.62`             |
| KODBOX_PORT         | Kodbox Web 界面的主机端口映射  | `80`               |
| MYSQL_VERSION       | MySQL 镜像版本                 | `9.4.0`            |
| MYSQL_HOST          | MySQL 主机                     | `kodbox-db`        |
| MYSQL_PORT          | MySQL 端口                     | `3306`             |
| MYSQL_DATABASE      | MySQL 数据库名                 | `kodbox`           |
| MYSQL_USER          | MySQL 用户名                   | `kodbox`           |
| MYSQL_PASSWORD      | MySQL 密码                     | `kodbox123`        |
| MYSQL_ROOT_PASSWORD | MySQL root 密码                | `root123`          |
| REDIS_VERSION       | Redis 镜像版本                 | `8.2.1-alpine3.22` |
| REDIS_HOST          | Redis 主机                     | `kodbox-redis`     |
| REDIS_PORT          | Redis 端口                     | `6379`             |
| REDIS_PASSWORD      | Redis 密码(留空表示不需要认证) | `""`               |

请创建 `.env` 文件并根据需要进行修改。

## 数据卷

- `kodbox_data`: 用于存储 Kodbox 应用和用户文件的卷。
- `kodbox_db_data`: 用于存储 MySQL 数据的卷。
- `kodbox_redis_data`: 用于存储 Redis 数据的卷。

## 快速开始

1. (可选)创建 `.env` 文件以自定义设置:

   ```env
   KODBOX_PORT=8080
   MYSQL_PASSWORD=your-secure-password
   MYSQL_ROOT_PASSWORD=your-secure-root-password
   ```

2. 启动服务:

   ```bash
   docker compose up -d
   ```

3. 访问 `http://localhost`(或您配置的端口)

4. 首次访问时按照安装向导操作

## 初始设置

首次访问时,安装向导将引导您完成:
- 数据库配置(从环境变量自动填充)
- 创建管理员账户
- 基本设置配置

**注意**: 如果您在 `.env` 中更改了数据库凭据,请确保在安装向导中也进行相应更新。

## 功能特性

- **类 Windows 界面**: 在 Web 浏览器中提供熟悉的桌面体验
- **多云支持**: 连接本地磁盘、FTP、WebDAV 和各种云存储服务
- **文件管理**: 支持拖放的全功能文件操作
- **在线预览**: 预览 100+ 种文件格式,包括 Office、PDF、图片、视频
- **在线编辑**: 内置文本编辑器,支持 120+ 种语言的语法高亮
- **团队协作**: 细粒度权限控制和文件共享
- **插件系统**: 通过插件扩展功能

## 文档

更多信息请访问 [Kodbox 官方文档](https://doc.kodcloud.com/)。

## 安全提示

- 在生产环境中更改所有默认密码
- 在生产环境中使用 HTTPS
- 定期备份所有数据卷
- 保持 Kodbox、MySQL 和 Redis 更新到最新稳定版本
- 在生产环境中考虑为 Redis 设置密码
