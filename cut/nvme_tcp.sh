#!/bin/bash
#
# Copyright (C) SUSE LINUX GmbH 2017, all rights reserved.
#
# This library is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation; either version 2.1 of the License, or
# (at your option) version 3.
#
# This library is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
# License for more details.

RAPIDO_DIR="$(realpath -e ${0%/*})/.."
. "${RAPIDO_DIR}/runtime.vars"

_rt_require_dracut_args "$RAPIDO_DIR/autorun/nvme_tcp.sh" "$@"
_rt_require_networking
req_inst=()
_rt_require_lib req_inst "libkeyutils.so.1"

"$DRACUT" --install "tail blockdev ps rmdir resize dd vim grep find df sha256sum lscpu lsblk fio \
		   strace mkfs.xfs killall nvme rdma \
		   ${req_inst[*]}" \
	--add-drivers "nvme-core nvme-fabrics nvme-rdma nvmet nvmet-rdma nvmet-tcp nvme-tcp \
		       rdma_rxe zram lzo lzo-rle ib_core ib_uverbs rdma_ucm \
		       crc32_generic" \
        --include "/usr/lib64/fio/fio-libaio.so" "/usr/lib64/fio/fio-libaio.so" \
	--modules "base" \
	"${DRACUT_RAPIDO_ARGS[@]}" \
	"$DRACUT_OUT"
