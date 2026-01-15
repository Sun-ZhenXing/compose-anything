# Overleaf

Overleaf 是一个基于网络的协作式 LaTeX 编辑器，使技术文档的编写如同小菜一碟。在线编写、编译和下载 LaTeX 文档，具有自动云备份功能。

## 快速开始

```bash
docker compose up -d
```

## 端口

| 服务     | 端口 | 用途     |
| -------- | ---- | -------- |
| Overleaf | 8080 | Web 界面 |

## 默认访问

- Web UI：<http://localhost:8080>
- 创建新账户或登录

## 环境变量

关键环境变量：

- `OVERLEAF_VERSION`：Docker 镜像版本（默认值：5.2.1）
- `OVERLEAF_PORT_OVERRIDE`：覆盖默认 HTTP 端口（默认值：8080）
- `SHARELATEX_APP_NAME`：应用程序名称（默认值：Overleaf）
- `SHARELATEX_ADMIN_EMAILS`：管理员电子邮件地址
- `ENABLE_SUBSCRIPTIONS`：启用订阅功能（默认值：false）

请查看 `.env.example` 获取所有可用选项。

## 包含的服务

- **Overleaf**：主应用程序
- **MongoDB**：项目和用户数据存储
- **Redis**：会话和缓存管理

## 功能特性

- 实时协作编辑
- 富文本和代码编辑器
- 编译文档的即时预览
- 版本控制和历史记录
- 模板库
- Git 集成（Pro 版）

## 文档

- [Overleaf 官方文档](https://www.overleaf.com/learn)
- [社区服务器设置](https://www.overleaf.com/help/207-how-does-overleaf-help-with-group-collaboration)

## 许可证

AGPL 许可证（社区版）
