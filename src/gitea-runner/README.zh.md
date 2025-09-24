# Gitea Runner

[English](./README.md) | [中文](./README.zh.md)

此服务用于搭建一个 Gitea Runner。

## 前提条件

1. 生成 `config.yaml` 文件：

   ```bash
   docker run --entrypoint="" --rm -it gitea/act_runner:0.2.12 act_runner generate-config > config.yaml
   ```

2. 配置 `config.yaml`，例如：

   ```yaml
   cache:
     enabled: true
     dir: ""
     host: "192.168.8.17"
     port: 8088
   ```

3. 配置环境变量：

   ```properties
   INSTANCE_URL=http://xxx:3000
   REGISTRATION_TOKEN=xxxxxx
   RUNNER_NAME=runner-1
   RUNNER_LABELS=xxxxxx
   ```

## 启动 Runner

```bash
docker compose up -d
```

## 服务

- `runner`: Gitea Runner 服务。

## 配置

### 环境变量

- `INSTANCE_URL`: Gitea 实例的 URL。
- `REGISTRATION_TOKEN`: Gitea Runner 的注册令牌。
- `RUNNER_NAME`: Runner 的名称。
- `RUNNER_LABELS`: Runner 的标签。

## 卷

- `config.yaml`: Gitea Runner 的配置文件。
- `data`: 用于存储 Runner 数据的卷。
- `/var/run/docker.sock`: 用于与 Docker守护进程通信。
