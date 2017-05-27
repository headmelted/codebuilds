#!/bin/bash
set -e;

export LABEL=armhf_linux;
export CROSS_TOOLCHAIN=true;
export ARCH=armhf;
export NPM_ARCH=arm;
export GNU_TRIPLET=arm-linux-gnueabihf;
export GNU_MULTILIB_TRIPLET=arm-linux-gnueabihf;
export GPP_COMPILER=arm-linux-gnueabihf-g++;
export GCC_COMPILER=arm-linux-gnueabihf-gcc;
export VSCODE_ELECTRON_PLATFORM=arm;
export PACKAGE_ARCH=armhf;
export QEMU_ARCH=arm;
export QEMU_ARCHIVE="http://archive.raspbian.org/raspbian";
export QEMU_IMAGE="https://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2017-04-10/2017-04-10-raspbian-jessie-lite.zip";
export QEMU_KERNEL="kernel7.img";
export QEMU_DTB="bcm2709-rpi-2-b.dtb";
export QEMU_MACHINE="raspi2";
