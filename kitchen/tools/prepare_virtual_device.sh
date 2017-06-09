#!/bin/bash
set -e;

image_ext=${QEMU_IMAGE##*.};
echo "Detected image extension as ${image_ext}"

echo "Current directory is: $(pwd)";

  if [[ ! -f ../../../../.cache/unpatched_image_${LABEL}.${image_ext} ]]; then
  
    echo "Downloading image to ../../../../.cache/unpatched_image.${image_ext}";
    wget "${QEMU_IMAGE}" -O ../../../../.cache/unpatched_image_${LABEL}.${image_ext};
  
  fi;

  if [[ ! -f ../../../../.cache/image_${LABEL}.img ]]; then
    
    echo "Creating working directory for image";
    rm -rf ../image_work && mkdir ../image_work && cd ../image_work;
  
    if [ "$image_ext" == "zip" ]; then
      echo "Unzipping image";
      unzip ../../../../.cache/unpatched_image_${LABEL}.zip;
    else
     if [ "$image_ext" == "xz" ]; then
       echo "Decompressing xz image";
       unxz *.xz;
     else
       if [ "$image_ext" == "7z" ]; then
         echo "Decompressing 7z image";
         7z x *.7z;
       fi;
     fi;
    fi;
  
    echo "Renaming image file to image_${LABEL}.img";
    mv *.img image_${LABEL}.img;
    
    echo "Creating ../../../../.cache folder if it does not exist";
    if [[ ! -d ../../../../.cache ]]; then mkdir ../../../../.cache; fi;
    
    echo "Moving image file to cache..."
    mv image_${LABEL}.img ../../../../.cache/image_${LABEL}.img;
    
  echo "Creating mount directories";
  mkdir ../image_${LABEL} ../image_${LABEL}/boot ../image_${LABEL}/root;
    
  echo "Reading disk structure";
  fdisk -l ../../../../.cache/image_${LABEL}.img;
    
  echo "Getting boot offset";
  boot_offset=0;
  boot_offset=$(fdisk -l ../../../../.cache/image_${LABEL}.img | grep -oP "(\.img1)( *)([0-9]*?) " | grep -oE "*([0-9]*)*" | tail -1);
    
  echo "Boot offset is $boot_offset.";
    
  boot_sector_offset=$(($boot_offset*512));
    
  echo "Boot sector offset is $boot_sector_offset.";
  
  echo "Mounting boot";
  echo "\"mount -o loop,offset=\$boot_sector_offset image.img ./image/boot\"";
  mount -o loop,offset=$boot_sector_offset ../../../../.cache/image_${LABEL}.img ../image_${LABEL}/boot;
  
  echo "Listing boot";
  ls ../image_${LABEL}/boot;
  
  # echo "Creating boot directory";
  # mkdir boot;
  
  # echo "Copying kernel ${QEMU_KERNEL} to cache";
  # cp ./image/boot/${QEMU_KERNEL} ../../../../../.cache/boot.img;
  
  echo "Download kernel";
  wget "https://github.com/dhruvvyas90/qemu-rpi-kernel/raw/master/kernel-qemu-4.4.34-jessie" -O ../../../../.cache/boot_${LABEL}.img;
  
  echo "Copying dtb ${QEMU_DTB} to cache";
  cp ../image_${LABEL}/boot/${QEMU_DTB} ../../../../.cache/boot_${LABEL}.dtb;
  
  echo "Unmounting boot";
  umount ../image_${LABEL}/boot;
    
  echo "Getting root offset";
  root_offset=$(fdisk -l ../../../../.cache/image_${LABEL}.img | grep -oP "(\.img2)( *)([0-9]*?) " | grep -oE "*([0-9]*)*" | tail -1);
    
  echo "Root offset is $root_offset.";
    
  root_sector_offset=$(($root_offset*512));
    
  echo "Root sector offset is $root_sector_offset.";
  
  echo "Mounting root directory";
  mount -t ext4 -o loop,offset=$root_sector_offset ../../../../.cache/image_${LABEL}.img ../image_${LABEL}/root;
  
  if [ "${ARCH}" == "armhf" ]; then
    echo "Emptying ld.so.preload";
    echo "" > ../image_${LABEL}/root/etc/ld.so.preload;
    echo "Setting boot.sh to execute, and then shutdown";
    echo "
chmod +x /workspace/boot.sh;
/workspace/boot.sh;
poweroff;
" | tee -a ../image_${LABEL}/root/etc/init.d/superscript;

    # echo "Current fstab:";
    # cat ./image/root/etc/fstab;
    # echo "Removing mmcblk entries in fstab";
    # sed -e '/mmcblk/ s/^#*/#/' -i ./image/root/etc/fstab;
    # echo "Modified fstab:";
    # cat ./image/root/etc/fstab;
  fi;
    
  # echo "Creating getty tty1 service descriptor";
  # mkdir -pv ./image/root/etc/systemd/system/getty@tty1.service.d;
  
  # if [ ! -f ./image/root/etc/systemd/system/getty@tty1.service.d/autologin.conf ]; then
  #   echo "autologin.conf does not exist, creating";
  #   touch ./image/root/etc/systemd/system/getty@tty1.service.d/autologin.conf;
  # fi;
    
  # echo "Adding ExecStart commands to ./image/root/etc/systemd/system/getty@tty1.service.d/autologin.conf.";
  # echo "[Service]" >> ./image/root/etc/systemd/system/getty@tty1.service.d/autologin.conf;
  # echo "ExecStart=" >> ./image/root/etc/systemd/system/getty@tty1.service.d/autologin.conf;
  # echo "ExecStart=-/sbin/agetty --autologin pi --noclear %I 38400 linux" >> ./image/root/etc/systemd/system/getty@tty1.service.d/autologin.conf;
    
  # echo "Current ./image/root/etc/systemd/system/getty@tty1.service.d/autologin.conf.";
  # cat ./image/root/etc/systemd/system/getty@tty1.service.d/autologin.conf;
  
  # echo "Setting getty for automatic login";
  # cp --remove-destination ./image/root/etc/systemd/system/autologin@.service ./image/root/etc/systemd/system/getty.target.wants/getty@tty1.service;
    
  # echo "Adding test script to profile startup";
  # echo ". /testing/test.sh" >> ./image/root/etc/profile;
    
  # echo "Copying deb package into host";
  # cp $(find ./.build/linux -type f -name "*.deb") ./image_${LABEL}/root/workspace;
  
  echo "Syncing mount";
  sync;
  
  echo "Unmounting root";
  umount ../image_${LABEL}/root;
  
  echo "Removing image directory, now that everything has been put in the cache";
  rm -rf ../image_${LABEL};
  
  echo "Removing working directory, now that we have finished";
  rm -rf ../image_work;
    
  fi;
  
  echo "Restoring patched image.img (rootfs) from cache";
  cp -rv ./../../../../.cache/image_${LABEL}.img ../image_${LABEL}.img;
  
  echo "Restoring boot.dtb from cache";
  cp -rv ./../../../../.cache/boot_${LABEL}.dtb ../boot_${LABEL}.dtb;
  
  echo "Restoring boot.img (kernel) from cache";
  cp -rv ./../../../../.cache/boot_${LABEL}.img ../boot_${LABEL}.img;
    
  echo "Getting root offset";
  root_offset=$(fdisk -l ../image_${LABEL}.img | grep -oP "(\.img2)( *)([0-9]*?) " | grep -oE "*([0-9]*)*" | tail -1);
    
  echo "Root offset is $root_offset.";
    
  root_sector_offset=$(($root_offset*512));
  
  echo "Unmounting root";
  umount ../image_${LABEL}/root;
  
  echo "Deleting existing mount directory if it exists"
  rm -rf ../image_${LABEL};
  
  echo "Creating mount directories";
  mkdir ../image_${LABEL} ../image_${LABEL}/root;
  
  echo "Mounting root directory at $root_sector_offset";
  mount -t ext4 -o loop,offset=$root_sector_offset ../image_${LABEL}.img ../image_${LABEL}/root;
  
  echo "Creating workspace directory";
  mkdir ../image_${LABEL}/root/workspace;
  
  echo "Copying tools into host";
  mkdir ../image_${LABEL}/root/workspace/tools;
  cp -R ../../../tools ../image_${LABEL}/root/workspace/tools;
  
  echo "Copying vscode into host";
  mkdir ../image_${LABEL}/root/workspace/.builds ../image_${LABEL}/root/workspace/.builds/$LABEL;
  cp -R ./.vscode ../image_${LABEL}/root/workspace/.builds/${LABEL}/.vscode;
  
  echo "Listing workspace inside image";
  ls ../image_${LABEL}/root/workspace;
  
  echo "Syncing mount";
  sync;
  
  echo "Unmounting root";
  umount ./image_${LABEL}/root;
  
  echo "Deleting mount point";
  rm -rf ./image_${LABEL};