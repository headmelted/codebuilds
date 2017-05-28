#!/bin/bash
set -e;

# echo "Changing directory to $HOME/codebuilds...";
# cd $HOME/codebuilds;

echo "Setting self as owner of node_modules...";
sudo chown -hR $USER ./;

echo "Running npm install...";
./scripts/npm.sh install --unsafe-perm --arch=${VSCODE_ELECTRON_PLATFORM};

#echo "Starting hygiene...";
#gulp hygiene;

echo "Node version is $(node -v)."

echo "Starting electron...";
gulp electron --unsafe-perm --arch=${VSCODE_ELECTRON_PLATFORM};

echo "Starting compile...";
gulp compile --unsafe-perm --max_old_space_size=4096;
