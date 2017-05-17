#!/bin/bash
set -e

export CXX="${GPP_COMPILER}" CC="${GCC_COMPILER}" DEBIAN_FRONTEND="noninteractive";

echo "Deleting .nvm directory if it already exists...";
rm -rf .nvm;

echo "Installing git...";
sudo apt-get install -y git;

git submodule update --init --recursive;
git clone --depth 1 https://github.com/creationix/nvm.git ./.nvm;
source ./.nvm/nvm.sh;
nvm install 7.4.0;
nvm use 7.4.0;

echo "Setting python binding...";
npm config set python `which python`;

echo "Installing gulp...";
npm install -g gulp;
