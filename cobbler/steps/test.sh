#!/bin/bash
set -e;

echo "Creating images directory [/kitchen/.images]"
mkdir /kitchen/.images;

echo "Downloading Ubuntu cloud image for $ARCH";
wget "https://cloud-images.ubuntu.com/cosmic/20180913/cosmic-server-cloudimg-$ARCH.img" -O /kitchen/.images/cosmic-server-cloudimg-$ARCH.img;

echo "Downloaded cosmic-server-cloudimg-$ARCH.img successfully."

echo "Installing QEMU";
apt-get install -y qemu;

echo "Booting QEMU image"
qemu-system-$QEMU_ARCH -m 4096 -M virt -nographic -drive if=none,file=/kitchen/.images/cosmic-server-cloudimg-$ARCH.img,id=hd0 \
 -device virtio-blk-device,drive=hd0 -netdev type=tap,id=net0 -device virtio-net-device,netdev=net0;
    
# echo "Running tests";
# ./scripts/test.sh;

# echo "Running integration tests";
# ./scripts/test-integration.sh;
