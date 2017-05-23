#!/bin/bash
set -e;

if [[ ${LABEL} == "armhf_linux" ]]; then

  echo "Installing QEMU...";
  apt-get install -y qemu-system-${QEMU_ARCH};
  
  if [[ ! -f ${TRAVIS_BUILD_DIR}/cache/image.img ]]; then
  
    echo "Cached raspbian image not available!";
  
    echo "Retrieving raspbian image...";
    wget "https://downloads.raspberrypi.org/raspbian_lite_latest" -O image.zip;
  
    echo "Unzipping raspbian image...";
    unzip image.zip;
  
    echo "Removing raspbian zip...";
    rm -rf image.zip;
  
    echo "Renaming image file to image.img...";
    mv *.img image.img;
    
    echo "Copying image file to cache..."
    cp image.img ${TRAVIS_BUILD_DIR}/cache/image.img;
    
  else
  
    echo "Raspbian is cached, restoring...";
    cp ${TRAVIS_BUILD_DIR}/cache/image.img ${TRAVIS_BUILD_DIR}/image.img;
    
  fi;
    
  echo "Creating mount directories...";
  mkdir image ./image/boot ./image/root;
    
  echo "Reading disk structure...";
  fdisk -l image.img;
    
  echo "Getting boot offset...";
  boot_offset=0;
  boot_offset=$(fdisk -l image.img | grep -oP "(image\.img1)( *)([0-9]*?) " | grep -oE "*([0-9]*)*" | tail -1);
    
  echo "Boot offset is $boot_offset.";
    
  boot_sector_offset=$(($boot_offset*512));
    
  echo "Boot sector offset is $boot_sector_offset.";
  
  echo "Mounting boot...";
  echo "\"mount -o loop,offset=\$boot_sector_offset image.img ./image/boot\"";
  mount -o loop,offset=$boot_sector_offset image.img ./image/boot;
  
  echo "Listing boot...";
  ls ./image/boot;
  
  echo "Creating boot directory...";
  mkdir boot;
  
  echo "Copying kernel...";
  cp ./image/boot/kernel*.img ./;
  
  echo "Copying dtb...";
  cp ./image/boot/*.dtb ./;
  
  echo "Unmounting boot...";
  umount ./image/boot;
    
  echo "Getting root offset...";
  root_offset=$(fdisk -l image.img | grep -oP "(image\.img2)( *)([0-9]*?) " | grep -oE "*([0-9]*)*" | tail -1);
    
  echo "Root offset is $root_offset.";
    
  root_sector_offset=$(($root_offset*512));
    
  echo "Root sector offset is $root_sector_offset.";
  
  echo "Mounting root directory...";
  mount -t ext4 -o loop,offset=$root_sector_offset image.img ./image/root;
  
  echo "Emptying ld.so.preload...";
  echo "" > ./image/root/etc/ld.so.preload;
    
  echo "Creating getty tty1 service descriptor...";
  mkdir -pv /etc/systemd/system/getty@tty1.service.d;
    
  echo "Adding ExecStart commands to ./image/root/etc/systemd/system/getty@tty1.service.d/autologin.conf....";
  echo "[Service]" >> ./image/root/etc/systemd/system/getty@tty1.service.d/autologin.conf;
  echo "ExecStart=" >> ./image/root/etc/systemd/system/getty@tty1.service.d/autologin.conf;
  echo "ExecStart=-/sbin/agetty --autologin pi --noclear %I 38400 linux" >> ./image/root/etc/systemd/system/getty@tty1.service.d/autologin.conf;
    
  echo "Current ./image/root/etc/systemd/system/getty@tty1.service.d/autologin.conf....";
  cat ./image/root/etc/systemd/system/getty@tty1.service.d/autologin.conf;
    
  # echo "Adding test script to profile startup...";
  # echo ". /testing/test.sh" >> ./image/root/etc/profile;
  
  echo "Copying test directory into host...";
  cp -r test ./image/root/workspace/test;
  
  echo "Copying tools into host...";
  cp -r codebuilds-tools ./image/root/workspace/codebuilds-tools;
    
  echo "Copying deb package into host...";
  cp $(find .build/linux -type f -name "*.deb") ./image/root/workspace;
  
  echo "Setting getty for automatic login...";
  cp --remove-destination ./image/root/etc/systemd/system/autologin@.service ./image/root/etc/systemd/system/getty.target.wants/getty@tty1.service;
  
  echo "Syncing mount...";
  sync;
  
  echo "Unmounting root...";
  umount ./image/root;
  
  #   echo "Copying patched images to cache...";
  #   cp image.img ${TRAVIS_BUILD_DIR}/cache/image.img;
  #   cp kernel7.img ${TRAVIS_BUILD_DIR}/cache/kernel7.img;
  #   cp bcm2709-rpi-2-b.dtb ${TRAVIS_BUILD_DIR}/cache/bcm2709-rpi-2-b.dtb;
  
  # else
  
  #   echo "Cached images available!";
  #   cp ${TRAVIS_BUILD_DIR}/cache/image.img image.img;
  #   cp ${TRAVIS_BUILD_DIR}/cache/kernel7.img kernel7.img;
  #   cp ${TRAVIS_BUILD_DIR}/cache/bcm2709-rpi-2-b.dtb bcm2709-rpi-2-b.dtb;
  
  # fi;
  
fi;
