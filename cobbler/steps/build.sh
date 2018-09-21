#!/bin/bash
set -e;

. ~/cobbler/steps/setup_nvm.sh;

echo "Running npm install for $npm_config_target_arch";
yarn install;

echo "Compiling VS Code for $npm_config_target_arch";
yarn run gulp vscode-linux-$npm_config_target_arch-min;
