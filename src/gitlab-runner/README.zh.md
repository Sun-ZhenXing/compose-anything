# GitLab Runner

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署一个 GitLab Runner。

## 部署 GitLab Runner

1. 在 GitLab 中新建 Runner 实例，勾选 *运行未打标签的作业*。
2. 创建 Runner 实例：

   ```bash
   docker compose up -d
   ```

3. 配置 Runner：

   ```bash
   docker exec -it gitlab-runner gitlab-runner register
   ```

## 配置

可编辑配置文件 `config.toml` 来修改配置：

```toml
[[runners]]

[runners.docker]
tls_verify = false
pull_policy = "if-not-present"
image = "local/docker:1.0"
privileged = true
disable_entrypoint_overwrite = false
oom_kill_disable = false
disable_cache = false
volumes = [
  "/var/run/docker.sock:/var/run/docker.sock",
  "/cache",
  "/builds:/builds"
]
extra_hosts = [ "host.docker.internal:host-gateway", ]
shm_size = 0
network_mtu = 0
```

## 服务

- `gitlab-runner`: GitLab Runner 服务。

## 卷

- `/var/run/docker.sock`: 用于与 Docker 守护进程通信。
- `config`: 用于存储 GitLab Runner 配置的卷。
