#!/bin/bash

#echo "Inserting custom xvfb into /etc/init.d...";
#mv -f ./codebuilds-tools/xvfb /etc/init.d/xvfb;

if [[ ${LABEL} == "armhf_linux" ]]; then
  echo "Installing QEMU...";
  apt-get install -y qemu-system-${QEMU_ARCH};
  echo "Retrieving raspbian image...";
  wget "https://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2017-04-10/2017-04-10-raspbian-jessie-lite.zip" -O image.zip;
  echo "Unzipping raspbian image...";
  unzip image.zip;
  echo "Removing raspbian zip...";
  rm -rf image.zip;
  echo "Moving image file...";
  mv *.img image.img;
  echo "Creating mount directory...";
  mkdir image;
  echo "Mounting image file...";
  mount -o loop,offset=$((92160*512)) image.img image;
  echo "Listing mounted image...";
  ls image;
  echo "Creating boot directory...";
  mkdir boot;
  echo "Copying kernel...";
  cp image/kernel7.img boot;
  echo "Copying dtb...";
  cp image/bcm2709-rpi-2-b.dtb boot;
  echo "Emptying ld.so.preload...";
  echo "" > /image/etc/ld.so.preload;
  echo "Running qemu-system-${ARCH}...";
  qemu-system-arm -M raspi2 -kernel boot/kernel7.img -sd image.img -append "rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2" -dtb boot/bcm2709-rpi-2-b.dtb -serial stdio;
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

