# OpenCoze

[English](./README.md) | [中文](./README.zh.md)

OpenCoze 是一个基于 Coze Studio 的综合性 AI 应用开发平台。

## 重要提示

OpenCoze 需要一个复杂的多服务架构,包括:

- MySQL(数据库)
- Redis(缓存)
- Elasticsearch(搜索引擎)
- MinIO(对象存储)
- etcd(分布式配置)
- Milvus(向量数据库)
- NSQ(消息队列)
- Coze Server(主应用)
- Nginx(反向代理)

由于设置的复杂性,**我们建议直接使用 Coze Studio 仓库中的官方 docker-compose 配置**。

## 官方部署

1. 克隆官方仓库:

   ```bash
   git clone https://github.com/coze-dev/coze-studio.git
   cd coze-studio/docker
   ```

2. 遵循官方部署指南:
   - [官方文档](https://github.com/coze-dev/coze-studio)
   - [Docker 部署指南](https://github.com/coze-dev/coze-studio/tree/main/docker)

3. 官方 docker-compose 包含所有必需的服务及适当的配置。

## 系统要求

- **最低要求**:
  - CPU: 8 核
  - 内存: 16GB
  - 磁盘: 100GB SSD

- **推荐配置**:
  - CPU: 16 核
  - 内存: 32GB
  - 磁盘: 200GB SSD

## 主要功能

- **AI 机器人构建器**: 用于创建 AI 驱动的聊天机器人的可视化界面
- **工作流自动化**: 设计具有 AI 能力的复杂工作流
- **知识库**: 管理和利用知识库进行 AI 响应
- **插件系统**: 使用自定义插件扩展功能
- **多模型支持**: 与各种 LLM 提供商集成
- **团队协作**: 具有权限管理的多用户工作区

## 快速开始

详细的设置说明请参考:

- [官方 GitHub 仓库](https://github.com/coze-dev/coze-studio)
- [官方 Docker Compose](https://github.com/coze-dev/coze-studio/blob/main/docker/docker-compose.yml)

## 替代方案: 云版本

如果自托管过于复杂,可以考虑使用云版本:

- [Coze 云服务](https://www.coze.com/)(官方云服务)

## 安全提示

部署 OpenCoze 时:

- 更改所有默认密码
- 使用强加密密钥
- 启用带有有效 SSL 证书的 HTTPS
- 实施适当的防火墙规则
- 定期备份所有数据卷
- 保持所有服务更新到最新版本
- 监控资源使用和性能

## 支持

如有问题和疑问:

- [GitHub Issues](https://github.com/coze-dev/coze-studio/issues)
- [官方文档](https://github.com/coze-dev/coze-studio)
