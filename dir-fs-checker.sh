#! /bin/bash

# Warn when percentage used space reaches max:
max="95"

# Paths to file systems to check: (e.g. /media/mount_point /mnt/mount_point)
filesystems=(/media/foo /media/bar /mnt/foo)

for fs in ${filesystems[*]}; do
	#check if filesystem is actually mounted
	if grep -qs "$fs" /proc/mounts; then
		space=$(df -h | grep $fs | awk '{print $(NF-1)}' | sed 's/%//')
		if [ "$space" -ge "$max" ]; then
			echo "$fs is at "$space"%"
		fi
	fi
done
