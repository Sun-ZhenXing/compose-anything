# OpenList

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署 OpenList，一个支持多种存储的文件列表程序。

## 服务

- `openlist`：OpenList 服务

## 环境变量

| 变量名                   | 说明          | 默认值          |
| ------------------------ | ------------- | --------------- |
| `OPENLIST_VERSION`       | OpenList 版本 | `latest`        |
| `PUID`                   | 用户 ID       | `0`             |
| `PGID`                   | 组 ID         | `0`             |
| `UMASK`                  | UMASK         | `022`           |
| `TZ`                     | 时区          | `Asia/Shanghai` |
| `OPENLIST_PORT_OVERRIDE` | 主机端口映射  | `5244`          |

## 卷

- `openlist_data`：数据目录

## 使用方法

### 启动 OpenList

```bash
docker compose up -d
```

### 访问

- Web UI：<http://localhost:5244>

### 初始设置

1. 打开 <http://localhost:5244>
2. 完成初始设置向导
3. 配置存储提供商
4. 开始管理文件

## 注意事项

- 首次启动需要初始配置
- 支持多种云存储提供商
- AList 的社区驱动分支

## 许可证

OpenList 遵循原始 AList 许可证。详情请参见 [OpenList GitHub](https://github.com/OpenListTeam/OpenList)。
