# OceanBase

OceanBase 是由蚂蚁集团开发的分布式关系型数据库，具有高可用、高扩展性的特点，并兼容 MySQL 协议。

## 使用方法

```bash
docker compose up -d
```

## 配置说明

主要环境变量：

- `OB_ROOT_PASSWORD`：root 用户密码（默认：`oceanbase`）
- `OB_TENANT_NAME`：租户名称（默认：`test`）
- `OB_TENANT_PASSWORD`：租户密码（默认：`oceanbase`）
- `OB_MEMORY_LIMIT`：内存限制（默认：`8G`，最小：`8G`）
- `OB_DATAFILE_SIZE`：数据文件大小（默认：`10G`）
- `OB_LOG_DISK_SIZE`：日志磁盘大小（默认：`6G`）

## 端口说明

- `2881`：MySQL 协议端口
- `2882`：RPC 端口

## 连接方式

使用 MySQL 客户端连接：

```bash
mysql -h127.0.0.1 -P2881 -uroot@test -poceanbase
```

或连接到 sys 租户：

```bash
mysql -h127.0.0.1 -P2881 -uroot -poceanbase
```

## 注意事项

- OceanBase 需要至少 8GB 内存才能正常运行
- 首次启动可能需要几分钟时间进行初始化
- 使用 `slim` 模式适合开发/测试环境
- 生产环境建议使用 `normal` 模式和专用集群

## 参考资料

- [OceanBase 官方文档](https://www.oceanbase.com/docs)
- [OceanBase Docker Hub](https://hub.docker.com/r/oceanbase/oceanbase-ce)
