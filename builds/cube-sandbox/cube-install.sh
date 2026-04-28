#!/usr/bin/env bash
# Run the CubeSandbox one-click installer, then run quickcheck.sh.
# Called by cube-install.service (Type=oneshot) after docker.service and
# cube-xfs-mount.service are both active.
set -euo pipefail

log() { printf '[cube-install] %s\n' "$*"; }
err() { printf '[cube-install] ERROR: %s\n' "$*" >&2; }

INSTALL_PREFIX="/usr/local/services/cubetoolbox"
QUICKCHECK="${INSTALL_PREFIX}/scripts/one-click/quickcheck.sh"
UP_SCRIPT="${INSTALL_PREFIX}/scripts/one-click/up-with-deps.sh"
MIRROR="${CUBE_MIRROR:-cn}"
INSTALLER_URL_CN="https://cnb.cool/CubeSandbox/CubeSandbox/-/git/raw/master/deploy/one-click/online-install.sh"
INSTALLER_URL_GH="https://github.com/tencentcloud/CubeSandbox/raw/master/deploy/one-click/online-install.sh"

# /dev/kvm sanity — required by the MicroVM hypervisor.
if [ ! -c /dev/kvm ]; then
    err "/dev/kvm is not available inside the container."
    err "Ensure the compose stack passes --device /dev/kvm and nested virt is enabled on the host."
    exit 1
fi
log "KVM device present: $(ls -l /dev/kvm)"

# Wait for dockerd (started by docker.service) to be ready before install.sh
# tries to pull MySQL / Redis / CubeProxy images.
log "Waiting for docker daemon ..."
for i in $(seq 1 60); do
    if docker info >/dev/null 2>&1; then
        log "docker ready."
        break
    fi
    sleep 2
done
if ! docker info >/dev/null 2>&1; then
    err "docker daemon not ready after 120 s"
    exit 1
fi

# Redirect TMPDIR to the 50 GB XFS volume.
# /tmp is only 256 MB (tmpfs) and mounted noexec — both cause install failures:
#   - curl: (23) Failure writing output to destination  (out of space)
#   - extracted scripts fail to execute                 (noexec mount flag)
mkdir -p /data/tmp
export TMPDIR=/data/tmp
log "TMPDIR set to $TMPDIR ($(df -h /data/tmp | awk 'NR==2{print $4}') free)"

# Set CAROOT so mkcert can find / create the local CA directory on every boot.
# Without this, up-cube-proxy.sh calls `mkcert -install` which exits with:
#   "ERROR: failed to find the default CA location"
# Because up-with-deps.sh runs under set -euo pipefail, that failure aborts
# the entire script before any compute services (network-agent, CubeAPI, etc.)
# are started.  Persisting the CA on /data (named volume) means the cert is
# re-used across container restarts rather than regenerated each time.
export CAROOT=/data/mkcert-ca
mkdir -p "$CAROOT"
log "CAROOT set to $CAROOT"

# Run the upstream one-click installer on first boot; on subsequent boots
# just re-launch all services via up-with-deps.sh.
if [ -x "$QUICKCHECK" ] && [ "${CUBE_FORCE_REINSTALL:-0}" != "1" ]; then
    log "CubeSandbox already installed at $INSTALL_PREFIX — starting services."
    if [ ! -x "$UP_SCRIPT" ]; then
        err "up-with-deps.sh not found at $UP_SCRIPT — reinstall required"
        exit 1
    fi
    ONE_CLICK_TOOLBOX_ROOT="$INSTALL_PREFIX" \
    ONE_CLICK_RUNTIME_ENV_FILE="${INSTALL_PREFIX}/.one-click.env" \
    bash "$UP_SCRIPT" \
        || log "WARNING: up-with-deps.sh exited non-zero; services may still be starting"
else
    log "Running CubeSandbox one-click installer (mirror=$MIRROR) ..."
    if [ "$MIRROR" = "cn" ]; then
        curl -fsSL "$INSTALLER_URL_CN" | MIRROR=cn bash
    else
        curl -fsSL "$INSTALLER_URL_GH" | bash
    fi
fi

