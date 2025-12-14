# Renovate - 自动化依赖更新工具

[English](README.md)

Renovate 是一个自动化依赖更新工具，当有新版本可用时，它会通过创建拉取请求来保持你的项目依赖最新。

## 特性

- 🤖 跨多平台的自动化依赖更新
- 🔄 支持 GitHub、GitLab、Gitea、Bitbucket、Azure DevOps 等
- 📦 多语言支持：JavaScript、Python、Go、Docker 等众多语言
- 🎯 高度可配置，提供智能默认值
- 🔒 注重安全，支持漏洞扫描
- 📊 详细的更新摘要和变更日志
- ⚙️ 灵活的调度和自动合并选项

## 快速开始

1. **复制示例环境文件：**

   ```bash
   cp .env.example .env
   ```

2. **配置身份验证：**
   编辑 `.env` 文件并设置：
   - `RENOVATE_PLATFORM`：你的平台（例如：`github`、`gitlab`、`gitea`）
   - `RENOVATE_TOKEN`：你的身份验证令牌（必需）
   - `RENOVATE_REPOSITORIES`：要处理的仓库（例如：`myorg/repo1,myorg/repo2`）

3. **获取身份验证令牌：**
   - **GitHub**：在 <https://github.com/settings/tokens> 创建个人访问令牌
     - 所需权限：`repo`、`workflow`
   - **GitLab**：在 <https://gitlab.com/-/profile/personal_access_tokens> 创建个人访问令牌
     - 所需权限：`api`、`write_repository`

4. **运行 Renovate：**

   ```bash
   # 一次性执行
   docker compose run --rm renovate

   # 或设置定时任务以定期运行
   # 示例：每天凌晨 2 点运行
   0 2 * * * cd /path/to/renovate && docker compose run --rm renovate
   ```

## 配置

### 环境变量

`.env` 中的关键环境变量：

| 变量                    | 描述              | 默认值         |
| ----------------------- | ----------------- | -------------- |
| `RENOVATE_VERSION`      | Renovate 镜像版本 | `42.52.5-full` |
| `RENOVATE_PLATFORM`     | 平台类型          | `github`       |
| `RENOVATE_TOKEN`        | 身份验证令牌      | **（必需）**   |
| `RENOVATE_REPOSITORIES` | 要处理的仓库      | `''`           |
| `RENOVATE_ONBOARDING`   | 创建引导 PR       | `true`         |
| `RENOVATE_DRY_RUN`      | 演练模式          | `false`        |
| `RENOVATE_LOG_LEVEL`    | 日志级别          | `info`         |

### 高级配置

对于高级配置，编辑 `config.js`：

```javascript
module.exports = {
  platform: 'github',
  repositories: ['myorg/repo1', 'myorg/repo2'],
  
  // 调度（cron 格式）
  schedule: ['before 5am on monday'],
  
  // 自动合并设置
  automerge: true,
  automergeType: 'pr',
  
  // 包规则
  packageRules: [
    {
      matchUpdateTypes: ['minor', 'patch'],
      automerge: true,
    },
  ],
};
```

## 使用示例

### 在特定仓库上运行

```bash
# 使用环境变量
RENOVATE_REPOSITORIES=myorg/repo1,myorg/repo2 docker compose run --rm renovate

# 使用 config.js - 先编辑文件
docker compose run --rm renovate
```

### 演练模式

在不创建实际 PR 的情况下测试配置：

```bash
RENOVATE_DRY_RUN=full docker compose run --rm renovate
```

### 调试模式

启用详细日志以进行故障排除：

```bash
RENOVATE_LOG_LEVEL=debug docker compose run --rm renovate
```

### 定期执行

创建 systemd 定时器或 cron 任务：

```bash
# Cron 示例（每天凌晨 2 点运行）
0 2 * * * cd /path/to/renovate && docker compose run --rm renovate >> /var/log/renovate.log 2>&1
```

## 工作原理

1. **引导**：首次运行时，Renovate 会创建一个包含 `renovate.json` 配置文件的引导 PR
2. **扫描**：Renovate 扫描你的仓库以查找依赖文件（package.json、requirements.txt、Dockerfile 等）
3. **检测**：检查所有检测到的依赖项的可用更新
4. **创建 PR**：根据你的配置创建更新的拉取请求
5. **调度**：可以配置为按计划运行（每天、每周等）

## 仓库配置

引导后，在仓库的 `renovate.json` 中配置 Renovate 行为：

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "extends": ["config:base"],
  "schedule": ["after 10pm every weekday", "before 5am every weekday", "every weekend"],
  "packageRules": [
    {
      "matchUpdateTypes": ["minor", "patch"],
      "automerge": true
    }
  ]
}
```

## 支持的平台

- GitHub（github.com 和 Enterprise Server）
- GitLab（gitlab.com 和 Self-Managed）
- Gitea
- Bitbucket Cloud 和 Server
- Azure DevOps
- 以及更多...

## 支持的语言和管理器

Renovate 支持 100 多个包管理器，包括：

- **JavaScript/Node.js**：npm、yarn、pnpm
- **Python**：pip、poetry、pipenv
- **Go**：go modules
- **Java**：maven、gradle
- **PHP**：composer
- **Ruby**：bundler
- **Rust**：cargo
- **Docker**：Dockerfile、docker-compose
- 以及更多...

## 安全性

- 以非 root 用户运行（可通过 `PUID`/`PGID` 配置）
- 最小权限与安全加固
- 基于令牌的身份验证（绝不在日志中暴露令牌）
- 支持漏洞扫描和安全更新

## 资源

资源限制可在 `.env` 中调整：

- **CPU**：2.0 核限制，0.5 核保留
- **内存**：2GB 限制，512MB 保留

## 故障排除

### 未找到仓库

确保 `RENOVATE_TOKEN` 具有适当的权限，并且 `RENOVATE_REPOSITORIES` 设置正确。

### 身份验证错误

验证令牌权限：

- GitHub：`repo`、`workflow`
- GitLab：`api`、`write_repository`

### 速率限制

在 `config.js` 中配置速率限制：

```javascript
prConcurrentLimit: 10,
prHourlyLimit: 2,
```

## 文档

- 官方文档：<https://docs.renovatebot.com/>
- 配置选项：<https://docs.renovatebot.com/configuration-options/>
- GitHub 仓库：<https://github.com/renovatebot/renovate>

## 许可证

Renovate 采用 AGPL-3.0 许可证。详情请参见 [Renovate 仓库](https://github.com/renovatebot/renovate)。

## 注意事项

- Renovate 设计为作为计划任务运行，而不是持续服务
- 首次运行将在每个仓库中创建一个引导 PR
- 考虑设置 cron 任务或 CI/CD 管道以定期执行
- 监控日志以确保更新正在正确处理
