# Open Policy Agent（OPA）

[English](./README.md) | [中文](./README.zh.md)

Open Policy Agent（OPA）是一个通用策略引擎，用于根据结构化数据作出策略决策。本 Docker Compose 栈使用官方 OPA 镜像，并提供一个最小授权策略。

## 服务

- `opa`：OPA 策略服务器与 HTTP API，使用容器端口 8181

## 快速开始

```bash
docker compose up -d
```

默认可通过 <http://127.0.0.1:8181> 访问 OPA。

为已允许的用户 `alice` 评估内置策略：

```bash
curl --request POST http://127.0.0.1:8181/v1/data/app/authz/allow \
  --header "Content-Type: application/json" \
  --data '{"input":{"user":"alice"}}'
```

响应为 `{"result":true}`。

## 配置与策略文件

- [policies/authz.rego](./policies/authz.rego) 定义默认拒绝的授权规则，并允许策略数据中列出的用户。
- [policies/data.json](./policies/data.json) 包含允许的用户，初始允许 `alice`。

编辑这些本地文件后，重启 OPA 以加载策略变更：

```bash
docker compose restart opa
```

## 环境变量

| 变量 | 说明 | 默认值 |
| --- | --- | --- |
| `GLOBAL_REGISTRY` | 可选的全局镜像仓库前缀 | `""` |
| `OPA_VERSION` | OPA 镜像版本 | `1.18.2` |
| `TZ` | 容器时区 | `UTC` |
| `OPA_PORT_OVERRIDE` | 映射到容器端口 8181 的宿主机回环端口 | `8181` |
| `OPA_CPU_LIMIT` | CPU 限制 | `0.5` |
| `OPA_CPU_RESERVATION` | CPU 预留 | `0.1` |
| `OPA_MEMORY_LIMIT` | 内存限制 | `256M` |
| `OPA_MEMORY_RESERVATION` | 内存预留 | `128M` |

## 端口

- `127.0.0.1:8181`：OPA HTTP API，默认仅绑定宿主机回环地址

## 存储

本地 `./policies` 目录以只读方式挂载到 `/policies`。此栈中的 OPA 不需要持久化卷或命名卷。

## 安全说明

- 默认仅在宿主机回环地址上公开 API，且此栈未提供内置身份验证。
- 容器以用户 `1000:1000` 运行，根文件系统只读，删除所有 Linux capabilities，并启用 `no-new-privileges`。
- `/tmp` 是容量受限的临时文件系统，禁止执行文件和设置用户 ID 的文件。
- 在本地主机以外公开 OPA 前，请审查策略数据并添加经过身份验证的网关。

## 参考资料

- [Open Policy Agent 文档](https://www.openpolicyagent.org/docs/)
- [OPA Docker Hub 仓库](https://hub.docker.com/r/openpolicyagent/opa)
- [OPA REST API](https://www.openpolicyagent.org/docs/rest-api/)
