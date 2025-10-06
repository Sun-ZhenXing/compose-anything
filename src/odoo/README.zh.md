# Odoo

[Odoo](https://www.odoo.com/) 是一套开源商业应用程序，涵盖了公司的所有需求：CRM、电子商务、会计、库存、销售点、项目管理等。

## 功能特性

- 模块化：从 30,000 多个应用中选择
- 集成化：所有应用无缝协作
- 开源：免费使用和定制
- 可扩展：从小型企业到大型企业
- 用户友好：现代直观的界面

## 快速开始

使用 PostgreSQL 启动 Odoo：

```bash
docker compose up -d
```

## 配置

### 环境变量

- `ODOO_VERSION`: Odoo 版本（默认：`19.0`）
- `ODOO_PORT_OVERRIDE`: HTTP 端口（默认：`8069`）
- `POSTGRES_VERSION`: PostgreSQL 版本（默认：`17-alpine`）
- `POSTGRES_USER`: 数据库用户（默认：`odoo`）
- `POSTGRES_PASSWORD`: 数据库密码（默认：`odoopass`）
- `POSTGRES_DB`: 数据库名称（默认：`postgres`）

## 访问

- Web UI: <http://localhost:8069>

## 首次设置

1. 导航到 <http://localhost:8069>
2. 创建新数据库：
   - 主密码：（设置一个强密码）
   - 数据库名称：（例如：`mycompany`）
   - 邮箱：您的管理员邮箱
   - 密码：您的管理员密码
3. 选择要安装的应用
4. 开始使用 Odoo！

## 自定义插件

将自定义插件放在 `odoo_addons` 卷中。目录结构应该是：

```text
odoo_addons/
  ├── addon1/
  │   ├── __init__.py
  │   ├── __manifest__.py
  │   └── ...
  └── addon2/
      ├── __init__.py
      ├── __manifest__.py
      └── ...
```

## 数据库管理

### 创建新数据库

1. 访问 <http://localhost:8069/web/database/manager>
2. 点击"创建数据库"
3. 填写必要信息
4. 点击"创建"

### 备份数据库

1. 访问 <http://localhost:8069/web/database/manager>
2. 选择您的数据库
3. 点击"备份"
4. 保存备份文件

### 恢复数据库

1. 访问 <http://localhost:8069/web/database/manager>
2. 点击"恢复数据库"
3. 上传您的备份文件
4. 点击"恢复"

## 资源配置

- 资源限制：2 CPU，2G 内存（Odoo），1 CPU，1G 内存（数据库）
- 资源预留：0.5 CPU，1G 内存（Odoo），0.25 CPU，512M 内存（数据库）

## 生产环境考虑因素

对于生产环境部署：

1. 设置强主密码
2. 使用 HTTPS（配置反向代理）
3. 定期数据库备份
4. 监控资源使用情况
5. 保持 Odoo 和插件更新
6. 配置电子邮件设置以接收通知
7. 设置适当的日志记录和监控
