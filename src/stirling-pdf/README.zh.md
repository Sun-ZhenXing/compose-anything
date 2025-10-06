# Stirling-PDF

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署 Stirling-PDF，一个本地托管的基于 Web 的 PDF 操作工具。

## 服务

- `stirling-pdf`: Stirling-PDF 服务。

## 环境变量

| 变量名               | 说明                   | 默认值         |
| -------------------- | ---------------------- | -------------- |
| STIRLING_VERSION     | Stirling-PDF 镜像版本  | `latest`       |
| PORT_OVERRIDE        | 主机端口映射           | `8080`         |
| ENABLE_SECURITY      | 启用安全功能           | `false`        |
| ENABLE_LOGIN         | 启用登录功能           | `false`        |
| INITIAL_USERNAME     | 初始管理员用户名       | `admin`        |
| INITIAL_PASSWORD     | 初始管理员密码         | `admin`        |
| INSTALL_ADVANCED_OPS | 安装高级操作           | `false`        |
| LANGUAGES            | 支持的语言（逗号分隔） | `en_GB`        |
| PUID                 | 运行服务的用户 ID      | `1000`         |
| PGID                 | 运行服务的组 ID        | `1000`         |
| UMASK                | 文件创建掩码           | `022`          |
| DEFAULT_LOCALE       | 默认系统区域设置       | `en-US`        |
| APP_NAME             | 应用程序名称           | `Stirling-PDF` |
| HOME_DESCRIPTION     | 主页描述               | `""`           |
| NAVBAR_NAME          | 导航栏名称             | `""`           |
| MAX_FILE_SIZE        | 最大文件大小（MB）     | `2000`         |
| METRICS_ENABLED      | 启用指标收集           | `false`        |
| GOOGLE_VISIBILITY    | 允许 Google 索引       | `false`        |

请根据实际需求修改 `.env` 文件。

## 卷

- `stirling_trainingData`: Tesseract 的 OCR 训练数据。
- `stirling_configs`: 配置文件。
- `stirling_logs`: 应用程序日志。
- `stirling_customFiles`: 自定义文件和模板。

## 功能

Stirling-PDF 支持 50 多种 PDF 操作，包括:

- 合并、拆分、旋转 PDF
- PDF 转换
- OCR（光学字符识别）
- 添加/删除水印
- 压缩 PDF
- 加密/解密 PDF
- 签名 PDF
- 填写表单
- 提取图像和文本
- 以及更多功能！

## 安全说明

- 默认情况下，安全功能被禁用以便于设置。
- 对于生产环境，请设置 `ENABLE_SECURITY=true` 和 `ENABLE_LOGIN=true`。
- 在部署前更改默认管理员凭据。
- 考虑使用反向代理和 HTTPS 以实现安全访问。

## 许可证

Stirling-PDF 使用 MIT 许可证授权。
