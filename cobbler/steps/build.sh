#!/bin/bash
set -e;

echo "VS Code electron platform before set: $VSCODE_ELECTRON_PLATFORM";

case "$ARCH" in
  "armhf")
    VSCODE_ELECTRON_PLATFORM="arm";;
  "amd64")
    VSCODE_ELECTRON_PLATFORM="amd64";;
esac

echo "VS Code electron platform after set but before export: $VSCODE_ELECTRON_PLATFORM";
export VSCODE_ELECTRON_PLATFORM="$VSCODE_ELECTRON_PLATFORM";
echo "VS Code electron platform after export: $VSCODE_ELECTRON_PLATFORM";

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
