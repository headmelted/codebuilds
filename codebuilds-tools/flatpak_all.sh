#!/bin/bash;
set -e;

echo "Installing flatpak dependencies (including static QEMU for ${QEMU_ARCH})...";
sudo apt-get install -y qemu-system-${QEMU_ARCH} qemu-user-static flatpak;

echo "Restarting systemd-binfmt.service daemon...";
sudo systemctl restart systemd-binfmt.service;

echo "Installing flatpak runtimes for ...";
flatpak install --user gnome org.freedesktop.Sdk/${QEMU_ARCH}/1.6 org.freedesktop.Platform/${QEMU_ARCH}/1.6;

echo "Creating flatpak build directory...";
mkdir /workspace/flatpak;

echo "Initializing flatpak directory...";
flatpak build-init /workspace/flatpak org.freedesktop.Sdk/${QEMU_ARCH}/1.6  org.freedesktop.Platform/${QEMU_ARCH}/1.6;

echo "Initializing flatpak directory...";
flatpak build-init

. /workspace/codebuilds-tools/setup_nvm.sh;
. /workspace/codebuilds-tools/build.sh;
