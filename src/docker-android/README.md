# Docker Android Emulator

[English](./README.md) | [中文](./README.zh.md)

This service deploys the HQarroum Docker Android emulator image.

## Usage

- Start the default emulator:

  ```bash
  docker compose up -d
  ```

- Start with GPU acceleration:

  ```bash
  docker compose --profile gpu up -d
  ```

- Connect with ADB:

  ```bash
  adb connect 127.0.0.1:5555
  ```

## Services

- `docker_android`: Android emulator (default).
- `docker_android_gpu`: Android emulator with CUDA support (profile: `gpu`).

## Configuration

- `DOCKER_ANDROID_VERSION`: Image tag, default is `api-33`.
- `DOCKER_ANDROID_GPU_VERSION`: GPU image tag, default is `api-33-cuda`.
- `DOCKER_ANDROID_ADB_PORT_OVERRIDE`: Host port for ADB, default is `5555`.
- `DOCKER_ANDROID_CONSOLE_PORT_OVERRIDE`: Host port for emulator console, default is `5554`.
- `DOCKER_ANDROID_KVM_DEVICE`: KVM device path, default is `/dev/kvm`.
- `DOCKER_ANDROID_KEYS_DIR`: ADB key directory for Play Store images, default is `./keys`.
- `DOCKER_ANDROID_DISABLE_ANIMATION`: Disable animations, default is `false`.
- `DOCKER_ANDROID_DISABLE_HIDDEN_POLICY`: Disable hidden API policy, default is `false`.
- `DOCKER_ANDROID_SKIP_AUTH`: Skip ADB authentication, default is `true`.
- `DOCKER_ANDROID_MEMORY`: Emulator RAM in MB, default is `8192`.
- `DOCKER_ANDROID_CORES`: Emulator CPU cores, default is `4`.
- `DOCKER_ANDROID_GPU_COUNT`: Number of GPUs, default is `1`.
- `DOCKER_ANDROID_CPU_LIMIT`: CPU limit, default is `2`.
- `DOCKER_ANDROID_MEMORY_LIMIT`: Memory limit, default is `8G`.
- `DOCKER_ANDROID_CPU_RESERVATION`: CPU reservation, default is `1`.
- `DOCKER_ANDROID_MEMORY_RESERVATION`: Memory reservation, default is `4G`.

## Volumes

- `docker_android_data`: Android AVD data stored at `/data`.

## Notes

- Linux with KVM is required for performance. Ensure `/dev/kvm` is available.
- For Play Store images, set `DOCKER_ANDROID_VERSION=api-33-playstore` and place `adbkey` and `adbkey.pub` in the `./keys` directory.
- The emulator is headless and can be controlled with `scrcpy` after connecting ADB.
