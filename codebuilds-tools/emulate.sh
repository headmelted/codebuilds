#!/bin/bash
set -e;

echo "Booting Raspberry Pi 2...";
qemu-system-arm -nographic -serial mon:stdio -M raspi2 -dtb bcm2710-rpi-3-b.dtb -kernel kernel7.img -sd image.img -append "rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2,script=$1";

