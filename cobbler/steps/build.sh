#!/bin/bash
set -e;

echo "/lib -------------------------------"
ls /lib;
echo "/usr/include ---------------------------"
ls /usr/include;
echo "/usr/lib/$COBBLER_GNU_TRIPLET -----------------------"
ls /usr/lib/$COBBLER_GNU_TRIPLET;
echo "/usr/include/$COBBLER_GNU_TRIPLET --------------------"
tree /usr/include/$COBBLER_GNU_TRIPLET
echo "------------------------------------------------------------"

. ~/cobbler/steps/setup_nvm.sh;

echo "Running npm install for $npm_config_target_arch";
yarn install;

echo "Compiling VS Code for $npm_config_target_arch";
yarn run gulp vscode-linux-$npm_config_target_arch-min;
