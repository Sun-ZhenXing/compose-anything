# Jenkins

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署 Jenkins，一个用于 CI/CD 流水线的开源自动化服务器。

## 服务

- `jenkins`：Jenkins 自动化服务器

## 环境变量

| 变量名                        | 说明                                 | 默认值                                          |
| ----------------------------- | ------------------------------------ | ----------------------------------------------- |
| `JENKINS_VERSION`             | Jenkins 镜像版本                     | `2.486-lts-jdk17`                               |
| `JENKINS_HTTP_PORT_OVERRIDE`  | HTTP 主机端口映射（映射到端口 8080） | `8080`                                          |
| `JENKINS_AGENT_PORT_OVERRIDE` | 代理主机端口映射（映射到端口 50000） | `50000`                                         |
| `JENKINS_OPTS`                | 额外的 Jenkins 选项                  | `--httpPort=8080`                               |
| `JAVA_OPTS`                   | Java JVM 选项                        | `-Djenkins.install.runSetupWizard=false -Xmx2g` |
| `CASC_JENKINS_CONFIG`         | 配置即代码目录                       | `/var/jenkins_home/casc_configs`                |
| `JENKINS_USER_ID`             | Jenkins 进程的用户 ID                | `1000`                                          |
| `JENKINS_GROUP_ID`            | Jenkins 进程的组 ID                  | `1000`                                          |

请根据实际需求修改 `.env` 文件。

## 卷

- `jenkins_home`：用于存储 Jenkins 数据、配置和工作空间的卷
- `/var/run/docker.sock`：Docker 套接字（只读），用于 Docker-in-Docker 功能
- `./jenkins.yaml`：可选的配置即代码文件

## 初始设置

1. 启动服务：

   ```bash
   docker compose up -d
   ```

2. 获取初始管理员密码：

   ```bash
   docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
   ```

3. 访问 `http://localhost:8080` 并完成设置向导。

## 配置即代码

Jenkins 可以使用配置即代码（JCasC）进行配置。创建一个 `jenkins.yaml` 文件并将其挂载到 `/var/jenkins_home/casc_configs/jenkins.yaml`。

示例配置：

```yaml
jenkins:
  systemMessage: Jenkins configured automatically by Jenkins Configuration as Code plugin

  securityRealm:
    local:
      allowsSignup: false
      users:
        - id: admin
          password: admin123

  authorizationStrategy:
    loggedInUsersCanDoAnything:
      allowAnonymousRead: false
```

## 安全提示

- 设置完成后立即更改默认管理员密码
- 生产环境部署请考虑使用 HTTPS
- 定期更新 Jenkins 及其插件以获取安全补丁
- 使用适当的身份验证和授权策略
- 限制对 Jenkins Web 界面的访问
