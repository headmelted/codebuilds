#!/bin/bash
set -e;

echo "VS Code electron platform: $VSCODE_ELECTRON_PLATFORM";

echo "Current directory is [$(pwd)]";

echo "Running yarn install for ${NPM_ARCH}";
yarn install --target-arch=${NPM_ARCH} --unsafe-perm;

echo "Compiling VS Code for $NPM_ARCH";
yarn run gulp vscode-linux-${NPM_ARCH}-min;
