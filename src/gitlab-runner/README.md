# GitLab Runner

[English](./README.md) | [中文](./README.zh.md)

This service deploys a GitLab Runner.

## Deploy GitLab Runner

1. Create a new runner instance in GitLab, and check *Run untagged jobs*.
2. Create the runner instance:

   ```bash
   docker compose up -d
   ```

3. Configure the runner:

   ```bash
   docker exec -it gitlab-runner gitlab-runner register
   ```

## Configuration

You can edit the `config.toml` file to modify the configuration:

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
    extra_hosts = [
      "host.docker.internal:host-gateway",
    ]
    shm_size = 0
    network_mtu = 0
```

## Services

- `gitlab-runner`: The GitLab Runner service.

## Volumes

- `/var/run/docker.sock`: For communicating with the Docker daemon.
- `config`: A volume for storing GitLab Runner configuration.
