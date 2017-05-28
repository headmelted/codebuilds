#!/bin/bash
set -e;

echo "Re-pointing APT sources for Ubuntu version: '${UBUNTU_VERSION}' and architecture '${ARCH}'.";

if [ -f "/etc/apt/sources.list" ]; then
  echo "Reading sources.list..."
  cat /etc/apt/sources.list;
  echo "Removing /etc/apt/sources.list...";
  sudo rm /etc/apt/sources.list;
else
  echo "No /etc/apt/sources.list currently exists."
fi;

echo "Removing existing sources lists...";
sudo rm -rf /etc/apt/sources.list.d/**;

echo "Adding ${UBUNTU_VERSION} package sources for amd64 and i386...";
echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu ${UBUNTU_VERSION} main universe multiverse restricted" | sudo tee /etc/apt/sources.list;
echo "deb [arch=amd64,i386] http://security.ubuntu.com/ubuntu ${UBUNTU_VERSION}-security main universe multiverse restricted" | sudo tee -a /etc/apt/sources.list;
echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu ${UBUNTU_VERSION}-updates main universe multiverse restricted" | sudo tee -a /etc/apt/sources.list;
echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu ${UBUNTU_VERSION}-backports main universe multiverse restricted" | sudo tee -a /etc/apt/sources.list;

if [ "${ARCH}" != "amd64" ]; then

  echo "Adding ${UBUNTU_VERSION} package sources for ${ARCH}...";
  echo "deb [arch=${ARCH}] http://ports.ubuntu.com/ubuntu-ports ${UBUNTU_VERSION} main universe multiverse restricted" | sudo tee -a /etc/apt/sources.list;
  echo "deb [arch=${ARCH}] http://ports.ubuntu.com/ubuntu-ports ${UBUNTU_VERSION}-security main universe multiverse restricted" | sudo tee -a /etc/apt/sources.list;
  echo "deb [arch=${ARCH}] http://ports.ubuntu.com/ubuntu-ports ${UBUNTU_VERSION}-updates main universe multiverse restricted" | sudo tee -a /etc/apt/sources.list;
  echo "deb [arch=${ARCH}] http://ports.ubuntu.com/ubuntu-ports ${UBUNTU_VERSION}-backports main universe multiverse restricted" | sudo tee -a /etc/apt/sources.list;

  echo "Adding ${UBUNTU_VERSION} package sources for source code...";
  echo "deb-src http://archive.ubuntu.com/ubuntu ${UBUNTU_VERSION} main universe multiverse restricted" | sudo tee -a /etc/apt/sources.list;
  echo "deb-src http://security.ubuntu.com/ubuntu ${UBUNTU_VERSION}-security main universe multiverse restricted" | sudo tee -a /etc/apt/sources.list;
  echo "deb-src http://archive.ubuntu.com/ubuntu ${UBUNTU_VERSION}-updates main universe multiverse restricted" | sudo tee -a /etc/apt/sources.list;
  echo "deb-src http://archive.ubuntu.com/ubuntu ${UBUNTU_VERSION}-backports main universe multiverse restricted" | sudo tee -a /etc/apt/sources.list;

fi;

echo "Updated sources:";
cat /etc/apt/sources.list;

echo "Updating package repositories...";
sudo apt update -yq;
