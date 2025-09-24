# RabbitMQ

[English](./README.md) | [中文](./README.zh.md)

This service deploys RabbitMQ, a message broker for reliable messaging between applications.

## Services

- `rabbitmq`: The RabbitMQ service.

## Configuration

- `RABBITMQ_VERSION`: The version of the RabbitMQ image, default is `4.1.4-management-alpine`.
- `RABBITMQ_PORT`: The host port for RabbitMQ, default is `5672`.
- `RABBITMQ_MANAGEMENT_PORT`: The host port for RabbitMQ Management UI, default is `15672`.
- `RABBITMQ_DEFAULT_USER`: The default username, default is `admin`.
- `RABBITMQ_DEFAULT_PASS`: The default password, default is `password`.

## Volumes

- `rabbitmq_data`: A volume for storing RabbitMQ data.
