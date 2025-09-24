# GitLab

[English](./README.md) | [中文](./README.zh.md)

此服务用于搭建一个 GitLab 服务。

## 配置

编辑 `config/gitlab.rb` 文件，添加以下内容：

```ruby
external_url 'http://my-server.local:5080'
nginx['listen_port'] = 5080
gitlab_rails['gitlab_ssh_host'] = 'my-server'
gitlab_rails['gitlab_shell_ssh_port'] = 5022
```

## 服务

- `gitlab`: GitLab 服务。

## 端口

- `5443:443` (HTTPS)
- `5080:80` (HTTP)
- `5022:22` (SSH)

## 卷

- `config`: 用于存储 GitLab 配置的卷。
- `logs`: 用于存储 GitLab 日志的卷。
- `data`: 用于存储 GitLab 数据的卷。
