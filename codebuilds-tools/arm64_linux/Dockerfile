FROM ubuntu:yakkety
MAINTAINER Jay Rodgers <headmelted@gmail.com>

RUN apt-get update
RUN apt-get install -y software-properties-common xvfb wget git python curl zip p7zip-full libgtk2.0-0:arm64 libxkbfile-dev:arm64 libx11-dev:arm64 rpm graphicsmagick libwww-perl libexpat1 libxml-libxml-perl libxml-sax-expat-perl gcc-aarch64-linux-gnu g++-aarch64-linux-gnu crossbuild-essential-arm64 libstdc++6-arm64-cross dpkg-dev perl libconfig-inifiles-perl libxml-simple-perl liblocale-gettext-perl libgcc1 libgcc1:arm64 libdpkg-perl libconfig-auto-perl libdebian-dpkgcross-perl ucf debconf dpkg-cross libdbus-1-3:arm64 libffi6:arm64 libpcre3:arm64 libselinux1:arm64 libp11-kit0:arm64 libcomerr2:arm64 libk5crypto3:arm64 libkrb5-3:arm64 libpango-1.0-0:arm64 libpangocairo-1.0-0:arm64 libpangoft2-1.0-0:arm64 libxcursor1:arm64 libxfixes3:arm64 libfreetype6:arm64 libavahi-client3:arm64 libgssapi-krb5-2:arm64 libexpat1:arm64 libjpeg8:arm64 libpng12-dev libtiff5:arm64 fontconfig-config libgdk-pixbuf2.0-common libgdk-pixbuf2.0-0:arm64 libfontconfig1:arm64 libcups2:arm64 libcairo2:arm64 libc6 libc6:arm64 libc6-dev:arm64 libatk1.0-0:arm64 libx11-xcb-dev libx11-xcb-dev:arm64 libxtst6 libxtst6:arm64 libxss-dev libxss-dev:arm64 libgconf-2-4:arm64 libasound2:arm64
  
ENV \
LABEL=arm64_linux \
CROSS_TOOLCHAIN=true \
ARCH=arm64 \
NPM_ARCH=arm \
GNU_TRIPLET=aarch64-linux-gnu \
GNU_MULTILIB_TRIPLET=arm-linux-gnueabihf \
GPP_COMPILER=aarch64-linux-gnu-g++ \
GCC_COMPILER=aarch64-linux-gnu-gcc \
VSCODE_ELECTRON_PLATFORM=arm \
PACKAGE_ARCH=arm64 \
QEMU_ARCH=aarch64 \
QEMU_IMAGE="https://dl.armbian.com/odroidc2/Ubuntu_xenial_default.7z" \
QEMU_KERNEL="Image" \
QEMU_DTB="meson64_odroidc2.dtb" \
QEMU_MACHINE="virt"