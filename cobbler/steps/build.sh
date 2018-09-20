#!/bin/bash
set -e;

cd $COBBLER_CODE_DIRECTORY;

chmod +x ~/cobbler/steps/*.sh;

echo "Running NVM installer";
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

echo "Running npm install for $npm_config_target_arch";
npm install --target-arch=$npm_config_target_arch --unsafe-perm;

echo "Compiling VS Code for $npm_config_target_arch";
yarn run gulp vscode-linux-$npm_config_target_arch-min;
