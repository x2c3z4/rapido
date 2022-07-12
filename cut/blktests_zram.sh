#!/bin/bash
# SPDX-License-Identifier: (LGPL-2.1 OR LGPL-3.0)
# Copyright (C) SUSE LLC 2017, all rights reserved.

RAPIDO_DIR="$(realpath -e ${0%/*})/.."
. "${RAPIDO_DIR}/runtime.vars"

_rt_require_dracut_args "$RAPIDO_DIR/autorun/blktests_zram.sh" "$@"
_rt_require_blktests
_rt_mem_resources_set "2048M"
#_rt_require_networking
#  yum install systemd-networkd

"$DRACUT" --install "netstat sysctl lsmod ip lspci lsscsi zcat \
           tail blockdev ps rmdir resize dd vim grep find df sha256sum \
		   getopt tput wc column blktrace losetup parted truncate \
		   lsblk strace which awk bc touch cut chmod true false mktemp \
		   killall id sort uniq date expr tac diff head dirname seq \
		   basename tee egrep hexdump sync fio logger cmp stat nproc \
		   xfs_io modinfo blkdiscard realpath timeout nvme" \
	--include "/root/bin/fio" "$BLKTESTS_SRC" \
    --include "/usr/lib64/fio/fio-libaio.so" "/usr/lib64/fio/fio-libaio.so" \
	--modules "base" \
	"${DRACUT_RAPIDO_ARGS[@]}" \
	"$DRACUT_OUT" || _fail "dracut failed"
	#--add-drivers "zram lzo lzo-rle scsi_debug null_blk loop nvme" \
