#!/bin/bash
set -e;

echo "Listing workspace for debug..";
ls /workspace;

echo "Booting ${QEMU_ARCH} emulator...";
qemu-system-${QEMU_ARCH} -nographic -serial stdio -machine ${QEMU_MACHINE} -dtb /workspace/cache/boot.dtb -kernel /workspace/cache/boot.img -sd /workspace/cache/image.img -append "rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2";

