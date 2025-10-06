# ZooKeeper

[Apache ZooKeeper](https://zookeeper.apache.org/) 是一个用于维护配置信息、命名、提供分布式同步和提供组服务的集中式服务。

## 功能特性

- 配置管理：集中式配置管理
- 命名服务：分布式命名服务
- 同步：分布式同步原语
- 组服务：组成员管理和领导者选举
- 高可用性：内置复制和故障转移

## 快速开始

启动 ZooKeeper：

```bash
docker compose up -d
```

## 配置

### 环境变量

- `ZOOKEEPER_VERSION`: ZooKeeper 版本（默认：`3.9.3`）
- `ZOOKEEPER_CLIENT_PORT_OVERRIDE`: 客户端端口（默认：`2181`）
- `ZOOKEEPER_ADMIN_PORT_OVERRIDE`: 管理服务器端口（默认：`8080`）
- `ZOO_TICK_TIME`: 心跳时间（毫秒）（默认：`2000`）
- `ZOO_INIT_LIMIT`: 初始化限制（默认：`10`）
- `ZOO_SYNC_LIMIT`: 同步限制（默认：`5`）
- `ZOO_MAX_CLIENT_CNXNS`: 最大客户端连接数（默认：`60`）
- `ZOO_4LW_COMMANDS_WHITELIST`: 四字母命令白名单（默认：`srvr,mntr,ruok`）

## 访问

- 客户端端口：`localhost:2181`
- 管理服务器：<http://localhost:8080>

## 使用方法

### 连接到 ZooKeeper

```bash
docker compose exec zookeeper zkCli.sh
```

### 检查状态

```bash
echo ruok | nc localhost 2181
```

如果 ZooKeeper 正常运行，响应应该是 `imok`。

### 获取服务器统计信息

```bash
echo stat | nc localhost 2181
```

## 四字母命令

ZooKeeper 支持一组恰好四个字母的命令：

- `ruok`: 测试服务器是否运行
- `stat`: 列出服务器统计信息和客户端
- `srvr`: 列出服务器信息
- `mntr`: 列出服务器指标
- `conf`: 显示服务器配置

## 数据存储

ZooKeeper 数据存储在三个卷中：

- `zookeeper_data`: 主数据目录
- `zookeeper_datalog`: 事务日志
- `zookeeper_logs`: 应用程序日志

## 资源配置

- 资源限制：1 CPU，1G 内存
- 资源预留：0.25 CPU，512M 内存

## 生产环境考虑因素

对于生产环境部署：

1. 使用至少 3 个节点的集群（ensemble）
2. 为事务日志配置适当的磁盘 I/O
3. 监控堆内存使用情况
4. 设置适当的备份策略
5. 为所有必需的端口配置防火墙规则
