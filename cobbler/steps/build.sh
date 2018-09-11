#!/bin/bash
set -e;

export GITHUB_TOKEN=$GITHUB_TOKEN;

echo "VS Code electron platform: $VSCODE_ELECTRON_PLATFORM";

echo "Running npm install for ${NPM_ARCH}";
./scripts/npm.sh install --target-arch=${NPM_ARCH} --unsafe-perm;

yarn run gulp vscode-linux-${NPM_ARCH}-min
