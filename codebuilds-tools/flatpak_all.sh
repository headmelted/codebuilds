#!/bin/bash
set -e;

echo "Installing flatpak dependencies (including static QEMU for ${QEMU_ARCH})...";
apt-get install -y qemu-system-${QEMU_ARCH} qemu-user-static flatpak;

echo "Restarting systemd-binfmt.service daemon...";
systemctl restart systemd-binfmt.service;

echo "Installing flatpak runtimes for ...";
flatpak install --user gnome org.freedesktop.Sdk/${QEMU_ARCH}/1.6 org.freedesktop.Platform/${QEMU_ARCH}/1.6;

echo "Initializing flatpak directory...";
flatpak build-init /workspace/flatpak code-oss org.freedesktop.Sdk/${QEMU_ARCH}  org.freedesktop.Platform/${QEMU_ARCH};

echo "Executing the build inside the flatpak sandbox...";
flatpak build code-oss ln -s ./ /workspace && . /workspace/codebuilds-tools/setup_nvm.sh && . /workspace/codebuilds-tools/build.sh;
