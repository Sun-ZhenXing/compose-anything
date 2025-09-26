# Clash

[English](./README.md) | [中文](./README.zh.md)

Clash 是一个用 Go 编写的基于规则的隧道工具。

## 初始化

1. 复制示例环境文件：

   ```bash
   cp .env.example .env
   ```

2. 在同一目录下创建你的 Clash 配置文件 `config.yaml`。

3. 启动服务：

   ```bash
   docker compose up -d
   ```

## 服务

- `clash`: Clash 服务。

## 配置

- **Web 仪表板**: <http://localhost:7880>
- **SOCKS5 代理**: localhost:7890
- **HTTP 代理**: localhost:7890

| 变量            | 描述       | 默认值   |
| --------------- | ---------- | -------- |
| `CLASH_VERSION` | Clash 版本 | `1.18.0` |

## 安全说明

- 在生产环境使用前更改默认密码和配置
- 考虑限制对 Web 仪表板的访问
- 检查你的代理规则和配置

## 许可证

请参考官方 Clash 项目的许可信息。
