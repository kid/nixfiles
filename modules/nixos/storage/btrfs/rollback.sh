#!/usr/bin/env bash

set -euo pipefail

label="nixos"
mount_point="/run/btrfs-root"
root_vol_name="root"

mkdir $mount_point
mount "/dev/disk/by-label/$label" "$mount_point"

if [[ -e "$mount_point/$root_vol_name" ]]; then
	mkdir -p "$mount_point/old_roots"
	timestamp=$(date --date="@$(stat -c %Y "$mount_point/root")" "+%Y-%m-%-d_%H:%M:%S")
	mv "$mount_point/$root_vol_name" "$mount_point/old_roots/$timestamp"
fi

delete_subvolume_recursively() {
	IFS=$'\n'
	for subvol in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
		delete_subvolume_recursively "$mount_point/$subvol"
	done
	btrfs subvolume delete "$1"
}

if [[ -d "mount_point/old_roots" ]]; then
	find "$mount_point/old_roots/" -maxdepth 1 -mtime +30 -type d | while read -r subvol; do
		echo "Deleting subvolume $subvol"
		delete_subvolume_recursively "$subvol"
	done
fi

btrfs subvolume create "$mount_point/$root_vol_name"
umount "$mount_point"
