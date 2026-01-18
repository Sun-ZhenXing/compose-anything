# Docker Android Emulator

[English](./README.md) | [中文](./README.zh.md)

该服务用于部署 HQarroum 的 Docker Android Emulator 镜像。

## 使用方法

- 启动默认模拟器：

  ```bash
  docker compose up -d
  ```

- 启动 GPU 加速：

  ```bash
  docker compose --profile gpu up -d
  ```

- 使用 ADB 连接：

  ```bash
  adb connect 127.0.0.1:5555
  ```

## 服务

- `docker_android`：默认 Android 模拟器。
- `docker_android_gpu`：带 CUDA 的 Android 模拟器（Profile：`gpu`）。

## 配置

- `DOCKER_ANDROID_VERSION`：镜像标签，默认 `api-33`。
- `DOCKER_ANDROID_GPU_VERSION`：GPU 镜像标签，默认 `api-33-cuda`。
- `DOCKER_ANDROID_ADB_PORT_OVERRIDE`：ADB 主机端口，默认 `5555`。
- `DOCKER_ANDROID_CONSOLE_PORT_OVERRIDE`：模拟器控制台端口，默认 `5554`。
- `DOCKER_ANDROID_KVM_DEVICE`：KVM 设备路径，默认 `/dev/kvm`。
- `DOCKER_ANDROID_KEYS_DIR`：Play Store 镜像的 ADB 密钥目录，默认 `./keys`。
- `DOCKER_ANDROID_DISABLE_ANIMATION`：禁用动画，默认 `false`。
- `DOCKER_ANDROID_DISABLE_HIDDEN_POLICY`：禁用隐藏 API 策略，默认 `false`。
- `DOCKER_ANDROID_SKIP_AUTH`：跳过 ADB 认证，默认 `true`。
- `DOCKER_ANDROID_MEMORY`：模拟器内存（MB），默认 `8192`。
- `DOCKER_ANDROID_CORES`：模拟器 CPU 核心数，默认 `4`。
- `DOCKER_ANDROID_GPU_COUNT`：GPU 数量，默认 `1`。
- `DOCKER_ANDROID_CPU_LIMIT`：CPU 限制，默认 `2`。
- `DOCKER_ANDROID_MEMORY_LIMIT`：内存限制，默认 `8G`。
- `DOCKER_ANDROID_CPU_RESERVATION`：CPU 预留，默认 `1`。
- `DOCKER_ANDROID_MEMORY_RESERVATION`：内存预留，默认 `4G`。

## 数据卷

- `docker_android_data`：Android AVD 数据目录，挂载到 `/data`。

## 说明

- 建议在支持 KVM 的 Linux 主机上运行，确保 `/dev/kvm` 可用。
- Play Store 镜像请设置 `DOCKER_ANDROID_VERSION=api-33-playstore`，并将 `adbkey` 与 `adbkey.pub` 放到 `./keys` 目录。
- 模拟器为无界面模式，ADB 连接后可使用 `scrcpy` 进行控制。
