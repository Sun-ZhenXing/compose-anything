# Ollama

[English](./README.md) | [中文](./README.zh.md)

This service deploys Ollama for running local LLM models.

## Usage

- Pull DeepSeek R1 7B model:

  ```bash
  docker exec -it ollama ollama pull deepseek-r1:7b
  ```

- List all local models:

  ```bash
  docker exec -it ollama ollama list
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
