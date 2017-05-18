#!/bin/bash
set -e;

echo "Downloading ostree...";
wget "http://mirrors.kernel.org/ubuntu/pool/universe/o/ostree/ostree_2016.10-1_amd64.deb";
dpkg -i ostree_2016.10-1_amd64.deb;

if [[ ! -d repo ]]
then
  ostree init --mode=archive-z2 --repo=repo
fi

if [ "${CROSS_TOOLCHAIN}" == "true" ]
then
  ../qemu.sh;
fi

echo "Setting tag in json configuration...";
sed -i -e "s/@@TAG@@/${TRAVIS_TAG}/g" com.visualstudio.code.oss.json;

flatpak-builder \
    --force-clean \
    --ccache \
    --require-changes \
    --repo=repo \
    --arch=$VSCODE_ELECTRON_PLATFORM \
    --subject="com.visualstudio.code.oss.${TRAVIS_TAG}" \
    build \
    com.visualstudio.code.oss.json;
