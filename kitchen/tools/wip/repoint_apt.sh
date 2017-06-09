#!/bin/bash

echo "Re-pointing APT sources for Ubuntu version: '${UBUNTU_VERSION}' and architecture '${ARCH}'.";

 if [ -f "/etc/apt/sources.list" ]; then
   echo "Reading sources.list..."
   cat /etc/apt/sources.list;
   echo "Removing /etc/apt/sources.list";
   rm /etc/apt/sources.list;
 else
   echo "No /etc/apt/sources.list currently exists."
fi;

echo "Removing existing sources lists";
rm -rf /etc/apt/sources.list.d/**;

if [ ! -f /etc/apt/sources.list.d/codebuilds_$LABEL.list ]; then

echo "Adding ${UBUNTU_VERSION} package sources for amd64 and i386";
echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu ${UBUNTU_VERSION} main universe multiverse restricted" | tee ./codebuilds_$LABEL.list;
echo "deb [arch=amd64,i386] http://security.ubuntu.com/ubuntu ${UBUNTU_VERSION}-security main universe multiverse restricted" | tee -a ./codebuilds_$LABEL.list;
echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu ${UBUNTU_VERSION}-updates main universe multiverse restricted" | tee -a ./codebuilds_$LABEL.list;
echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu ${UBUNTU_VERSION}-backports main universe multiverse restricted" | tee -a ./codebuilds_$LABEL.list;

  echo "Adding ${UBUNTU_VERSION} package sources for other architectures";
  echo "deb [arch=armhf,arm64] http://ports.ubuntu.com/ubuntu-ports ${UBUNTU_VERSION} main universe multiverse restricted" | tee -a ./codebuilds_$LABEL.list;
  echo "deb [arch=armhf,arm64] http://ports.ubuntu.com/ubuntu-ports ${UBUNTU_VERSION}-security main universe multiverse restricted" | tee -a ./codebuilds_$LABEL.list;
  echo "deb [arch=armhf,arm64] http://ports.ubuntu.com/ubuntu-ports ${UBUNTU_VERSION}-updates main universe multiverse restricted" | tee -a ./codebuilds_$LABEL.list;
  echo "deb [arch=armhf,arm64] http://ports.ubuntu.com/ubuntu-ports ${UBUNTU_VERSION}-backports main universe multiverse restricted" | tee -a ./codebuilds_$LABEL.list;

  echo "Adding ${UBUNTU_VERSION} package sources for source code";
  echo "deb-src http://archive.ubuntu.com/ubuntu ${UBUNTU_VERSION} main universe multiverse restricted" | tee -a ./codebuilds_$LABEL.list;
  echo "deb-src http://security.ubuntu.com/ubuntu ${UBUNTU_VERSION}-security main universe multiverse restricted" | tee -a ./codebuilds_$LABEL.list;
  echo "deb-src http://archive.ubuntu.com/ubuntu ${UBUNTU_VERSION}-updates main universe multiverse restricted" | tee -a ./codebuilds_$LABEL.list;
  echo "deb-src http://archive.ubuntu.com/ubuntu ${UBUNTU_VERSION}-backports main universe multiverse restricted" | tee -a ./codebuilds_$LABEL.list;

fi;

fi;

echo "Updated sources file [codebuilds_$LABEL.list]:";
cat ./codebuilds_$LABEL.list;

echo "Updating package repositories";
apt update -yq;
