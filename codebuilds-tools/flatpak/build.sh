#!/bin/bash
set -e;

echo "Installing flatpak repository...";
add-apt-repository -y ppa:alexlarsson/flatpak;

echo "Updating package repositories...";
apt update -yq;

echo "Installing flatpak dependencies...";
apt install -y ostree wget flatpak flatpak-builder;

echo "Installing flatpak dependencies...";
wget https://sdk.gnome.org/keys/gnome-sdk.gpg -O gnome-sdk.gpg;
flatpak --user remote-add --gpg-import=gnome-sdk.gpg gnome https://sdk.gnome.org/repo/;
flatpak --user install gnome org.freedesktop.Platform//1.4 org.freedesktop.Sdk//1.4;

if [[ ! -d repo ]]
then
  ostree init --mode=archive-z2 --repo=repo
fi

# if [ "${CROSS_TOOLCHAIN}" == "true" ]
# then
#   ../qemu.sh;
# fi

echo "Setting tag in json configuration...";
sed -i -e "s/@@TAG@@/${TRAVIS_TAG}/g" /workspace/codebuilds-tools/flatpak/com.visualstudio.code.oss.json;

flatpak-builder \
    --force-clean \
    --ccache \
    --require-changes \
    --repo=repo \
    --arch=$VSCODE_ELECTRON_PLATFORM \
    --subject="com.visualstudio.code.oss.${TRAVIS_TAG}" \
    build \
    /workspace/codebuilds-tools/flatpak/com.visualstudio.code.oss.json;