# Run quickcheck.sh with retries — network-agent initialises 500 tap interfaces
# which takes ~2 minutes; we retry every 30 s for up to 10 minutes.
QUICKCHECK_PASSED=0
if [ -x "$QUICKCHECK" ]; then
    log "Running quickcheck.sh (retrying up to 10 min for network-agent tap init) ..."
    for i in $(seq 1 20); do
        if ONE_CLICK_TOOLBOX_ROOT="$INSTALL_PREFIX" \
           ONE_CLICK_RUNTIME_ENV_FILE="${INSTALL_PREFIX}/.one-click.env" \
           "$QUICKCHECK" 2>&1; then
            QUICKCHECK_PASSED=1
            break
        fi
        log "quickcheck attempt $i/20 failed — retrying in 30 s ..."
        sleep 30
    done
else
    err "quickcheck.sh not found at $QUICKCHECK — install may have failed."
    exit 1
fi

if [ "$QUICKCHECK_PASSED" != "1" ]; then
    err "quickcheck.sh never passed after 20 attempts — CubeSandbox is unhealthy."
    exit 1
fi

# Ensure containerd-shim-cube-rs is on Cubelet's clean PATH.
# up.sh/up-with-deps.sh launch Cubelet with:
#   PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# Cubelet resolves runtime shims from that PATH, so it cannot find
# containerd-shim-cube-rs unless it is symlinked into one of those dirs.
# We create the symlink unconditionally on every boot (both after fresh
# install and after the restart path) so Cubelet can start sandboxes.
SHIM_SRC="${INSTALL_PREFIX}/cube-shim/bin/containerd-shim-cube-rs"
SHIM_DST="/usr/local/bin/containerd-shim-cube-rs"
if [ -x "$SHIM_SRC" ]; then
    ln -sf "$SHIM_SRC" "$SHIM_DST"
    log "containerd-shim-cube-rs linked: $SHIM_DST -> $SHIM_SRC"
else
    log "WARNING: $SHIM_SRC not found — Cubelet will not be able to start MicroVMs"
fi

# Restart Cubelet now that network-agent is confirmed ready.
# On first startup the Cubelet process begins before network-agent has finished
# initialising its 500 TAP interfaces (~2 min).  This causes the
# io.cubelet.images-service.v1 plugin to fail with:
#   "network-agent health check failed ... context deadline exceeded"
# leaving the gRPC cubelet.services.images.v1.Images service unregistered.
# When CubeMaster later tries to distribute a template artifact to the node it
# gets back gRPC Unimplemented and the build fails.
# Restarting Cubelet here — after quickcheck has confirmed network-agent is up —
# allows the images-service plugin to load successfully on the second boot.
CUBELET_BIN="${INSTALL_PREFIX}/Cubelet/bin/cubelet"
CUBELET_CFG="${INSTALL_PREFIX}/Cubelet/config/config.toml"
CUBELET_DYN="${INSTALL_PREFIX}/Cubelet/dynamicconf/conf.yaml"
CUBELET_LOG="/data/log/Cubelet/Cubelet-req.log"

if [ -x "$CUBELET_BIN" ]; then
    log "Restarting Cubelet so images-service plugin loads against ready network-agent ..."
    pkill -f "${CUBELET_BIN}" 2>/dev/null || true
    sleep 2
    mkdir -p "$(dirname "$CUBELET_LOG")"
    nohup "$CUBELET_BIN" \
        --config "$CUBELET_CFG" \
        --dynamic-conf-path "$CUBELET_DYN" \
        >>"$CUBELET_LOG" 2>&1 &
    CUBELET_PID=$!
    log "Cubelet restarted (PID ${CUBELET_PID}) — waiting 10 s for boot ..."
    sleep 10
    if kill -0 "$CUBELET_PID" 2>/dev/null; then
        log "Cubelet is running."
    else
        log "WARNING: Cubelet PID ${CUBELET_PID} exited — check ${CUBELET_LOG}."
    fi
fi

log "==================== CubeSandbox is up ===================="
log "  CubeAPI:      http://127.0.0.1:3000/health"
log "  CubeMaster:   http://127.0.0.1:8089/notify/health"
log "  network-agent http://127.0.0.1:19090/healthz"
log "  Logs:         /data/log/{CubeAPI,CubeMaster,Cubelet}/"
log "==========================================================="
