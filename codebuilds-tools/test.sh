#!/bin/bash
set -e;

#echo "Inserting custom xvfb into /etc/init.d...";
#mv -f ./codebuilds-tools/xvfb /etc/init.d/xvfb;

if [[ ${LABEL} == "armhf_linux" ]]; then

  echo "Installing QEMU...";
  apt-get install -y qemu-system-${QEMU_ARCH};
  
  echo "Retrieving raspbian image...";
  wget "https://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2015-11-24/2015-11-21-raspbian-jessie-lite.zip" -O image.zip;
  
  echo "Unzipping raspbian image...";
  unzip image.zip;
  
  echo "Removing raspbian zip...";
  rm -rf image.zip;
  
  echo "Moving image file...";
  mv *.img image.img;
  
  echo "Creating mount directories...";
  mkdir image ./image/boot ./image/root;
  
  echo "Mounting boot...";
  mount -o loop,offset=4194304 image.img ./image/boot;
  
  echo "Listing boot...";
  ls ./image/boot;
  
  echo "Creating boot directory...";
  mkdir boot;
  
  echo "Copying kernel to boot...";
  cp ./image/boot/kernel7.img ./boot;
  
  echo "Copying dtb to boot...";
  cp ./image/boot/bcm2709-rpi-2-b.dtb ./boot;
  
  echo "Unmounting boot...";
  umount ./image/boot;
  
  echo "Mounting root directory...";
  mount -o loop,offset=$((92160*512)) image.img ./image/root;
  
  echo "Emptying ld.so.preload...";
  echo "" > ./image/root/etc/ld.so.preload;
  
  echo "Setting getty for automatic login...";
  cp ./image/root/etc/systemd/system/autologin@.service ./image/root/etc/systemd/system/getty.target.wants/getty@tty1.service;
  
  echo "Syncing mount...";
  sync;
  
  echo "Unmounting root...";
  umount ./image/root;
  
  echo "Booting Raspberry Pi 2...";
  qemu-system-arm -nographic -serial mon:stdio -M raspi2 -dtb "./boot/bcm2709-rpi-2-b.dtb" -kernel "./boot/kernel7.img" -sd image.img -append "rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2";
  
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

