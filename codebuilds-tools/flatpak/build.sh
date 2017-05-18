#!/bin/bash
set -e;

echo "Installing ostree...";
apt-get install -y ostree;

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
