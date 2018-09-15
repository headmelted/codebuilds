#!/bin/bash
set -e;

# echo "Cobbler is $(lsb_release -a)";

# echo "Installed packages list:"
# apt list --installed;

# echo "Creating images directory [/kitchen/.images]"
# mkdir /kitchen/.images;

echo "Downloading Ubuntu cloud images (used for testing later)";
wget "https://cloud-images.ubuntu.com/cosmic/current/cosmic-server-cloudimg-$arch.img" -O /kitchen/.images/cosmic-server-cloudimg-$arch.img;

echo "Booting QEMU image"
/usr/bin/qemu-system-$QEMU_ARCH -m 4096 -M virt -nographic -drive if=none,file=/kitchen/.images/cosmic-server-cloudimg-$arch,id=hd0 -device virtio-blk-device,drive=hd0 -net nic,macaddr=18:27:99:aa:de:01,model=virtio -net tap;
    
# echo "Running tests";
# ./scripts/test.sh;

# echo "Running integration tests";
# ./scripts/test-integration.sh;
