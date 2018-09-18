#!/bin/bash
set -e;

echo "Starting vscode-linux-$npm_config_target_arch";
gulp "vscode-linux-$npm_config_target_arch";

echo "Starting vscode-linux-$npm_config_target_arch-build-deb";
yarn run gulp vscode-linux-$npm_config_target_arch-build-deb;

echo "Moving deb packages for release";
mv $COBBLER_CODE_DIRECTORY/.build/linux/deb/$COBBLER_ARCH/deb/*.deb $COBBLER_OUTPUT_DIRECTORY;

echo "Starting vscode-linux-$npm_config_target_arch-build-rpm";
yarn run gulp "vscode-linux-$npm_config_target_arch-build-rpm";

echo "Moving rpm packages for release";
mv $COBBLER_CODE_DIRECTORY/.build/linux/rpm/$COBBLER_RPM_ARCH/rpmbuild/RPMS/$COBBLER_RPM_ARCH/*.rpm $COBBLER_OUTPUT_DIRECTORY;

# echo "Tarring build folder for release";
# tar -zcvf "/cobbler/.output/code-oss_${LABEL}.tar.gz" /kitchen/.builds/VSCode-linux-$COBBLER_NPM_ARCH;
