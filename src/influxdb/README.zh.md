# InfluxDB

InfluxDB 是一个高性能的开源时序数据库，专为处理高写入和查询负载而设计。它非常适合存储和分析指标、事件以及实时分析数据。

## 功能特性

- **时序优化**：专为时间戳数据而构建
- **高性能**：快速的时序数据写入和查询
- **类 SQL 查询语言**：Flux 和 InfluxQL 提供灵活的数据查询
- **内置 UI**：基于 Web 的数据探索和可视化界面
- **保留策略**：自动数据过期和降采样
- **多租户**：通过组织和桶实现数据隔离

## 快速开始

1. 复制环境配置文件并自定义：

   ```bash
   cp .env.example .env
   ```

2. 编辑 `.env` 文件配置您的 InfluxDB 实例：
   - `INFLUXDB_ADMIN_USERNAME`：管理员用户名（默认：admin）
   - `INFLUXDB_ADMIN_PASSWORD`：管理员密码（默认：changeme123456）
   - `INFLUXDB_ORG`：组织名称（默认：myorg）
   - `INFLUXDB_BUCKET`：默认桶名称（默认：mybucket）
   - `INFLUXDB_ADMIN_TOKEN`：API 访问令牌（默认：mytoken123456）

3. 启动 InfluxDB：

   ```bash
   docker compose up -d
   ```

4. 访问 InfluxDB UI：`http://localhost:8086`

## 配置说明

### 环境变量

| 变量                      | 说明                        | 默认值           |
| ------------------------- | --------------------------- | ---------------- |
| `INFLUXDB_VERSION`        | InfluxDB 版本               | `2.8.0`          |
| `TZ`                      | 时区                        | `UTC`            |
| `INFLUXDB_INIT_MODE`      | 初始化模式（setup/upgrade） | `setup`          |
| `INFLUXDB_ADMIN_USERNAME` | 管理员用户名                | `admin`          |
| `INFLUXDB_ADMIN_PASSWORD` | 管理员密码                  | `changeme123456` |
| `INFLUXDB_ORG`            | 组织名称                    | `myorg`          |
| `INFLUXDB_BUCKET`         | 默认桶名称                  | `mybucket`       |
| `INFLUXDB_RETENTION`      | 保留期限（0 表示永久）      | `0`              |
| `INFLUXDB_ADMIN_TOKEN`    | 管理员 API 令牌             | `mytoken123456`  |
| `INFLUXDB_PORT_OVERRIDE`  | 主机端口绑定                | `8086`           |

### 数据卷

- `influxdb_data`：存储时序数据
- `influxdb_config`：存储配置文件

## 使用方法

### 访问 Web UI

在浏览器中打开：

```text
http://localhost:8086
```

使用 `.env` 文件中配置的凭据登录。

### 使用命令行

在容器内执行命令：

```bash
docker compose exec influxdb influx
```

### 写入数据

使用 Flux 查询语言：

```bash
docker compose exec influxdb influx write \
  --bucket mybucket \
  --org myorg \
  'measurement,tag=value field=42'
```

### 查询数据

使用 CLI 查询数据：

```bash
docker compose exec influxdb influx query \
  --org myorg \
  'from(bucket: "mybucket") |> range(start: -1h)'
```

## API 访问

InfluxDB 提供 RESTful API 用于编程访问：

```bash
curl -X POST "http://localhost:8086/api/v2/query?org=myorg" \
  -H "Authorization: Token mytoken123456" \
  -H "Content-Type: application/json" \
  -d '{"query": "from(bucket: \"mybucket\") |> range(start: -1h)"}'
```

## 备份与恢复

### 备份

```bash
docker compose exec influxdb influx backup /var/lib/influxdb2/backup
docker compose cp influxdb:/var/lib/influxdb2/backup ./backup
```

### 恢复

```bash
docker compose cp ./backup influxdb:/var/lib/influxdb2/backup
docker compose exec influxdb influx restore /var/lib/influxdb2/backup
```

## 安全注意事项

1. **修改默认凭据**：在生产环境中务必修改默认的管理员密码和令牌
2. **使用强令牌**：为 API 访问生成加密安全的令牌
3. **网络安全**：生产环境中考虑使用带 HTTPS 的反向代理
4. **访问控制**：使用 InfluxDB 的内置授权系统限制访问

## 故障排除

### 容器无法启动

查看日志：

```bash
docker compose logs influxdb
```

### 无法访问 Web UI

确保端口 8086 未被占用：

```bash
netstat -an | grep 8086
```

### 数据持久化

验证数据卷是否正确挂载：

```bash
docker compose exec influxdb ls -la /var/lib/influxdb2
```

## 参考资源

- [官方文档](https://docs.influxdata.com/influxdb/v2/)
- [Flux 查询语言](https://docs.influxdata.com/flux/v0/)
- [Docker Hub](https://hub.docker.com/_/influxdb)
- [GitHub 仓库](https://github.com/influxdata/influxdb)

## 许可证

InfluxDB 采用 MIT 许可证发布。详情请参阅 [LICENSE](https://github.com/influxdata/influxdb/blob/master/LICENSE) 文件。
