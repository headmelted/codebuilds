#!/bin/bash

echo "Changing directory to $HOME...";
cd $HOME;

export CXX="${GPP_COMPILER}" CC="${GCC_COMPILER}" DEBIAN_FRONTEND="noninteractive";

if [[ "${CROSS_TOOLCHAIN}" == "true" ]]; then
  
  echo " directory is [$(pwd)].";
  
  echo "Adding ${ARCH} architecture...";
  dpkg --add-architecture ${ARCH};

  echo "Updating package repositories...";
  apt-get update -yq;

  echo "Installing apt pre-requisites...";
  apt-get install -y python curl xvfb git libwww-perl libexpat1 libxml-libxml-perl libxml-sax-expat-perl gcc-${GNU_TRIPLET} g++-${GNU_TRIPLET} crossbuild-essential-${ARCH} libstdc++6-${ARCH}-cross dpkg-dev perl libconfig-inifiles-perl libxml-simple-perl liblocale-gettext-perl libgcc1 libgcc1:${ARCH} libdpkg-perl libconfig-auto-perl libdebian-dpkgcross-perl ucf debconf dpkg-cross libdbus-1-3:${ARCH} libffi6:${ARCH} libpcre3:${ARCH} libselinux1:${ARCH} libp11-kit0:${ARCH} libcomerr2:${ARCH} libk5crypto3:${ARCH} libkrb5-3:${ARCH} libpango-1.0-0:${ARCH} libpangocairo-1.0-0:${ARCH} libpangoft2-1.0-0:${ARCH} libxcursor1:${ARCH} libxfixes3:${ARCH} libglib2.0-0:${ARCH} libfreetype6:${ARCH} libavahi-client3:${ARCH} libgssapi-krb5-2:${ARCH} libexpat1:${ARCH} libjpeg8:${ARCH} libpng-dev libpng-dev:${ARCH} libtiff5:${ARCH} fontconfig-config libgdk-pixbuf2.0-common libgdk-pixbuf2.0-0:${ARCH} libfontconfig1:${ARCH} libcups2:${ARCH} libcairo2:${ARCH} libc6 libc6:${ARCH} libc6-dev:${ARCH} libatk1.0-0:${ARCH} libgtk2.0-0:${ARCH} libx11-dev:${ARCH} libxkbfile-dev:${ARCH} libx11-xcb-dev libx11-xcb-dev:${ARCH} libxtst6 libxtst6:${ARCH} libxss-dev libxss-dev:${ARCH} libgconf-2-4:${ARCH} libasound2:${ARCH} rpm;
  
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

git submodule update --init --recursive;
git clone --depth 1 https://github.com/creationix/nvm.git ./.nvm;
source ./.nvm/nvm.sh;
nvm install 6.6.0;
nvm use 6.6.0;

echo "Setting python binding...";
npm config set python `which python`;

echo "Installing gulp...";
npm install gulp;
npm install -g gulp;

if [[ "${ARCH}" == "amd64" ]]; then
  ./scripts/npm.sh install --unsafe-perm | tee -a ../buildlog_${LABEL}.txt;
  gulp electron | tee -a ../buildlog_${LABEL}.txt;
else
  ./scripts/npm.sh install --unsafe-perm --arch=${NPM_ARCH} | tee -a ../buildlog_${LABEL}.txt;
  gulp electron --arch=${VSCODE_ELECTRON_PLATFORM} | tee -a ../buildlog_${LABEL}.txt;
fi;

echo "Starting hygiene...";
gulp hygiene | tee -a ../buildlog_${LABEL}.txt;

echo "Starting compile...";
gulp compile --max_old_space_size=4096 | tee -a ../buildlog_${LABEL}.txt;

echo "Starting optimize...";
gulp optimize-vscode --max_old_space_size=4096 | tee -a ../buildlog_${LABEL}.txt;