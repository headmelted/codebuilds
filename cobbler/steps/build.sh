#!/bin/bash
set -e;

echo "Running NVM setup";
. ./setup_nvm.sh;

echo "Running npm install for $npm_config_target_arch";
npm install --target-arch=$npm_config_target_arch --unsafe-perm;

echo "Compiling VS Code for $npm_config_target_arch";
yarn run gulp vscode-linux-$npm_config_target_arch-min;
