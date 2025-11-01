# Budibase

Budibase 是一个一体化的低代码平台，用于快速构建现代内部工具和仪表板。可以在几分钟内构建 CRUD 应用、管理面板、审批工作流等。

## 功能特点

- **可视化应用构建器**：通过拖放界面快速构建应用
- **内置数据库**：类似电子表格的数据库或连接到外部数据源
- **多租户支持**：用户管理和基于角色的访问控制
- **自动化**：无需编码即可构建工作流和自动化流程
- **自定义插件**：使用自定义组件扩展功能
- **API 和 Webhook**：REST API、GraphQL 和 webhook 支持
- **自托管**：完全控制您的数据

## 快速开始

1. 复制 `.env.example` 到 `.env`：

   ```bash
   copy .env.example .env
   ```

2. **重要**：编辑 `.env` 并更改以下安全设置：
   - `BUDIBASE_INTERNAL_API_KEY` - 生成一个 32 位以上的随机字符串
   - `BUDIBASE_JWT_SECRET` - 生成一个 32 位以上的随机字符串
   - `BUDIBASE_ADMIN_EMAIL` - 您的管理员邮箱
   - `BUDIBASE_ADMIN_PASSWORD` - 一个强密码
   - `BUDIBASE_MINIO_ACCESS_KEY` 和 `BUDIBASE_MINIO_SECRET_KEY` - MinIO 凭证

3. 启动 Budibase：

   ```bash
   docker compose up -d
   ```

4. 访问 `http://localhost:10000`

5. 使用配置的管理员凭证登录

## 默认配置

| 服务     | 端口  | 说明          |
| -------- | ----- | ------------- |
| Budibase | 10000 | Web UI 和 API |

**默认管理员凭证**（请更改！）：

- 邮箱：`admin@budibase.com`
- 密码：`changeme`

## 环境变量

主要环境变量（完整列表请参阅 `.env.example`）：

| 变量                        | 说明                      | 默认值               |
| --------------------------- | ------------------------- | -------------------- |
| `BUDIBASE_VERSION`          | Budibase 镜像版本         | `3.23.0`             |
| `BUDIBASE_PORT_OVERRIDE`    | UI 的主机端口             | `10000`              |
| `BUDIBASE_INTERNAL_API_KEY` | 内部 API 密钥（32+ 字符） | **必须更改！**       |
| `BUDIBASE_JWT_SECRET`       | JWT 密钥（32+ 字符）      | **必须更改！**       |
| `BUDIBASE_ADMIN_EMAIL`      | 管理员用户邮箱            | `admin@budibase.com` |
| `BUDIBASE_ADMIN_PASSWORD`   | 管理员用户密码            | `changeme`           |
| `BUDIBASE_ENVIRONMENT`      | 环境模式                  | `PRODUCTION`         |
| `TZ`                        | 时区                      | `UTC`                |

## 资源需求

**最低要求**：

- CPU：0.5 核心
- 内存：512MB
- 磁盘：2GB

**推荐配置**：

- CPU：2 核心
- 内存：2GB
- 磁盘：10GB

## 数据卷

- `budibase_data`：Budibase 应用数据（数据库、文件、配置）
- `redis_data`：Redis 缓存数据

## 安全注意事项

1. **更改默认凭证**：始终更改默认管理员凭证
2. **强密钥**：为 API 密钥和 JWT 密钥使用强随机字符串
3. **环境变量**：将敏感值存储在 `.env` 文件中，切勿提交到版本控制
4. **SSL/TLS**：在生产环境中使用带 SSL 的反向代理（nginx、Traefik）
5. **防火墙**：在生产环境中限制对 10000 端口的访问
6. **备份**：定期备份 `budibase_data` 数据卷

## 升级

1. 拉取最新镜像：

   ```bash
   docker compose pull
   ```

2. 重启服务：

   ```bash
   docker compose up -d
   ```

3. 检查日志：

   ```bash
   docker compose logs -f
   ```

## 故障排除

**服务无法启动：**

- 检查日志：`docker compose logs budibase`
- 确保端口未被占用：`netstat -an | findstr 10000`
- 验证环境变量设置正确

**无法登录：**

- 验证 `.env` 文件中的管理员凭证
- 通过使用新凭证重新创建容器来重置管理员密码

**性能问题：**

- 在 `.env` 文件中增加资源限制
- 检查 Redis 内存使用：`docker compose exec redis redis-cli INFO memory`

## 参考资料

- 官方网站：<https://budibase.com>
- 文档：<https://docs.budibase.com>
- GitHub：<https://github.com/Budibase/budibase>
- 社区：<https://github.com/Budibase/budibase/discussions>
- Docker Hub：<https://hub.docker.com/r/budibase/budibase>

## 许可证

Budibase 使用 GPL-3.0 许可证。详情请参阅 [LICENSE](https://github.com/Budibase/budibase/blob/master/LICENSE)。
