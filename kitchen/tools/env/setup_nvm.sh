#!/bin/bash

echo "Checking for node";
if [[ "$(node -v)" != "v7.4.0" ]]; then

  echo "Removing old nvm for user if it exists";
  rm -rf ~/.nvm;

  echo "Cloning nvm for user";
  git clone --depth 1 https://github.com/creationix/nvm.git ~/.nvm;

  echo "Setting current owner as owner of ~/.nvm";
  chown ${USER:=$(/usr/bin/id -run)}:$USER -R ~/.nvm;

  echo "Running NVM script";
  source ~/.nvm/nvm.sh;

  echo "Setting up NVM";
  nvm install 7.4.0;
  nvm use 7.4.0;
  nvm alias default 7.4.0;
  
else

  echo "node up-to-date"
  
fi;

echo "Setting python binding";
npm config set python `which python`;

echo "Installing npm dependencies";
npm install -g gulp;
