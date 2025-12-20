# Netdata

[English](./README.md) | [中文](./README.zh.md)

Netdata 是一个高性能、实时的系统和应用监控与故障排除工具。它通过每秒的指标和交互式可视化，为您提供对基础设施的无与伦比的洞察力。

## 服务

- `netdata`: Netdata Agent (端口 19999)

## 快速开始

```bash
docker compose up -d
```

## 环境变量

| 变量名                       | 描述             | 默认值   |
| :--------------------------- | :--------------- | :------- |
| `NETDATA_VERSION`            | Netdata 镜像版本 | `v2.8.4` |
| `TZ`                         | 时区             | `UTC`    |
| `NETDATA_CPU_LIMIT`          | CPU 限制         | `1.0`    |
| `NETDATA_MEMORY_LIMIT`       | 内存限制         | `1G`     |
| `NETDATA_CPU_RESERVATION`    | CPU 预留         | `0.1`    |
| `NETDATA_MEMORY_RESERVATION` | 内存预留         | `256M`   |

请根据您的使用情况修改 `.env` 文件。

## 数据卷

- `netdataconfig`: 存储 Netdata 配置文件
- `netdatalib`: 存储 Netdata 库和数据库
- `netdatacache`: 存储 Netdata 缓存文件

## 注意事项

- 此配置使用 `network_mode: host` 以提供对宿主机的完整监控能力。
- Netdata 仪表板可通过 `http://localhost:19999` 访问。
