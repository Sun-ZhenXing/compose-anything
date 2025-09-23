# Docker 镜像仓库

请参考教程 [搭建私有 Docker 镜像仓库](https://docs.alexsun.top/public/ops/docker/docker-registry/)。

需要先 [给服务器生成一张证书](https://docs.alexsun.top/public/blog/2024-06/certs-maker.html)，然后将证书放到服务器上的 `certs/` 文件夹下面，请使用 PEM 格式的证书。

配置 `.env` 文件：

```bash
REGISTRY_HTTP_TLS_CERTIFICATE=xxxxxx.crt
REGISTRY_HTTP_TLS_KEY=xxxxxx.key
```

使用 `OTEL_TRACES_EXPORTER=none` 停用观测。
