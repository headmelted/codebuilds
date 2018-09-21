#!/bin/bash
set -e;

echo "Retrieving Node.js...";
curl -sL https://deb.nodesource.com/setup_8.x | bash -;

echo "Installing Node.js...";
apt-get install -y nodejs;
  
echo "Setting python binding";
npm config set python `which python`;

echo "Installing common npm dependencies";
npm install -g gulp yarn;
