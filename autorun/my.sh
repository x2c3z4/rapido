#!/bin/bash
# SPDX-License-Identifier: (LGPL-2.1 OR LGPL-3.0)
# Copyright (C) SUSE LLC 2017, all rights reserved.

_vm_ar_env_check || exit 1

modprobe virtio_blk 2>/dev/null
modprobe virtio_scsi 2>/dev/null
mkdir /root/shared 2>/dev/null
mount -t 9p -o trans=virtio fs0 /root/shared 2>/dev/null
mount -t debugfs debugfs /sys/kernel/debug/ 2>/dev/null
ip link set lo up 2>/dev/null

cd "/root" || _fatal
[ -f /root/shared/autorun.sh ] && /root/shared/autorun.sh
return
