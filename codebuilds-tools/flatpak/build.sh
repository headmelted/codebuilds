#!/bin/bash
set -e;

if [[ ! -d repo ]]
then
  ostree init --mode=archive-z2 --repo=repo
fi

if [ "${CROSS_TOOLCHAIN}" == "true" ]
then
  ../qemu.sh;
fi

flatpak-builder \
    --force-clean \
    --ccache \
    --require-changes \
    --repo=repo \
    --arch=$VSCODE_ELECTRON_PLATFORM \
    --subject="build of com.visualstudio.code.oss, $(date)" \
    build \
    com.visualstudio.code.oss.json;
