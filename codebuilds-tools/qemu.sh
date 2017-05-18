#!/bin/bash
set -e;

echo "Installing QEMU and dependencies...";
apt-get install -y qemu binfmt_misc qemu-user-static;

echo "Reading proc...";
ls /proc/sys/fs/;
  
echo "Mounting binfmt_misc...";
mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc;
  
echo "Enabling binfmt_misc...";
echo 1 > /proc/sys/fs/binfmt_misc/status;

echo "Enabling ${QEMU_ARCH} emulator...";
update-binfmts --enable qemu-${QEMU_ARCH};

