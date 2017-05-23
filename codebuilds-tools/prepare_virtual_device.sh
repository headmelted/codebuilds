#!/bin/bash
set -e;

  if [[ ! -f /workspace/cache/image.img ]]; then
  
    echo "Cached image not available!";
    
    echo "Creating working directory for image...";
    mkdir image_work && cd image_work;
  
    echo "Retrieving image...";
    wget "${QEMU_IMAGE}";
    
    image_ext=${QEMU_IMAGE##*.};
    echo "Detected image extension as ${image_ext}"
  
    if [ "$image_ext" == "zip" ]; then
      echo "Unzipping image...";
      unzip *.zip;
    else
     if [ "$image_ext" == "xz" ]; then
       echo "Decompressing xz image...";
       unxz *.xz;
     else
       if [ "$image_ext" == "7z" ]; then
         echo "Installing p7zip-full...";
         apt-get install -y p7zip-full;
         echo "Decompressing 7z image...";
         7z x *.7z;
       fi;
     fi;
    fi;
    
    echo "Removing compressed image...";
    rm -rf "*.${image_ext}";
  
    echo "Renaming image file to image.img...";
    mv *.img image.img;
    
    echo "Moving image file to cache..."
    mv image.img /workspace/cache/image.img;
    
    echo "Returning to parent directory...";
    cd ..;
    
  echo "Creating mount directories...";
  mkdir /workspace/image /workspace/image/boot /workspace/image/root;
    
  echo "Reading disk structure...";
  fdisk -l /workspace/cache/image.img;
    
  echo "Getting boot offset...";
  boot_offset=0;
  boot_offset=$(fdisk -l image.img | grep -oP "(image\.img1)( *)([0-9]*?) " | grep -oE "*([0-9]*)*" | tail -1);
    
  echo "Boot offset is $boot_offset.";
    
  boot_sector_offset=$(($boot_offset*512));
    
  echo "Boot sector offset is $boot_sector_offset.";
  
  echo "Mounting boot...";
  echo "\"mount -o loop,offset=\$boot_sector_offset image.img ./image/boot\"";
  mount -o loop,offset=$boot_sector_offset /workspace/cache/image.img /workspace/image/boot;
  
  echo "Listing boot...";
  ls ./image/boot;
  
  echo "Creating boot directory...";
  mkdir boot;
  
  echo "Copying kernel ${QEMU_KERNEL} to cache...";
  cp ./image/boot/${QEMU_KERNEL} /workspace/cache/boot.img;
  
  echo "Copying dtb ${QEMU_DTB} to cache...";
  cp ./image/boot/${QEMU_DTB} /workspace/cache/boot.dtb;
  
  echo "Unmounting boot...";
  umount /workspace/image/boot;
    
  echo "Getting root offset...";
  root_offset=$(fdisk -l /workspace/cache/image.img | grep -oP "(image\.img2)( *)([0-9]*?) " | grep -oE "*([0-9]*)*" | tail -1);
    
  echo "Root offset is $root_offset.";
    
  root_sector_offset=$(($root_offset*512));
    
  echo "Root sector offset is $root_sector_offset.";
  
  echo "Mounting root directory...";
  mount -t ext4 -o loop,offset=$root_sector_offset /workspace/cache/image.img /workspace/image/root;
  
  if [ "${QEMU_MACHINE}" == "raspi2" ]; then
    echo "Emptying ld.so.preload...";
    echo "" > /workspace/image/root/etc/ld.so.preload;
  fi;
    
  echo "Creating getty tty1 service descriptor...";
  mkdir -pv /etc/systemd/system/getty@tty1.service.d;
  
  if [ ! -f /workspace/image/root/etc/systemd/system/getty@tty1.service.d/autologin.conf ]; then
    echo "autologin.conf does not exist, creating...";
    touch /workspace/image/root/etc/systemd/system/getty@tty1.service.d/autologin.conf;
  fi;
    
  echo "Adding ExecStart commands to ./image/root/etc/systemd/system/getty@tty1.service.d/autologin.conf....";
  echo "[Service]" >> /workspace/image/root/etc/systemd/system/getty@tty1.service.d/autologin.conf;
  echo "ExecStart=" >> /workspace/image/root/etc/systemd/system/getty@tty1.service.d/autologin.conf;
  echo "ExecStart=-/sbin/agetty --autologin pi --noclear %I 38400 linux" >> /workspace/image/root/etc/systemd/system/getty@tty1.service.d/autologin.conf;
    
  echo "Current ./image/root/etc/systemd/system/getty@tty1.service.d/autologin.conf....";
  cat /workspace/image/root/etc/systemd/system/getty@tty1.service.d/autologin.conf;
  
  echo "Setting getty for automatic login...";
  cp --remove-destination /workspace/image/root/etc/systemd/system/autologin@.service /workspace/image/root/etc/systemd/system/getty.target.wants/getty@tty1.service;
    
  # echo "Adding test script to profile startup...";
  # echo ". /testing/test.sh" >> ./image/root/etc/profile;
  
  echo "Creating workspace directory...";
  mkdir /workspace/image/root/workspace;
  
  echo "Copying test directory into host...";
  cp -r /workspace/test ./image/root/workspace/test;
  
  echo "Copying tools into host...";
  cp -r /workspace/codebuilds-tools /workspace/image/root/workspace/codebuilds-tools;
  
  echo "Copying scripts into host...";
  cp -r /workspace/scripts /workspace/image/root/workspace/scripts;
    
  echo "Copying deb package into host...";
  cp $(find /workspace/.build/linux -type f -name "*.deb") /workspace/image/root/workspace;
  
  echo "Syncing mount...";
  sync;
  
  echo "Unmounting root...";
  umount /workspace/image/root;
    
  else
  
    echo "Restoring image.img (rootfs) from cache...";
    cp /workspace/cache/image.img /workspace/image.img;
  
    echo "Restoring boot.dtb from cache...";
    cp /workspace/cache/image.img /workspace/boot.dtb;
  
    echo "Restoring boot.img (kernel) from cache...";
    cp /workspace/cache/image.img /workspace/boot.img;
    
  fi;