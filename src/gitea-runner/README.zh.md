# Gitea Runner

[English](./README.md) | [中文](./README.zh.md)

此配置使用 Gitea Runner 2.1.0 运行 Gitea Actions。Compose 服务名为 `gitea_runner`，它通过宿主机的 Docker 守护进程在 Docker 容器中执行任务。

## 服务

- `gitea_runner`：注册到 Gitea，并为 Actions 任务创建 Docker 容器。

## 前提条件

在 Gitea 的“设置 -> Actions -> Runners”中创建 Runner 注册令牌。此令牌为必填项。

## 快速开始

```bash
cp .env.example .env
# 在 .env 中设置 GITEA_RUNNER_REGISTRATION_TOKEN，并在需要时修改 GITEA_INSTANCE_URL。
docker compose up -d
```

默认地址 `http://host.docker.internal:3000` 指向 Docker 宿主机上发布到 3000 端口的 Gitea。Compose 会为 Runner 将该主机名映射到宿主机网关，`config.yaml` 也会为任务容器添加同一映射。如果 Gitea 位于远程主机、使用其他端口，或无法通过宿主机访问，请修改此地址；所选地址必须同时可被 Runner 和任务容器访问。

## 配置

| 变量                                                            | 默认值                                                        | 说明                                                                                |
| --------------------------------------------------------------- | ------------------------------------------------------------- | ----------------------------------------------------------------------------------- |
| `GLOBAL_REGISTRY`                                               | 空                                                            | 可选镜像仓库前缀，必须包含末尾的 `/`。                                              |
| `GITEA_RUNNER_VERSION`                                          | `2.1.0`                                                       | Runner 镜像版本。                                                                   |
| `TZ`                                                            | `UTC`                                                         | 容器时区。                                                                          |
| `GITEA_INSTANCE_URL`                                            | `http://host.docker.internal:3000`                            | Runner 和任务容器均可访问的 Gitea 地址。                                            |
| `GITEA_RUNNER_REGISTRATION_TOKEN`                               | 空                                                            | 必填的注册令牌。                                                                    |
| `GITEA_RUNNER_NAME`                                             | `Gitea-Runner`                                                | Gitea 中显示的 Runner 名称。                                                        |
| `GITEA_RUNNER_LABELS`                                           | `ubuntu-latest`、`ubuntu-24.04`、`ubuntu-22.04` Docker labels | 以逗号分隔的 labels，默认 job image repository 为 `docker.io/gitea/runner-images`。 |
| `GITEA_RUNNER_HTTP_PROXY`                                       | 空                                                            | Runner 和每个任务容器使用的 HTTP 代理。留空则禁用代理。                             |
| `GITEA_RUNNER_HTTPS_PROXY`                                      | 空                                                            | HTTPS 代理。通常与 HTTP 代理使用同一地址。                                          |
| `GITEA_RUNNER_NO_PROXY`                                         | `localhost,127.0.0.1,::1,host.docker.internal`                | 不经过代理的主机列表。                                                              |
| `GITEA_RUNNER_CPU_LIMIT` / `GITEA_RUNNER_CPU_RESERVATION`       | `1.0` / `0.1`                                                 | CPU 限制和预留。                                                                    |
| `GITEA_RUNNER_MEMORY_LIMIT` / `GITEA_RUNNER_MEMORY_RESERVATION` | `2G` / `1G`                                                   | 内存限制和预留。                                                                    |

仓库已经提供可直接使用的 `config.yaml`，无需在启动前生成。如需查看上游 2.1.0 的新配置，可运行：

```bash
docker run --entrypoint="" --rm gitea/runner:2.1.0 gitea-runner generate-config > config.yaml
```

## 代理

在 `.env` 中设置 `GITEA_RUNNER_HTTP_PROXY` 和 `GITEA_RUNNER_HTTPS_PROXY`，整个栈即使用代理。两者默认为空，即不启用代理。

代理必须在宿主机上监听 `0.0.0.0` 而非仅 `127.0.0.1`，否则容器无法通过 `host.docker.internal` 访问。如果代理是同一网络上的另一个容器，请使用其服务名代替。

覆盖范围：

- Runner 自身对 Gitea 和 action 仓库的请求。
- 每个任务容器，因为 Runner 会同时注入大写和小写形式的代理变量。

### 为构建配置代理

Docker CLI 不从环境变量读取代理设置，但会从其自身的配置文件中读取。在任务的第一步写入该文件后，该任务中后续的 `docker build`、`docker compose build` 和 `docker buildx build` 都会自动使用代理，无需任何命令行参数。

```yaml
- run: mkdir -p ~/.docker && printf '{"proxies":{"default":{"httpProxy":"%s","httpsProxy":"%s","noProxy":"%s"}}}' "$HTTP_PROXY" "$HTTPS_PROXY" "$NO_PROXY" > ~/.docker/config.json
```

任务容器已经拥有这三个变量，因为 Runner 会注入它们，因此该步骤无需额外配置。当代理被禁用时，这些值为空，构建行为与之前相同。

Dockerfiles 无需为此添加 `ARG` 行，因为这些代理变量是预定义的构建参数。

请在同任务的任何 `docker login` 之前运行此步骤。`docker login` 会合并到同一文件并保留代理部分，但在登录之后写入该文件会丢弃已存储的凭据。

不覆盖：镜像拉取。任务容器镜像以及 `docker build` 期间拉取的基础镜像由宿主机 Docker 守护进程获取，该守护进程仅使用自身的代理配置。请单独配置：Docker Desktop 在 **Settings -> Resources -> Proxies** 中设置（Docker Desktop 会忽略 `daemon.json` 中的 `proxies` 键），在 Linux 上可在 `/etc/systemd/system/docker.service.d/http-proxy.conf` 中配置 systemd drop-in 并设置 `Environment="HTTP_PROXY=..."`，或在 Docker Engine 23.0 及以上版本的 `daemon.json` 中使用 `proxies` 键。

请勿在 `GITEA_RUNNER_NO_PROXY` 中使用 CIDR 格式。Runner 可以接受，但任务容器中的 `curl` 不支持。

## 存储与健康检查

- `gitea_runner_data` 保存注册信息和 Runner 状态。
- `./config.yaml` 以只读方式挂载到 `/config.yaml`。
- `/var/run/docker.sock` 让 Runner 能够创建任务容器。
- 健康检查访问内部指标端点 `http://127.0.0.1:9101/healthz`。

## 安全

访问 Docker 套接字等同于拥有宿主机级别的高权限。不要在此 Runner 上运行不可信 workflow。如需更强隔离，请使用专用宿主机或 VM，或评估 rootless Docker-in-Docker 方案。

## 从 act_runner 迁移

- 镜像和二进制名称已从 `gitea/act_runner` 和 `act_runner` 改为 `gitea/runner` 和 `gitea-runner`。
- 将 `INSTANCE_URL`、`REGISTRATION_TOKEN`、`RUNNER_NAME` 和 `RUNNER_LABELS` 改为上表对应的官方 `GITEA_*` 变量。
- 默认 labels 现在包含 Ubuntu 24.04 和 22.04 镜像，`container.force_pull` 的默认值改为 `false`。
- Runner v2.0 对私有镜像凭据引入了 breaking change；运行私有镜像前，请检查并重新配置相关凭据。
