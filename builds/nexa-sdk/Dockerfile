# https://github.com/NexaAI/nexa-sdk/issues/684
FROM ubuntu:24.04
#FROM nvidia/cuda:12.4.1-base-ubuntu22.04

RUN apt update && apt install -y libgomp1 curl ffmpeg sox
RUN curl -fsSL https://github.com/NexaAI/nexa-sdk/releases/latest/download/nexa-cli_linux_x86_64.sh | sh
