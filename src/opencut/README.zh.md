# OpenCut

[English](./README.md) | [中文](./README.zh.md)

OpenCut 是一个开源的视频编辑和音频处理平台。

## 前置条件

在部署 OpenCut 之前，您需要：

1. 访问 [FreeSound.org](https://freesound.org/) 并创建账户
2. 在账户设置中创建 API 应用程序以获取您的客户端 ID 和 API 密钥
3. **从源代码构建 OpenCut web 镜像**（参见 [OpenCut GitHub](https://github.com/OpenCut-app/OpenCut)）

## 快速开始

1. 复制示例环境变量文件：

   ```bash
   cp .env.example .env
   ```

2. **必需配置** - 编辑 `.env` 并设置以下必需变量：
   - `POSTGRES_PASSWORD`：数据库密码（请修改默认值！）
   - `SERVERLESS_REDIS_HTTP_TOKEN`：Redis HTTP 接口的随机令牌
   - `OPENCUT_BETTER_AUTH_SECRET`：身份验证的随机密钥
   - `OPENCUT_FREESOUND_CLIENT_ID`：您的 FreeSound 客户端 ID
   - `OPENCUT_FREESOUND_API_KEY`：您的 FreeSound API 密钥

3. **可选配置** - 如需转录功能，请设置：
   - `OPENCUT_CLOUDFLARE_ACCOUNT_ID`
   - `OPENCUT_R2_ACCESS_KEY_ID`
   - `OPENCUT_R2_SECRET_ACCESS_KEY`
   - `OPENCUT_R2_BUCKET_NAME`
   - `OPENCUT_MODAL_TRANSCRIPTION_URL`

4. 启动服务：

   ```bash
   docker compose up -d
   ```

5. 访问 Web 界面：<http://localhost:3100>

## 服务

- `web`：OpenCut Web 应用程序
- `db`：PostgreSQL 数据库
- `redis`：Redis 缓存
- `serverless-redis-http`：用于 Upstash 兼容性的 Redis HTTP 接口

## 配置

### 版本配置

- `POSTGRES_VERSION`：PostgreSQL 版本，默认为 `17`
- `REDIS_VERSION`：Redis 版本，默认为 `7-alpine`
- `SERVERLESS_REDIS_HTTP_VERSION`：Serverless Redis HTTP 版本，默认为 `latest`
- `OPENCUT_WEB_IMAGE`：OpenCut web 镜像名称，默认为 `opencut/web:latest`

### 端口配置

- `POSTGRES_PORT_OVERRIDE`：PostgreSQL 主机端口，默认为 `5432`
- `REDIS_PORT_OVERRIDE`：Redis 主机端口，默认为 `6379`
- `SERVERLESS_REDIS_HTTP_PORT_OVERRIDE`：Redis HTTP 接口主机端口，默认为 `8079`
- `OPENCUT_WEB_PORT_OVERRIDE`：Web 应用程序主机端口，默认为 `3100`

### 数据库配置

- `POSTGRES_USER`：数据库用户名，默认为 `opencut`
- `POSTGRES_PASSWORD`：数据库密码，**必需**
- `POSTGRES_DB`：数据库名称，默认为 `opencut`

### Redis 配置

- `SERVERLESS_REDIS_HTTP_TOKEN`：Redis HTTP 接口的令牌，**必需**

### 应用程序配置

- `TZ`：时区，默认为 `UTC`
- `OPENCUT_BETTER_AUTH_URL`：身份验证服务 URL，默认为 `http://localhost:3100`
- `OPENCUT_BETTER_AUTH_SECRET`：身份验证密钥，**必需**
- `OPENCUT_FREESOUND_CLIENT_ID`：FreeSound 客户端 ID，**必需**
- `OPENCUT_FREESOUND_API_KEY`：FreeSound API 密钥，**必需**

### 可选转录配置

留空以禁用自动字幕功能：

- `OPENCUT_CLOUDFLARE_ACCOUNT_ID`：Cloudflare 账户 ID
- `OPENCUT_R2_ACCESS_KEY_ID`：R2 访问密钥 ID
- `OPENCUT_R2_SECRET_ACCESS_KEY`：R2 秘密访问密钥
- `OPENCUT_R2_BUCKET_NAME`：R2 存储桶名称
- `OPENCUT_MODAL_TRANSCRIPTION_URL`：Modal 转录服务 URL

## 数据卷

- `postgres_data`：PostgreSQL 数据存储

## 资源限制

| 服务                  | CPU 限制 | 内存限制 | CPU 预留 | 内存预留 |
| --------------------- | -------- | -------- | -------- | -------- |
| web                   | 2.00     | 2G       | 0.50     | 512M     |
| db                    | 2.00     | 1G       | 0.50     | 256M     |
| redis                 | 1.00     | 512M     | 0.25     | 128M     |
| serverless-redis-http | 1.00     | 256M     | 0.25     | 64M      |

## 安全提示

⚠️ **重要安全建议：**

- **在生产环境部署前修改所有默认密码和密钥**
- 为以下变量使用强随机生成的值：
  - `POSTGRES_PASSWORD`
  - `SERVERLESS_REDIS_HTTP_TOKEN`
  - `OPENCUT_BETTER_AUTH_SECRET`
- 切勿将包含真实凭据的 `.env` 文件提交到版本控制系统
- 考虑设置带 HTTPS 的反向代理以供外部访问
- 在生产环境中将数据库和 Redis 端口限制在内部网络
- 妥善保管 FreeSound API 密钥

## 从源代码构建

由于 OpenCut 不提供预构建的 Docker 镜像，您需要自行构建：

```bash
# 克隆 OpenCut 仓库
git clone https://github.com/OpenCut-app/OpenCut.git
cd OpenCut

# 构建 web 镜像
docker build -t opencut/web:latest -f apps/web/Dockerfile .

# 返回到您的 compose 目录并启动服务
cd /path/to/compose-anything/src/opencut
docker compose up -d
```

## 参考

- [OpenCut 官方仓库](https://github.com/OpenCut-app/OpenCut)
- [原始 docker-compose.yaml](https://github.com/OpenCut-app/OpenCut/blob/main/docker-compose.yaml)

## 许可证

请参考 OpenCut 官方项目的许可证信息。
