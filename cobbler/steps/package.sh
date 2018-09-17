#!/bin/bash
set -e;

echo "Starting vscode-linux-$COBBLER_NPM_ARCH";
gulp "vscode-linux-$COBBLER_NPM_ARCH";

echo "Starting vscode-linux-$COBBLER_NPM_ARCH-build-deb";
yarn run gulp vscode-linux-$COBBLER_NPM_ARCH-build-deb;

echo "Moving deb packages for release";
mv /kitchen/.builds/$COBBLER_ARCH/.code/.build/linux/deb/$COBBLER_ARCH/deb/*.deb /cooked;

echo "Starting vscode-linux-$COBBLER_NPM_ARCH-build-rpm";
yarn run gulp "vscode-linux-$COBBLER_NPM_ARCH-build-rpm";

echo "Moving rpm packages for release";
mv /kitchen/.builds/$COBBLER_ARCH/.code/.build/linux/rpm/$COBBLER_RPM_ARCH/rpmbuild/RPMS/$COBBLER_RPM_ARCH/*.rpm /cooked;

# echo "Tarring build folder for release";
# tar -zcvf "/cobbler/.output/code-oss_${LABEL}.tar.gz" /kitchen/.builds/VSCode-linux-$COBBLER_NPM_ARCH;

echo "Listing output packages";
ls /cooked;
