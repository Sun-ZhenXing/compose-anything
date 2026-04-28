#!/usr/bin/env bash
# Thin PID-1 wrapper: capture container runtime env vars into a file that
# systemd EnvironmentFile= can read, then exec systemd as PID 1.
#
# This script runs BEFORE systemd, so it must be kept minimal and must not
# depend on any CubeSandbox service being available.
set -euo pipefail

# Write CUBE_* and TZ vars to /etc/cube-sandbox.env so that
# cube-xfs-mount.service and cube-install.service can pick them up via
# EnvironmentFile=/etc/cube-sandbox.env.
install -m 0644 /dev/null /etc/cube-sandbox.env
printenv | grep -E '^(CUBE_|TZ=)' >> /etc/cube-sandbox.env 2>/dev/null || true

# Mount BPF filesystem required by network-agent eBPF map pinning.
# /sys/fs/bpf is not auto-mounted in Docker containers even when the kernel
# supports BPF; without it network-agent crashes on startup with
# "not on a bpf filesystem" and then a nil-pointer panic.
if ! mountpoint -q /sys/fs/bpf 2>/dev/null; then
    mkdir -p /sys/fs/bpf
    mount -t bpf none /sys/fs/bpf 2>/dev/null \
        || echo "[cube-init] WARNING: could not mount BPF filesystem; network-agent may fail" >&2
fi

# Redirect CubeMaster's rootfs artifact workspace to the persistent data volume.
# Template builds export the sandbox image into a tar (often > 2 GB) before
# converting it to an ext4 disk image.  /tmp is only a 2 GB tmpfs and is wiped on
# every container restart; /data (a named Docker volume) has 50+ GB and is
# persistent.
#
# We use a bind mount instead of a symlink: CubeMaster's Go startup code calls
# os.RemoveAll + os.MkdirAll on this path, which would silently replace a
# symlink with a real tmpfs directory.  A bind-mount point returns EBUSY on
# removal, keeping the mount intact so all writes land on /data.
mkdir -p /data/cubemaster-rootfs-artifacts
mkdir -p /tmp/cubemaster-rootfs-artifacts
if ! mountpoint -q /tmp/cubemaster-rootfs-artifacts 2>/dev/null; then
    mount --bind /data/cubemaster-rootfs-artifacts /tmp/cubemaster-rootfs-artifacts \
        || echo "[cube-init] WARNING: bind mount for cubemaster-rootfs-artifacts failed; writes may fill tmpfs" >&2
fi

# Hand off to systemd (or whatever CMD was passed to the container).
exec "$@"
