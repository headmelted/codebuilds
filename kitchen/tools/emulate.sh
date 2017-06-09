#!/bin/bash
set -e;

echo "Booting ${QEMU_ARCH} emulator from [$(pwd)]";

#qemu-system-${QEMU_ARCH} -nographic -serial stdio -monitor none -machine ${QEMU_MACHINE} ${QEMU_OPTS} -no-reboot -dtb ./.cache/boot.dtb -kernel ./.cache/boot.img -sd ./.cache/image.img -append "rootfstype=ext4rw earlyprintk loglevel=8 panic=1 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2";

# Boot virtualized device based on QEMU_OPTS
qemu-system-arm -dtb ../../../../.cache/boot_${LABEL}.dtb -kernel ../../../../.cache/boot_${LABEL}.img ${QEMU_OPTS} -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw vga=normal console=ttyAMA0" -drive "file=../../../../.cache/image_${LABEL}.img,index=0,media=disk,format=raw" -no-reboot -serial stdio -curses