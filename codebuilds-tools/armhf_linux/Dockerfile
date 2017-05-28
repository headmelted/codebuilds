FROM ubuntu:yakkety
MAINTAINER Jay Rodgers <headmelted@gmail.com>

RUN apt-get update
RUN apt-get install -y sudo apt install -y software-properties-common xvfb wget git python curl zip p7zip-full libgtk2.0-0:armhf libxkbfile-dev:armhf libx11-dev:armhf rpm graphicsmagick libwww-perl libexpat1 libxml-libxml-perl libxml-sax-expat-perl gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf crossbuild-essential-armhf libstdc++6-armhf-cross dpkg-dev perl libconfig-inifiles-perl libxml-simple-perl liblocale-gettext-perl libgcc1 libgcc1:armhf libdpkg-perl libconfig-auto-perl libdebian-dpkgcross-perl ucf debconf dpkg-cross libdbus-1-3:armhf libffi6:armhf libpcre3:armhf libselinux1:armhf libp11-kit0:armhf libcomerr2:armhf libk5crypto3:armhf libkrb5-3:armhf libpango-1.0-0:armhf libpangocairo-1.0-0:armhf libpangoft2-1.0-0:armhf libxcursor1:armhf libxfixes3:armhf libfreetype6:armhf libavahi-client3:armhf libgssapi-krb5-2:armhf libexpat1:armhf libjpeg8:armhf libpng12-dev libtiff5:armhf fontconfig-config libgdk-pixbuf2.0-common libgdk-pixbuf2.0-0:armhf libfontconfig1:armhf libcups2:armhf libcairo2:armhf libc6 libc6:armhf libc6-dev:armhf libatk1.0-0:armhf libx11-xcb-dev libx11-xcb-dev:armhf libxtst6 libxtst6:armhf libxss-dev libxss-dev:armhf libgconf-2-4:armhf libasound2:armhf
  
ENV \
LABEL=armhf_linux \
CROSS_TOOLCHAIN=true \
ARCH=armhf \
NPM_ARCH=arm \
GNU_TRIPLET=arm-linux-gnueabihf \
GNU_MULTILIB_TRIPLET=arm-linux-gnueabihf \
GPP_COMPILER=arm-linux-gnueabihf-g++ \
GCC_COMPILER=arm-linux-gnueabihf-gcc \
VSCODE_ELECTRON_PLATFORM=arm \
PACKAGE_ARCH=armhf \
QEMU_ARCH=arm \
QEMU_ARCHIVE="http://archive.raspbian.org/raspbian" \
QEMU_IMAGE="https://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2017-04-10/2017-04-10-raspbian-jessie-lite.zip" \
QEMU_KERNEL="kernel7.img" \
QEMU_DTB="bcm2709-rpi-2-b.dtb" \
QEMU_MACHINE="raspi2"
