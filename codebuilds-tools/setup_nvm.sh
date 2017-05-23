#!/bin/bash
set -e;

if [ ! -d /workspace/.nvm ]; then

  echo "Installing nvm..."
  git submodule update --init --recursive;
  git clone --depth 1 https://github.com/creationix/nvm.git /workspace/.nvm;
  . /workspace/.nvm/nvm.sh;
  nvm install 7.4.0;
  nvm use 7.4.0;

  echo "Setting python binding...";
  npm config set python `which python`;

  echo "Installing gulp...";
  npm install -g gulp;
  
else

  echo "nvm already exists, skipping...";
  
fi;
