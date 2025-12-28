#!/bin/sh
set -e

# Adapted from official docker-library/docker dind entrypoint
# https://github.com/docker-library/docker/blob/master/24/dind/dockerd-entrypoint.sh

if [ -z "$DOCKER_HOST" ]; then
	case "$1" in
		dockerd*)
			# If we're running dockerd, we need to make sure we have cgroups mounted
			if [ ! -d /sys/fs/cgroup ]; then
				mkdir -p /sys/fs/cgroup
			fi
			if ! mountpoint -q /sys/fs/cgroup; then
				mount -t tmpfs -o uid=0,gid=0,mode=0755 cgroup /sys/fs/cgroup
			fi

			# Mount cgroup v2 if available and not mounted
			if [ -e /sys/fs/cgroup/cgroup.controllers ] && ! mountpoint -q /sys/fs/cgroup; then
				mount -t cgroup2 -o nsdelegate cgroup2 /sys/fs/cgroup
			fi

			# If /sys/fs/cgroup is not a cgroup2 mount, we might need to mount cgroup v1 hierarchies
			if ! mountpoint -q /sys/fs/cgroup || [ "$(stat -f -c %T /sys/fs/cgroup)" != "cgroup2fs" ]; then
				if [ -d /sys/fs/cgroup/cgroup.controllers ]; then
					# It is cgroup2 but maybe not mounted as such?
					# Actually if it exists, it's likely v2.
					:
				else
					# cgroup v1
					for subsystem in $(awk '/^[^#]/ { print $1 }' /proc/cgroups); do
						mkdir -p "/sys/fs/cgroup/$subsystem"
						if ! mountpoint -q "/sys/fs/cgroup/$subsystem"; then
							mount -t cgroup -o "$subsystem" cgroup "/sys/fs/cgroup/$subsystem"
						fi
					done
				fi
			fi
			;;
	esac
fi

if [ "$1" = 'dockerd' ] || [ "${1#-}" != "$1" ]; then
	# if the first argument is "dockerd" or a flag (starts with -)
	if [ "${1#-}" != "$1" ]; then
		set -- dockerd "$@"
	fi

    # Explicitly use iptables-legacy if available, as it is often more stable for DinD
    if command -v update-alternatives >/dev/null; then
        if update-alternatives --query iptables | grep -q "iptables-legacy"; then
            update-alternatives --set iptables /usr/sbin/iptables-legacy || true
            update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy || true
        fi
    fi
fi

exec "$@"
