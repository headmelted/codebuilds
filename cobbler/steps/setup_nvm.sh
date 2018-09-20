#!/bin/bash
set -e;

echo "Removing old nvm for user if it exists";
rm -rf ~/.nvm;

echo "Cloning nvm for user";
git clone --depth 1 https://github.com/creationix/nvm.git ~/.nvm;

echo "Setting current owner as owner of ~/.nvm";
chown ${USER:=$(/usr/bin/id -run)}:$USER -R ~/.nvm;

echo "NVM Script:"
cat ~/.nvm/nvm.sh;

echo "Running NVM script";
. ~/.nvm/nvm.sh;

echo "Setting up NVM";
nvm install $1;
nvm use $1;
nvm alias default $1;
  
echo "Setting python binding";
npm config set python `which python`;

echo "Installing common npm dependencies";
npm install -g gulp yarn;
