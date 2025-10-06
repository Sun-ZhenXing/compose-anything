# Halo

[English](./README.md) | [中文](./README.zh.md)

此服务部署 Halo,一个强大易用的开源博客和内容管理系统。

## 服务

- `halo`: Halo 主应用服务器。
- `halo-db`: Halo 的 PostgreSQL 数据库。

## 环境变量

| 变量名                   | 描述                                   | 默认值                  |
| ------------------------ | -------------------------------------- | ----------------------- |
| HALO_VERSION             | Halo 镜像版本                          | `2.21.9`                |
| HALO_PORT                | Halo Web 界面的主机端口映射            | `8090`                  |
| POSTGRES_VERSION         | PostgreSQL 镜像版本                    | `17.2-alpine3.21`       |
| POSTGRES_USER            | PostgreSQL 用户名                      | `postgres`              |
| POSTGRES_PASSWORD        | PostgreSQL 密码(必需)                  | `postgres`              |
| POSTGRES_DB              | PostgreSQL 数据库名                    | `halo`                  |
| SPRING_R2DBC_URL         | R2DBC 连接 URL                         | (自动配置)              |
| SPRING_SQL_INIT_PLATFORM | SQL 平台类型                           | `postgresql`            |
| HALO_EXTERNAL_URL        | Halo 的外部 URL                        | `http://localhost:8090` |
| HALO_ADMIN_USERNAME      | 初始管理员用户名                       | `admin`                 |
| HALO_ADMIN_PASSWORD      | 初始管理员密码(留空则在首次登录时设置) | `""`                    |

请创建 `.env` 文件并根据需要进行修改。

## 数据卷

- `halo_data`: 用于存储 Halo 应用数据的卷。
- `halo_db_data`: 用于存储 PostgreSQL 数据的卷。

## 快速开始

1. (可选)创建 `.env` 文件以自定义设置:

   ```env
   POSTGRES_PASSWORD=your-secure-password
   HALO_EXTERNAL_URL=https://yourdomain.com
   ```

2. 启动服务:

   ```bash
   docker compose up -d
   ```

3. 访问 `http://localhost:8090`

4. 按照设置向导创建管理员账户(如果未通过 `HALO_ADMIN_PASSWORD` 配置)

## 初始设置

首次访问时,您将看到初始设置向导:

- 设置管理员账户凭据(如果未通过环境变量配置)
- 配置站点信息
- 从应用市场选择并安装主题

## 文档

更多信息请访问 [Halo 官方文档](https://docs.halo.run)。

## 主题和插件市场

访问 [Halo 应用市场](https://www.halo.run/store/apps) 浏览主题和插件。

## 安全提示

- 在生产环境中更改默认数据库密码
- 在生产环境中使用 HTTPS
- 设置强管理员密码
- 定期备份两个数据卷
- 保持 Halo 和 PostgreSQL 更新到最新稳定版本
