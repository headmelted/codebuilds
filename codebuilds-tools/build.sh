#!/bin/bash
set -e;

# echo "Changing directory to $HOME/codebuilds...";
# cd $HOME/codebuilds;

if [[ "${CROSS_TOOLCHAIN}" != "true" ]]; then

  echo "Installing apt pre-requisites...";
  sudo apt-get install -y gcc-4.9 g++-4.9 gcc-4.9-multilib g++-4.9-multilib libc6-dev-i386 zip libgtk2.0-0 libx11-dev libxkbfile-dev rpm graphicsmagick;

else
  
  # echo " directory is [$(pwd)].";
  
  # echo "Removing existing sources lists...";
  # sudo rm -rf /etc/apt/sources.list.d/**;
  # sudo rm /etc/apt/sources.list;
  
  # echo "Adding 16.04 (zesty) package sources for amd64 and i386...";
  # echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu zesty main universe multiverse restricted" | sudo tee /etc/apt/sources.list;
  
  # echo "Adding 16.04 (zesty) package sources for ${ARCH}...";
  # echo "deb [arch=${ARCH}] http://ports.ubuntu.com/ubuntu-ports zesty main universe multiverse restricted" | sudo tee -a /etc/apt/sources.list;
  
  # echo "Adding 16.04 (zesty) package sources for source code...";
  # echo "deb-src http://archive.ubuntu.com/ubuntu zesty main universe multiverse restricted" | sudo tee -a /etc/apt/sources.list;
  
  # echo "Adding ${ARCH} architecture...";
  # sudo dpkg --add-architecture ${ARCH};

  # echo "Updating package repositories...";
  # sudo apt-get update -yq;

  echo "Installing apt pre-requisites...";
  sudo apt-get install -y python curl git libwww-perl libexpat1 libxml-libxml-perl libxml-sax-expat-perl gcc-${GNU_TRIPLET} g++-${GNU_TRIPLET} crossbuild-essential-${ARCH} libstdc++6-${ARCH}-cross dpkg-dev perl libconfig-inifiles-perl libxml-simple-perl liblocale-gettext-perl libgcc1 libgcc1:${ARCH} libdpkg-perl libconfig-auto-perl libdebian-dpkgcross-perl ucf debconf dpkg-cross libdbus-1-3:${ARCH} libffi6:${ARCH} libpcre3:${ARCH} libselinux1:${ARCH} libp11-kit0:${ARCH} libcomerr2:${ARCH} libk5crypto3:${ARCH} libkrb5-3:${ARCH} libpango-1.0-0:${ARCH} libpangocairo-1.0-0:${ARCH} libpangoft2-1.0-0:${ARCH} libxcursor1:${ARCH} libxfixes3:${ARCH} libfreetype6:${ARCH} libavahi-client3:${ARCH} libgssapi-krb5-2:${ARCH} libexpat1:${ARCH} libjpeg8:${ARCH} libpng-dev libpng-dev:${ARCH} libtiff5:${ARCH} fontconfig-config libgdk-pixbuf2.0-common libgdk-pixbuf2.0-0:${ARCH} libfontconfig1:${ARCH} libcups2:${ARCH} libcairo2:${ARCH} libc6 libc6:${ARCH} libc6-dev:${ARCH} libatk1.0-0:${ARCH} libgtk2.0-0:${ARCH} libx11-dev:${ARCH} libxkbfile-dev:${ARCH} libx11-xcb-dev libx11-xcb-dev:${ARCH} libxtst6 libxtst6:${ARCH} libxss-dev libxss-dev:${ARCH} libgconf-2-4:${ARCH} libasound2:${ARCH} rpm graphicsmagick;
  
  # echo "Reading proc...";
  # ls /proc/sys/fs/;
  
  # echo "Mounting binfmt_misc...";
  # mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc;
  
  # echo "Enabling binfmt_misc...";
  # echo 1 > /proc/sys/fs/binfmt_misc/status;

  # echo "Enabling ${QEMU_ARCH} emulator...";
  # update-binfmts --enable qemu-${QEMU_ARCH};
  
  # echo "Symlinking libstdc++.so.6...";
  # ln -s /usr/arm-linux-gnueabihf/lib/libstdc++.so.6 /lib/libstdc++.so.6;

  # echo "Emulators available:" && update-binfmts --display;
   
fi;

echo "Running npm install...";
./scripts/npm.sh install --unsafe-perm --arch=${VSCODE_ELECTRON_PLATFORM};

#echo "Starting hygiene...";
#gulp hygiene;

echo "Starting electron...";
gulp electron --unsafe-perm --arch=${VSCODE_ELECTRON_PLATFORM};

echo "Starting compile...";
gulp compile --unsafe-perm --max_old_space_size=4096;
