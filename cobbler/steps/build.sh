#!/bin/bash

echo "Running npm install for ${ELECTRON_ARCH}";
./scripts/npm.sh install --arch=${ELECTRON_ARCH} --unsafe-perm;

echo "Starting hygiene";
#gulp hygiene;

echo "Starting electron";
gulp electron-${NPM_ARCH};

echo "Starting compile";
gulp compile --max_old_space_size=4096;

echo "Starting optimize";
gulp optimize-vscode --max_old_space_size=4096;
