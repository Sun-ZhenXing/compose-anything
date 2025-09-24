# RabbitMQ

[English](./README.md) | [中文](./README.zh.md)

此服务用于部署 RabbitMQ，一个用于应用间可靠消息传递的消息中间件。

## 服务

- `rabbitmq`: RabbitMQ 服务。

## 配置

- `RABBITMQ_VERSION`: RabbitMQ 镜像的版本，默认为 `4.1.4-management-alpine`。
- `RABBITMQ_PORT`: RabbitMQ 的主机端口，默认为 `5672`。
- `RABBITMQ_MANAGEMENT_PORT`: RabbitMQ 管理界面的主机端口，默认为 `15672`。
- `RABBITMQ_DEFAULT_USER`: 默认用户名，默认为 `admin`。
- `RABBITMQ_DEFAULT_PASS`: 默认密码，默认为 `password`。

## 卷

- `rabbitmq_data`: 用于存储 RabbitMQ 数据的卷。
