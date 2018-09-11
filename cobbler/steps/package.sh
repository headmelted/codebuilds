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
tree /kitchen/.build/;
tree /kitchen/.builds/;

echo "Moving deb packages for release";
mv "/kitchen/.builds/**/*.deb" /cobbler/.output/;

echo "Moving rpm packages for release";
mv "/kitchen/.builds/**/*.rpm" /cobbler/.output/;

#echo "Starting vscode-linux-${NPM_ARCH}-flatpak";
#yarn run gulp --verbose "vscode-linux-${NPM_ARCH}-flatpak";

echo "Tarring build folder for release";
tar -zcvf "/cobbler/.output/code-oss_${LABEL}.tar.gz" ../VSCode-linux-${NPM_ARCH};

echo "Listing output packages";
ls /cobbler/.output;
