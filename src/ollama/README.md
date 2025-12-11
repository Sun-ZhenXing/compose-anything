# Ollama

[English](./README.md) | [中文](./README.zh.md)

This service deploys Ollama for running local LLM models.

## Usage

- Pull DeepSeek R1 7B model:

  ```bash
  docker exec -it ollama-ollama-1 ollama pull deepseek-r1:7b
  ```

- List all local models:

  ```bash
  docker exec -it ollama-ollama-1 ollama list
  ```

- Get all local models via API:

  ```bash
  curl http://localhost:11434/api/tags 2> /dev/null | jq
  ```

## Services

- `ollama`: The Ollama service.

## Configuration

- `OLLAMA_VERSION`: The version of the Ollama image, default is `0.12.0`.
- `OLLAMA_PORT_OVERRIDE`: The host port for Ollama, default is `11434`.

## Volumes

- `ollama_models`: A volume for storing Ollama models.

## Troubleshooting

### GPU Becomes Unavailable After Long Run (Linux Docker)

If Ollama initially works on the GPU in a Docker container, but then switches to running on CPU after some period of time with errors in the server log reporting GPU discovery failures, this can be resolved by disabling systemd cgroup management in Docker.

Edit `/etc/docker/daemon.json` on the host and add `"exec-opts": ["native.cgroupdriver=cgroupfs"]` to the Docker configuration:

```json
{
  "exec-opts": ["native.cgroupdriver=cgroupfs"]
}
```

Then restart Docker:

```bash
sudo systemctl restart docker
```

For more details, see [Ollama Troubleshooting - Linux Docker](https://docs.ollama.com/troubleshooting#linux-docker).
