#!/bin/bash
set -e;

vscode_git="https://github.com/Microsoft/vscode.git"

echo "Retrieving code from git endpoint [$vscode_git] into [code]";
git clone $vscode_git code;
  
echo "Setting current owner as owner of code folder";
chown ${USER:=$(/usr/bin/id -run)}:$USER -R code;

echo "Synchronizing overlays folder";
rsync -avh ./overlays/ code/;

echo "Running yarn install";
yarn install;

echo "Compiling VS Code for $npm_config_arch";
yarn run gulp vscode-linux-$npm_config_arch-min;

echo "Starting vscode-linux-$npm_config_arch-build-deb";
yarn run gulp vscode-linux-$npm_config_arch-build-deb;

echo "Moving deb packages for release";
mv ./code/.build/linux/deb/$COBBLER_ARCH/deb/*.deb output;

echo "Extracting deb archive";
dpkg -x output/*.deb output/extracted;

#echo "Reading ELF dependencies";
#readelf -d output/extracted/usr/share/code-oss/code-oss;

cd output/extracted;
echo "Binary components of output --------------------------------------------------"
find . -type f -exec file {} ";" | grep ELF
echo "------------------------------------------------------------------------------"

echo "Dependency tree for code-oss -------------------------------------------------"
ldd -v output/extracted/usr/share/code-oss/code-oss;
echo "------------------------------------------------------------------------------"

#echo "Starting vscode-linux-$npm_config_target_arch-build-rpm";
#yarn run gulp "vscode-linux-$npm_config_target_arch-build-rpm";

#echo "Moving rpm packages for release";
#mv $COBBLER_CODE_DIRECTORY/.build/linux/rpm/$COBBLER_RPM_ARCH/rpmbuild/RPMS/$COBBLER_RPM_ARCH/*.rpm output;
