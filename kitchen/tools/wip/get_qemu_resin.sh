#!/bin/bash
set -e;

if [ ! -d ./.cache/qemu ]; then

  echo "Downloading QEMU resin build";
  wget https://github.com/resin-io/qemu/releases/download/qemu-2.5.50-resin-execve-${QEMU_ARCH}/qemu-2.5.50-resin-execve-${QEMU_ARCH}.tar.gz;
  
  echo "Creating .cache folder if it doesn't exist";
  if [ ! -d ./.cache ]; then mkdir .cache; fi;
  
  echo "Creating qemu folder if it doesn't exist";
  if [ ! -d ./.cache/qemu ]; then mkdir .cache/qemu; fi;

  echo "Extracting QEMU";
  tar xvzf qemu-2.5.50-resin-execve-${QEMU_ARCH}.tar.gz --strip-components 1 -C ./.cache/qemu;
  
  echo "Deleting downloaded QEMU tarball";
  rm qemu-2.5.50-resin-execve-${QEMU_ARCH}.tar.gz;
  
else

  echo "QEMU already in cache";

fi;
