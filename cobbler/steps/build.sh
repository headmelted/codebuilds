#!/bin/bash
set -e;

echo "VS Code electron platform: $VSCODE_ELECTRON_PLATFORM";

echo "Running npm install for ${NPM_ARCH}";
./scripts/npm.sh install --target-arch=${NPM_ARCH} --unsafe-perm;

yarn run gulp vscode-linux-arm-min

yarn run gulp vscode-linux-arm-build-deb
