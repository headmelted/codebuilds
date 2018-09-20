#!/bin/bash
set -e;

echo "Running NVM installer";
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash;

echo "Setting up NVM";
nvm install $1;
nvm use $1;
nvm alias default $1;
  
echo "Setting python binding";
npm config set python `which python`;

echo "Installing common npm dependencies";
npm install -g gulp yarn;
