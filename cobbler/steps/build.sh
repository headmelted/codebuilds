#!/bin/bash
set -e;

echo "VS Code electron platform: $VSCODE_ELECTRON_PLATFORM";

echo "Current directory is [$(pwd)]";

echo "Running npm install for $COBBLER_NPM_ARCH";
npm install --target-arch=$COBBLER_NPM_ARCH --unsafe-perm;

echo "Compiling VS Code for $COBBLER_NPM_ARCH";
yarn run gulp vscode-linux-$COBBLER_NPM_ARCH-min;
