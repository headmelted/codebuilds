#!/bin/bash
set -e

export CXX="${GPP_COMPILER}" CC="${GCC_COMPILER}" DEBIAN_FRONTEND="noninteractive";

echo "Deleting .nvm directory if it already exists...";
rm -rf .nvm;

echo "Updating package repositories...";
apt update -yq;

if [ "${CROSS_TOOLCHAIN}" != "true" ]; then
  apt install -y software-properties-common xvfb wget git python curl zip libgtk2.0-0 libxkbfile-dev libx11-dev rpm graphicsmagick gcc-4.9 g++-4.9 gcc-4.9-multilib g++-4.9-multilib libc6-dev-i386 build-essential libxss-dev libgconf-2-4 fakeroot rpm libnss3 libasound2 libxtst6 libfuse2 libnotify-bin libxss1 libx11-xcb-dev;

else
  
  echo "Reading sources.list..."
  cat /etc/apt/sources.list;
  
  echo "Removing existing sources lists...";
  rm -rf /etc/apt/sources.list.d/**;
  rm /etc/apt/sources.list;
  
  echo "Adding ${UBUNTU_VERSION} package sources for amd64 and i386...";
  echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu ${UBUNTU_VERSION} main universe multiverse restricted" | tee /etc/apt/sources.list;
  echo "deb [arch=amd64,i386] http://security.ubuntu.com/ubuntu ${UBUNTU_VERSION}-security main universe multiverse restricted" | tee /etc/apt/sources.list;
  echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu ${UBUNTU_VERSION}-updates main universe multiverse restricted" | tee /etc/apt/sources.list;
  echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu ${UBUNTU_VERSION}-backports main universe multiverse restricted" | tee /etc/apt/sources.list;
  
  echo "Adding ${UBUNTU_VERSION} package sources for ${ARCH}...";
  echo "deb [arch=${ARCH}] http://ports.ubuntu.com/ubuntu-ports ${UBUNTU_VERSION} main universe multiverse restricted" | tee -a /etc/apt/sources.list;
  echo "deb [arch=${ARCH}] http://ports.ubuntu.com/ubuntu-ports ${UBUNTU_VERSION}-security main universe multiverse restricted" | tee -a /etc/apt/sources.list;
  echo "deb [arch=${ARCH}] http://ports.ubuntu.com/ubuntu-ports ${UBUNTU_VERSION}-updates main universe multiverse restricted" | tee -a /etc/apt/sources.list;
  echo "deb [arch=${ARCH}] http://ports.ubuntu.com/ubuntu-ports ${UBUNTU_VERSION}-backports main universe multiverse restricted" | tee -a /etc/apt/sources.list;
  
  echo "Adding ${UBUNTU_VERSION} package sources for source code...";
  echo "deb-src http://archive.ubuntu.com/ubuntu ${UBUNTU_VERSION} main universe multiverse restricted" | tee -a /etc/apt/sources.list;
  echo "deb-src http://security.ubuntu.com/ubuntu ${UBUNTU_VERSION}-security main universe multiverse restricted" | tee -a /etc/apt/sources.list;
  echo "deb-src http://archive.ubuntu.com/ubuntu ${UBUNTU_VERSION}-updates main universe multiverse restricted" | tee -a /etc/apt/sources.list;
  echo "deb-src http://archive.ubuntu.com/ubuntu ${UBUNTU_VERSION}-backports main universe multiverse restricted" | tee -a /etc/apt/sources.list;
  
  echo "Adding ${ARCH} architecture...";
  dpkg --add-architecture ${ARCH};

  echo "Updating package repositories...";
  apt-get update -yq;

  apt install -y ia32-libs software-properties-common xvfb wget git python curl zip libgtk2.0-0:${ARCH} libxkbfile-dev:${ARCH} libx11-dev:${ARCH} rpm graphicsmagick libwww-perl libexpat1 libxml-libxml-perl libxml-sax-expat-perl gcc-${GNU_TRIPLET} g++-${GNU_TRIPLET} crossbuild-essential-${ARCH} libstdc++6-${ARCH}-cross dpkg-dev perl libconfig-inifiles-perl libxml-simple-perl liblocale-gettext-perl libgcc1 libgcc1:${ARCH} libdpkg-perl libconfig-auto-perl libdebian-dpkgcross-perl ucf debconf dpkg-cross libdbus-1-3:${ARCH} libffi6:${ARCH} libpcre3:${ARCH} libselinux1:${ARCH} libp11-kit0:${ARCH} libcomerr2:${ARCH} libk5crypto3:${ARCH} libkrb5-3:${ARCH} libpango-1.0-0:${ARCH} libpangocairo-1.0-0:${ARCH} libpangoft2-1.0-0:${ARCH} libxcursor1:${ARCH} libxfixes3:${ARCH} libfreetype6:${ARCH} libavahi-client3:${ARCH} libgssapi-krb5-2:${ARCH} libexpat1:${ARCH} libjpeg8:${ARCH} libpng-dev libpng-dev:${ARCH} libtiff5:${ARCH} fontconfig-config libgdk-pixbuf2.0-common libgdk-pixbuf2.0-0:${ARCH} libfontconfig1:${ARCH} libcups2:${ARCH} libcairo2:${ARCH} libc6 libc6:${ARCH} libc6-dev:${ARCH} libatk1.0-0:${ARCH} libx11-xcb-dev libx11-xcb-dev:${ARCH} libxtst6 libxtst6:${ARCH} libxss-dev libxss-dev:${ARCH} libgconf-2-4:${ARCH} libasound2:${ARCH};
  
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

echo "Installing flatpak repository...";
add-apt-repository -y ppa:alexlarsson/flatpak;

echo "Updating package repositories to include flatpak...";
apt update -yq;

echo "Installing flatpak package...";
apt-get install -y flatpak;

echo "Installing flatpak dependencies...";
wget https://sdk.gnome.org/keys/gnome-sdk.gpg -O gnome-sdk.gpg;
flatpak --user remote-add --gpg-import=gnome-sdk.gpg gnome https://sdk.gnome.org/repo/;
flatpak --user install gnome org.freedesktop.Platform//1.4 org.freedesktop.Sdk//1.4;

echo "Current directory is [$(pwd)].";
  
echo "Installing nvm..."
git submodule update --init --recursive;
git clone --depth 1 https://github.com/creationix/nvm.git ./.nvm;
source ./.nvm/nvm.sh;
nvm install 7.4.0;
nvm use 7.4.0;

echo "Setting python binding...";
npm config set python `which python`;

echo "Installing gulp...";
npm install -g gulp;
