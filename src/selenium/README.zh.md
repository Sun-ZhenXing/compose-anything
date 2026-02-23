# Selenium Standalone Chrome

[![Docker Image](https://img.shields.io/docker/v/selenium/standalone-chrome?sort=semver)](https://hub.docker.com/r/selenium/standalone-chrome)
[![Docker Pulls](https://img.shields.io/docker/pulls/selenium/standalone-chrome)](https://hub.docker.com/r/selenium/standalone-chrome)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/SeleniumHQ/docker-selenium/blob/trunk/LICENSE.md)

Selenium Grid 独立模式，配备 Chrome 浏览器，用于大规模浏览器自动化。

## 快速开始

```bash
# 启动服务
docker compose up -d

# 验证服务运行状态
docker compose ps

# 查看日志
docker compose logs -f

# 停止服务
docker compose down
```

## 服务信息

### 端口

| 端口 | 服务          | 说明                           |
| ---- | ------------- | ------------------------------ |
| 4444 | Selenium Grid | WebDriver HTTP 端点            |
| 7900 | noVNC         | 浏览器查看界面（密码：secret） |

### 默认凭据

- VNC 密码：`secret`（可通过 `SE_VNC_PASSWORD` 配置）

### 数据卷

- `selenium_downloads`：浏览器下载目录（`/home/seluser/Downloads`）

## 配置说明

### 环境变量

所有配置都可以通过 `.env` 文件自定义：

```bash
# 复制示例配置文件
cp .env.example .env

# 编辑配置
nano .env
```

主要配置：

| 变量                          | 默认值           | 说明                                  |
| ----------------------------- | ---------------- | ------------------------------------- |
| `SELENIUM_VERSION`            | `144.0-20260120` | Docker 镜像标签（Chrome 版本 + 日期） |
| `SELENIUM_SHM_SIZE`           | `2g`             | 共享内存大小（浏览器稳定性所需）      |
| `SELENIUM_GRID_PORT_OVERRIDE` | `4444`           | Grid HTTP 端点端口                    |
| `SELENIUM_VNC_PORT_OVERRIDE`  | `7900`           | noVNC 查看器端口                      |
| `SE_SCREEN_WIDTH`             | `1920`           | 浏览器屏幕宽度                        |
| `SE_SCREEN_HEIGHT`            | `1080`           | 浏览器屏幕高度                        |
| `SE_NODE_MAX_SESSIONS`        | `1`              | 每个容器最大并发会话数                |
| `SE_NODE_SESSION_TIMEOUT`     | `300`            | 会话超时时间（秒）                    |

完整的环境变量列表请参考 [Selenium Docker 文档](https://github.com/SeleniumHQ/docker-selenium/blob/trunk/ENV_VARIABLES.md)。

## 使用方法

### 基础 WebDriver 测试（Python）

```python
from selenium import webdriver
from selenium.webdriver.chrome.options import Options

# 配置 Chrome 选项
options = Options()

# 连接到 Selenium Grid
driver = webdriver.Remote(
    command_executor='http://localhost:4444',
    options=options
)

# 运行测试
driver.get('https://www.selenium.dev/')
print(driver.title)

# 清理资源
driver.quit()
```

### 基础 WebDriver 测试（Node.js）

```javascript
const { Builder } = require('selenium-webdriver')
const chrome = require('selenium-webdriver/chrome');

(async function example() {
  const driver = await new Builder()
    .forBrowser('chrome')
    .usingServer('http://localhost:4444')
    .build()

  try {
    await driver.get('https://www.selenium.dev/')
    console.log(await driver.getTitle())
  }
  finally {
    await driver.quit()
  }
})()
```

### 查看浏览器会话

您可以使用 noVNC 实时查看测试执行过程：

1. 在浏览器中打开 `http://localhost:7900/?autoconnect=1&resize=scale&password=secret`
2. 默认 VNC 密码是 `secret`
3. 您将实时看到浏览器会话

或者，使用 VNC 客户端连接到 `localhost:5900`（如果已暴露）。

## 高级配置

### 更改浏览器版本

要使用特定的 Chrome 版本，请在 `.env` 文件中更新 `SELENIUM_VERSION`：

```bash
# 使用 Chrome 143.0
SELENIUM_VERSION=143.0-20260120

# 或使用特定的 Selenium Grid 版本
SELENIUM_VERSION=144.0-chromedriver-144.0-grid-4.40.0-20260120
```

访问 [Docker Hub](https://hub.docker.com/r/selenium/standalone-chrome/tags) 查看可用版本。

### 增加并发会话数

在单个容器中运行多个并发会话（生产环境不推荐）：

```bash
SE_NODE_MAX_SESSIONS=5
```

**注意：** 为了更好的稳定性，建议通过扩展容器来实现：

```bash
docker compose up -d --scale selenium-chrome=3
```

### 获取下载的文件

要访问测试期间下载的文件，挂载下载目录：

```yaml
volumes:
  - ./downloads:/home/seluser/Downloads
```

**Linux 用户：** 挂载前设置正确的权限：

```bash
mkdir -p ./downloads
sudo chown 1200:1201 ./downloads
```

### 无头模式运行

对于新版 Chrome（127+），无头模式需要 Xvfb：

```bash
SE_START_XVFB=true
```

然后在测试中配置无头模式：

```python
options = Options()
options.add_argument('--headless=new')
```

### 自定义屏幕分辨率

根据测试需求调整屏幕分辨率：

```bash
SE_SCREEN_WIDTH=1366
SE_SCREEN_HEIGHT=768
SE_SCREEN_DEPTH=24
SE_SCREEN_DPI=74
```

## 健康检查

容器包含内置的健康检查，每 30 秒轮询 Grid 状态端点：

```bash
# 检查容器健康状态
docker compose ps

# 或检查健康状态详情
docker inspect --format='{{json .State.Health.Status}}' <container-id>
```

## 故障排除

### 浏览器崩溃

如果看到 "Chrome failed to start" 或 "invalid argument: can't kill an exited process" 等错误：

1. **确保足够的共享内存：** 默认的 `2g` 应该适用于大多数情况

   ```bash
   SELENIUM_SHM_SIZE=2g
   ```

2. **检查无头模式配置：** 如果在 Chrome 127+ 中使用无头模式，请确保 `SE_START_XVFB=true`

### 权限问题（Linux）

在 Linux 上挂载卷时，确保正确的权限：

```bash
# 对于下载目录
mkdir -p ./downloads
sudo chown 1200:1201 ./downloads

# 检查容器中的用户/组 ID
docker compose exec selenium-chrome id
```

### 资源限制

如果测试缓慢或容器被 OOM 终止：

```bash
# 增加资源限制
SELENIUM_CPU_LIMIT=4.0
SELENIUM_MEMORY_LIMIT=4G
```

### VNC 连接问题

如果无法连接到 VNC：

1. 检查端口 7900 是否被占用
2. 验证 VNC 密码是否正确（默认：`secret`）
3. 尝试禁用 VNC 认证：`SE_VNC_NO_PASSWORD=true`

## 多浏览器支持

要运行多种浏览器类型（Chrome、Firefox、Edge），请考虑使用：

- **Hub & Nodes 架构：** 参见 `docker-compose-grid.yaml` 示例
- **动态 Grid：** 按需自动生成容器
- **Selenium Grid 4：** 完整的分布式模式，包含 Router、Distributor 等

## 其他资源

- [Selenium 文档](https://www.selenium.dev/documentation/)
- [Docker Selenium GitHub](https://github.com/SeleniumHQ/docker-selenium)
- [Selenium Grid 配置](https://www.selenium.dev/documentation/grid/)
- [环境变量参考](https://github.com/SeleniumHQ/docker-selenium/blob/trunk/ENV_VARIABLES.md)

## 安全注意事项

- **VNC 密码：** 生产环境中更改默认的 `secret` 密码
- **网络暴露：** 不要将 Selenium Grid 直接暴露到互联网
- **资源限制：** 始终设置 CPU 和内存限制以防止资源耗尽
- **用户权限：** Selenium 以非 root 用户 `seluser` 运行（UID 1200，GID 1201）

## 许可证

本配置遵循 Apache License 2.0 提供，与 Selenium 项目的许可保持一致。
Selenium Docker 镜像由 SeleniumHQ 团队和社区贡献者维护。
