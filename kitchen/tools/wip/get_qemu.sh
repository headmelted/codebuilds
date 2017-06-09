#!/bin/bash
set -e;

if [ ! -d ./.cache/qemu-2.9.0 ]; then

  echo "Downloading QEMU source code";
  wget http://download.qemu-project.org/qemu-2.9.0.tar.xz;
  
  echo "Creating .cache folder if it doesn't exist";
  if [ ! -d ./.cache ]; then mkdir .cache; fi;

  echo "Extracting QEMU";
  tar xvJf qemu-2.9.0.tar.xz -C ./.cache/;
  
  echo "Deleting downloaded QEMU tarball";
  rm qemu-2.9.0.tar.xz;

  echo "Entering QEMU directory";
  cd ./.cache/qemu-2.9.0;

  echo "Configuring QEMU";
  ./configure --static --cc=gcc-4.9 --cxx=g++-4.9 --target-list=arm-softmmu,arm-linux-user,aarch64-linux-user;

  echo "Building QEMU";
  make;
  
  echo "Returning to original directory";
  cd ../..;
  
else

  echo "QEMU already in cache";

fi;
