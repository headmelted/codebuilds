#!/bin/bash
set -e;

vscode_git="https://github.com/Microsoft/vscode.git"

echo "Retrieving code from git endpoint [$vscode_git] into [$COBBLER_CODE_DIRECTORY]";
git clone $vscode_git $COBBLER_CODE_DIRECTORY;
  
echo "Setting current owner as owner of code folder";
chown ${USER:=$(/usr/bin/id -run)}:$USER -R $COBBLER_CODE_DIRECTORY;

echo "Synchronizing overlays folder";
rsync -avh ./overlays/ $COBBLER_CODE_DIRECTORY/;

echo "Running yarn install";
yarn install;

echo "Compiling VS Code for $npm_config_arch";
yarn run gulp vscode-linux-$npm_config_arch-min;

echo "Starting vscode-linux-$npm_config_arch-build-deb";
yarn run gulp vscode-linux-$npm_config_arch-build-deb;

echo "Moving deb packages for release";
mv $COBBLER_CODE_DIRECTORY/.build/linux/deb/$COBBLER_ARCH/deb/*.deb $COBBLER_OUTPUT_DIRECTORY;

echo "Extracting deb archive";
dpkg -x $COBBLER_OUTPUT_DIRECTORY/*.deb $COBBLER_OUTPUT_DIRECTORY/extracted;

#echo "Reading ELF dependencies";
#readelf -d $COBBLER_OUTPUT_DIRECTORY/extracted/usr/share/code-oss/code-oss;

cd $COBBLER_OUTPUT_DIRECTORY/extracted;
echo "Binary components of output --------------------------------------------------"
find . -type f -exec file {} ";" | grep ELF
echo "------------------------------------------------------------------------------"

echo "Dependency tree for code-oss -------------------------------------------------"
ldd -v $COBBLER_OUTPUT_DIRECTORY/extracted/usr/share/code-oss/code-oss;
echo "------------------------------------------------------------------------------"

#echo "Starting vscode-linux-$npm_config_target_arch-build-rpm";
#yarn run gulp "vscode-linux-$npm_config_target_arch-build-rpm";

#echo "Moving rpm packages for release";
#mv $COBBLER_CODE_DIRECTORY/.build/linux/rpm/$COBBLER_RPM_ARCH/rpmbuild/RPMS/$COBBLER_RPM_ARCH/*.rpm $COBBLER_OUTPUT_DIRECTORY;
