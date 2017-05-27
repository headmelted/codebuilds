#!/bin/bash
set -e;

echo "Removing old nvm if it exists...";
rm -rf .nvm;

echo "Installing nvm..."
git submodule update --init --recursive;
git clone --depth 1 https://github.com/creationix/nvm.git .nvm;
. ./.nvm/nvm.sh;
nvm install 7.4.0;
nvm use 7.4.0;
nvm alias default 7.4.0;

echo "Setting python binding...";
npm config set python `which python`;

echo "Installing npm dependencies...";
npm install -g gulp @emmetio/node;

echo "Installing local emmetio/node...";
npm install @emmetio/node;
