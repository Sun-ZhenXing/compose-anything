FROM pytorch/pytorch:2.6.0-cuda12.4-cudnn9-runtime
ARG DEBIAN_FRONTEND=noninteractive
ARG VERSION=1.6.0

WORKDIR /workspace

RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    libsm6 libxext6 ffmpeg libfontconfig1 libxrender1 libgl1-mesa-glx \
    curl python3-pip
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --upgrade pip
RUN pip3 install iopaint==${VERSION} && pip3 cache purge

EXPOSE 8080
CMD ["iopaint", "start", "--model=lama", "--device=cuda", "--port=8080", "--host=0.0.0.0"]
