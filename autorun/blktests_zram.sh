#!/bin/bash
# SPDX-License-Identifier: (LGPL-2.1 OR LGPL-3.0)
# Copyright (C) SUSE LLC 2017, all rights reserved.

_vm_ar_env_check || exit 1

modprobe virtio_blk 2>/dev/null
modprobe virtio_scsi 2>/dev/null
mkdir /root/shared 2>/dev/null
mount -t 9p -o trans=virtio fs0 /root/shared 2>/dev/null

cd "$BLKTESTS_SRC" || _fatal
return

modprobe zram num_devices="1" || _fatal "failed to load zram module"

_vm_ar_dyn_debug_enable
_vm_ar_configfs_mount

echo "1G" > /sys/block/zram0/disksize || _fatal "failed to set zram disksize"

echo "TEST_DEVS=(/dev/zram0)" > ${BLKTESTS_SRC}/config

set +x

echo "/dev/zram0 provisioned and ready for ${BLKTESTS_SRC}/check"

if [ -n "$BLKTESTS_AUTORUN_CMD" ]; then
	eval "$BLKTESTS_AUTORUN_CMD"
fi
