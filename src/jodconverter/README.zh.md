# OfficeConverter（JODConverter）

[English](./README.md) | [中文](./README.zh.md)

此服务部署 OfficeConverter，一个基于 JODConverter 和 LibreOffice 的现代 REST API 文档转换服务。它自动进行文档转换，支持多种格式包括 Word、PDF、Excel、PowerPoint 等。officeconverter 项目是 jodconverter-samples-rest 的扩展和积极维护的版本。

## 服务

- `officeconverter`：具有集成 LibreOffice 实例的 REST API 文档转换服务。

## 环境变量

| 变量名                          | 描述                            | 默认值      |
| ------------------------------- | ------------------------------- | ----------- |
| OFFICECONVERTER_VERSION         | OfficeConverter 镜像版本        | `latest`    |
| OFFICECONVERTER_PORT_OVERRIDE   | 主机端口映射（映射到端口 8000） | 8000        |
| CONVERTER_LIBREOFFICE_INSTANCES | 并行 LibreOffice 实例数         | `2`         |
| CONVERTER_QUEUE_SIZE            | 最大转换队列大小                | `1000`      |
| JAVA_OPTS                       | Java 堆内存配置                 | `-Xmx1024m` |
| TZ                              | 时区                            | `UTC`       |

请根据您的使用情况修改 `.env` 文件。

## 卷

- `officeconverter_config`：用于存储 OfficeConverter 配置的卷，位于 `/etc/app`。

## 使用方法

1. 启动服务：

   ```bash
   docker compose up -d
   ```

2. OfficeConverter REST API 将在 `http://localhost:8000`（或您配置的端口）上可用。

3. 在 `http://localhost:8000/ready` 检查服务就绪状态

## 文档转换

### 基本转换

使用 REST API 转换文档：

```bash
curl -X POST http://localhost:8000/conversion?format=pdf \
  -F "file=@input.docx" \
  -o output.pdf
```

### REST 端点

- `POST /conversion?format=<format>` - 将文档转换为指定格式
  - 查询参数：`format` - 输出格式（例如 pdf、html、docx、xlsx）
  - 表单参数：`file` - 待转换文件
- `GET /ready` - 健康检查端点

### 支持的格式

OfficeConverter 支持各种文档格式之间的转换，包括：

- 文档：DOCX、DOC、ODT、RTF、TXT、DOTX
- 电子表格：XLSX、XLS、ODS、CSV、XLTX
- 演示文稿：PPTX、PPT、ODP
- PDF 和 HTML 转换

可以通过编辑 `src/resources/document-formats.json` 添加其他格式。

## 配置

### LibreOffice 实例

控制 LibreOffice 实例数量以实现并行文档处理：

```dotenv
CONVERTER_LIBREOFFICE_INSTANCES=4
```

更多实例允许更高的并发性，但会消耗更多内存。

### 内存配置

根据您的转换负载调整 Java 堆内存：

```dotenv
JAVA_OPTS=-Xmx2048m
```

### 自定义配置

挂载自定义 `application.yml` 文件以进行高级配置：

```yaml
# /etc/app/application.yml
converter:
  libreoffice-instances: 4
  queue:
    max-size: 2000
```

## 资源限制

- CPU：限制为 2 核，预留 0.5 核
- 内存：限制为 2 GB，预留 512 MB

资源限制可以根据您的转换工作负载在 docker-compose.yaml 中调整。

## 健康检查

该服务包括一个健康检查，验证 `/ready` 端点。在 30 秒的成功健康检查后，容器将被视为健康。

## 高级使用

### 带选项的转换

某些转换支持其他参数。查看 OfficeConverter 文档了解高级选项。

### 监控

查看日志以监视转换活动：

```bash
docker compose logs -f officeconverter
```

### 性能调优

对于高容量转换工作负载，请考虑：

- 将 `CONVERTER_LIBREOFFICE_INSTANCES` 增加到 4-8
- 增加 `JAVA_OPTS` 内存限制
- 增加 `CONVERTER_QUEUE_SIZE` 以支持更多待处理作业

## 故障排除

### 服务未就绪

检查服务是否已完全初始化：

```bash
curl http://localhost:8000/ready
```

如果未就绪，检查日志：

```bash
docker compose logs officeconverter
```

### 内存问题

如果转换因内存错误而失败，请增加 Java 堆：

```dotenv
JAVA_OPTS=-Xmx2048m
```

并增加 docker-compose.yaml 中的内存限制。

### 转换失败

检查服务日志以获取详细错误消息：

```bash
docker compose logs officeconverter | grep -i error
```

有关更多信息，请访问 [OfficeConverter GitHub 仓库](https://github.com/EugenMayer/officeconverter)。
