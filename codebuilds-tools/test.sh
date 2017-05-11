#!/bin/bash

#echo "Inserting custom xvfb into /etc/init.d...";
#mv -f ./codebuilds-tools/xvfb /etc/init.d/xvfb;

if [[ ${LABEL} == "armhf_linux" ]]; then
  apt-get install -y qemu-system-${QEMU_ARCH};
  wget "https://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2017-04-10/2017-04-10-raspbian-jessie-lite.zip" -O image.zip;
  unzip image.zip;
  rm -rf image.zip;
  mv *.img image.img;
  mount -o loop,offset=$((92160*512)) image.img /image;
  echo "" > /image/etc/ld.so.preload;
  wget "https://github.com/dhruvvyas90/qemu-rpi-kernel/raw/master/kernel-qemu-4.4.34-jessie" -O ./kernel-qemu;
  qemu-system-${QEMU_ARCH} -kernel kernel-qemu -cpu arm1176 -m 256 -M versatilepb -no-reboot -serial stdio -append "root=/dev/sda2 panic=1" -hda ./image.img -redir tcp:5022::22;
fi;

echo "Exporting display :99.0...";
export DISPLAY=:99.0;

echo "Starting xvfb...";
sh -e /etc/init.d/xvfb start;

echo "Waiting 10 seconds for xvfb to start up...";
sleep 3;

echo "Starting test...";
./scripts/test.sh;

echo "Starting integration tests...";
./scripts/test-integration.sh;

