#!/bin/bash
set -e;

#echo "Inserting custom xvfb into /etc/init.d...";
#mv -f ./codebuilds-tools/xvfb /etc/init.d/xvfb;

echo "Checking if cache directory exists...";
if [[ ! -d ./cache ]]; then 
  echo "Creating cache directory...";
  mkdir cache
fi;

if [[ ${LABEL} == "armhf_linux" ]]; then

  echo "Installing QEMU...";
  apt-get install -y qemu-system-${QEMU_ARCH};
  
  echo "Cache directory [$(pwd)/cache] contains:"
  ls ./cache;
  
  if [[ ! -f ./cache/image.img ]]; then
  
    echo "Cached raspbian image not available!";
  
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
  
    echo "Copying kernel...";
    cp ./image/boot/kernel7.img ./;
  
    echo "Copying dtb...";
    cp ./image/boot/bcm2709-rpi-2-b.dtb ./;
  
    echo "Unmounting boot...";
    umount ./image/boot;
  
    echo "Mounting root directory...";
    mount -t ext4 -o loop,offset=47185920 image.img ./image/root;
  
    echo "Emptying ld.so.preload...";
    echo "" > ./image/root/etc/ld.so.preload;
  
    echo "Setting getty for automatic login...";
    cp ./image/root/etc/systemd/system/autologin@.service ./image/root/etc/systemd/system/getty.target.wants/getty@tty1.service;
  
    echo "Syncing mount...";
    sync;
  
    echo "Unmounting root...";
    umount ./image/root;
  
    echo "Copying patched images to cache...";
    cp image.img ./cache/image.img;
    cp kernel7.img ./cache/kernel7.img;
    cp bcm2709-rpi-2-b.dtb ./cache/bcm2709-rpi-2-b.dtb;
  
  else
  
    echo "Cached images available!";
    cp ./cache/image.img image.img;
    cp ./cache/kernel7.img kernel7.img;
    cp ./cache/bcm2709-rpi-2-b.dtb bcm2709-rpi-2-b.dtb;
  
  fi;
  
  echo "Booting Raspberry Pi 2...";
  qemu-system-arm -nographic -serial mon:stdio -M raspi2 -dtb bcm2709-rpi-2-b.dtb -kernel kernel7.img -sd image.img -append "rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2";
  
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

