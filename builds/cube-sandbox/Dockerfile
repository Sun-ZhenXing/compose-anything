# CubeSandbox in a privileged systemd+DinD container.
#
# CubeSandbox's official install.sh is designed for bare metal / VMs and
# requires a running systemd (it registers all services as systemd units).
# This image therefore runs systemd as PID 1 rather than tini.
#
# UBUNTU_IMAGE may be overridden to use a regional mirror, e.g.:
#   docker.m.daocloud.io/library/ubuntu:22.04   (China DaoCloud mirror)
#   ccr.ccs.tencentyun.com/library/ubuntu:22.04 (Tencent Cloud mirror)
ARG UBUNTU_IMAGE=ubuntu:22.04
FROM ${UBUNTU_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# Core system deps + systemd as the container init system.
# deploy/one-click/install.sh requires: tar, rg (ripgrep), ss (iproute2),
# bash, curl, sed, pgrep (procps), date, docker, python3, ip (iproute2), awk (gawk).
# Plus DinD prerequisites: iptables, ca-certificates, gnupg.
# Plus xfsprogs for the XFS-backed /data/cubelet (install.sh hard requirement).
RUN apt-get update && apt-get install -y --no-install-recommends \
        systemd \
        systemd-sysv \
        dbus \
        ca-certificates \
        curl \
        gnupg \
        lsb-release \
        bash \
        tar \
        ripgrep \
        iproute2 \
        procps \
        gawk \
        sed \
        python3 \
        python3-pip \
        iptables \
        kmod \
        xfsprogs \
        e2fsprogs \
        util-linux \
        file \
        less \
    && rm -rf /var/lib/apt/lists/*

# Mask systemd units that are irrelevant or will fail in a container context.
RUN for unit in \
        getty@tty1.service \
        apt-daily.service \
        apt-daily-upgrade.service \
        apt-daily.timer \
        apt-daily-upgrade.timer \
        motd-news.service \
        motd-news.timer \
        systemd-networkd.service \
        systemd-networkd-wait-online.service \
        systemd-udevd.service \
        systemd-udevd-control.socket \
        systemd-udevd-kernel.socket \
        systemd-logind.service \
        e2scrub_reap.service \
        apparmor.service; do \
    ln -sf /dev/null "/etc/systemd/system/${unit}"; \
    done

# Install Docker CE + Compose plugin from the official Docker apt repository.
RUN install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
       | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && chmod a+r /etc/apt/keyrings/docker.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
       https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" \
       > /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin \
    && rm -rf /var/lib/apt/lists/*

# Configure Docker daemon defaults.
RUN mkdir -p /etc/docker && printf '%s\n' \
    '{' \
    '  "log-driver": "json-file",' \
    '  "log-opts": { "max-size": "50m", "max-file": "3" },' \
    '  "storage-driver": "overlay2"' \
    '}' > /etc/docker/daemon.json

# Install E2B Python SDK so smoke tests can run from inside the container
# without polluting the WSL2 host with pip packages.
RUN pip3 install --no-cache-dir --break-system-packages \
        e2b-code-interpreter==1.0.* \
        requests \
    || pip3 install --no-cache-dir \
        e2b-code-interpreter==1.0.* \
        requests

# Persistent locations the installer writes to.
VOLUME ["/var/lib/docker", "/data", "/usr/local/services/cubetoolbox"]

# Helper scripts for the bootstrap flow.
COPY cube-init.sh       /usr/local/bin/cube-init.sh
COPY cube-xfs-setup.sh  /usr/local/bin/cube-xfs-setup.sh
COPY cube-install.sh    /usr/local/bin/cube-install.sh
RUN chmod +x \
        /usr/local/bin/cube-init.sh \
        /usr/local/bin/cube-xfs-setup.sh \
        /usr/local/bin/cube-install.sh

# Systemd service units for the CubeSandbox bootstrap sequence.
COPY cube-xfs-mount.service /etc/systemd/system/cube-xfs-mount.service
COPY cube-install.service   /etc/systemd/system/cube-install.service

# Enable services by creating the wanted-by symlinks that systemctl enable
# would create (systemctl cannot run during a Docker image build).
RUN mkdir -p /etc/systemd/system/multi-user.target.wants \
    && ln -sf /etc/systemd/system/cube-xfs-mount.service \
              /etc/systemd/system/multi-user.target.wants/cube-xfs-mount.service \
    && ln -sf /etc/systemd/system/cube-install.service \
              /etc/systemd/system/multi-user.target.wants/cube-install.service \
    && ln -sf /lib/systemd/system/docker.service \
              /etc/systemd/system/multi-user.target.wants/docker.service \
    && ln -sf /lib/systemd/system/containerd.service \
              /etc/systemd/system/multi-user.target.wants/containerd.service

# cube-init.sh captures CUBE_* and TZ env vars from the container runtime
# into /etc/cube-sandbox.env (readable by systemd EnvironmentFile=), then
# execs /lib/systemd/systemd as PID 1.
ENTRYPOINT ["/usr/local/bin/cube-init.sh"]
CMD ["/lib/systemd/systemd"]
