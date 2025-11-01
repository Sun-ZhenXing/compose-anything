# Conductor

Netflix Conductor 是一个在云端运行的工作流编排引擎,允许您通过可视化工作流设计器来编排微服务和工作流。

## 功能特点

- **可视化工作流设计器**：通过拖放界面构建复杂工作流
- **微服务编排**：使用决策逻辑协调多个服务
- **任务管理**：内置重试机制和错误处理
- **可扩展架构**：为高吞吐量场景而设计
- **REST API**：完整的 REST API,提供 Java、Python、Go、C# SDK
- **监控**：通过 Prometheus 进行实时监控和指标收集

## 快速开始

1. 复制 `.env.example` 到 `.env`：

   ```bash
   copy .env.example .env
   ```

2. （可选）编辑 `.env` 自定义数据库密码和其他设置

3. 启动 Conductor（注意：首次运行将构建镜像,可能需要几分钟）：

   ```bash
   docker compose up -d
   ```

4. 等待服务健康检查通过（使用 `docker compose ps` 检查）

5. 访问 Conductor UI：`http://localhost:5000`

6. API 地址：`http://localhost:8080`

## 默认配置

| 服务             | 端口 | 说明               |
| ---------------- | ---- | ------------------ |
| Conductor Server | 8080 | REST API           |
| Conductor UI     | 5000 | Web UI             |
| PostgreSQL       | 5432 | 数据库（内部）     |
| Elasticsearch    | 9200 | 搜索与索引（内部） |

**身份验证**：默认未配置身份验证。在生产环境中应添加身份验证层（使用 OAuth2、LDAP 等的反向代理）。

## 环境变量

主要环境变量（完整列表请参阅 `.env.example`）：

| 变量                             | 说明               | 默认值      |
| -------------------------------- | ------------------ | ----------- |
| `CONDUCTOR_SERVER_PORT_OVERRIDE` | API 的主机端口     | `8080`      |
| `CONDUCTOR_UI_PORT_OVERRIDE`     | UI 的主机端口      | `5000`      |
| `POSTGRES_DB`                    | 数据库名称         | `conductor` |
| `POSTGRES_USER`                  | 数据库用户         | `conductor` |
| `POSTGRES_PASSWORD`              | 数据库密码         | `conductor` |
| `ELASTICSEARCH_VERSION`          | Elasticsearch 版本 | `8.11.0`    |
| `CONDUCTOR_LOG_LEVEL`            | 日志级别           | `INFO`      |
| `TZ`                             | 时区               | `UTC`       |

## 资源需求

**最低要求**：

- CPU：1 核心
- 内存：1.5GB
- 磁盘：5GB

**推荐配置**：

- CPU：4+ 核心
- 内存：4GB+
- 磁盘：20GB+

## 数据卷

- `postgres_data`：PostgreSQL 数据库数据
- `elasticsearch_data`：Elasticsearch 索引
- `conductor_logs`：Conductor 服务器日志

## 使用 Conductor

### 创建工作流

1. 访问 UI：`http://localhost:5000`
2. 进入 "Definitions" > "Workflow Defs"
3. 点击 "Define Workflow" 并使用可视化编辑器
4. 定义任务及其执行逻辑
5. 保存并执行您的工作流

### 使用 API

示例：获取服务器信息

```bash
curl http://localhost:8080/api/
```

示例：列出工作流

```bash
curl http://localhost:8080/api/metadata/workflow
```

### SDK

Conductor 提供官方 SDK：

- Java：<https://github.com/conductor-oss/conductor/tree/main/java-sdk>
- Python：<https://github.com/conductor-oss/conductor/tree/main/python-sdk>
- Go：<https://github.com/conductor-oss/conductor/tree/main/go-sdk>
- C#：<https://github.com/conductor-oss/conductor/tree/main/csharp-sdk>

## 安全注意事项

1. **身份验证**：生产环境中配置身份验证
2. **数据库密码**：为 PostgreSQL 使用强密码
3. **网络安全**：使用防火墙规则限制访问
4. **SSL/TLS**：通过反向代理启用 HTTPS
5. **Elasticsearch**：生产环境中考虑启用 X-Pack 安全功能

## 升级

升级 Conductor：

1. 在 `.env` 文件中更新版本（如果使用版本标签）
2. 拉取最新镜像并重启：

   ```bash
   docker compose pull
   docker compose up -d
   ```

3. 检查日志查看迁移消息：

   ```bash
   docker compose logs -f conductor-server
   ```

## 故障排除

**服务无法启动：**

- 检查日志：`docker compose logs conductor-server`
- 确保数据库健康：`docker compose ps postgres`
- 验证 Elasticsearch：`docker compose ps elasticsearch`

**UI 无法访问：**

- 检查端口 5000 是否可用：`netstat -an | findstr 5000`
- 验证服务运行状态：`docker compose ps conductor-server`

**性能问题：**

- 在 `.env` 中增加资源限制
- 监控 Elasticsearch 堆大小
- 检查数据库连接池设置

## 参考资料

- 官方网站：<https://conductor-oss.org>
- 文档：<https://docs.conductor-oss.org>
- GitHub：<https://github.com/conductor-oss/conductor>
- 社区：<https://github.com/conductor-oss/conductor/discussions>

## 许可证

Conductor 使用 Apache-2.0 许可证。详情请参阅 [LICENSE](https://github.com/conductor-oss/conductor/blob/main/LICENSE)。
