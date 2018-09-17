#!/bin/bash
set -e;

echo "Setting environment";
. ./env/linux/setup.sh;

# echo "Installed packages list:"
# apt list --installed;

# echo "Creating images directory [/kitchen/.images]"
# mkdir /kitchen/.images;

# echo "Downloading Ubuntu cloud images (used for testing later)";
# wget "https://cloud-images.ubuntu.com/cosmic/current/cosmic-server-cloudimg-$COBBLER_ARCH.img" -O /kitchen/.images/cosmic-server-cloudimg-$COBBLER_ARCH.img;

# echo "Creating TUN device for network bridging";
# mkdir /dev/net;
# mknod /dev/net/tun c 10 200;

# echo "Creating TUN device for the session"
# tunctl -t tap0 -u $(whoami)

echo "Booting QEMU image"
/usr/bin/qemu-system-$QEMU_ARCH -m 4096 -M virt =nographic -serial mon:stdio -append 'console=ttyS0' -drive if=none,file=/kitchen/.images/cosmic-server-cloudimg-$COBBLER_ARCH.img,id=hd0 -device virtio-blk-device,drive=hd0 -netdev tap,ifname=tap0,id=mynet0,script=no,downscript=no;
    
# echo "Running tests";
# ./scripts/test.sh;

# echo "Running integration tests";
# ./scripts/test-integration.sh;
