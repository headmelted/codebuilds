#!/bin/bash
set -e;

if [ -f ${TRAVIS_BUILD_DIR}/cache/qemu-2.9.0-compiled.tar.gz ]; then

  echo "Downloading QEMU source code...";
  wget http://download.qemu-project.org/qemu-2.9.0.tar.xz;

  echo "Extracting QEMU...";
  tar xvJf qemu-2.9.0.tar.xz;

   "Entering QEMU directory...";
  cd qemu-2.9.0;

  echo "Configuring QEMU...";
  ./configure;

  echo "Building QEMU...";
  make;

  echo "Returning to parent directory...";
  cd ..;
  
  echo "Compressing built qemu...";
  tar -zcvf qemu-2.9.0-compiled.tar.gz qemu-2.9.0;
  
  echo "Moving compressed qemu to cache...";
  mv qemu-2.9.0-compiled.tar.gz ${TRAVIS_BUILD_DIR}/cache/;
  
else

  echo "Restoring compressed qemu from cache...";
  tar -xvzf ${TRAVIS_BUILD_DIR}/cache/qemu-2.9.0-compiled.tar.gz;

fi;
