#!/bin/bash
set -e;

echo "Installing python"
apt-get install -y python;

echo "Retrieving latest Visual Studio Code sources into [code]";
git clone "https://github.com/Microsoft/vscode.git" code;
  
echo "Setting current owner as owner of code folder";
chown ${USER:=$(/usr/bin/id -run)}:$USER -R code;

echo "Synchronizing overlays folder";
rsync -avh ./overlays/ code/;

echo "Installing NVM and dependencies";
. /root/kitchen/tools/setup_nvm.sh;

echo "Entering code directory";
cd code;

echo "NPM arch is [$npm_config_arch]"

echo "Running yarn install";
yarn;

echo "Compiling VS Code for $npm_config_arch";
yarn run gulp vscode-linux-$npm_config_arch-min;

echo "Starting vscode-linux-$npm_config_arch-build-deb";
yarn run gulp vscode-linux-$npm_config_arch-build-deb;

echo "Moving deb packages for release";
mv ./code/.build/linux/deb/$COBBLER_ARCH/deb/*.deb output;

echo "Extracting deb archive";
dpkg -x output/*.deb output/extracted;

cd output/extracted;

echo "Binary components of output --------------------------------------------------"
find . -type f -exec file {} ";" | grep ELF
echo "------------------------------------------------------------------------------"

echo "Dependency tree for code-oss -------------------------------------------------"
ldd -v output/extracted/usr/share/code-oss/code-oss;
echo "------------------------------------------------------------------------------"
