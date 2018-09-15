#!/bin/bash
set -e;

apt-get install -y qemu;

which qemu-system-$QEMU_ARCH;

echo "Booting QEMU image"
qemu-system-$QEMU_ARCH -m 4096 -M virt -nographic -drive if=none,file=/kitchen/.images/cosmic-server-cloudimg-$ARCH.img,id=hd0 \
 -device virtio-blk-device,drive=hd0 -netdev type=tap,id=net0 -device virtio-net-device,netdev=net0;
    
# echo "Running tests";
# ./scripts/test.sh;

# echo "Running integration tests";
# ./scripts/test-integration.sh;
