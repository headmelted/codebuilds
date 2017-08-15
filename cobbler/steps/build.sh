#!/bin/bash
set -e;

echo "VS Code electron platform: $VSCODE_ELECTRON_PLATFORM";

echo "Running npm install for ${NPM_ARCH}";
./scripts/npm.sh install --arch=${NPM_ARCH} --unsafe-perm;

echo "Starting hygiene";
#gulp hygiene;

echo "Starting electron";
gulp electron-${NPM_ARCH};

echo "Starting compile";
gulp compile --max_old_space_size=4096;

echo "Starting optimize";
gulp optimize-vscode --max_old_space_size=4096;
