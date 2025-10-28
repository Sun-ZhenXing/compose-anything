# Portkey AI 网关

[Portkey AI 网关](https://github.com/Portkey-AI/gateway)是一个快速、开源的 AI 网关，允许您通过单个 API 路由到 200+ 个语言、视觉、音频和图像模型。它提供可靠的路由、安全功能、成本管理和企业级部署选项。

## 特性

- **多 LLM 路由**：通过单个 API 路由到 200+ 个 LLM
- **可靠的路由**：故障转移、自动重试、负载均衡和请求超时
- **安全性和准确性**：防护栏、安全密钥管理、RBAC、SOC2/HIPAA/GDPR 合规
- **成本管理**：智能缓存、使用分析、提供者优化
- **协作**：代理框架支持、提示模板管理
- **企业级就绪**：具有高级功能的私有部署

## 快速开始

```bash
docker compose up -d
```

网关将在 `http://localhost:8787` 可用

访问控制台 `http://localhost:8787/public/`

## 环境变量

- `PORTKEY_GATEWAY_VERSION`：Docker 镜像版本（默认：`latest`）
- `PORTKEY_GATEWAY_PORT_OVERRIDE`：暴露的主机端口（默认：`8787`）
- `TZ`：时区（默认：`UTC`）

## 文档

- [Portkey 网关文档](https://portkey.ai/docs)
- [GitHub 仓库](https://github.com/Portkey-AI/gateway)
- [API 参考](https://portkey.ai/docs/welcome/make-your-first-request)

## 默认端口

- **网关 API**：`8787`（<http://localhost:8787/v1>）
- **控制台**：`8787`（<http://localhost:8787/public/>）

## 配置

网关通过控制台提供广泛的配置系统。主要功能包括：

- 模型路由规则和条件
- 故障转移和重试策略
- 输入/输出防护栏
- 自定义插件和集成
- 密钥管理和虚拟密钥

访问控制台 `http://localhost:8787/public/` 来配置网关。

## 集成

Portkey 网关与以下集成：

- **LLM 框架**：LangChain、LlamaIndex、Autogen、CrewAI
- **代理框架**：支持自定义代理
- **监控**：日志记录和跟踪功能

## 许可证

Portkey AI 网关是开源的，采用 MIT 许可证。
