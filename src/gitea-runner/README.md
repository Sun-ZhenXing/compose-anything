# Gitea Runner

[English](./README.md) | [中文](./README.zh.md)

This service sets up a Gitea Runner.

## Prerequisites

1. Generate the `config.yaml` file:

   ```bash
   docker run --entrypoint="" --rm -it gitea/act_runner:0.2.13 act_runner generate-config > config.yaml
   ```

2. Configure `config.yaml`, for example:

   ```yaml
   cache:
     enabled: true
     dir: ''
     host: 192.168.8.17
     port: 8088
   ```

3. Configure environment variables:

   ```properties
   INSTANCE_URL=http://xxx:3000
   REGISTRATION_TOKEN=xxxxxx
   RUNNER_NAME=runner-1
   RUNNER_LABELS=xxxxxx
   ```

## Start the Runner

```bash
docker compose up -d
```

## Services

- `runner`: The Gitea Runner service.

## Configuration

### Environment Variables

- `INSTANCE_URL`: The URL of the Gitea instance.
- `REGISTRATION_TOKEN`: The registration token for the Gitea Runner.
- `RUNNER_NAME`: The name of the runner.
- `RUNNER_LABELS`: The labels for the runner.

## Volumes

- `config.yaml`: The configuration file for the Gitea Runner.
- `data`: A volume for storing runner data.
- `/var/run/docker.sock`: For communicating with the Docker daemon.
