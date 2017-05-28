FROM ubuntu:yakkety
MAINTAINER Jay Rodgers <headmelted@gmail.com>

RUN apt-get update
RUN apt-get install -y software-properties-common xvfb wget git python curl zip libgtk2.0-0 libxkbfile-dev libx11-dev rpm graphicsmagick gcc-4.9 g++-4.9 gcc-4.9-multilib g++-4.9-multilib libc6-dev-i386 build-essential libxss-dev libgconf-2-4 fakeroot rpm libnss3 libasound2 libxtst6 libfuse2 libnotify-bin libxss1 libx11-xcb-dev

ENV \
LABEL=amd64_linux \
ARCH=amd64 \
GPP_COMPILER=g++-4.9 \
GCC_COMPILER=gcc-4.9 \
VSCODE_ELECTRON_PLATFORM=x64 \
PACKAGE_ARCH=x64
