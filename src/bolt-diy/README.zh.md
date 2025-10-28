# Bolt.diy

Bolt.diy 是一个由 AI 驱动的网页版 IDE，让你可以直接在浏览器中构建全栈 web 应用程序。它将 AI 的强大功能与现代开发环境相结合，以简化你的开发工作流程。

## 快速开始

```bash
docker compose up -d
```

在 [http://localhost:5173](http://localhost:5173) 访问 Bolt.diy

## 功能特性

- **AI 驱动开发**：利用 AI 辅助代码生成和开发
- **全栈开发**：构建具有前端和后端功能的完整 web 应用程序
- **实时预览**：在开发时实时查看你的更改
- **内置终端**：直接在 IDE 中执行命令
- **Git 集成**：在 IDE 中管理你的代码库

## 配置

### 环境变量

| 变量                           | 默认值 | 说明                                        |
| ------------------------------ | ------ | ------------------------------------------- |
| `BOLT_DIY_PORT_OVERRIDE`       | 5173   | 访问 Bolt.diy 的主机端口                    |
| `BOLT_DIY_VERSION`             | latest | Docker 镜像版本                             |
| `VITE_LOG_LEVEL`               | info   | 日志级别（trace、debug、info、warn、error） |
| `ENABLE_EXPERIMENTAL_FEATURES` | false  | 启用实验性功能                              |
| `TZ`                           | UTC    | 时区                                        |

### 端口映射

- **5173**：Bolt.diy web 界面

## 存储卷

容器为开发环境使用内存存储。如需持久化存储，可根据需要挂载卷。

## 健康检查

该服务包含一个健康检查，监控 web 界面的可用性。

## 资源限制

- **CPU**：2 核心（上限）/ 0.5 核心（预留）
- **内存**：2GB（上限）/ 512MB（预留）

## 文档

- [Bolt.diy 官方仓库](https://github.com/stackblitz-labs/bolt.diy)
- [Bolt.diy 文档](https://docs.bolt.new/)

## 许可证

参考 [Bolt.diy 许可证](https://github.com/stackblitz-labs/bolt.diy/blob/main/LICENSE)
