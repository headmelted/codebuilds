#!/bin/bash
set -e;

#echo "/lib -------------------------------"
#ls /lib;
#echo "/usr/lib -------------------------------"
#ls /usr/lib;
#echo "/usr/include ---------------------------"
#ls /usr/include;
#echo "/usr/include/libsecret-1 ---------------------------"
#ls /usr/include/libsecret-1;
#echo "/usr/include/libsecret-1/libsecret --------------------------"
#ls /usr/include/libsecret-1/libsecret;
#echo "/usr/lib/$COBBLER_GNU_TRIPLET -----------------------"
#ls /usr/lib/$COBBLER_GNU_TRIPLET;
#echo "/usr/include/$COBBLER_GNU_TRIPLET --------------------"
#tree /usr/include/$COBBLER_GNU_TRIPLET
#echo "------------------------------------------------------------"

. ~/cobbler/steps/setup_nvm.sh;

echo "Running npm install for $npm_config_target_arch";
yarn install;

echo "Compiling VS Code for $npm_config_target_arch";
yarn run gulp vscode-linux-$npm_config_target_arch-min;

echo "Starting vscode-linux-$npm_config_target_arch-build-deb";
yarn run gulp vscode-linux-$npm_config_target_arch-build-deb;

echo "Moving deb packages for release";
mv $COBBLER_CODE_DIRECTORY/.build/linux/deb/$COBBLER_ARCH/deb/*.deb $COBBLER_OUTPUT_DIRECTORY;

#echo "Starting vscode-linux-$npm_config_target_arch-build-rpm";
#yarn run gulp "vscode-linux-$npm_config_target_arch-build-rpm";

#echo "Moving rpm packages for release";
#mv $COBBLER_CODE_DIRECTORY/.build/linux/rpm/$COBBLER_RPM_ARCH/rpmbuild/RPMS/$COBBLER_RPM_ARCH/*.rpm $COBBLER_OUTPUT_DIRECTORY;
