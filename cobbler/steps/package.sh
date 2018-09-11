#!/bin/bash
set -e;

echo "Starting vscode-linux-${NPM_ARCH}";
gulp "vscode-linux-${NPM_ARCH}";

echo "Creating output folder";
mkdir /cobbler/.output;

echo "Starting vscode-linux-${NPM_ARCH}-build-deb";
yarn run gulp vscode-linux-${NPM_ARCH}-build-deb;

echo "Starting vscode-linux-${NPM_ARCH}-build-rpm";
yarn run gulp "vscode-linux-${NPM_ARCH}-build-rpm";

echo "Looking for release debs";
tree /kitchen/.builds/${ARCH}/.code/.build/;

echo "Moving deb packages for release";
mv /kitchen/.builds/${ARCH}/.code/.build/linux/deb/${ARCH}/deb/*.deb /cobbler/.output/;

echo "Moving rpm packages for release";
mv /kitchen/.builds/${ARCH}/.code/.build/linux/rpm/${RPM_ARCH}/rpmbuild/RPMS/${RPM_ARCH}/*.rpm /cobbler/.output/;

# echo "Starting vscode-linux-${NPM_ARCH}-flatpak";
# yarn run gulp --verbose "vscode-linux-${NPM_ARCH}-flatpak";

# echo "Starting vscode-linux-${NPM_ARCH}-snap";
# yarn run gulp --verbose "vscode-linux-${NPM_ARCH}-snap";

# echo "Tarring build folder for release";
# tar -zcvf "/cobbler/.output/code-oss_${LABEL}.tar.gz" /kitchen/.builds/VSCode-linux-${NPM_ARCH};

echo "Listing output packages";
ls /cobbler/.output;
