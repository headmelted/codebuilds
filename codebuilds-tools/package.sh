#!/bin/bash
set -e;

echo "Starting vscode-linux-${PACKAGE_ARCH}...";
gulp "vscode-linux-${PACKAGE_ARCH}";

echo "Starting vscode-linux-${PACKAGE_ARCH}-build-deb...";
gulp "vscode-linux-${PACKAGE_ARCH}-build-deb";

echo "Starting vscode-linux-${PACKAGE_ARCH}-build-rpm...";
gulp --silent "vscode-linux-${PACKAGE_ARCH}-build-rpm";

echo "Installing flatpak...";
sudo add-apt-repository ppa:alexlarsson/flatpak;
sudo apt update;
sudo apt install flatpak;

echo "Installing flatpak dependencies...";
wget https://sdk.gnome.org/keys/gnome-sdk.gpg
flatpak --user remote-add --gpg-import=gnome-sdk.gpg gnome https://sdk.gnome.org/repo/
flatpak --user install org.freedesktop.Platform 1.4
flatpak --user install org.freedesktop.Sdk 1.4

echo "Starting vscode-linux-${PACKAGE_ARCH}-build-flatpak...";
gulp "vscode-linux-${PACKAGE_ARCH}-prepare-flatpak";

# echo "Tarring build folder for release...";
# tar -zcvf "code-oss_${LABEL}.tar.gz" .build;
