#!/bin/bash

echo "Running npm install for ${VSCODE_ELECTRON_PLATFORM}";
./scripts/npm.sh install --arch=${VSCODE_ELECTRON_PLATFORM} --unsafe-perm;

echo "Starting hygiene";
gulp hygiene --silent;

echo "Starting electron";
gulp electron-${NPM_ARCH} --silent;

echo "Starting compile";
gulp compile --silent --max_old_space_size=4096;

echo "Starting optimize";
gulp optimize-vscode --silent --max_old_space_size=4096;
