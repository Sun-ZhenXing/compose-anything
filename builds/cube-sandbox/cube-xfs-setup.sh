#!/usr/bin/env bash
# Create and mount the XFS-formatted loop volume at /data/cubelet.
# Called by cube-xfs-mount.service (Type=oneshot) before docker.service starts.
#
# install.sh hard-requires that /data/cubelet is on an XFS filesystem;
# it validates this with `df -T /data/cubelet | grep -q xfs`.
set -euo pipefail

log() { printf '[cube-xfs] %s\n' "$*"; }

CUBE_DATA_DIR="${CUBE_DATA_DIR:-/data/cubelet}"
CUBE_XFS_IMG="${CUBE_XFS_IMG:-/data/cubelet.img}"
CUBE_XFS_SIZE="${CUBE_XFS_SIZE:-50G}"

mkdir -p /data "$CUBE_DATA_DIR"

current_fs="$(stat -fc %T "$CUBE_DATA_DIR" 2>/dev/null || echo unknown)"
if [ "$current_fs" = "xfs" ]; then
    log "Already mounted: $CUBE_DATA_DIR ($current_fs) — nothing to do."
    exit 0
fi

log "Preparing XFS loop volume at $CUBE_XFS_IMG (size=$CUBE_XFS_SIZE) ..."
if [ ! -f "$CUBE_XFS_IMG" ]; then
    fallocate -l "$CUBE_XFS_SIZE" "$CUBE_XFS_IMG"
    mkfs.xfs -q -f "$CUBE_XFS_IMG"
    log "Formatted $CUBE_XFS_IMG as XFS."
fi

mount -o loop "$CUBE_XFS_IMG" "$CUBE_DATA_DIR"
log "Mounted $CUBE_DATA_DIR ($(stat -fc %T "$CUBE_DATA_DIR"))."
