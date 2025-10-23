# ArXiv MCP 服务器

ArXiv MCP 服务器通过 Model Context Protocol 提供与 arXiv 研究库之间的全面桥接。

## 功能特性

- 🔍 **论文搜索** - 使用高级过滤搜索 arXiv 论文
- 📥 **论文下载** - 下载并将论文转换为 Markdown
- 📖 **论文阅读** - 读取和分析论文内容
- 🔬 **研究分析** - 深层研究分析功能
- 💾 **本地存储** - 本地论文管理和存储

## 环境变量

| 变量                      | 默认值         | 说明               |
| ------------------------- | -------------- | ------------------ |
| `MCP_ARXIV_VERSION`       | `latest`       | MCP ArXiv 镜像版本 |
| `MCP_ARXIV_PORT_OVERRIDE` | `8000`         | MCP 服务端口       |
| `ARXIV_STORAGE_PATH`      | `/data/papers` | 论文存储路径       |
| `TZ`                      | `UTC`          | 时区               |

## 快速开始

```bash
docker compose up -d
```
