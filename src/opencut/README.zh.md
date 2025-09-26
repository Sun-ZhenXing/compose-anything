# OpenCut

[English](./README.md) | [中文](./README.zh.md)

OpenCut 是一个开源的视频编辑和音频处理平台。

## 先决条件

1. 访问 [FreeSound.org](https://freesound.org/) 并创建账户
2. 在账户设置中创建 API 应用
3. 获取客户端 ID 和 API 密钥

## 初始化

1. 复制示例环境文件：

   ```bash
   cp .env.example .env
   ```

2. 配置必要的环境变量（特别是 FreeSound API 配置）

3. 启动服务：

   ```bash
   docker compose up -d
   ```

4. 访问 Web 界面：<http://localhost:3100>

## 服务

- `opencut`: OpenCut Web 应用。
- `postgres`: PostgreSQL 数据库。
- `redis`: Redis 缓存。

## 配置

- **Web 应用**: 端口 3100
- **PostgreSQL 数据库**: 端口 5432
- **Redis 缓存**: 端口 6379
- **Redis HTTP 服务**: 端口 8079

| 变量                      | 描述                | 必需 |
| ------------------------- | ------------------- | ---- |
| `FREESOUND_CLIENT_ID`     | FreeSound 客户端 ID | 是   |
| `FREESOUND_API_KEY`       | FreeSound API 密钥  | 是   |
| `CLOUDFLARE_ACCOUNT_ID`   | Cloudflare 账户 ID  | 否*  |
| `R2_ACCESS_KEY_ID`        | R2 访问密钥 ID      | 否*  |
| `R2_SECRET_ACCESS_KEY`    | R2 密钥             | 否*  |
| `R2_BUCKET_NAME`          | R2 存储桶名称       | 否*  |
| `MODAL_TRANSCRIPTION_URL` | Modal 转录服务 URL  | 否*  |

*用于转录功能，如果不需要自动字幕功能可以留空。

## 数据持久化

- PostgreSQL 数据存储在 `postgres_data` 卷中
- Redis 数据在内存中，重启后会丢失

## 安全说明

- 在生产环境中更改默认的数据库密码
- 更新 `BETTER_AUTH_SECRET` 为一个安全的随机字符串
- 考虑为外部访问设置反向代理

## 许可证

请参考官方 OpenCut 项目的许可信息。
