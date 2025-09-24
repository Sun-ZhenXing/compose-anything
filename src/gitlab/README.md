# GitLab

[English](./README.md) | [中文](./README.zh.md)

This service sets up a GitLab service.

## Configuration

Edit the `config/gitlab.rb` file and add the following content:

```ruby
external_url 'http://my-server.local:5080'
nginx['listen_port'] = 5080
gitlab_rails['gitlab_ssh_host'] = 'my-server'
gitlab_rails['gitlab_shell_ssh_port'] = 5022
```

## Services

- `gitlab`: The GitLab service.

## Ports

- `5443:443` (HTTPS)
- `5080:80` (HTTP)
- `5022:22` (SSH)

## Volumes

- `config`: A volume for storing GitLab configuration.
- `logs`: A volume for storing GitLab logs.
- `data`: A volume for storing GitLab data.
