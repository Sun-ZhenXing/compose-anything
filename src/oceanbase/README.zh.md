# OceanBase

OceanBase 是由蚂蚁集团开发的分布式关系型数据库，具有高可用、高扩展性的特点，并兼容 MySQL 协议。

## 使用方法

```bash
docker compose up -d
```

## 配置说明

主要环境变量：

- `OCEANBASE_VERSION`：精确镜像版本（默认：`4.4.2.1-101000022026050611`）
- `OB_SYS_PASSWORD`：sys 租户 root 用户密码（默认：`oceanbase`）
- `OB_TENANT_NAME`：租户名称（默认：`test`）
- `OB_TENANT_PASSWORD`：租户密码（默认：`oceanbase`）
- `OB_MEMORY_LIMIT`：内存限制（默认：`8G`，最小：`8G`）
- `OB_DATAFILE_SIZE`：数据文件大小（默认：`10G`）
- `OB_LOG_DISK_SIZE`：日志磁盘大小（默认：`6G`）

## 端口说明

- `2881`：MySQL 协议端口
- `2882`：RPC 端口

## 连接方式

使用 `OB_TENANT_PASSWORD` 连接默认租户（默认：`oceanbase`）：

```bash
mysql -h127.0.0.1 -P2881 -uroot@test -poceanbase
```

或使用 `OB_SYS_PASSWORD` 连接 sys 租户（默认：`oceanbase`）：

```bash
mysql -h127.0.0.1 -P2881 -uroot -poceanbase
```

## 存储

数据库数据存储在命名卷 `oceanbase_data` 中。

## 安全

将 OceanBase 暴露到可信本地环境之外前，请更改 `OB_SYS_PASSWORD` 和 `OB_TENANT_PASSWORD` 的默认值。

## 注意事项

- OceanBase 需要至少 8GB 内存才能正常运行
- 首次启动可能需要几分钟时间进行初始化
- 此服务栈默认使用 `mini` 模式；专用生产集群请使用 `normal` 模式
- 请勿使用 `slim` 快速启动模式，因为它会忽略 sys 密码和资源配置
- 本文档未说明从 4.3.3 到 4.4.2 的直接原地升级。请先备份数据并遵循官方升级路径，不要复用旧卷。

## 参考资料

- [OceanBase 官方文档](https://www.oceanbase.com/docs)
- [OceanBase Docker Hub](https://hub.docker.com/r/oceanbase/oceanbase-ce)
